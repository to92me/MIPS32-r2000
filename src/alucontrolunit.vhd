-------------------------------------------------------------------------------
--
--                         ALU CONTROL UNIT 
--
-------------------------------------------------------------------------------

-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: CPU model 
-- Module Name: mips_cpu - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1 (Linux) 
-- Description:
--      Cpu module with all  needed componets ( registers, alu, control, unit
--      memory, rom memory and alu operation encoder)
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

entity alucontrolunit is

  port (
    opcode    : in  std6_st;            -- opcodes from instruction
    rt        : in  std5_st;            -- register source
    func      : in  std6_st;            -- function
    operation : out AluOp_t);           -- alu operation

end entity alucontrolunit;


architecture Behavioral of alucontrolunit is
  shared variable spec1, spec2  : boolean;
  signal special1_v, special2_v : AluOp_t;
begin  -- architecture Behavioral

  --case opcode is
  -- when  => ;
  -- when others => null;
  -- end case;
  -- when special1_c =>
  with func select
    special1_v <=
    alu_add     when ADD_fun_c,
    alu_addu    when ADDU_fun_c,
    alu_div     when DIV_fun_c,
    alu_divu    when DIVU_fun_c,
    alu_mult    when MULT_fun_c,
    alu_multu   when MULTU_fun_c,
    alu_slt     when SLT_fun_c,
    alu_sltu    when SLTU_fun_c,
    alu_sub     when SUB_fun_c,
    alu_subu    when SUBU_fun_c,
    alu_and     when AND_fun_c,
    alu_nor     when NOR_fun_c,
    alu_or      when OR_fun_c,
    alu_xor     when XOR_ic,
    alu_sll     when SLL_fun_c,
    alu_sllv    when SLLV_fun_c,
    alu_sra     when SRA_fun_c,
    alu_srav    when SRAV_fun_c,
    alu_srl     when SRL_fun_c,
    alu_srlv    when SRLV_fun_c,
    alu_sync    when SYNC_fun_c,
    alu_syscall when SYSCALL_fun_c,
    alu_mfhi    when MFHI_fun_c,
    alu_mflo    when MFLO_fun_c,
    alu_movn    when MOVN_fun_c,
    alu_movz    when MOVZ_fun_c,
    alu_mthi    when MTHI_fun_c,
    alu_mtlo    when MTLO_fun_c,
    alu_nop     when others;

  --when special2_c =>
  with func select
    special2_v <=
    alu_clo   when CLO_fun_c,
    alu_clz   when CLZ_fun_c,
    alu_madd  when MADD_fun_c,
    alu_maddu when MADDU_fun_c,
    alu_msub  when MSUB_fun_c,
    alu_msubu when MSUBU_fun_c,
    alu_mul   when MULT_fun_c,
    alu_nop   when others;

  -- when others =>
  with opcode select
    operation <=
    special1_v when special1_c,
    special2_v when special2_c,
    alu_addi   when ADDI_op_c,
    alu_addiu  when ADDIU_op_c,
    alu_slti   when SLTI_op_c,
    alu_sltiu  when SLTIU_op_c,
    alu_andi   when ANDI_op_c,
    alu_ori    when ORI_op_c,
    alu_lb     when LB_op_c,
    alu_lbu    when LBU_op_c,
    alu_lh     when LH_op_c,
    alu_lhu    when LHU_op_c,
    alu_lw     when LW_op_c,
    alu_ll     when LL_op_c,
    alu_lui    when LUI_op_c,
    alu_lwl    when LWL_op_c,
    alu_lwr    when LWR_op_c,
    alu_pref   when PREF_op_c,
    alu_sb     when SB_op_c,
    alu_sh     when SH_op_c,
    alu_sw     when SW_op_c,
    alu_swl    when SWL_op_c,
    alu_swr    when SWR_op_c,
    alu_sc     when SC_op_c,
    alu_nop    when others;
  --end case;




end architecture Behavioral;
