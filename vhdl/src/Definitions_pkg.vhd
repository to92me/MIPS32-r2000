-------------------------------------------------------------------------------
--                           DEFINITIONS AND CONSTANTS  
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
-- file         : Definitions_pkg.vhd 
-- module       : package Definitions and constants 
-- description  : this is common definitions and constant values for whole 
--				  project. It contains subtypes, constants and new types. 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package Definitions_pkg is

	-----------------------------------------------------------------------------
	-- subtypes of stdlogic for easier managing
	-----------------------------------------------------------------------------
	subtype std32_st is std_logic_vector(31 downto 0); -- Word
	subtype std16_st is std_logic_vector(15 downto 0); -- HalfWord
	subtype std8_st is std_logic_vector(7 downto 0); -- Byte
	subtype std6_st is std_logic_vector(5 downto 0); -- Instructions
	subtype std5_st is std_logic_vector(4 downto 0); -- address
	subtype std10_st is std_logic_vector(9 downto 0); -- rom address
	subtype std25_st is std_logic_vector(24 downto 0); -- for instruction-index
	subtype std26_st is std_logic_vector(25 downto 0); -- address for jump instruction 
	subtype std64_st is std_logic_vector(63 downto 0); -- for dual result in ALU
	subtype std28_st is std_logic_vector(27 downto 0); 
	subtype std33_st is std_logic_vector(32 downto 0); -- for ALU res + zero 

	-----------------------------------------------------------------------------

	-----------------------------------------------------------------------------
	-- New types
	-----------------------------------------------------------------------------

	--  type std32_st_file_t is file of std32_st_file_t;  -- type for opening rom and memory files
	

	-----------------------------------------------------------------------------
	-- constants
	-----------------------------------------------------------------------------

	constant std32_zero_c : std32_st := "00000000000000000000000000000000";
	constant std32_one_c  : std32_st := "11111111111111111111111111111111";
	
	constant std33_zero_c : std33_st := "000000000000000000000000000000000";
	constant std33_one_c  : std33_st := "111111111111111111111111111111111";

	------------------------------------------------------------------------------
	-- ######################### INSTRUCTIONS OPCODE ###########################
	-----------------------------------------------------------------------------
	-- ARITHMETIC INSTRUCTIONS
	-----------------------------------------------------------------------------
	constant special1_c : std6_st := "000000"; -- special opcode 1
	constant special2_c : std6_st := "011100"; -- special opcode 2

	-- special 1, opcode = 000000 
	constant ADD_fun_c   : std6_st := "100000"; -- Add Word
	constant ADDU_fun_c  : std6_st := "100001"; -- Add Unsigned Word
	constant DIV_fun_c   : std6_st := "011010"; -- Divide Word
	constant DIVU_fun_c  : std6_st := "011011"; -- Divide Unsigned Word
	constant MULT_fun_c  : std6_st := "011000"; -- Multiply Word
	constant MULTU_fun_c : std6_st := "011001"; -- Multiply Unsigned Word
	constant SLT_fun_c   : std6_st := "101010"; -- Set on Less Than
	constant SLTU_fun_c  : std6_st := "101011"; -- Set On Less Unsigned
	constant SUB_fun_c   : std6_st := "100010"; -- Subtract Word
	constant SUBU_fun_c  : std6_st := "100011"; -- Subtract Unsigned Word


	-- special 2, opcode = 011100
	constant CLO_fun_c   : std6_st := "100001"; -- Count Leading Ones in Word
	constant CLZ_fun_c   : std6_st := "100000"; -- Count Leading Zeros in Word
	constant MADD_fun_c  : std6_st := "000000"; -- Multiply and Add Word to Hi,Lo
	constant MADDU_fun_c : std6_st := "000001"; -- Multiply and Add Unsigned Word  to Hi,Lo
	constant MSUB_fun_c  : std6_st := "000100"; -- Multiply and Subtract Word to Hi,Lo
	constant MSUBU_fun_c : std6_st := "000101"; -- Multiply  and Subtract Word to Hi,Lo
	constant MUL_fun_c   : std6_st := "000010"; -- Multiply Word to GPR


	-- stand-alone opcodes 
	constant ADDI_op_c  : std6_st := "001000"; -- Add Immediate Word
	constant ADDIU_op_c : std6_st := "001001"; -- Add Immediate Unsigned Word
	constant SLTI_op_c  : std6_st := "001010"; -- Set on Less Than Immediate
	constant SLTIU_op_c : std6_st := "001011"; -- Set on Less Than Immediate Unsigned


	-----------------------------------------------------------------------------
	--LOGICAL INSTRUCTIONS
	-----------------------------------------------------------------------------
	--special 1, opcode 00000 
	constant AND_fun_c : std6_st := "100100"; -- And
	constant NOR_fun_c : std6_st := "100111"; -- Nor
	constant OR_fun_c  : std6_st := "100101"; -- Or
	constant XOR_fun_c : std6_st := "100110"; -- Exclusive OR

	--stand-alone 
	constant ANDI_op_c : std6_st := "001100"; -- And Immediate
	constant ORI_op_c  : std6_st := "001101"; -- Or Immediate
	constant XORI_op_c : std6_st := "001110"; -- Exclusive OR Immediate

	-----------------------------------------------------------------------------
	-- SHIFT INSTRUCTIONS
	-----------------------------------------------------------------------------
	--specal 1 opcode = 000000 
	constant SLL_fun_c  : std6_st := "000000";
	constant SLLV_fun_c : std6_st := "000100";
	constant SRA_fun_c  : std6_st := "000011";
	constant SRAV_fun_c : std6_st := "000111";
	constant SRL_fun_c  : std6_st := "000010";
	constant SRLV_fun_c : std6_st := "000110";

	-------------------------------------------------------------------------------
	-- LOAD AND STORE INSTRUCTIONS
	-------------------------------------------------------------------------------

	--stand-alone opcodes
	constant LB_op_c   : std6_st := "100000"; -- Load Byte
	constant LBU_op_c  : std6_st := "100100"; -- Load Byte Unsigned
	constant LH_op_c   : std6_st := "100001"; -- Load Halfword
	constant LHU_op_c  : std6_st := "100101"; -- Load Halfword Unsigned
	constant LW_op_c   : std6_st := "100011"; -- Load Word
	constant LL_op_c   : std6_st := "110000"; -- Load Lined Word
	constant LUI_op_c  : std6_st := "001111"; -- Load Upper Immediate
	constant LWL_op_c  : std6_st := "100010"; -- Load Word Left
	constant LWR_op_c  : std6_st := "100110"; -- Load Word Right
	constant PREF_op_c : std6_st := "110011"; -- Pre-fetch
	constant SB_op_c   : std6_st := "101000"; -- Store Byte
	constant SH_op_c   : std6_st := "101001"; -- Store Halfword
	constant SW_op_c   : std6_st := "101011"; -- Store Word
	constant SWL_op_c  : std6_st := "101010"; -- Store Word Left
	constant SWR_op_c  : std6_st := "101110"; -- Store Word Right
	constant SC_op_c   : std6_st := "111000"; -- Store Conditional Word

	--special 1 opcode 000000
	constant SYNC_fun_c    : std6_st := "001111"; -- Synchronize Shared Memory
	constant SYSCALL_fun_c : std6_st := "001100"; -- System Call


	-------------------------------------------------------------------------------
	-- MOVE INSTRUCTIONS
	-------------------------------------------------------------------------------
	-- special 1 opcode = 00000
	constant MFHI_fun_c : std6_st := "010000"; -- Move From HI Register
	constant MFLO_fun_c : std6_st := "010010"; -- Move From Low Register
	constant MOVN_fun_c : std6_st := "001011"; -- Move to Conditional on Not Zero
	constant MOVZ_fun_c : std6_st := "001010"; -- Move Conditional on Zero
	constant MTHI_fun_c : std6_st := "010001"; -- Move to HI Register
	constant MTLO_fun_c : std6_st := "010011"; -- Move to LO Register

	

	-------------------------------------------------------------------------------
	-- BRANCH INSTRUCTIONS
	-------------------------------------------------------------------------------
	constant BEQ_op_c : std6_st := "000100"; --branch if equal
