-------------------------------------------------------------------------------
--
--                           ALU  
--
-------------------------------------------------------------------------------

-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: ALU model 
-- Module Name: alu  - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1 (Linux) 
-- Description:
--      
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--      
-------------------------------------------------------------------------------
--
-- Revision 1.0
-- Mentor: Rastislav Struharek
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;


entity alu is

  port (
    operand1  : in  std32_st;
    operand2  : in  std32_st;
    operation : in  AluOp_t;
    result    : out std32_st;
    result64  : out std32_st);          -- extended result for HI LO registes

end entity alu;


architecture Behavioral of alu is

begin  -- architecture Behavioral
  process (operand1, operand2, operation) is
    variable oper_us1 : std32_st;
    variable oper_us2 : std32_st;
    variable dualres  : std64_st := "0000000000000000000000000000000000000000000000000000000000000000";
    variable oper_s1 : std32_st;
    variable oper_s2 : std32_st;
    variable L        : line;
  begin  -- process
    --oper_us1 := unsigned(operand1);
    --oper_us2 := unsigned(operand2);
    

    case operation is
      when alu_or =>
        result <= operand1 or operand2;
      when alu_nor =>
        result <= operand1 nor operand2;
      when alu_xor =>
        result <= operand1 xor operand2;
      when alu_and =>
        result <= operand1 and operand2;

      when others =>
        result <= std32_zero_c;
        write(L, string'("alu error, no such instruction"));
        writeline(output, L);
    end case;
  end process;


end architecture Behavioral;






