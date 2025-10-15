-- Multiplexer of 2 inputs to 1 output
-- Input has N bits

------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    generic (N : positive := 32);
    port
    (
        X0  : in std_logic_vector (N-1 downto 0);
        X1  : in std_logic_vector (N-1 downto 0);
        SEL : in std_logic;
        Y   : out std_logic_vector (N-1 downto 0)
    );
end mux2to1;

architecture Dataflow of mux2to1 is
    begin
    
        Y <= X0 when SEL = '0' else
        X1 when SEL = '1' else
        (others => '-');
        
end Dataflow;
