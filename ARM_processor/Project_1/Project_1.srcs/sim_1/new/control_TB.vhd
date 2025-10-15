
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity control_TB is
--  Port ( );
end control_TB;

architecture Behavioral of control_TB is

-- Unit Under Test (UUT)
    component Control
        Port(
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
    end component;
    
    -- Internal inputs to UUT
    signal instr       : std_logic_vector(31 downto 0);
    signal N_Flag      : std_logic;
    signal Z_Flag      : std_logic;
    signal V_Flag      : std_logic;
    signal C_Flag      : std_logic;
    
    -- Internal outputs to UUT    
    signal RegSrc      : std_logic_vector(2 downto 0);
    signal ALUSrc      : std_logic;
    signal ImmSrc      : std_logic;
    signal ALUControl  : std_logic_vector(3 downto 0);
    signal MemToReg    : std_logic;
    signal RegWrite    : std_logic;
    signal MemWrite    : std_logic;
    signal FlagsWrite  : std_logic;
    signal PCSrc       : std_logic;
    
    -- Clock period definition
    constant CLK_period : time := 12.150ns;
      
begin

    -- Instantiate the Unit Under Test (UUT) 
    uut: Control
        port map(
            instr       => instr,
            N_Flag      => N_Flag,
            Z_Flag      => Z_Flag,
            V_Flag      => V_Flag,
            C_Flag      => C_Flag,
            RegSrc      => RegSrc,
            ALUSrc      => ALUSrc,
            ImmSrc      => ImmSrc,
            ALUControl  => ALUControl,
            MemToReg    => MemToReg,
            RegWrite    => RegWrite,
            MemWrite    => MemWrite,
            FlagsWrite  => FlagsWrite,
            PCSrc       => PCSrc
        );
    
CONTROL_TEST: process
begin

    -- Instructions testing
    report "TESTING BL INSTRUCTION";
    instr <= "11101011XXXXXXXXXXXXXXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING B INSTRUCTION";
    instr <= "11101010XXXXXXXXXXXXXXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LSL INSTRUCTION";
    instr <= "111000011010XXXX0001XXXXX000XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LSR INSTRUCTION";
    instr <= "111000011010XXXX0001XXXXX010XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ASR INSTRUCTION";
    instr <= "111000011010XXXX0001XXXXX100XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ROR INSTRUCTION";
    instr <= "111000011010XXXX0001XXXXX110XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING MVN (REG) INSTRUCTION";
    instr <= "111000011110XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING MVN (IMM) INSTRUCTION";
    instr <= "111000111110XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING MOV-NOP (REG) INSTRUCTION";
    instr <= "111000011010XXXX000100000XX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING MOV (IMM) INSTRUCTION";
    instr <= "111000111010XXXX000100000XX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING CMP (REG) INSTRUCTION";
    instr <= "111000010101XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING CMP (IMM) INSTRUCTION";
    instr <= "111000110101XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ADD (REG, S = 0) INSTRUCTION";
    instr <= "111000001000XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ADD (IMM, S = 0) INSTRUCTION";
    instr <= "111000101000XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ADD (REG, S = 1) INSTRUCTION";
    instr <= "111000001001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ADD (IMM, S = 1) INSTRUCTION";
    instr <= "111000101001XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING SUB (REG, S = 0) INSTRUCTION";
    instr <= "111000000100XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING SUB (IMM, S = 0) INSTRUCTION";
    instr <= "111000100100XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING SUB (REG, S = 1) INSTRUCTION";
    instr <= "111000000101XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING SUB (IMM, S = 1) INSTRUCTION";
    instr <= "111000100101XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING AND (REG, S = 0) INSTRUCTION";
    instr <= "111000000000XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING AND (IMM, S = 0) INSTRUCTION";
    instr <= "111000100000XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING AND (REG, S = 1) INSTRUCTION";
    instr <= "111000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING AND (IMM, S = 1) INSTRUCTION";
    instr <= "111000100001XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING XORR (REG, S = 0) INSTRUCTION";
    instr <= "111000000010XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING XORR (IMM, S = 0) INSTRUCTION";
    instr <= "111000100010XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING XORR (REG, S = 1) INSTRUCTION";
    instr <= "111000000011XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING XORR (IMM, S = 1) INSTRUCTION";
    instr <= "111000100011XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ORR (REG, S = 0) INSTRUCTION";
    instr <= "111000011000XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ORR (IMM, S = 0) INSTRUCTION";
    instr <= "111000111000XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ORR (REG, S = 1) INSTRUCTION";
    instr <= "111000011001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ORR (IMM, S = 1) INSTRUCTION";
    instr <= "111000111001XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING STR (U=1) INSTRUCTION";
    instr <= "111001011000XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING STR (U=0) INSTRUCTION";
    instr <= "111001010000XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LDR (U=1) INSTRUCTION";
    instr <= "111001011001XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LDR (U=0) INSTRUCTION";
    instr <= "111001010001XXXX0001XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;



    -- Rd=15 instructions
    report "TESTING LDR (U=0) RD=15 INSTRUCTION";
    instr <= "111001010001XXXX1111XXXXXXXXXXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING ADD (REG, S = 0) RD=15 INSTRUCTION";
    instr <= "111000001000XXXX1111XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;




    -- Conditional execution tests (AND instruction, S = 1)
    report "TESTING EQ";
    instr <= "000000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= '0';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING NE";
    instr <= "000100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= '1';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING CS/HS";
    instr <= "001000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= '0';
    wait for 1*CLK_period;

    report "TESTING CC/LO";
    instr <= "001100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= '1';
    wait for 1*CLK_period;

    report "TESTING MI";
    instr <= "010000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= '0';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING PL";
    instr <= "010100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= '1';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING VS";
    instr <= "011000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= '0';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING VC";
    instr <= "011100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= '1';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING HI";
    instr <= "100000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= 'X';
    V_Flag <= 'X';
    C_Flag <= '0';
    wait for 1*CLK_period;

    report "TESTING LS";
    instr <= "100100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= '0';
    V_Flag <= 'X';
    C_Flag <= '1';
    wait for 1*CLK_period;

    report "TESTING GE";
    instr <= "101000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= '0';
    Z_Flag <= 'X';
    V_Flag <= '1';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LT";
    instr <= "101100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= '0';
    Z_Flag <= 'X';
    V_Flag <= '0';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING GT";
    instr <= "110000000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= '1';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING LE";
    instr <= "110100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= 'X';
    Z_Flag <= '0';
    V_Flag <= 'X';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING NONE";
    instr <= "111100000001XXXX0001XXXXXXX0XXXX";
    N_Flag <= '0';
    Z_Flag <= '0';
    V_Flag <= '0';
    C_Flag <= 'X';
    wait for 1*CLK_period;

    report "TESTING COMPLETED";
    stop(2);
end process;

    


end Behavioral;
