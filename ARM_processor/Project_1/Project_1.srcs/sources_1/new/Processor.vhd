-- Processor (Structural)
-- Integrates Control and Datapath. The Datapath fetches/executes instructions and exposes flags, the Control decodes the current instruction and flags to generate
-- control signals that drive the Datapath.
-- Inputs:
--   CLK, RESET                    : clock and asynchronous reset.
-- Outputs:
--   PC(W-1 downto 0)             : fetch address used by the Datapath (PC+4).
--   Instr(W-1 downto 0)          : current fetched instruction.
--   ALUResult(W-1 downto 0)      : result of the ALU operation.
--   WriteData(W-1 downto 0)      : data forwarded from register file to Data Memory for stores.
--   Result(W-1 downto 0)         : final value written back to the register file (from ALU or memory).

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Processor is
    generic (
        W                   : positive := 32; --Word width   
        S                   : positive := 5; -- Shift amount width
        N                   : integer := 4;  -- number of flags (default 4: C, Z, N, V)
        M                   : positive := 6 -- 2^6 = 64 words 
    );
      
    Port (
        CLK         : in std_logic;
        RESET       : in std_logic;
        PC          : out std_logic_vector(W-1 downto 0);
        Instr       : out std_logic_vector(W-1 downto 0);
        ALUResult   : out std_logic_vector(W-1 downto 0);
        WriteData   : out std_logic_vector(W-1 downto 0); 
        Result      : out std_logic_vector(W-1 downto 0)
        -- SrcA, SrcB  : out std_logic_vector(W-1 downto 0);  --For testing
        -- Flag signals only for testing
        -- N_Flag    : out std_logic;
        -- Z_Flag    : out std_logic;
        -- V_Flag    : out std_logic;
        -- C_Flag    : out std_logic;
        -- ALUControl: out std_logic_vector(3 downto 0) --For testing
     );
end Processor;

architecture Structural of Processor is

-- Component declaration
    component Datapath is 
      generic (
            W                   : positive := 32; --Word width   
            S                   : positive := 5; -- Shift amount width
            N                   : integer := 4;  -- number of flags (default 4: C, Z, N, V)
            M                   : positive := 6 -- 2^6 = 64 words
      );
      port(
            CLK         : in std_logic;
            Reset       : in std_logic:='0';
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
            PCPlus4     : out std_logic_vector(W-1 downto 0); -- The address of the next instruction  
            Result      : out std_logic_vector(W-1 downto 0); -- Final write-back result to register file 
            WriteData   : out std_logic_vector(W-1 downto 0) -- Written data to DM  
            -- SrcA, SrcB  : out std_logic_vector(W-1 downto 0)  --For testing
    );  
    end component  ;
    
    component Control is
        port(
            instr       : in std_logic_vector(31 downto 0);
            N_Flag      : in std_logic;
            Z_Flag      : in std_logic;
            V_Flag      : in std_logic;
            C_Flag      : in std_logic;
            RegSrc      : out std_logic_vector(2 downto 0);
            ALUSrc      : out std_logic;
            ImmSrc      : out std_logic;
            ALUControl  : out std_logic_vector(3 downto 0);
            MemToReg    : out std_logic;
            RegWrite    : out std_logic;
            MemWrite    : out std_logic;
            FlagsWrite  : out std_logic;
            PCSrc       : out std_logic
        );
        end component  ;       
             
 -- Signals declaration      
    signal RegSrcSignal     : std_logic_vector(2 downto 0);
    signal ALUSrcSignal     : std_logic;
    signal MemToRegSignal   : std_logic; 
    signal ALUControlSignal : std_logic_vector(3 downto 0);
    signal ImmSrcSignal     : std_logic;
    signal MemWriteSignal   : std_logic;     
    signal FlagsWriteSignal : std_logic;           
    signal RegWriteSignal   : std_logic;   
    signal PCSrcSignal      : std_logic;    
    signal instrSignal      : std_logic_vector(31 downto 0);  
    signal N_FlagSignal     : std_logic;     
    signal Z_FlagSignal     : std_logic;      
    signal V_FlagSignal     : std_logic;      
    signal C_FlagSignal     : std_logic;        
    --signal SrcA_Signal      : std_logic_vector(W-1 downto 0); --For testing
    --signal SrcB_Signal      : std_logic_vector(W-1 downto 0); --For testing     
begin

    --Components instances declaration
    DatapathComp: Datapath
        generic map(
            W => W,   
            S => S,
            N => N,
            M => M
        )
        port map(
            CLK         => CLK,
            Reset       => RESET,
            PCSrc       => PCSrcSignal,
            RegSrc      => RegSrcSignal,
            RegWrite    => RegWriteSignal,
            ImmSrc      => ImmSrcSignal,    
            ALUSrc      => ALUSrcSignal,
            MemWrite    => MemWriteSignal,
            FlagsWrite  => FlagsWriteSignal,
            MemtoReg    => MemToRegSignal,
            ALUControl  => ALUControlSignal,
            Instr       => instrSignal,
            N_Flag      => N_FlagSignal,
            Z_Flag      => Z_FlagSignal,
            V_Flag      => V_FlagSignal,
            C_Flag      => C_FlagSignal,
            ALUResult   => ALUResult,
            PCPlus4     => PC,
            Result      => Result,
            WriteData   => WriteData
            --SrcA        => SrcA_Signal, --For testing  
            --SrcB        => SrcB_Signal  --For testing      
         );  
         
    ControlComp: Control 
        port map(
            Instr       => instrSignal,
            N_Flag      => N_FlagSignal,
            Z_Flag      => Z_FlagSignal,
            V_Flag      => V_FlagSignal,
            C_Flag      => C_FlagSignal,
            RegSrc      => RegSrcSignal,
            ALUSrc      => ALUSrcSignal,
            ImmSrc      => ImmSrcSignal,  
            ALUControl  => ALUControlSignal,
            MemtoReg    => MemToRegSignal,
            RegWrite    => RegWriteSignal,
            MemWrite    => MemWriteSignal,
            FlagsWrite  => FlagsWriteSignal,
            PCSrc       => PCSrcSignal   
    );

 Instr <= instrSignal; 
-- Flag signals only for testing
-- N_Flag <= N_FlagSignal;
-- Z_Flag <= Z_FlagSignal;
-- V_Flag <= V_FlagSignal;
-- C_Flag <= C_FlagSignal;  
 
-- SrcA <= SrcA_Signal;
-- SrcB <= SrcB_Signal;       
-- ALUControl <= ALUControlSignal;

end Structural;
