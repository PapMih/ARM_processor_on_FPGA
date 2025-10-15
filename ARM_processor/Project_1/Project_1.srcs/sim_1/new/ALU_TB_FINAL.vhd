-- 32-bit ALU Testbench
-- Implementation uses input and output registers as specified
-- Verifies all main ALU operations and the flags N, Z, C, V

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity ALU_TB is

end ALU_TB;

architecture Behavioral of ALU_TB is
    -- Unit Under Test (UUT)
    component ALU is
        generic (
            W : positive := 32;
            S : positive := 5
        );
        port(
            SrcA, SrcB : in  std_logic_vector(W-1 downto 0);
            shamt5     : in  std_logic_vector(S-1 downto 0);
            ALUResult  : out std_logic_vector(W-1 downto 0);
            N, Z, C, V : out std_logic;
            ALUControl : in  std_logic_vector(3 downto 0)
        );
    end component;

    -- Signals declaration

    --Internal inputs to UUT
    signal CLK           : std_logic;
    signal SrcA_in       : std_logic_vector(W-1 downto 0);
    signal SrcB_in       : std_logic_vector(W-1 downto 0);
    signal shamt5_in     : std_logic_vector(S-1 downto 0);
    signal ALUControl_in : std_logic_vector(3 downto 0);

    --Internal outputs from UUT
    signal ALUResult_out : std_logic_vector(W-1 downto 0);
    signal N_out         : std_logic;
    signal Z_out         : std_logic;
    signal C_out         : std_logic;
    signal V_out         : std_logic;

    --Internal inputs registers
    signal SrcA_reg       : std_logic_vector(W-1 downto 0);
    signal SrcB_reg       : std_logic_vector(W-1 downto 0);
    signal shamt5_reg     : std_logic_vector(S-1 downto 0);
    signal ALUControl_reg : std_logic_vector(3 downto 0);

    --Internal outputs registers
    signal ALUResult_reg  : std_logic_vector(W-1 downto 0);
    signal N_reg          : std_logic;
    signal Z_reg          : std_logic;
    signal C_reg          : std_logic;
    signal V_reg          : std_logic;

    -- Clock period definition
    constant CLK_period : time := 13.674ns;

