-- Performs Logical Shift Left (LSL): ALUResult = SrcB << shamt5
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity LSL is
    generic (
        N : positive := 32;
        S : positive := 5 -- shift amount width (bits)  
    );
    
    port( 
        SrcB        : in std_logic_vector (N-1 downto 0);
        shamt5      : in std_logic_vector (S-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
end LSL;

architecture Dataflow of LSL is

begin
    ALUResult <= std_logic_vector(shift_left(unsigned(SrcB), to_integer(unsigned(shamt5))));

end Dataflow;
