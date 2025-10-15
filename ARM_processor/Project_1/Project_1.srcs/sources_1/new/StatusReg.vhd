-- StatusReg: N-bit status register (default N=4) for flags
-- - Stores flags C, Z, N, V
-- - Reset (RE) clears all flags to '0' synchronously
-- - Write enable (WE) loads new flag values on rising edge of CLK
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity StatusReg is
    generic (
        N : integer := 4  -- number of flags (default 4: C, Z, N, V)
    );
    port (
        CLK   : in  std_logic;
        WE    : in  std_logic;  -- Write enable
        RE    : in  std_logic;  -- Reset
        C_in  : in  std_logic;
        Z_in  : in  std_logic;
        N_in  : in  std_logic;
        V_in  : in  std_logic;
        C_out : out std_logic;
        Z_out : out std_logic;
        N_out : out std_logic;
        V_out : out std_logic
    );
end StatusReg;

architecture Behavioral of StatusReg is
    signal SR : std_logic_vector(N-1 downto 0) := (others => '0');
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RE = '1' then
                SR <= (others => '0');
            elsif WE = '1' then
                SR(0) <= V_in;  -- bit 0 = V
                SR(1) <= C_in;  -- bit 1 = C
                SR(2) <= Z_in;  -- bit 2 = Z
                SR(3) <= N_in;  -- bit 3 = N
            end if;
        end if;
    end process;

    V_out <= SR(0);
    C_out <= SR(1);
    Z_out <= SR(2);
    N_out <= SR(3);

end Behavioral;
