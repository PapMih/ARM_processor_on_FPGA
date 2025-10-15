--Perfomes logical and
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Andd is
    generic (N : positive := 32);
    
    port
    (
        SrcA        : in std_logic_vector (N-1 downto 0); 
        SrcB        : in std_logic_vector (N-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
end Andd;

architecture Dataflow of Andd is

begin

    ALUResult <= SrcA and SrcB;

end Dataflow;
