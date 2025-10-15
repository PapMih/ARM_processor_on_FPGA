-- Performs NOR on N bits and returns 1 only if all bits are 0

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Norr is
    generic (N : positive := 32);
    
    port (
        input  : in  std_logic_vector(N-1 downto 0);
        output : out std_logic
    );
end Norr;

architecture Behavioral of Norr is
    signal temp : std_logic;
begin
    process(input)
        variable or_result : std_logic := '0';
    begin
        or_result := '0';
        for i in 0 to N-1 loop
            or_result := or_result or input(i);
        end loop;
        output <= not or_result;
    end process;
end Behavioral;
