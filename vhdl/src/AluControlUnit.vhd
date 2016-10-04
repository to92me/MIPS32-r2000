-------------------------------------------------------------------------------
--                           ALU CONTROL UNIT 
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
-- file         : alucontrolunit.vhd
-- module       : AluControlUnit 
-- description  : Alu Control Unit is unit that decodes function part of 
--				  instruction if it is needed. If opcode is "00000" or "011100"
--				  then alu operation is decoded from functino part of 
--				  instruction. 
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

entity AluControlUnit is

  port (
    cu_operation : in  AluOp_t;         -- operation got from ControlUnit 
    func         : in  std6_st;         -- function part of instruction 
    operation    : out AluOp_t);        -- output operation for ALU 

end entity AluControlUnit;


architecture Behavioral of AluControlUnit is

  signal special_op_1, special_op_2 : AluOp_t; 
  
begin 
	
-- decode function part of instruction for special2 opcode 	
with func select special_op_2  <= 
	alu_madd when MADD_fun_c,
	alu_mul when MUL_fun_c,
	alu_nop when others; 

-- decode function part of instruction for special1 opcode 	
with func select special_op_1  <= 
	alu_add when ADD_fun_c,
	alu_addu when ADDU_fun_c, 
	alu_div when DIV_fun_c, 
	alu_divu when DIVU_fun_c,
	alu_mult when MULT_fun_c,
	alu_sub when SUB_fun_c,
	alu_subu when SUBU_fun_c,
	alu_and when AND_fun_c,
	alu_nor when NOR_fun_c,
	alu_or when OR_fun_c,
	alu_xor when XOR_fun_c,
--	alu_sll when SLL_fun_c,
--	alu_srl when SRL_fun_c,
	alu_sllv when SLLV_fun_c,
	alu_srlv when SRLV_fun_c,
	alu_slt when SLT_fun_c,
	alu_sltu when SLTU_fun_c,   
	alu_nop when others;

--set final ALU operation.
with cu_operation select operation  <= 
	special_op_1 when alu_special1, 
	special_op_2 when alu_special2,
	cu_operation when others;  


end architecture Behavioral;