--	constant BNE_op_c : std6_st := "000101"; --branch if not equal -- for this option control unit 
--  must be modified. TODO
	
	-------------------------------------------------------------------------------
	-- BRANCH INSTRUCTIONS
	-------------------------------------------------------------------------------
	constant J_op_c : std6_st := "000010"; -- jump to address
--	constant JR_func_c :std6_st := "001000"; -- jump to address got from register -- currently i don't
--  have design that can support this TODO 

	-------------------------------------------------------------------------------
	-- TRAP INSTRUCTIONS 
	-- 
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	-- OTHER 
	-------------------------------------------------------------------------------

	type AluOp_t is (
		alu_special1, alu_special2,
		alu_add, alu_addu, alu_div, alu_divu, alu_mult, alu_multu, alu_slt, alu_sltu,
		alu_sub, alu_subu,
		alu_clo, alu_clz, alu_madd, alu_maddu, alu_msub, alu_msubu, alu_mul,
		--    alu_addi, alu_addiu, alu_slti, alu_sltiu,
		alu_and, alu_xor, alu_nor, alu_or,
		--    alu_andi, alu_ori, alu_xori,
		alu_sll, alu_sllv, alu_sra, alu_srav, alu_srl, alu_srlv,
		--    alu_lb, alu_lbu, alu_lh, alu_lhu, alu_lw, alu_ll, alu_lui, alu_lwl, alu_lwr,
		--    alu_pref, alu_sb, alu_sh, alu_sw, alu_swl, alu_swr, alu_sc,
		--    alu_sync, alu_syscall,
		--    alu_mfhi, alu_mflo, alu_movn, alu_movz, alu_mthi, alu_mtlo,
		alu_not,
		alu_nop);                       -- alu operations
	
end package Definitions_pkg;
    
    


