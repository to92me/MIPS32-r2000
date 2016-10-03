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
		operand1  : in  std32_st;		-- operand1 - got from registers 
		operand2  : in  std32_st;		-- operand2 - got from AluSource MUX (registers or immediate from instruction)
		operation : in  AluOp_t;		-- operation - this operation ALU should execute 
		result    : out std32_st;		-- result from operation 
		zero      : out std_logic		-- zero - signal for branch instructions (if operand1 == operand2 set zero to 1) 
	);

end entity alu;

architecture Behavioral of alu is
begin
	-- if operand1 and operand2 are equal zero is '1' 
	zero_result : process(operand1, operand2, operation)
	begin
		if (operand1 = operand2) then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end process zero_result;
	
	-- main process of ALU where all operations are executed 
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
			when alu_sll  => 
				result  <= std_logic_vector(unsigned(operand1) sll to_integer(signed(operand2))); 
			when alu_srl  => 
				result  <= std_logic_vector(unsigned(operand1) srl to_integer(signed(operand2))); 	
				
			--NOP
			when alu_nop =>
				result <= std32_zero_c;
			
			when others =>
				result <= std32_zero_c;
				report "ALU ERROR - ALU instruction is not implemented ";
		end case;
	end process;

end architecture Behavioral;






