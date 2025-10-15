-- Performs Logical Shift Right (LSR): ALUResult = SrcB >> shamt5
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LSR is
    generic (
        N : positive := 32;  
        S : positive := 5    -- shift amount width 
  );
  port (
    SrcB        : in  std_logic_vector(N-1 downto 0);
    shamt5      : in  std_logic_vector(S-1 downto 0);
    ALUResult   : out std_logic_vector(N-1 downto 0)
  );
end LSR;

architecture Dataflow of LSR is
begin
  ALUResult <= std_logic_vector( shift_right(unsigned(SrcB), to_integer(unsigned(shamt5))) );
  
end Dataflow;
