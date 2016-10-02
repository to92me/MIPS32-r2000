-------------------------------------------------------------------------------
--                           CPU 
-------------------------------------------------------------------------------
-- developer	: Tomislav Tumbas
-- email 		: tumbas.tomislav@gmail.com 
-- college 		: Faculty of Technical Science (FTN) Novi Sad 
-- department 	: Microprocessor Systems and Algorithms
-------------------------------------------------------------------------------
-- mentor 		: Rastislav Struharik, Ph.D. 
-------------------------------------------------------------------------------
-- project 		: Single cycle MIPS32 design 
-------------------------------------------------------------------------------
-- file         : alu.vhd
-- module       : alu 
-- description  : alu - Arithmetic logic unit 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity alu is
	port(
		operand1  : in  std32_st;
		operand2  : in  std32_st;
		operation : in  AluOp_t;
		result    : out std32_st;
		--		result64  : out std32_st;
		zero      : out std_logic
	);

end entity alu;

architecture Behavioral of alu is
begin
	zero_result : process(operand1, operand2, operation)
	begin
		if (operand1 = operand2) then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end process zero_result;

	process(operand1, operand2, operation) is
		variable oper_us1 : std32_st;
		variable oper_us2 : std32_st;
		variable dualres  : std64_st;
		variable oper_s1  : std32_st;
		variable oper_s2  : std32_st;
		variable L        : line;
	begin
		case operation is
			-- logic 
			when alu_or =>
				result <= operand1 or operand2;
			when alu_nor =>
				result <= operand1 nor operand2;
			when alu_xor =>
				result <= operand1 xor operand2;
			when alu_and =>
				result <= operand1 and operand2;
			--			when alu_
			-- arithmetic 
			when alu_add =>
				result <= std_logic_vector(signed(operand1) + signed(operand2));
			when alu_addu =>
				result <= std_logic_vector(unsigned(operand1) + unsigned(operand2));
			when alu_sub =>
				result <= std_logic_vector(signed(operand1) - signed(operand2));
			when alu_subu =>
				result <= std_logic_vector(unsigned(operand1) - unsigned(operand2));
-- FIXME this is not valid because multiplication stores result in 64bit register 
--			when alu_mult =>
--				result <= std_logic_vector(signed(operand1) * signed(operand2));
--			when alu_multu =>
--				result <= std_logic_vector(unsigned(operand1) * unsigned(operand2));
			when alu_div =>
				result <= std_logic_vector(signed(operand1) / signed(operand2));
			when alu_divu =>
				result <= std_logic_vector(unsigned(operand1) / unsigned(operand2));
			when alu_sll  => 
				result  <= std_logic_vector(unsigned(operand1) sll to_integer(signed(operand2))); 
			when alu_srl  => 
				result  <= std_logic_vector(unsigned(operand1) srl to_integer(signed(operand2))); 	
				
			--NOP
			when alu_nop =>
				result <= std32_zero_c;
			
			when others =>
				result <= std32_zero_c;
				write(L, string'("alu error, no such instruction"));
				writeline(output, L);
		end case;
	end process;

end architecture Behavioral;






