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
--  shared variable spec1, spec2           : boolean;
--  shared variable special1_v, special2_v : AluOp_t;
  
  signal special_op_1, special_op_2 : AluOp_t; 
  
--  signal spec_1_true, spec_2_true : std_logic; 
begin 
	
	
--  process (func) is
--  begin  -- process
--    case func is
----      when CLO_fun_c   => special2_v := alu_clo;
----      when CLZ_fun_c   => special2_v := alu_clz;
--      when MADD_fun_c  => special2_v := alu_madd;
----      when MADDU_fun_c => special2_v := alu_maddu;
----      when MSUB_fun_c  => special2_v := alu_msub;
----      when MSUBU_fun_c => special2_v := alu_msubu;
--      when MUL_fun_c   => special2_v := alu_mul;
--      when others      => special2_v := alu_nop;
--    end case;
--
--    case func is
--      when ADD_fun_c     => special1_v := alu_add;
--      when ADDU_fun_c    => special1_v := alu_addu;
--      when DIV_fun_c     => special1_v := alu_div;
--      when DIVU_fun_c    => special1_v := alu_divu;
--      when MULT_fun_c    => special1_v := alu_mult;
----      when SLT_fun_c     => special1_v := alu_slt;
----      when SLTU_fun_c    => special1_v := alu_sltu;
--      when SUB_fun_c     => special1_v := alu_sub;
--      when SUBU_fun_c    => special1_v := alu_subu;
--      when AND_fun_c     => special1_v := alu_and;
--      when NOR_fun_c     => special1_v := alu_nor;
--      when OR_fun_c      => special1_v := alu_or;
--      when XOR_fun_c     => special1_v := alu_xor;
--      when SLL_fun_c     => special1_v := alu_sll;
----      when SLLV_fun_c    => special1_v := alu_sllv;
----      when SRA_fun_c     => special1_v := alu_sra;
----      when SRAV_fun_c    => special1_v := alu_srav;
--      when SRL_fun_c     => special1_v := alu_srl;
----      when SRLV_fun_c    => special1_v := alu_srlv;
----      when SYNC_fun_c    => special1_v := alu_sync;
----      when SYSCALL_fun_c => special1_v := alu_syscall;
----      when MFHI_fun_c    => special1_v := alu_mfhi;
----      when MFLO_fun_c    => special1_v := alu_mflo;
----      when MOVN_fun_c    => special1_v := alu_movn;
----      when MOVZ_fun_c    => special1_v := alu_movz;
----      when MTHI_fun_c    => special1_v := alu_mthi;
----      when MTLO_fun_c    => special1_v := alu_mtlo;
--      when others        => special1_v := alu_nop;
--    end case;
--  end process;
--
--  selecting_alu_operation : process (func,cu_operation) is
--  begin  -- process  selecting_alu_operation
--
--    if cu_operation = alu_special1 then
--      operation <= special1_v;
--
--    elsif cu_operation = alu_special2 then
--      operation <= special2_v;
--    else
--      operation <= cu_operation;
--    end if;
--  end process selecting_alu_operation;


with func select special_op_2  <= 
	alu_madd when MADD_fun_c,
	alu_mul when MUL_fun_c,
	alu_nop when others; 

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
	alu_sll when SLL_fun_c,
	alu_srl when SRL_fun_c, 
	alu_nop when others;

with cu_operation select operation  <= 
	special_op_1 when alu_special1, 
	special_op_2 when alu_special2,
	cu_operation when others;  

--spec_1_true  <= cu_operation xnor 


end architecture Behavioral;
