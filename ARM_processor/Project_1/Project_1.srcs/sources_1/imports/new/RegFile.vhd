-- Registers R0-R14
-- The outputs RD1 and RD2 provide the data stored in the registers located at addresses A1 and A2
-- When WE3 is 1, the data from WD3 is written into the register specified by A3
-- Reading is asynchronous
-- Writing is synchronous

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile is
    generic (
        M : positive := 32;  -- 32 bit
        N : integer  := 4    -- 2^N total registers
    );
    port (
        CLK : in  std_logic;
        WE3 : in  std_logic; -- Write enable
        A1  : in  std_logic_vector(N-1 downto 0);
        A2  : in  std_logic_vector(N-1 downto 0);
        A3  : in  std_logic_vector(N-1 downto 0);
        WD3 : in  std_logic_vector(M-1 downto 0);
        RD1 : out std_logic_vector(M-1 downto 0);
        RD2 : out std_logic_vector(M-1 downto 0)
    );
end RegFile;

architecture Behavioral of RegFile is
    type ramtype is array (2**N - 2 downto 0) of std_logic_vector(M-1 downto 0);
    signal mem : ramtype;
    constant R15_ADDR : integer := 2**N - 1;

begin

    -- Asynchronous reading
    READ : process (A1, A2, mem)
        variable i1, i2 : integer;
    begin
        i1 := to_integer(unsigned(A1));
        i2 := to_integer(unsigned(A2));

        if i1 < R15_ADDR then
            RD1 <= mem(i1);
        else
            RD1 <= (others => '0');
        end if;

        if i2 < R15_ADDR then
            RD2 <= mem(i2);
        else
            RD2 <= (others => '0');
        end if;
    end process;

    -- Synchronous writing
    WRITE : process (CLK)
    begin
        if rising_edge(CLK) then
            if WE3 = '1' then
                if to_integer(unsigned(A3)) < R15_ADDR then
                    mem(to_integer(unsigned(A3))) <= WD3;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

