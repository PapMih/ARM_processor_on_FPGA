-- Performs shift operations using submodules: ASR, LSL, LSR, and ROR
-- Inputs:
--   - sel: 2-bit selector (from ALUControl[1:0])
--       "00" -> ASR (Arithmetic Shift Right)
--       "01" -> LSL (Logical Shift Left)
--       "10" -> LSR (Logical Shift Right)
--       "11" -> ROR (Rotate Right)
--   - SrcB: N-bit input to be shifted
--   - shamt5: 5-bit shift amount
-- Output:
--   - ALUResult: result of the selected shift operation
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftOperationsComponent is
    generic (
        N : positive := 32;
        S : positive := 5    -- Shift amount width
    );
    port (
        sel       : in  std_logic_vector(1 downto 0); -- AluControl[1:0]
        SrcB      : in  std_logic_vector(N - 1 downto 0);
        shamt5    : in  std_logic_vector(S - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0)
    );
end ShiftOperationsComponent;

architecture Structural of ShiftOperationsComponent is

    component ASR is
        generic (N : positive := 32; S : positive := 5);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            shamt5    : in  std_logic_vector(S - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component LSL is
        generic (N : positive := 32; S : positive := 5);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            shamt5    : in  std_logic_vector(S - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component LSR is
        generic (N : positive := 32; S : positive := 5);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            shamt5    : in  std_logic_vector(S - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component RORR is
        generic (N : positive := 32; S : positive := 5);
        port (
            SrcB      : in  std_logic_vector(N - 1 downto 0);
            shamt5    : in  std_logic_vector(S - 1 downto 0);
            ALUResult : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    signal ASRSignal   : std_logic_vector(N - 1 downto 0);
    signal LSRSignal   : std_logic_vector(N - 1 downto 0);
    signal LSLSignal   : std_logic_vector(N - 1 downto 0);
    signal RORRSignal  : std_logic_vector(N - 1 downto 0);

begin

    ASRComp: ASR
        generic map (N => N, S => S)
        port map (
            SrcB      => SrcB,
            shamt5    => shamt5,
            ALUResult => ASRSignal
        );

    LSLComp: LSL
        generic map (N => N, S => S)
        port map (
            SrcB      => SrcB,
            shamt5    => shamt5,
            ALUResult => LSLSignal
        );

    LSRComp: LSR
        generic map (N => N, S => S)
        port map (
            SrcB      => SrcB,
            shamt5    => shamt5,
            ALUResult => LSRSignal
        );

    RORRComp: RORR
        generic map (N => N, S => S)
        port map (
            SrcB      => SrcB,
            shamt5    => shamt5,
            ALUResult => RORRSignal
        );

    with sel select
        ALUResult <= ASRSignal  when "00",
                     LSLSignal  when "01",
                     LSRSignal  when "10",
                     RORRSignal when "11",
                     (others => '-') when others;

end Structural;
