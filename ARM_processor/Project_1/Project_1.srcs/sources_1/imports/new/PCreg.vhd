-- N bit programm counter register with sychronous reset and write enable(always 1)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCreg is
    generic (M : positive := 32); -- Word length
    port(
        CLK,
        Reset       : in std_logic;
        WE          : in std_logic := '1';
        PCN         : in std_logic_vector (M-1 downto 0);
        PC          : out std_logic_vector (M-1 downto 0)
    );
end PCreg;

architecture Behavioral of PCreg is
signal pc_s : std_logic_vector(M-1 downto 0) := (others => '0'); -- Initial value

begin
 

    process(CLK) 
    begin
        if rising_edge(CLK) then
            if Reset = '1' then
                pc_s <= (others => '0');
            elsif WE = '1' then
                pc_s <= PCN;
           end if;
        end if;
    end process;
    
    PC <= pc_s;

end Behavioral;
