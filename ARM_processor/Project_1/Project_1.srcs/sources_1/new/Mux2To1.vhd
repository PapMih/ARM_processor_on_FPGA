-- Multiplexer of 2 inputs to 1 output
-- Input has N bits
-- Selects between Y0 when SEL=0 and Y1 SEL=1

------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux2To1 is
    generic (N : positive := 32);
    port
    (
        X       : out std_logic_vector (N-1 downto 0);
        SEL     : in std_logic;
        Y1, Y0  : in std_logic_vector (N-1 downto 0)
    );
end Mux2To1;

architecture Dataflow of Mux2To1 is
    begin
    
        X <= Y0 when SEL = '0' else
             Y1 when SEL = '1' else
            (others => '-');
        
end Dataflow;
