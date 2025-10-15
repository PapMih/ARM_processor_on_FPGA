-- Adder/Subtractor unit.
-- Performs addition when sel = "00" and subtraction when sel = "01".
-- Uses the Adder component.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AddSub is
    generic (
        N : positive := 32
    );
    port (
        sel       : in  std_logic_vector(1 downto 0);
        SrcA      : in  std_logic_vector(N - 1 downto 0);
        SrcB      : in  std_logic_vector(N - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0);
        C         : out std_logic;
        V         : out std_logic
    );
end AddSub;

architecture Structural of AddSub is
    component Adder is
        generic (N : positive := 32);
        port (
            SrcA        : in  std_logic_vector(N - 1 downto 0);
            SrcB        : in  std_logic_vector(N - 1 downto 0);
            ALUControl  : in  std_logic;
            sum         : out std_logic_vector(N - 1 downto 0);
            C           : out std_logic;
            V           : out std_logic
        );
    end component;

begin
    add: Adder
        generic map (N => N)
        port map (
            SrcA       => SrcA,
            SrcB       => SrcB,
            ALUControl => sel(0),
            sum        => ALUResult,
            C          => C,
            V          => V
        );

end Structural;