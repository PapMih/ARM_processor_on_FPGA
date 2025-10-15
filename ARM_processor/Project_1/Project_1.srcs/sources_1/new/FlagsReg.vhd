----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2025 17:20:46
-- Design Name: 
-- Module Name: FlagsReg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlagsReg is
    generic (
        N : integer  := 4    -- 4 flags
    );
 
     port (   
        CLK     : in  std_logic;
        WE      : in  std_logic; -- Write enable
        RE      : in  std_logic; -- RESET
        C_in    : in  std_logic;
        Z_in    : in  std_logic;
        N_in    : in  std_logic;
        V_in    : in  std_logic;
        C_out   : out  std_logic;
        Z_out   : out  std_logic;
        N_out   : out  std_logic;
        V_out   : out  std_logic
    );    

end FlagsReg;

architecture Behavioral of FlagsReg is

begin


end Behavioral;
