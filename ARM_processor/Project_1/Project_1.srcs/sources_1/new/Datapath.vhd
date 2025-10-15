-- Datapath
-- Inputs:
--   CLK, Reset                : clock and asynchronous reset.
--   PCSrc                     : selects the next PC value (PC+4 or branch target).
--   RegSrc(2 downto 0)         : controls selection of register addresses (RA1, RA2, WA) and write-back source (Result or PC+4) in the register file.
--   RegWrite                  : enables write to the register file.
--   ImmSrc                    : selects zero/sign extension mode in the immediate extender.
--   ALUSrc                    : selects the second ALU operand (register RD2 or extended immediate).
--   MemWrite                  : enables write to Data Memory for store instructions.
--   FlagsWrite                : enables update of the status register flags (N,Z,C,V).
--   MemtoReg                  : selects data source for write-back (ALU result or memory output).
--   ALUControl(3 downto 0)    : selects ALU operation (arithmetic, logic, move, shift).
--
-- Outputs:
--   Instr(W-1 downto 0)            : current fetched instruction from Instruction Memory.
--   N_Flag, Z_Flag, C_Flag, V_Flag : status flags from the Status Register.
--   ALUResult(W-1 downto 0)        : result of the ALU operation.
--   PCPlus4(W-1 downto 0)          : PC + 4 address used for sequential instruction fetching.
--   Result(W-1 downto 0)           : final value written back to the register file (from ALU or memory).
--   WriteData(W-1 downto 0)        : data forwarded from register file to Data Memory for stores.

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Datapath is
  generic (
        W                   : positive := 32; --Word width   
        S                   : positive := 5; -- Shift amount width
        N                   : integer := 4;  -- number of flags (default 4: C, Z, N, V)
        M                   : positive := 6 -- 2^6 = 64 words
  );
  
    port(   
        CLK         : in std_logic;
        Reset       : in std_logic;
        PCSrc       : in std_logic; -- Programam counter source
        RegSrc      : in std_logic_vector(2 downto 0); -- Register source
        RegWrite    : in std_logic; -- Write enabler for register
        ImmSrc      : in std_logic; -- For the extender operation     
        ALUSrc      : in std_logic; -- SrcB source in ALU
        MemWrite    : in std_logic; -- Write enabler for RAM
        FlagsWrite  : in std_logic; -- Write enabler for status register
        MemtoReg    : in std_logic; -- Enable when data have to be stored to register
        ALUControl  : in std_logic_vector(3 downto 0); -- Signal for ALU operation
        Instr       : out std_logic_vector(W-1 downto 0); -- The current instruction
        N_Flag      : out std_logic;
        Z_Flag      : out std_logic;
        V_Flag      : out std_logic;
        C_Flag      : out std_logic;
        ALUResult   : out std_logic_vector(W-1 downto 0); -- The ALU output
        PCPlus4     : out std_logic_vector(W-1 downto 0); -- The instruction  
        Result      : out std_logic_vector(W-1 downto 0); -- Final write-back result to register file 
        WriteData   : out std_logic_vector(W-1 downto 0) -- Written data to DM   
        --SrcA, SrcB  : out std_logic_vector(W-1 downto 0)  --For testing 
    );  
      
end Datapath;

architecture Structural of Datapath is

