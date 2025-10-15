-- Generic N-bit adder.
-- Produces:
--   - sum: N-bit result of SrcA + SrcB
--   - C  : carry-out flag 
--   - V  : overflow flag 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
    generic (
        N : positive := 32
    );
    port (
        SrcA, SrcB : in  std_logic_vector(N - 1 downto 0);
        ALUControl : in  std_logic;
        sum        : out std_logic_vector(N - 1 downto 0);
        C, V       : out std_logic
    );
end Adder;

architecture Dataflow of Adder is
    signal SrcASignal : unsigned(N downto 0);
    signal SrcBSignal : unsigned(N downto 0);
    signal sumSignal  : unsigned(N downto 0);
    
begin
    SrcASignal <= unsigned('0' & SrcA);
    
    SrcBSignal <= unsigned('0' & (not SrcB)) when ALUControl = '1' else 
                  unsigned('0' & SrcB);
    
    sumSignal <= SrcASignal + SrcBSignal when ALUControl = '0' else
                 SrcASignal + SrcBSignal + 1;
    
    sum <= std_logic_vector(sumSignal(N - 1 downto 0));
    C <= sumSignal(N);
    
    V <= (SrcA(N-1) xor sumSignal(N-1)) and 
         ((SrcB(N-1) xor ALUControl) xor sumSignal(N-1));

end Dataflow;