--Adds the n integer to the input 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INC4 is 
    generic (
        M : positive := 32; -- 32 bit
        N : integer := 4 -- Value to increment by
    );
        
    port(
        PC      :        in std_logic_vector(M-1 downto 0);
        PCPlus4 :   out std_logic_vector(M-1 downto 0)
    );
end INC4;

architecture Dataflow of INC4 is
begin

    PCPlus4 <= std_logic_vector(unsigned(PC) + to_unsigned(N, M));

end Dataflow;
