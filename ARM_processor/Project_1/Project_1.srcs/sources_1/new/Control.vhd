-- Control
-- Inputs:
--   instr(31 downto 0)             : current instruction word (contains cond/op/funct/fields).
--   N_Flag, Z_Flag, C_Flag, V_Flag : status flags used for conditional execution.
--
-- Outputs:
--   RegSrc(2 downto 0)             : controls selection of register addresses (RA1, RA2, WA) and use of PC+4 as write-back source.
--   ALUSrc                         : selects the second ALU operand (register RD2 or extended immediate).
--   ImmSrc                         : selects zero/sign extension mode for the immediate.
--   ALUControl(3 downto 0)         : selects ALU operation (arithmetic, logic, move, shift).
--   MemToReg                       : selects data source for write-back (ALU result or memory output).
--   RegWrite                       : enables write to the register file (after condition check).
--   MemWrite                       : enables write to Data Memory for store instructions (after condition check).
--   FlagsWrite                     : enables update of the status register flags (N,Z,C,V) (after condition check).
--   PCSrc                          : requests a PC update (branch or write to R15) (after condition check).

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
    Port (
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
end Control;

architecture Structural of Control is

-- Component declaration
    component CONDLogic is
        port(
            N_Flag      : in std_logic;
            Z_Flag      : in std_logic;
            V_Flag      : in std_logic;
            C_Flag      : in std_logic;
            cond        : in std_logic_vector(3 downto 0);
            CondEx_in   : out std_logic
        );              
    end component;  
 
    component InstrDec is
        port(
            op          : in std_logic_vector(1 downto 0);
            funct       : in std_logic_vector(5 downto 0);
            sh          : in std_logic_vector(1 downto 0);
            shamt5      : in std_logic_vector(4 downto 0);
            RegSrc      : out std_logic_vector(2 downto 0);
            ALUSrc      : out std_logic;
            ImmSrc      : out std_logic;
            ALUControl  : out std_logic_vector(3 downto 0);
            MemToReg    : out std_logic;
            NoWrite_in  : out std_logic
        );              
    end component;     

    component PCLogic is
        port(
             op          : in  std_logic;
             Rd          : in  std_logic_vector(3 downto 0);
             RegWrite_in : in  std_logic;
             PCSrc_in    : out std_logic
        );              
    end component;     
    
     component WELogic is
        port(
            op           : in std_logic_vector(1 downto 0);
            SL           : in std_logic;
            IL           : in std_logic_vector(1 downto 0);
            NoWrite_in   : in std_logic;
            RegWrite_in  : out std_logic;
            MemWrite_in  : out std_logic;
            FlagsWrite_in: out std_logic
        );              
    end component;        
 
 -- Signals declaration
    signal NoWrite_inSignal     : std_logic; 
    signal MemWrite_inSignal    : std_logic;
    signal FlagsWrite_inSignal  : std_logic;
    signal RegWrite_inSignal    : std_logic;   
    signal PCSrc_inSignal       : std_logic;              
    signal CondEx_inSignal      : std_logic;  
        
begin
--Components instances declaration
    
    CONDLogicComp: CONDLogic
        port map(
            N_Flag      => N_Flag,
            Z_Flag      => Z_Flag,
            V_Flag      => V_Flag,      
            C_Flag      => C_Flag,
            cond        => instr(31 downto 28),
            CondEx_in   => CondEx_inSignal
        );
        
   InstrDecComp: InstrDec
        port map(
            op          => instr(27 downto 26),
            funct       => instr(25 downto 20),
            sh          => instr(6 downto 5),
            shamt5      => instr(11 downto 7),
            RegSrc      => RegSrc,
            ALUSrc      => ALUSrc,
            ImmSrc      => ImmSrc,
            ALUControl  => ALUControl,
            MemToReg    => MemToReg,
            NoWrite_in  => NoWrite_inSignal
        ); 
                      
    PCLogicComp: PCLogic
        port map(
             op          => instr(27),
             Rd          => instr(15 downto 12),
             RegWrite_in => RegWrite_inSignal,
             PCSrc_in    => PCSrc_inSignal
        ); 
        
    WELogicComp: WELogic
        port map(
            op            => instr(27 downto 26),
            SL            => instr(20),
            IL            => instr(25 downto 24),
            NoWrite_in    => NoWrite_inSignal,
            RegWrite_in   => RegWrite_inSignal,
            MemWrite_in   => MemWrite_inSignal,
            FlagsWrite_in => FlagsWrite_inSignal
        );
        
    MemWrite    <= MemWrite_inSignal and CondEx_inSignal;
    FlagsWrite  <= FlagsWrite_inSignal and CondEx_inSignal;  
    RegWrite    <= RegWrite_inSignal and CondEx_inSignal;
    PCSrc       <= PCSrc_inSignal and CondEx_inSignal;                         
                         
end Structural;
