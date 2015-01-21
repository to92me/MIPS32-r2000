-------------------------------------------------------------------------------
--
--                          CONTROL UNIT 
--
-------------------------------------------------------------------------------

-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Create Date: 5/01/2012 4:20:21 AM 
-- Design Name: CPU model 
-- Module Name: mips_cpu - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1 (Linux) 
-- Description:
--     
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--      
-------------------------------------------------------------------------------
-- 
-- Revision 1.0
-- Mentor: Rastislav Struharek
-- Revision 0.01 - File Create
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity controlunit is

  port (
    opcode               : in  std6_st;
    register_write       : out std_logic;
    memory_write         : out std_logic;
    memory_read          : out std_logic;
    mem_to_reg           : out std_logic;
    register_destination : out std_logic;  -- first mux - if it's 0 <- rs is wrAddr
                                           --                     1 <- rt is wrAddr 
    alu_operation        : out AluOp_t;
    alu_source           : out std_logic;  -- mux in front of alu
    -- if it's 0 <- operand is from register
    --         1 <- operand is from instruction 
    branch               : out std_logic);

end entity controlunit;


architecture Behavioral of controlunit is

begin  -- architecture Behavioral

  -- purpose: identifie instruction type ( R I J ) seting outputs coresponding to instruction type 
  -- inputs : opcode
  -- outputs register_destination
  --         register_write
  --         alu_source
  --         mem_write
  --         mem_read
  --         mem_to_reg
  --         

  mux_select : process (opcode) is

  begin  -- process instruction_type

    if (opcode = special1_c) or
      (opcode = special2_c)
    then
      -- R type instruction
      register_destination <= '0';
      register_write       <= '1';
      alu_source           <= '0';
      memory_read          <= '0';
      memory_write         <= '0';
      mem_to_reg           <= '0';
      branch               <= '0';
      register_write       <= '1';

    elsif (opcode = LB_op_c) or
      (opcode = LBU_op_c) or
      (opcode = LH_op_c) or
      (opcode = LHU_op_c) or
      (opcode = LW_op_c) or
      (opcode = LL_op_c) or
      (opcode = LUI_op_c) or
      (opcode = LWL_op_c) or
      (opcode = LW_op_c) then
      -- Load instructions 
      register_destination <= '0';
      register_write       <= '1';
      alu_source           <= '1';
      memory_read          <= '0';
      memory_write         <= '0';
      mem_to_reg           <= '0';
      branch               <= '0';
    elsif
      (opcode = SB_op_c) or
      (opcode = SH_op_c) or
      (opcode = SW_op_c) or
      (opcode = SWL_op_c) or
      (opcode = SWR_op_c) or
      (opcode = SC_op_c) then
      -- Store instructions
      register_destination <= '1';
      register_write       <= '1';
      alu_source           <= '0';
      memory_read          <= '0';
      memory_write         <= '0';
      mem_to_reg           <= '0';
      branch               <= '0';
    elsif
      (opcode = ADDI_op_c)or
      (opcode = ADDIU_op_c)or
      (opcode = SLTI_op_c) or
      (opcode = SLTIU_op_c) then
      -- I type instructions 
      register_destination <= '1';
      register_write       <= '1';
      alu_source           <= '0';
      memory_read          <= '0';
      memory_write         <= '0';
      mem_to_reg           <= '0';
      branch               <= '0';
    else
      register_destination <= '1';
      register_write       <= '1';
      alu_source           <= '0';
      memory_read          <= '0';
      memory_write         <= '0';
      mem_to_reg           <= '0';
      branch               <= '0';
    end if;

  end process mux_select;


  opcide_decode : process (opcode) is
  begin  -- process opcide_decode
    case opcode is
      when ADDI_op_c  => alu_operation <= alu_addi;
      when ADDIU_op_c => alu_operation <= alu_addiu;
      when SLTI_op_c  => alu_operation <= alu_slti;
      when SLTIU_op_c => alu_operation <= alu_sltiu;
      when ANDI_op_c  => alu_operation <= alu_andi;
      when ORI_op_c   => alu_operation <= alu_ori;
      when LB_op_c    => alu_operation <= alu_lb;
      when LBU_op_c   => alu_operation <= alu_lbu;
      when LH_op_c    => alu_operation <= alu_lh;
      when LHU_op_c   => alu_operation <= alu_lhu;
      when LW_op_c    => alu_operation <= alu_lw;
      when LL_op_c    => alu_operation <= alu_ll;
      when LUI_op_c   => alu_operation <= alu_lui;
      when LWL_op_c   => alu_operation <= alu_lwr;
      when LWR_op_c   => alu_operation <= alu_lwr;
      when PREF_op_c  => alu_operation <= alu_pref;
      when SB_op_c    => alu_operation <= alu_sb;
      when SH_op_c    => alu_operation <= alu_sh;
      when SWR_op_c   => alu_operation <= alu_swr;
      when SWL_op_c   => alu_operation <= alu_swl;
      when SC_op_c    => alu_operation <= alu_sc;
      when others     => alu_operation <= alu_nop;
    end case;

  end process opcide_decode;

  --operation_select : process (opcode) is
  --begin  -- process operation_select
  --  with opcode select
  --    alu_operation <=
  --    alu_special1 when special1_c,
  --    alu_special2 when special2_c,
  --    alu_addi     when ADDI_op_c,
  --    alu_addiu    when ADDIU_op_c,
  --    alu_slti     when SLTI_op_c,
  --    alu_sltiu    when SLTIU_op_c,
  --    alu_andi     when ANDI_op_c,
  --    alu_ori      when ORI_op_c,
  --    alu_lb       when LB_op_c,
  --    alu_lbu      when LBU_op_c,
  --    alu_lh       when LH_op_c,
  --    alu_lhu      when LHU_op_c,
  --    alu_lw       when LW_op_c,
  --    alu_ll       when LL_op_c,
  --    alu_lui      when LUI_op_c,
  --    alu_lwl      when LWL_op_c,
  --    alu_lwr      when LWR_op_c,
  --    alu_pref     when PREF_op_c,
  --    alu_sb       when SB_op_c,
  --    alu_sh       when SH_op_c,
  --    alu_sw       when SW_op_c,
  --    alu_swl      when SWL_op_c,
  --    alu_swr      when SWR_op_c,
  --    alu_sc       when SC_op_c,
  --    alu_nop      when others;
  --end process operation_select;





end architecture Behavioral;
