-- Write Enable Logic (WELogic)
-- Decodes the write enable signals for register file, memory, and flags.
-- Inputs are:
--   op (bits 27:26) : main opcode group
--   SL (bit 20) : S/L field (Set flags/Load for different instruction types)
--   IL (bits 25:24) : 1L field for branch instructions (10=B, 11=BL)
--   NoWrite_in : internal signal that disables register write (e.g. for CMP)
-- Outputs:
--   RegWrite_in  : enables writing to register file
--   MemWrite_in  : enables writing to data memory
--   FlagsWrite_in: enables writing to status flags register

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WELogic is
    port(
        op           : in std_logic_vector(1 downto 0);
        SL           : in std_logic;
        IL           : in std_logic_vector(1 downto 0);
        NoWrite_in   : in std_logic;
        RegWrite_in  : out std_logic;
        MemWrite_in  : out std_logic;
        FlagsWrite_in: out std_logic
    );   
end WELogic;

architecture Behavioral of WELogic is

begin

    RegWrite_inProc: process(op, SL, IL, NoWrite_in)
    begin
        case op is
            -- Data-processing instructions
            when "00" =>
                case NoWrite_in is
                    when '0'    => RegWrite_in <= '1';  -- DP instructions write to register
                    when '1'    => RegWrite_in <= '0';  -- CMP does not writes to register
                    when others => RegWrite_in <= '-';  -- Any other case 
                end case;

            -- Memory instructions
            when "01" =>
                case SL is
                    when '1'    => RegWrite_in <= '1';  -- LDR writes to register
                    when '0'    => RegWrite_in <= '0';  -- STR does not write to register
                    when others => RegWrite_in <= '-';  -- Any other case 
                end case;

            -- Branch instructions
            when "10" =>
                case IL is
                    when "10"   => RegWrite_in <= '0';  -- B does not write to register
                    when "11"   => RegWrite_in <= '1';  -- BL writes to register
                    when others => RegWrite_in <= '-';  -- Any other case 
                end case;

            -- Any other case
            when others =>
                RegWrite_in <= '0';
        end case;
    end process;

    MemWrite_inProc: process(op, SL)
    begin
        case op is
            -- Data-processing instructions
            when "00" =>
                MemWrite_in <= '0';  -- DP instructions do not write to memory

            -- Memory instructions
            when "01" =>
                case SL is
                    when '1'    => MemWrite_in <= '0';  -- LDR does not write to memory
                    when '0'    => MemWrite_in <= '1';  -- STR writes to memory
                    when others => MemWrite_in <= '-';  -- Any other case 
                end case;

            -- Branch instructions
            when "10" =>
                MemWrite_in <= '0';  -- Branch instructions do not write to memory

            -- Any other case
            when others =>
                MemWrite_in <= '-';
        end case;
    end process;

    FlagsWrite_inProc: process(op, SL, NoWrite_in)
    begin
        case op is
            -- Data-processing instructions
            when "00" =>
                case SL is
                    when '1'    => FlagsWrite_in <= '1';  -- S=1 enables flag write (including CMP)
                    when '0'    => FlagsWrite_in <= '0';  -- S=0 does not write on flags registry
                    when others => FlagsWrite_in <= '-';  -- Any other case 
                end case;

            -- Memory instructions
            when "01" =>
                FlagsWrite_in <= '0';  -- Memory instructions do not write on flags registry

            -- Branch instructions
            when "10" =>
                FlagsWrite_in <= '0';  -- Branch instructions do not write on flags registry

            -- Any other case
            when others =>
                FlagsWrite_in <= '-'; 
        end case;
    end process;

end Behavioral;