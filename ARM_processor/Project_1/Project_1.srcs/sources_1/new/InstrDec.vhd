-- Instruction Decoder (InstrDec)
-- Decodes the fields of the 32-bit ARM-like instruction and produces the control signals
-- for the datapath. Inputs are:
--   op (bits 27:26) : main opcode group
--   funct (bits 25:20) : operation/function sub-code
--   sh (bits 6:5) and shamt5 (bits 11:7) : shift type and shift amount for shift instructions.
-- Outputs:
--   RegSrc[2:0] : selects source registers (RA1, RA2, RA3) according to the instruction type
--   ALUSrc      : selects second ALU operand (register or immediate)
--   ImmSrc      : selects immediate extension type (zero/sign extension)
--   ALUControl  : 4-bit code that selects arithmetic, logical, move or shift operation
--   MemToReg    : enables writing data from memory to register file for load instructions
--   NoWrite_in  : disables register write (e.g. CMP) when ALU result is not stored.

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstrDec is
    port(
        op          : in std_logic_vector(1 downto 0);
        funct       : in std_logic_vector(5 downto 0);
        sh          : in std_logic_vector(1 downto 0);
        shamt5      : in std_logic_vector(4 downto 0);
        RegSrc      : out std_logic_vector(2 downto 0);
        ALUSrc      : out std_logic;
        ImmSrc      : out std_logic;
        ALUControl  : out std_logic_vector(3 downto 0);
        MemToReg    : out std_logic;
        NoWrite_in  : out std_logic
    );   
end InstrDec;

architecture Behavioral of InstrDec is

begin

    RegSrcProc: process(op, funct)
    begin
    
        case op & funct(4) is
             when "101"     => RegSrc(2) <= '1'; -- RegSrc(2) = '1' only for BL instruction
             when others    => RegSrc(2) <= '0'; -- for any other case the value is 0 or don't-care (X), so I choose 0 in order to simplify the design
        end case;
        
        case op & funct(0) is
             when "010"     => RegSrc(1) <= '1'; -- RegSrc(1) = '1' only for STR instructions
             when others    => RegSrc(1) <= '0'; -- for any other case the value is 0 or don't-care (X), so I choose 0 in order to simplify the design
        end case;
        
        case op is
             when "10"      => RegSrc(0) <= '1'; -- RegSrc(0) = '1' for all branch instructions (B and BL)
             when others    => RegSrc(0) <= '0'; -- For any other case the value is 0 or don't-care (X), so I choose 0 in order to simplify the design
        end case;
        
    end process;
    
    ALUSrcProc: process(op, funct) 
    begin
    
        case op & funct(5) is
            when "001"  => ALUSrc <= '1';  -- Data-processing with I = 1
            when "010"  => ALUSrc <= '1';  -- Memory instructions (op = "01")
            when "101"  => ALUSrc <= '1';  -- Branch instructions (op = "10")
            when others => ALUSrc <= '0';  -- For any other case the value is 0 or don't-care (X), so I choose 0 in order to simplify the design
        end case;
      
    end process;
    
    ImmSrcProc: process(op, funct)
    begin
        
        case op is
            when "10"   => ImmSrc <= '1'; -- Branch instructions need sign-extended immediate 
            when others => ImmSrc <= '0'; -- For any other case the value is 0 or don't-care (X), so I choose 0 in order to simplify the design
        end case;
      
    end process;

    ALUControlProc: process(op, funct, sh, shamt5)
    begin
        case op is
            -- Data-processing instructions
            when "00" =>
                case funct(4 downto 1) is
                    when "0100" => ALUControl <= "0000"; -- ADD
                    when "0010" => ALUControl <= "0001"; -- SUB
                    when "1010" => ALUControl <= "0001"; -- CMP uses SUB
                    when "0000" => ALUControl <= "1010"; -- AND
                    when "0001" => ALUControl <= "1000"; -- XOR
                    when "1100" => ALUControl <= "1011"; -- ORR

                    -- MOV / NOP or SHIFT
                    when "1101" =>
                    -- For funct="1101" first check shamt5; if "00000" -> MOV (NOP ταυτίζεται με MOV),
                        case shamt5 is
                            when "00000" =>
                                ALUControl <= "0100";         -- MOV/NOP
                            when others =>
                                case sh is
                                    when "00"   => ALUControl <= "1101"; -- LSL
                                    when "01"   => ALUControl <= "1110"; -- LSR
                                    when "10"   => ALUControl <= "1100"; -- ASR
                                    when "11"   => ALUControl <= "1111"; -- ROR
                                    when others => ALUControl <= "----";
                                end case;
                        end case;

                    when "1111" => ALUControl <= "0101"; -- MVN
                    when others => ALUControl <= "----";
                end case;

            -- Memory instructions (use U bit = funct(3))
            when "01" =>
                case funct(3) is
                    when '1'     => ALUControl <= "0000"; -- ADD 
                    when '0'     => ALUControl <= "0001"; -- SUB 
                    when others  => ALUControl <= "----"; 
                end case;

            -- Branch instructions 
            when "10" =>
                ALUControl <= "0000"; -- ADD 

            -- Any other case 
            when others =>
                ALUControl <= "----";
        end case;
    end process;
 
 
    MemToRegProc: process(op, funct) -- Only in load instruction data from memory are written to the register file
    begin
        case op is
            -- Memory instructions
            when "01" =>
                case funct(0) is
                    when '1'     => MemToReg <= '1';   -- LDR -> data from memory
                    when '0'     => MemToReg <= '0';   
                    when others  => MemToReg <= '-';   
                end case;

            -- Other istructions
            when "00" | "10" =>
                MemToReg <= '0';                       

            -- Any other case 
            when others =>
                MemToReg <= '-';
        end case;
    end process;

    NoWrite_inProc: process(op, funct) -- Only in CMP instructions is '1'
    begin
        case op is
            -- Data-processing instructions
            when "00" =>
                case funct(4 downto 1) is
                    when "1010" => NoWrite_in <= '1';   -- CMP
                    when others => NoWrite_in <= '0';   
                end case;

            -- Other istructions
            when "01" | "10" =>
                NoWrite_in <= '0';                      

            -- Any other case 
            when others =>
                NoWrite_in <= '-';
        end case;
    end process;



end Behavioral;
