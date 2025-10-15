-- CONDLogic (Behavioral)
-- Evaluates the condition field of an instruction against the status flags and produces a single enable for conditional execution.
-- Inputs:
--   N_Flag, Z_Flag, C_Flag, V_Flag : status flags from the Status Register.
--   cond(3 downto 0)               : condition code from the instruction (bits 31:28).
-- Output:
--   CondEx_in                      : '1' when the condition is satisfied, else '0'.
-- Condition map:
--   0000 (EQ)  :  Z
--   0001 (NE)  :  not Z
--   0010 (CS)  :  C
--   0011 (CC)  :  not C
--   0100 (MI)  :  N
--   0101 (PL)  :  not N
--   0110 (VS)  :  V
--   0111 (VC)  :  not V
--   1000 (HI)  :  (not Z) and C
--   1001 (LS)  :  Z or (not C)
--   1010 (GE)  :  N xnor V
--   1011 (LT)  :  N xor V
--   1100 (GT)  :  (not Z) and (N xnor V)
--   1101 (LE)  :  Z or (N xor V)
--   1110 (AL)  :  '1'   -- always
--   1111       :  '1'   -- unconditional (same as AL)

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONDLogic is
     Port ( 
        N_Flag      : in std_logic;
        Z_Flag      : in std_logic;
        V_Flag      : in std_logic;
        C_Flag      : in std_logic;
        cond        : in std_logic_vector(3 downto 0);
        CondEx_in   : out std_logic        
        );
end CONDLogic;

architecture Behavioral of CONDLogic is
begin
    
    CondExProc: process(N_Flag, Z_Flag, V_Flag, C_Flag, cond)
    begin
       
        case cond is
            when "0000" => CondEx_in <= Z_Flag;                                 -- Equal
            when "0001" => CondEx_in <= not(Z_Flag);                            -- Not equal
            when "0010" => CondEx_in <= C_Flag;                                 -- Carry set / unsigned higher or same
            when "0011" => CondEx_in <= not(C_Flag);                            -- Carry clear / unsigned lower
            when "0100" => CondEx_in <= N_Flag;                                 -- Minus / negative
            when "0101" => CondEx_in <= not(N_Flag);                            -- Plus / positive or zero
            when "0110" => CondEx_in <= V_Flag;                                 -- Overflow / overflow set
            when "0111" => CondEx_in <= not(V_Flag);                            -- No overflow / overflow clear
            when "1000" => CondEx_in <= ((not(Z_Flag)) and (C_Flag));           -- Overflow / overflow set
            when "1001" => CondEx_in <= (Z_Flag or ( not (C_Flag)));            -- Unsigned lower or same
            when "1010" => CondEx_in <= N_Flag xnor V_Flag;                     -- Signed greater or equal
            when "1011" => CondEx_in <= N_Flag xor V_Flag;                      -- Signed less
            when "1100" => CondEx_in <= (not Z_Flag) and (N_Flag xnor V_Flag);  -- Signed greater
            when "1101" => CondEx_in <= Z_Flag or (N_Flag xor V_Flag);         -- Signed less or equal 
            when "1110" => CondEx_in <= '1';                                    -- Always / unconditional  
            when "1111" => CondEx_in <= '1';                                    -- Any others case                       
            when others => CondEx_in <= '-';
         end case;   
    end process;           
end Behavioral;
