--Performs MOV instruction 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MVN is
    generic (N : positive := 32);
    
    port
    ( 
        SrcB        : in std_logic_vector (N-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
end MVN;

architecture Dataflow of MVN is

begin
    ALUResult <= not SrcB;

end Dataflow;
