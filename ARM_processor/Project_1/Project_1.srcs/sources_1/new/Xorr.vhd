--Perfomes logical Xor
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Xorr is
    generic (N : positive := 32);
    
    port
    (
        SrcA        : in std_logic_vector (N-1 downto 0); 
        SrcB        : in std_logic_vector (N-1 downto 0); 
        ALUResult   : out std_logic_vector (N-1 downto 0)
    );
end Xorr;

architecture Dataflow of Xorr is

begin

    ALUResult <= SrcA xor SrcB;

end Dataflow;
