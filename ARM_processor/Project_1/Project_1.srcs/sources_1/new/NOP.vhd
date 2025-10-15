-- Performs NOP instruction (MOV R0, R0)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NOP is
    generic (N : positive := 32);
    
    port
    (
        SrcB        : in std_logic_vector (N-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
    
end NOP;

architecture Dataflow of NOP is

begin
     ALUResult <= SrcB;

end Dataflow;
