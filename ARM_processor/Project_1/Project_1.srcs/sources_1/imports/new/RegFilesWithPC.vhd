-- Register File with PC (R15) integration
-- Contains registers R0-R14. R15 (PC) is handled externally.
-- Outputs RD1 and RD2 provide data from registers at addresses A1 and A2
-- When WE3 = 1, WD3 is written to register at A3 on clock rise
-- Reading is asynchronous (combinational)
-- Writing is synchronous (clocked)
-- Reads from address 15 return external R15 (PC+8) instead of register file

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFilesWithPC is
    generic (
        M : positive := 32;  -- 32 bit
        N : integer  := 4    -- 2^N total registers
    );
    
    port (
        CLK  : in  std_logic;
        WE3  : in  std_logic; -- Write enable
        A1   : in  std_logic_vector(N-1 downto 0);
        A2   : in  std_logic_vector(N-1 downto 0);
        A3   : in  std_logic_vector(N-1 downto 0);
        WD3  : in  std_logic_vector(M-1 downto 0);
        RD1  : out std_logic_vector(M-1 downto 0);
        RD2  : out std_logic_vector(M-1 downto 0);
        R15  : in  std_logic_vector(M-1 downto 0)
    );
end RegFilesWithPC;

architecture Structural of RegFilesWithPC is

    component RegFile is
        generic (
            N : positive := 4;   -- 16 words
            M : positive := 32
        );
        port (
            CLK  : in  std_logic;
            WE3  : in  std_logic;
            A1   : in  std_logic_vector(N-1 downto 0);
            A2   : in  std_logic_vector(N-1 downto 0);
            A3   : in  std_logic_vector(N-1 downto 0);
            WD3  : in  std_logic_vector(M-1 downto 0);
            RD1  : out std_logic_vector(M-1 downto 0);
            RD2  : out std_logic_vector(M-1 downto 0)
        );
    end component;

    signal r1 : std_logic_vector(M-1 downto 0);
    signal r2 : std_logic_vector(M-1 downto 0);

begin

    rf: RegFile
        generic map (
            N => N,
            M => M
        )
        port map (
            CLK  => CLK,
            WE3  => WE3,
            A1   => A1,
            A2   => A2,
            A3   => A3,
            WD3  => WD3,
            RD1  => r1,
            RD2  => r2
        );

    RD1 <= R15 when A1 = std_logic_vector(to_unsigned(15, N)) else r1;
    RD2 <= R15 when A2 = std_logic_vector(to_unsigned(15, N)) else r2;

end Structural;
