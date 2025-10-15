--Perfomes logical or
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Orr is
    generic (N : positive := 32);
    
    port
    (
        SrcA        : in std_logic_vector (N-1 downto 0); 
        SrcB        : in std_logic_vector (N-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
end Orr;

architecture Dataflow of Orr is

begin

    ALUResult <= SrcA or SrcB;

end Dataflow;
