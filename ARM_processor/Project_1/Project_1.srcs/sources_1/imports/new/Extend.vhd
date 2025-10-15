-- Extend Unit
--  - ImmSrc = '0': zero-extend 12-bit immediate to 32 bits
--  - ImmSrc = '1': (Instr(23:0) << 2)  => 26-bit signed value, then sign-extend to 32 bits
-- Inputs : Instr[23:0] from instruction word, ImmSrc
-- Output : ExtImm[31:0]

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Extend is
    generic (
        OutputBits      : positive := 32; -- 32 bit output
        InputBits       : positive := 24; -- 24 bit input
        ZeroInputBits   : positive := 12; 
        SignInputBits   : positive := 26 -- Instr & "00"
    );

    Port (Instr     : in std_logic_vector (InputBits - 1 downto 0);
          ImmSrc    : in std_logic;
          ExtImm    : out std_logic_vector (OutputBits - 1 downto 0));
          
end Extend;

architecture Dataflow of Extend is

signal Instr12 : unsigned  (ZeroInputBits - 1 downto 0);
signal Instr26 : signed  (SignInputBits - 1 downto 0);

begin

    Instr26 <= signed(Instr & '0' & '0');
    Instr12 <= unsigned(Instr(ZeroInputBits-1 downto 0));
    
    ExtImm <= std_logic_vector(resize(Instr12, OutputBits)) when ImmSrc = '0' else
              std_logic_vector(resize(Instr26, OutputBits)) when ImmSrc = '1' else
              (others => '-');    
    
end Dataflow;
