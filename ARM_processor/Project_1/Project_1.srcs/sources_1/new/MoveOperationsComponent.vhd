-- Performs MOV-related operations using submodules: MOV, MVN, and NOP
-- Inputs:
--   - sel: 2-bit selector (from ALUControl[1:0])
--       "00" -> MOV  (copy SrcB to result)
--       "01" -> MVN  (bitwise NOT of SrcB)
--       "11" -> NOP  (MOV R0, R0 - effectively passes SrcB unchanged)
--   - SrcB: N-bit operand for all operations
-- Output:
--   - ALUResult: result of the selected move operation
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MoveOperationsComponent is
    generic (
        N : positive := 32
    );
    port (
        sel       : in  std_logic_vector(1 downto 0); -- AluControl[1:0]
        SrcB      : in  std_logic_vector(N - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0)
    );
end MoveOperationsComponent;

architecture Structural of MoveOperationsComponent is

    component MOV is
        generic (N : positive := 32);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component MVN is
        generic (N : positive := 32);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    signal MOVSignal  : std_logic_vector(N - 1 downto 0);
    signal MVNSignal  : std_logic_vector(N - 1 downto 0);

begin

    MOVComp: MOV
        generic map (N => N)
        port map (
            SrcB      => SrcB,
            ALUResult => MOVSignal
        );

    MVNComp: MVN
        generic map (N => N)
        port map (
            SrcB      => SrcB,
            ALUResult => MVNSignal
        );

    with sel select
        ALUResult <= MOVSignal  when "00",
                     MVNSignal when "01",
                     MOVSignal  when "11",   -- NOP treated as MOV   
                     (others => '-') when others;

end Structural;