begin
    
    -- Instantiate the Unit Under Test (UUT) 
    uut: ALU
        generic map (
            W => W,
            S => S
        )
        port map(
            SrcA        => SrcA_reg,
            SrcB        => SrcB_reg,
            shamt5      => shamt5_reg,
            ALUControl  => ALUControl_reg,
            ALUResult   => ALUResult_out,
            N           => N_out,
            Z           => Z_out,
            C           => C_out,
            V           => V_out
        );

    -- Clock process definition
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    -- Registers update process
    REG_UPDATE: process(CLK)
    begin
        if rising_edge(CLK) then
            SrcA_reg       <= SrcA_in;
            SrcB_reg       <= SrcB_in;
            shamt5_reg     <= shamt5_in;
            ALUControl_reg <= ALUControl_in;
            ALUResult_reg  <= ALUResult_out;
            N_reg          <= N_out;
            Z_reg          <= Z_out;
            C_reg          <= C_out;
            V_reg          <= V_out;
        end if;
    end process;

    ALU_TEST: process
    begin
        wait until (CLK = '0' and CLK'event);
        report "ALU TEST START";
        
        -- Expected result: X"78123456" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"12345678";
        shamt5_in     <= "01000";
        ALUControl_in <= "1111";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000001";
        shamt5_in     <= "00001";
        ALUControl_in <= "1111";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000000";
        shamt5_in     <= "00001";
        ALUControl_in <= "1111";
        wait for 1*CLK_period;

        report "TESTING ASR";
        -- Expected result: X"38000000"
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"70000000";
        shamt5_in     <= "00001";
        ALUControl_in <= "1100";
        wait for 1*CLK_period;
        -- Expected result: X"FFFFFFFF"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"80000000";
        shamt5_in     <= "11111";
        ALUControl_in <= "1100";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000001";
        shamt5_in     <= "00001";
        ALUControl_in <= "1100";
        wait for 1*CLK_period;

        report "TESTING LSR";
        -- Expected result: X"78000000" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"F0000000";
        shamt5_in     <= "00001";
        ALUControl_in <= "1110";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000001";
        shamt5_in     <= "00001";
        ALUControl_in <= "1110";
        wait for 1*CLK_period;

        report "TESTING LSL";
        -- Expected result: X"00000002" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000001";
        shamt5_in     <= "00001";
        ALUControl_in <= "1101"; 
        wait for 1*CLK_period;
        -- Expected result X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"40000000";
        shamt5_in     <= "00001";
        ALUControl_in <= "1101";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000000";
        shamt5_in     <= "00100";
        ALUControl_in <= "1101";
        wait for 1*CLK_period;

        report "TESTING AND";
        -- Expected result: X"0A0A0A0A" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= X"AAAAAAAA";
        SrcB_in       <= X"0F0F0F0F";
        ALUControl_in <= "1010";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= X"80000000";
        SrcB_in       <= X"F0000000";
        ALUControl_in <= "1010";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= X"12345678";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "1010";
        wait for 1*CLK_period;

        report "TESTING OR";
        -- Expected result: X"1F1F1F1F" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= X"0F0F0F0F";
        SrcB_in       <= X"10101010";
        ALUControl_in <= "1011";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= X"80000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "1011";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= X"00000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "1011";
        wait for 1*CLK_period;

        report "TESTING XOR";
        -- Expected result: X"1F1F1F1F" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= X"0F0F0F0F";
        SrcB_in       <= X"10101010";
        ALUControl_in <= "1000";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= X"80000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "1000";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= X"00000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "1000";
        wait for 1*CLK_period;

        report "TESTING ADD";
        -- Expected result: X"00000015" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= X"00000005";
        SrcB_in       <= X"00000010";
        ALUControl_in <= "0000";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:1, C:0
        SrcA_in       <= X"40000000";
        SrcB_in       <= X"40000000";
        ALUControl_in <= "0000";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= X"00000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "0000";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:1
        SrcA_in       <= X"FFFFFFFF";
        SrcB_in       <= X"00000001";
        ALUControl_in <= "0000";
        wait for 1*CLK_period;

        report "TESTING SUB";
        -- Expected result: X"00000008" 
        -- Expected flags. N:0 , Z:0, V:0, C:1
        SrcA_in       <= X"0000000A";
        SrcB_in       <= X"00000002";
        ALUControl_in <= "0001";  -- SUB
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:1, C:0
        SrcA_in       <= X"00000000";
        SrcB_in       <= X"80000000";
        ALUControl_in <= "0001";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:1
        SrcA_in       <= X"00000000";
        SrcB_in       <= X"00000000";
        ALUControl_in <= "0001";
        wait for 1*CLK_period;
        -- Expected result: X"00000003"
        -- Expected flags. N:0 , Z:0, V:0, C:1
        SrcA_in       <= X"00000005";
        SrcB_in       <= X"00000002";
        ALUControl_in <= "0001";
        wait for 1*CLK_period;
        -- Expected result: X"7FFFFFFF"
        -- Expected flags. N:0 , Z:0, V:1, C:1
        SrcA_in       <= X"80000000";
        SrcB_in       <= X"00000001";
        ALUControl_in <= "0001";
        wait for 1*CLK_period;

        report "TESTING MOV";
        -- Expected result: X"2AAAAAAA" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"2AAAAAAA";
        ALUControl_in <= "0100";
        wait for 1*CLK_period;
        -- Expected result: X"80000000"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"80000000";
        ALUControl_in <= "0100";
        wait for 1*CLK_period;
        -- Expected result: X"00000000"
        -- Expected flags. N:0 , Z:1, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000000";
        ALUControl_in <= "0100";
        wait for 1*CLK_period;

        report "TESTING MVN";
        -- Expected result: X"55555555" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"AAAAAAAA";
        ALUControl_in <= "0101";
        wait for 1*CLK_period;
        -- Expected result: X"7FFFFFFF"
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"80000000";
        ALUControl_in <= "0101";
        wait for 1*CLK_period;
        -- Expected result: X"FFFFFFFF"
        -- Expected flags. N:1 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000000";
        ALUControl_in <= "0101";
        wait for 1*CLK_period;

        report "TESTING NOP";
        -- Expected result: X"00000001" 
        -- Expected flags. N:0 , Z:0, V:0, C:0
        SrcA_in       <= (others => 'X');
        SrcB_in       <= X"00000001";
        ALUControl_in <= "0111";
        wait for 1*CLK_period;

        report "TESTS COMPLETED";
        
        wait for 1*CLK_period;
        stop(2);
    end process;

end Behavioral;