-- Component declaration
    component PCreg is
        generic (M : positive := 32); -- Word length
        port(
            CLK,
            Reset       : in std_logic;
            WE          : in std_logic := '1';
            PCN         : in std_logic_vector (M-1 downto 0);
            PC          : out std_logic_vector (M-1 downto 0)
        );
    end component  ;
    
    component IM is
        generic (
            M : positive := 32; -- Word length
            N : positive := 6 -- 2^6 = 64 words
        );
        port (
            A   : in std_logic_vector (N - 1 downto 0); -- N bit address
            RD  : out std_logic_vector (M - 1 downto 0) -- Output data
            );
    end component;
        
    component INC4 is 
        generic (
            M : positive := 32; -- 32 bit
            N : integer := 4 -- Value to increment by
        );
            
        port(
            PC      : in std_logic_vector(M-1 downto 0);
            PCPlus4 : out std_logic_vector(M-1 downto 0)
        );
    end component; 
    
    component Mux2To1 is
        generic (N : positive := 32);
        port
        (
            X       : out std_logic_vector (N-1 downto 0);
            SEL     : in std_logic;
            Y1, Y0  : in std_logic_vector (N-1 downto 0)
        );
    end component;   
    
    component Extend is
        generic (
            OutputBits      : positive := 32; -- 32 bit output
            InputBits       : positive := 24; -- 24 bit input
            ZeroInputBits   : positive := 12; 
            SignInputBits   : positive := 26 -- Instr & "00"
        );
    
        Port (Instr     : in std_logic_vector (InputBits - 1 downto 0);
              ImmSrc    : in std_logic;
              ExtImm    : out std_logic_vector (OutputBits - 1 downto 0));
              
    end component;
    
    component RegFilesWithPC is
        generic (
            M : positive := 32;  -- 32 bit
            N : integer  := 4    -- 2^N total registers
        );
        
        port (
            CLK  : in  std_logic;
            WE3  : in  std_logic; -- Write enable
            A1   : in  std_logic_vector(N-1 downto 0);
            A2   : in  std_logic_vector(N-1 downto 0);
            A3   : in  std_logic_vector(N-1 downto 0);
            WD3  : in  std_logic_vector(M-1 downto 0);
            RD1  : out std_logic_vector(M-1 downto 0);
            RD2  : out std_logic_vector(M-1 downto 0);
            R15  : in  std_logic_vector(M-1 downto 0)
        );
    end component;
    
    component ALU is
      generic (
        W : positive := 32;
        S : positive := 5
      );
      port (
        SrcA, SrcB : in  std_logic_vector(W-1 downto 0);
        shamt5     : in  std_logic_vector(S-1 downto 0);
        ALUResult  : out std_logic_vector(W-1 downto 0);
        N, Z, C, V : out std_logic;
        ALUControl : in  std_logic_vector(3 downto 0)
      );
    end component;   
    
    component StatusReg is
        generic (
            N : integer := 4  -- number of flags (default 4: C, Z, N, V)
        );
        port (
            CLK   : in  std_logic;
            WE    : in  std_logic;  -- Write enable
            RE    : in  std_logic;  -- Reset
            C_in  : in  std_logic;
            Z_in  : in  std_logic;
            N_in  : in  std_logic;
            V_in  : in  std_logic;
            C_out : out std_logic;
            Z_out : out std_logic;
            N_out : out std_logic;
            V_out : out std_logic
        );
    end component; 
    
    component DM is
        generic (
            M : positive := 32; -- Word length
            N : positive := 5 -- 2^5 = 32 words
        );
        
        Port (
                CLK, WE : in std_logic;
                A, WD : in std_logic_vector(M-1 downto 0);
                RD : out std_logic_vector(M-1 downto 0)
                );
    end component;
    
-- Signals declaration    
    signal PC_Signal        : std_logic_vector(W-1 downto 0);  
    signal PCN_Signal       : std_logic_vector(W-1 downto 0); 
    signal RA1_Signal       : std_logic_vector(3 downto 0); 
    signal RA2_Signal       : std_logic_vector(3 downto 0); 
    signal WA_Signal        : std_logic_vector(3 downto 0);
    signal WD3_Signal       : std_logic_vector(W-1 downto 0); 
    signal PCPlus4_Signal   : std_logic_vector(W-1 downto 0); 
    signal PCPlus8_Signal   : std_logic_vector(W-1 downto 0); 
    signal Instr_Signal     : std_logic_vector(W-1 downto 0);
    signal ExtImm_Signal    : std_logic_vector(W-1 downto 0);
    signal SrcA_Signal      : std_logic_vector(W-1 downto 0);
    signal SrcB_Signal      : std_logic_vector(W-1 downto 0);
    signal ALUResult_Signal : std_logic_vector(W-1 downto 0);
    signal N_Flag_Signal    : std_logic;
    signal Z_Flag_Signal    : std_logic;
    signal V_Flag_Signal    : std_logic;
    signal C_Flag_Signal    : std_logic;
    signal Result_Signal    : std_logic_vector(W-1 downto 0); 
    signal RD2_Signal       : std_logic_vector(W-1 downto 0);
    signal RD1_Signal       : std_logic_vector(W-1 downto 0);
    signal RD_Signal        : std_logic_vector(W-1 downto 0);
    signal PCWritesignal    : std_logic := '1' ; -- Write enabler for programma counter
    
begin

