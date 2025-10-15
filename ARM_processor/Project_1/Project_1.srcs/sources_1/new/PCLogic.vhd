-- PC Logic 
-- Determines when the Program Counter (PC) must be loaded with a new value instead of simply incrementing to the next sequential instruction.
-- Inputs:
--   op (bits 27:26): main opcode group
--   Rd             : 4-bit destination register field (bits 15:12 of the instruction)
--   RegWrite_in    : internal control signal that enables register write
-- Output:
--   PCSrc_in    : internal signal that requests a PC update from an alternative source

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCLogic is
    Port (
         op          : in  std_logic;
         Rd          : in  std_logic_vector(3 downto 0);
         RegWrite_in : in  std_logic;
         PCSrc_in    : out std_logic
    );
end PCLogic;

architecture Behavioral of PCLogic is
begin
  process(op, Rd, RegWrite_in)
  begin
    if op = '1' then               -- Branch
        PCSrc_in <= '1';
    elsif RegWrite_in = '1' and Rd = "1111" then  --Write to R15
        PCSrc_in <= '1';
    else
        PCSrc_in <= '0';            -- Any other case 
    end if;
  end process;
end Behavioral;
