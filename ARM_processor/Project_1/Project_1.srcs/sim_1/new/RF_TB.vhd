
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use STD.ENV.ALL;

entity RF_TB is
    generic (
        M : positive := 32;  -- 32 bit
        N : integer  := 4    -- 2^N total registers
    );
end RF_TB;

architecture Behavioral of RF_TB is
    -- Unit Under Test (UUT)
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
    
-- Signals declaration 
    signal CLK        : std_logic;
    
    --Internal inputs to UUT
    signal WE3_in  : std_logic; -- Write enable
    signal A1_in   : std_logic_vector(N-1 downto 0);
    signal A2_in   : std_logic_vector(N-1 downto 0);
    signal A3_in   : std_logic_vector(N-1 downto 0);
    signal WD3_in  : std_logic_vector(M-1 downto 0); 
    signal R15_in  : std_logic_vector(M-1 downto 0);
    
    --Internal outputs from UUT  
    signal RD1_out : std_logic_vector(M-1 downto 0);
    signal RD2_out : std_logic_vector(M-1 downto 0);

    --Internal inputs registers
    signal WE3_reg  : std_logic; -- Write enable
    signal A1_reg   : std_logic_vector(N-1 downto 0);
    signal A2_reg   : std_logic_vector(N-1 downto 0);
    signal A3_reg   : std_logic_vector(N-1 downto 0);
    signal WD3_reg  : std_logic_vector(M-1 downto 0); 
    
    --Internal outputs registers  
    signal RD1_reg  : std_logic_vector(M-1 downto 0);
    signal RD2_reg  : std_logic_vector(M-1 downto 0);    
 
     -- Clock period definition
    constant CLK_period : time := 12.150ns;
       
begin

    -- Instantiate the Unit Under Test (UUT) 
    uut: RegFilesWithPC
        generic map(
            M => M, 
            N => N 
        )
        port map(
            CLK => CLK,
            WE3 => WE3_reg,
            A1  => A1_reg,
            A2  => A2_reg,
            A3  => A3_reg,
            WD3 => WD3_reg,
            RD1 => RD1_out,
            RD2 => RD2_out,
            R15 => R15_in
        );                 

    -- Clock process definition   
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_period/2 ;
        CLK <= '1' ;
        wait for CLK_period/2 ;
    end process;
    
    -- Reigesters update process
    REG_UPDATE: process(CLK)
    begin
        if rising_edge(CLK) then
            WE3_reg <= WE3_in;
            A1_reg  <= A1_in;
            A2_reg  <= A2_in;
            A3_reg  <= A3_in;
            WD3_reg <= WD3_in;
            RD1_reg <= RD1_out;
            RD2_reg <= RD2_out;
        end if;
    end process;
       
          
    REGISTER_FILE_TEST: process
    variable temp : integer;
    
    begin
        wait until (CLK = '0' and CLK'event);
        report "REGISTER FILE TEST START";      
        
        report "INITIALIZING REGISTER VALUES"; 
        -- The value of R0 will be 0, of r1 will 1 etc. Furthermore i will try to write on r15 in order to confirm that, it is not allowed.
        WE3_in <= '1'; -- Write enable on
        for I in 0 to 15 loop
            A3_in  <= std_logic_vector(TO_UNSIGNED(I,N)); 
            WD3_in <= std_logic_vector(TO_UNSIGNED(I,M)); 
            wait for 1*CLK_period;
       end loop;
       
       WE3_in <= '0'; -- Write enable off
       
       wait for 1*CLK_period;
       report "INITIALIZING REGISTER VALUES DONE";
       
       report "START READING";        
       for I in 0 to 15 loop
            A2_in  <= std_logic_vector(TO_UNSIGNED(I,N)); 
            A3_in  <= std_logic_vector(TO_UNSIGNED(I,N));  
            wait for 1*CLK_period;
       end loop; 
       report "END READING";                  
 
       wait for 1*CLK_period;
       report "INITIALIZING R15"; 
       R15_in <= std_logic_vector(to_unsigned(16,M)); -- r15 = 16, in order to check the value
       wait for 1*CLK_period;    
 
        report "INVERSE WRITE TEST START";
        -- Reading each register (0–14) from port1, writing its inverse value, and reading back from port2
        
        for I in 0 to 15 loop
            -- Read from port1. Store current value in variable temp
            A1_in <= std_logic_vector(to_unsigned(I,N));
            wait for 2*CLK_period;
            temp := to_integer(signed(RD1_reg));

            -- Write inverse value to the same register
            WE3_in <= '1';
            A3_in  <= std_logic_vector(to_unsigned(I,N));
            WD3_in <= std_logic_vector(to_signed(-temp,M));
            wait for 1*CLK_period;
            WE3_in <= '0';

            -- Read back from port2 to confirm the new value
            A2_in <= std_logic_vector(to_unsigned(I,N));
            wait for 1*CLK_period;
            
        end loop;
        
        report "INVERSE WRITE TEST COMPLETED";       
        stop(2);
        
    end process;

end Behavioral;
