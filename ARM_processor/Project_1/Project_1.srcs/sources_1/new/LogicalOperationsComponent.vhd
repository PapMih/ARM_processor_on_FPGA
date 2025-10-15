-- Performs logical operations AND, OR, and XOR using individual subcomponents
-- Inputs:
--   - SrcA, SrcB: N-bit logic operands
--   - sel: 2-bit control input to select the operation
--       "10" -> AND
--       "11" -> OR
--       "00" -> XOR
-- Output:
--   - ALUResult: result of the selected logical operation
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicalOperationsComponent is
    generic (
        N : positive := 32
    );
    port (
        sel       : in  std_logic_vector(1 downto 0); -- AluControl[1:0]
        SrcA      : in  std_logic_vector(N - 1 downto 0);
        SrcB      : in  std_logic_vector(N - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0)
    );
end LogicalOperationsComponent;

architecture Structural of LogicalOperationsComponent is

    component Andd is
        generic (
            N : positive := 32
        );
        port (
            SrcA      : in  std_logic_vector(N - 1 downto 0);
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component Orr is
        generic (
            N : positive := 32
        );
        port (
            SrcA      : in  std_logic_vector(N - 1 downto 0);
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component Xorr is
        generic (
            N : positive := 32
        );
        port (
            SrcA      : in  std_logic_vector(N - 1 downto 0);
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    signal AnddSignal  : std_logic_vector(N - 1 downto 0);
    signal OrrSignal   : std_logic_vector(N - 1 downto 0);
    signal XorrSignal  : std_logic_vector(N - 1 downto 0);

begin

    AnddComp: Andd
        generic map (N => N)
        port map (
            SrcA      => SrcA,
            SrcB      => SrcB,
            ALUResult => AnddSignal
        );

    OrrComp: Orr
        generic map (N => N)
        port map (
            SrcA      => SrcA,
            SrcB      => SrcB,
            ALUResult => OrrSignal
        );

    XorrComp: Xorr
        generic map (N => N)
        port map (
            SrcA      => SrcA,
            SrcB      => SrcB,
            ALUResult => XorrSignal
        );

    with sel select
        ALUResult <= AnddSignal  when "10",
                     OrrSignal   when "11",
                     XorrSignal  when "00",
                     (others => '-') when others;

end Structural;
