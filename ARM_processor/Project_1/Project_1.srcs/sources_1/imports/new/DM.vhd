-- Data Memory (DM)
-- Parameterized RAM with 2^N words of M bits each, used as CPU data memory.
-- Inputs:
--   clk : Clock signal
--   WE  : Write Enable - on rising edge, writes WD to memory if WE = '1'
--   A   : Address input (uses bits A(N+1 downto 2) for indexing)
--   WD  : Write Data (M-bit)
-- Output:
--   RD  : Read Data (M-bit), read asynchronously
-- Generics:
--   M : Word size in bits (default 32)
--   N : Address bits - memory has 2^N words (default 5 -> 32 words)
 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DM is
    generic (
        M : positive := 32; -- Word length
        N : positive := 5 -- 2^5 = 32 words
    );
    
    Port (
            CLK, WE : in std_logic;
            A, WD : in std_logic_vector(M-1 downto 0);
            RD : out std_logic_vector(M-1 downto 0)
            );
end DM;

architecture Behavioral of DM is
type ramtype is array ((2**N -1) downto 0) of std_logic_vector(M-1 downto 0);
        signal  mem : ramtype := (others => (others => '0'));
        
begin

    process(CLK)
        begin
            if rising_edge(CLK) then
                if (WE = '1') then
                    mem(to_integer(unsigned(A(N+1 downto 2)))) <= WD;
                end if;
            end if;
        end process;
    
    RD <= mem(to_integer(unsigned(A(N+1 downto 2))));
                  
end Behavioral;
