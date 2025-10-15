-- Arithmetic Logic Unit (ALU)
-- Implements arithmetic, logic, shift and move operations based on ALUControl.
-- Operation categories are selected by the 2 MSB of ALUControl:
--   "00" -> Add/Subtract (uses LSB as sel)
--   "01" -> MOV, MVN, NOP (ALUControl(1:0))
--   "10" -> AND, ORR, XOR (ALUControl(1:0))
--   "11" -> LSL, LSR, ASR, ROR (ALUControl(1:0))
-- Outputs: ALUResult (W-bit), flags N, Z, C, V.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
  generic (
    W : positive := 32;
    S : positive := 5
  );
  port (
    SrcA, SrcB : in  std_logic_vector(W-1 downto 0);
    shamt5     : in  std_logic_vector(S-1 downto 0);
    ALUResult  : out std_logic_vector(W-1 downto 0);
    N, Z, C, V : out std_logic;
    ALUControl : in  std_logic_vector(3 downto 0)
  );
end ALU;

architecture Structural of ALU is

  component AddSub is
    generic (N : positive := 32);
    port (
      sel       : in std_logic_vector(1 downto 0);
      SrcA      : in std_logic_vector(N - 1 downto 0);
      SrcB      : in std_logic_vector(N - 1 downto 0);
      ALUResult : out std_logic_vector(N - 1 downto 0);
      C, V      : out std_logic
    );
  end component;

  component LogicalOperationsComponent is
    generic (N : positive := 32);
    port (
      sel       : in std_logic_vector(1 downto 0);
      SrcA      : in std_logic_vector(N - 1 downto 0);
      SrcB      : in std_logic_vector(N - 1 downto 0);
      ALUResult : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component MoveOperationsComponent is
    generic (N : positive := 32);
    port (
      sel       : in std_logic_vector(1 downto 0);
      SrcB      : in std_logic_vector(N - 1 downto 0);
      ALUResult : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component ShiftOperationsComponent is
    generic (
      N : positive := 32;
      S : positive := 5
    );
    port (
      sel       : in std_logic_vector(1 downto 0);
      SrcB      : in std_logic_vector(N - 1 downto 0);
      shamt5    : in std_logic_vector(S - 1 downto 0);
      ALUResult : out std_logic_vector(N - 1 downto 0)
    );
  end component;
  
  component Norr is
    generic (N : positive := 32);
    port (
        input  : in  std_logic_vector(N-1 downto 0);
        output : out std_logic
    );
end component;

  signal AddSubOut       : std_logic_vector(W - 1 downto 0);
  signal LogicOut        : std_logic_vector(W - 1 downto 0);
  signal MoveOut         : std_logic_vector(W - 1 downto 0);
  signal ShiftOut        : std_logic_vector(W - 1 downto 0);
  signal NorOut          : std_logic;
  signal CarrySignal     : std_logic;
  signal OverflowSignal  : std_logic;
  signal ResultSignal    : std_logic_vector(W - 1 downto 0);

begin

  -- ADD/SUB
  AddSubComp: AddSub
    generic map (N => W)
    port map (
      sel       => ALUControl(1 downto 0),
      SrcA      => SrcA,
      SrcB      => SrcB,
      ALUResult => AddSubOut,
      C         => CarrySignal,
      V         => OverflowSignal
    );

  -- Logical ops (AND, ORR, XOR)
  LogicComp: LogicalOperationsComponent
    generic map (N => W)
    port map (
      sel       => ALUControl(1 downto 0),
      SrcA      => SrcA,
      SrcB      => SrcB,
      ALUResult => LogicOut
    );

  -- Move ops (MOV, MVN, NOP)
  MoveComp: MoveOperationsComponent
    generic map (N => W)
    port map (
      sel       => ALUControl(1 downto 0),
      SrcB      => SrcB,
      ALUResult => MoveOut
    );

  -- Shift ops (LSL, LSR, ASR, ROR)
  ShiftComp: ShiftOperationsComponent
    generic map (N => W, S => S)
    port map (
      sel       => ALUControl(1 downto 0),
      SrcB      => SrcB,
      shamt5    => shamt5,
      ALUResult => ShiftOut
    );
    
   --Nor op
    NorrComp: Norr
    generic map (N => W)
    port map (
        input => ResultSignal,
        output => NorOut
    );

  -- ALU operation selection
  process(ALUControl, AddSubOut, LogicOut, MoveOut, ShiftOut, CarrySignal, OverflowSignal)
  begin
    ResultSignal <= (others => '0');
    C <= '0';
    V <= '0';

    case ALUControl(3 downto 2) is

      when "00" =>  -- Arithmetic: ADD/SUB
        ResultSignal <= AddSubOut;
        C <= CarrySignal and (not ALUControl(1));
        V <= OverflowSignal and (not ALUControl(1));

      when "01" =>  -- Move: MOV, MVN, NOP
        ResultSignal <= MoveOut;

      when "10" =>  -- Logic: AND, ORR, XOR
        ResultSignal <= LogicOut;

      when "11" =>  -- Shift: LSL, LSR, ASR, ROR
        ResultSignal <= ShiftOut;

      when others =>
        ResultSignal <= (others => 'X');
        C <= 'X';
        V <= 'X';

    end case;
  end process;


  ALUResult <= ResultSignal;
  N <= ResultSignal(W - 1);
  Z <= NorOut;

end Structural;