--Components instances declaration
    PC: PCreg 
        generic map (M => W) -- Word length
        port map(
            CLK     => CLK,
            Reset   => Reset,
            WE      => PCWritesignal,
            PCN     => PCN_Signal,
            PC      => PC_Signal
        );
        
    Instr_Mem: IM 
        generic map(
            M => W, -- Word length
            N => M -- 2^6 = 64 words
        )
        port map (
            A   => PC_Signal(M+1 downto 2),
            RD  =>Instr_Signal
        );
        
    PCPlus4_Comp: INC4 
        generic map(
            M => W, -- 32 bit
            N => 4 -- Value to increment by 4
        )  
        port map(
            PC      => PC_Signal, 
            PCPlus4 => PCPlus4_Signal 
        );
  
    PCPlus8_Comp: INC4 
        generic map(
            M => W, -- 32 bit
            N => 4 -- Value to increment by 4
        )  
        port map(
            PC      => PCPlus4_Signal , 
            PCPlus4 => PCPlus8_Signal 
        );  
        
    Mux2To1_A1_Reg: Mux2To1 
        generic map (N => 4)
        port map (
            X       => RA1_Signal,
            SEL     => RegSrc(0),
            Y1      => std_logic_vector(TO_UNSIGNED(15, 4)),
            Y0      => Instr_Signal(19 downto 16)
        );
            
     Mux2To1_A2_Reg: Mux2To1 
        generic map (N => 4)
        port map (
            X       => RA2_Signal,
            SEL     => RegSrc(1),
            Y1      => Instr_Signal(15 downto 12),
            Y0      => Instr_Signal(3 downto 0)
        );       
            
      Mux2To1_A3_Reg: Mux2To1 
        generic map (N => 4)
        port map (
            X       => WA_Signal,
            SEL     => RegSrc(2),
            Y1      => std_logic_vector(TO_UNSIGNED(14, 4)),
            Y0      => Instr_Signal(15 downto 12)
        );    
         
      Mux2To1_WD3_Reg: Mux2To1 
        generic map (N => W)
        port map (
            X       => WD3_Signal,
            SEL     => RegSrc(2),
            Y1      => PCPlus4_Signal,
            Y0      => Result_Signal
        );  
        
      Mux2To1_PCN: Mux2To1 
        generic map (N => W)
        port map (
            X       => PCN_Signal,
            SEL     => PCSrc,
            Y1      => Result_Signal,
            Y0      => PCPlus4_Signal
        ); 
        
     Extender: Extend 
        generic map (
            OutputBits      => W, -- 32 bit output
            InputBits       => 24, -- 24 bit input
            ZeroInputBits   => 12, 
            SignInputBits   => 26 -- Instr & "00"
        )
        Port map (
            Instr     => Instr_Signal(23 downto 0),
            ImmSrc    => ImmSrc,
            ExtImm    => ExtImm_Signal
        );  
             
    Register_File: RegFilesWithPC 
        generic map(
            M => W,  -- 32 bit
            N => 4    -- 2^N total registers
        )
        port map (
            CLK => CLK,
            WE3 => RegWrite,
            A1  => RA1_Signal,
            A2  => RA2_Signal,
            A3  => WA_Signal,
            WD3 => WD3_Signal,
            RD1 => RD1_Signal,
            RD2 => RD2_Signal,
            R15 => PCPlus8_Signal
        );
        
      Mux2To1_SrcB: Mux2To1 
        generic map (N => W)
        port map (
            X       => SrcB_Signal,
            SEL     => ALUSrc,
            Y1      => ExtImm_Signal,
            Y0      => RD2_Signal
        );   
        
      Mux2To1_Result: Mux2To1 
        generic map (N => W)
        port map (
            X       => Result_Signal,
            SEL     => MemtoReg,
            Y1      => RD_Signal,
            Y0      => ALUResult_Signal
        );    
        
    ALU_Comp: ALU 
      generic map (
        W => W,
        S => S
      )
      port map (
        SrcA        => SrcA_Signal,
        SrcB        => SrcB_Signal,
        shamt5      => Instr_Signal (11 downto 7),
        ALUResult   => ALUResult_Signal,
        N           => N_Flag_Signal,
        Z           => Z_Flag_Signal,
        C           => C_Flag_Signal,
        V           => V_Flag_Signal,
        ALUControl  => ALUControl
      );
      
     Status_Register: StatusReg 
        generic map (
            N => N  -- number of flags (default 4: C, Z, N, V)
        )
        port map (
            CLK     => CLK,
            WE      => FlagsWrite,  -- Write enable
            RE      => Reset,  -- Reset
            C_in    => C_Flag_Signal,
            Z_in    => Z_Flag_Signal,
            N_in    => N_Flag_Signal,
            V_in    => V_Flag_Signal,
            C_out   => C_Flag,
            Z_out   => Z_Flag,
            N_out   => N_Flag,
            V_out   => V_Flag
        );
        
     Data_Memory: DM
        generic map(
            M => W, -- Word length
            N => 5 -- 2^5 = 32 words
        )
        port map (
            CLK => CLK,
            WE  => MemWrite,
            A   => ALUResult_Signal,
            WD  => RD2_Signal,
            RD  => RD_Signal
         );
         
        SrcA_Signal <= RD1_Signal;  
        Instr       <= Instr_Signal;
        ALUResult   <= ALUResult_Signal;
        PCPlus4     <= PC_Signal;
        Result      <= Result_Signal;
        WriteData   <= RD2_Signal;  
        --SrcA        <= SrcA_Signal; --For testing
        --SrcB        <= SrcB_Signal; --For testing                    
                
        
    end Structural;
