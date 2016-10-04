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
-- file         : 
-- module       : 
-- description  : 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity AluControlUnit_tb is
end entity AluControlUnit_tb;

architecture Behavioral of AluControlUnit_tb is
	component AluControlUnit is
		port(
			cu_operation : in  AluOp_t;
			func         : in  std6_st;
			operation    : out AluOp_t);
	end component AluControlUnit;

	signal acu_cu_operation : AluOp_t;
	signal acu_operation    : AluOp_t;
	signal acu_func         : std6_st;

	constant wait_time      : time    := 1 ns;
	constant seed_array     : integer := 5;
	constant seed_special_1 : integer := 5;
	constant seed_special_2 : integer := 1;

	constant no_alu_operations      : integer := 13;
	constant no_special_functions_1 : integer := 13;
	constant no_special_functions_2 : integer := 2;

begin
	AluControlUnit_c : AluControlUnit
		port map(
			cu_operation => acu_cu_operation,
			operation    => acu_operation,
			func         => acu_func);

	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- cu_operation and func driver
	--------------------------------------------------------------

	cu_operation_driver : process is
		type AluOpA_t is array (0 to no_alu_operations - 1) of AluOp_t;
		type FuncA is array (integer range <>) of std6_st;
		variable operation_a        : AluOpA_t := (alu_special1, alu_special2, alu_or, alu_nor, alu_xor, alu_and, alu_add, alu_addu, alu_sub, alu_subu, alu_sll, alu_srl, alu_madd);
		variable iterator_alu_op    : integer;
		variable iterator_special_1 : integer;
		variable iterator_special_2 : integer;

		variable functions_special1 : FuncA(0 to no_special_functions_1 - 1) := (ADD_fun_c, ADDU_fun_c, DIV_fun_c, DIVU_fun_c, MULT_fun_c, SUB_fun_c,
			SUBU_fun_c, AND_fun_c, NOR_fun_c, OR_fun_c, XOR_fun_c, SLL_fun_c, SRL_fun_c);
		variable functions_special2 : FuncA(0 to no_special_functions_2 - 1) := (MUL_fun_c, MADD_fun_c);

	begin
		iterator_alu_op    := 0;
		iterator_special_1 := 0;
		iterator_special_2 := 0;
		
		for i in 0 to 100 loop
		
--			acu_cu_operation <= operation_a(iterator_alu_op);
			-- fist check if current operation os special 1 
			-- if it is firs
			if (operation_a(iterator_alu_op) = alu_special1) then
				acu_func <= functions_special1(iterator_special_1);

				iterator_special_1 := iterator_special_1 + seed_special_1;
				if (iterator_special_1 > no_special_functions_1 - 1) then
					iterator_special_1 := iterator_special_1 - no_special_functions_1;
				end if;

			end if;

			if (operation_a(iterator_alu_op) = alu_special2) then
				acu_func <= functions_special2(iterator_special_2);

				iterator_special_2 := iterator_special_2 + seed_special_2;
				if (iterator_special_2 > no_special_functions_2 - 1) then
					iterator_special_2 := iterator_special_2 - no_special_functions_2;
				end if;

			end if;
			
			wait for wait_time/10; 

			acu_cu_operation <= operation_a(iterator_alu_op);
			
			iterator_alu_op  := iterator_alu_op + seed_array;
			if iterator_alu_op > no_alu_operations - 1 then
				iterator_alu_op := iterator_alu_op - no_alu_operations;
			end if;
			wait for wait_time;
		end loop;
	end process cu_operation_driver;

	--------------------------------------------------------------
	-- DATA CHECKERS 
	--------------------------------------------------------------
	-- operation checker 
	--------------------------------------------------------------

	operation_checker : process(acu_operation) is
	begin
		if (acu_cu_operation = alu_special1) then
			case acu_func is
				when ADD_fun_c =>
					if (acu_operation = alu_add) then
--						report "special ADD_fun_c OK!";
					else
						report "Special ADD_fun_c ERROR!";
					end if;

				when ADDU_fun_c =>
					if (acu_operation = alu_addu) then
--						report "special ADDU_fun_c OK!";
					else
						report "Special ADDU_fun_c ERROR!";
					end if;

				when DIV_fun_c =>
					if (acu_operation = alu_div) then
--						report "special DIV_fun_c OK!";
					else
						report "Special DIV_fun_c ERROR!";
					end if;

				when DIVU_fun_c =>
					if (acu_operation = alu_divu) then
--						report "special DIV_fun_c OK!";
					else
						report "Special DIV_fun_c ERROR!";
					end if;

				when MULT_fun_c =>
					if (acu_operation = alu_mult) then
--						report "special MULT_fun_c OK!";
					else
						report "Special MULT_fun_c ERROR!";
					end if;

				when SUB_fun_c =>
					if (acu_operation = alu_sub) then
--						report "special SUB_fun_c OK!";
					else
						report "Special SUB_fun_c ERROR!";
					end if;

				when SUBU_fun_c =>
					if (acu_operation = alu_subu) then
--						report "special SUBU_fun_c OK!";
					else
						report "Special SUBU_fun_c ERROR!";
					end if;

				when AND_fun_c =>
					if (acu_operation = alu_and) then
--						report "special AND_fun_c OK!";
					else
						report "Special AND_fun_c ERROR!";
					end if;

				when NOR_fun_c =>
					if (acu_operation = alu_nor) then
--						report "special NOR_fun_c OK!";
					else
						report "Special NOR_fun_c ERROR!";
					end if;

				when OR_fun_c =>
					if (acu_operation = alu_or) then
--						report "special OR_fun_c OK!";
					else
						report "Special OR_fun_c ERROR!";
					end if;

				when XOR_fun_c =>
					if (acu_operation = alu_xor) then
--						report "special XOR_fun_c OK!";
					else
						report "Special XOR_fun_c ERROR!";
					end if;

				when SLL_fun_c =>
					if (acu_operation = alu_sll) then
--						report "special SLL_fun_c OK!";
					else
						report "Special SLL_fun_c ERROR!";
					end if;

				when SRL_fun_c =>
					if (acu_operation = alu_srl) then
--						report "special SRL_fun_c OK!";
					else
						report "Special SRL_fun_c ERROR!";
					end if;

				when "UUUUUU" =>
					report " staring simulation UUUUU func";

				when others =>
					report "got unexpected FUNC ERROR!!!";

			end case;

		elsif (acu_cu_operation = alu_special2) then
			case acu_func is
				when MADD_fun_c =>
					if (acu_operation = alu_madd) then
--						report "special MADD_fun_c OK!";
					else
						report "Special MADD_fun_c ERROR!";
					end if;

				when MUL_fun_c =>
					if (acu_operation = alu_mul) then
--						report "special MUL_fun_c OK!";
					else
						report "Special MUL_fun_c ERROR!";
					end if;

				when "UUUUUU" =>
					report " staring simulation UUUUU func";

				when others =>
					report "got unexpected FUNC ERROR!!!";

			end case;
		else
			if (acu_cu_operation = acu_operation) then
--				report "control unit not special operation OK";
			else
				report "control unit not special operation ERROR!";
			end if;
		end if;
	end process operation_checker;

end architecture Behavioral;
