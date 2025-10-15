library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity processor_TB is
end processor_TB;

architecture Behavioral of processor_TB is
    -- Unit Under Test (UUT)
    component Processor is
        port (
            CLK         : in std_logic;
            RESET       : in std_logic;
            PC          : out std_logic_vector(31 downto 0);
            Instr       : out std_logic_vector(31 downto 0);
            ALUResult   : out std_logic_vector(31 downto 0);
            WriteData   : out std_logic_vector(31 downto 0); 
            Result      : out std_logic_vector(31 downto 0)
--            SrcA, SrcB  : out std_logic_vector(31 downto 0);  --For testing
--            ALUControl  : out std_logic_vector(3 downto 0) --For testing          
            -- Flag signals only for testing
--            N_Flag      : out std_logic;
--            Z_Flag      : out std_logic;
--            V_Flag      : out std_logic;
--            C_Flag      : out std_logic                     
        );
    end component;
    
    -- Signals declaration
    signal CLK      : std_logic;
    signal RESET    : std_logic;                    
   
    --Internal outputs from UUT 
    signal PC          : std_logic_vector(31 downto 0);
    signal Instr       : std_logic_vector(31 downto 0);
    signal ALUResult   : std_logic_vector(31 downto 0);
    signal WriteData   : std_logic_vector(31 downto 0); 
    signal Result      : std_logic_vector(31 downto 0);
    
    --signal ALUControl  : std_logic_vector(3 downto 0); --For testing      
    --signal SrcA, SrcB  : std_logic_vector(31 downto 0);  --For testing
    
    -- Flag signals only for testing
--    signal N_Flag      : std_logic;
--    signal Z_Flag      : std_logic;
--    signal V_Flag      : std_logic;
--    signal C_Flag      : std_logic;
    
    constant clk_period : time := 12.150 ns;    
         
begin

    uut: Processor port map (
        CLK         => CLK,
        RESET       => RESET, 
        PC          => PC,
        Instr       => Instr,
        ALUResult   => ALUResult,
        WriteData   => WriteData,
        Result      => Result
--        SrcA        => SrcA, --For testing
--        SrcB        => SrcB, --For testing
--        ALUControl  => ALUControl,--For testing 
--        -- Flag signals only for testing
--        N_Flag    => N_Flag,
--        Z_Flag    => Z_Flag,
--        V_Flag    => V_Flag,
--        C_Flag    => C_Flag
    );

    clock: process is
    begin
        CLK <= '1';
        wait for clk_period / 2;
        CLK <= '0';
        wait for clk_period / 2;
    end process clock;
        
    Processor_TEST: process is
    begin        
        RESET <= '1';
        wait for 9 * clk_period;
        wait until (CLK = '0' and CLK'event);
        RESET <= '0';
        wait for 520 ns; -- 12.15ns x 42 commands
        stop(2);
    end process Processor_TEST;

end Behavioral;
