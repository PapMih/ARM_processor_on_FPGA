-- Performs Arithmetic Shift Right (ASR): ALUResult = SrcB sra shamt5
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ASR is
  generic (
    N : positive := 32;  
    S : positive := 5    -- shift amount width
  );
  port (
    SrcB        : in  std_logic_vector(N-1 downto 0);
    shamt5      : in  std_logic_vector(S-1 downto 0);
    ALUResult   : out std_logic_vector(N-1 downto 0)
  );
end ASR;

architecture Dataflow of ASR is
begin
  ALUResult <= std_logic_vector( shift_right(signed(SrcB), to_integer(unsigned(shamt5))) );
  
end Dataflow;
