-------------------------------------------------------------------------------
--
--                              DEFINITIONS_PKG
--
-------------------------------------------------------------------------------
--
-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Create Date: 11/26/2014 11:50:04 AM
-- Design Name: Definitions package
-- Module Name: Definitions_pkg
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1
-- Description: definitions of common
--      constants
--      types
--      subtypes
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--
-------------------------------------------------------------------------------x
--
-- Revision 1.0
-- Mentor: Rastislav Struharek
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package Definitions_pkg is


  -----------------------------------------------------------------------------
  -- subtypes of stdlogic for easier manageing
  -----------------------------------------------------------------------------
  subtype std32_st is std_logic_vector(31 downto 0);   -- Word
  subtype std16_st is std_logic_vector(15 downto 0);   -- HalfWord
  subtype std8_st is std_logic_vector(7 downto 0);     -- Byte
  subtype std6_st is std_logic_vector(5 downto 0);     -- Instructions
  subtype std5_st is std_logic_vector(4 downto 0);     -- address
  subtype std10_st is std_logic_vector(9 downto 0);    -- rom address
  subtype std25_st is std_logic_vector(24 downto 0);   -- for instruction-index
  subtype std26_st is std_logic_vector (25 downto 0);  --
  subtype std64_st is std_logic_vector(63 downto 0);  -- for dual result in alu

  constant write_c : std_logic := '1';  -- for writeing in register or memory
  constant read_c : std_logic := '0';   -- for reading from registers or memory
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- New types
  -----------------------------------------------------------------------------

--  type std32_st_file_t is file of std32_st_file_t;  -- type for opening rom and memory files


  -----------------------------------------------------------------------------
  -- constants
  -----------------------------------------------------------------------------

  constant std32_zero_c : std32_st := "00000000000000000000000000000000";  -- constant for reseting register
  constant std32_one_c  : std32_st := "11111111111111111111111111111111";

  ------------------------------------------------------------------------------
  -- ######################### INSTRUCTIONS OPCODE ###########################
  -----------------------------------------------------------------------------
  -- ARITHMETIC INSTRUCTIONS
  -- op code for instructions defined as _fun_c  is 0x0 
  -----------------------------------------------------------------------------
  constant special1_c : std6_st := "000000";  -- special opcode 1
  constant special2_c : std6_st := "011100";  -- special opcode 2

  -- special 1 op code = 000000 
  constant ADD_fun_c   : std6_st := "100000";  -- Add Word
  constant ADDU_fun_c  : std6_st := "100001";  -- Add Unsigned Word
  constant DIV_fun_c   : std6_st := "011010";  -- Divide Word
  constant DIVU_fun_c  : std6_st := "011011";  -- Divide Unsigned Word
  constant MULT_fun_c  : std6_st := "011000";  -- Multiply Word
  constant MULTU_fun_c : std6_st := "011001";  -- Multiply Unsigned Word
  --constant NOP_fun_c   : std6_st := "000000";  -- NOP NOP NOP :D
  constant SLT_fun_c   : std6_st := "101010";  -- Set on Less Than
  constant SLTU_fun_c  : std6_st := "101011";  -- Set On Less Unsigned
  constant SUB_fun_c   : std6_st := "100010";  -- Subtract Word
  constant SUBU_fun_c  : std6_st := "100011";  -- Subtract Unsigned Word


  -- special 2 op code = 011100
  constant CLO_fun_c   : std6_st := "100001";  -- Count Leading Ones in Word
  constant CLZ_fun_c   : std6_st := "100000";  -- Count Leading Zeros in Word
  constant MADD_fun_c  : std6_st := "000000";  -- Multiply and Add Word to Hi,Lo
  constant MADDU_fun_c : std6_st := "000001";  -- multiply and Add Unsigned Word  to Hi,Lo
  constant MSUB_fun_c  : std6_st := "000100";  -- Multiply and Subtrac Word to Hi,Lo
  constant MSUBU_fun_c : std6_st := "000101";  -- Multiply  and Subtrac Word to Hi,Lo
  constant MUL_fun_c   : std6_st := "000010";  -- Multiply Word to GPR


  -- standalone opcodes 
  constant ADDI_op_c  : std6_st := "001000";  -- Add Immediate Word
  constant ADDIU_op_c : std6_st := "001001";  -- Add Immediate Unsigned Word
  constant SLTI_op_c  : std6_st := "001010";  -- Set on Less Than Immediate
  constant SLTIU_op_c : std6_st := "001011";  -- Set on Less Than Immediate Unsigned


  -----------------------------------------------------------------------------
  --LOGICAL INSTRUCTIONS
  -----------------------------------------------------------------------------
  --special 1 op code 00000 
  constant AND_fun_c : std6_st := "100100";  -- And
  constant NOR_fun_c : std6_st := "100111";  -- Nor
  constant OR_fun_c  : std6_st := "100101";  -- Or
  constant XOR_ic    : std6_st := "100110";  -- Exclusive OR

  --standalone 
  constant ANDI_op_c : std6_st := "001100";  -- And Immediate
  constant ORI_op_c  : std6_st := "001101";  -- Or Immediate
  constant XORI_op_c : std6_st := "001110";  -- Exclusive OR Immediate

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

  --standalone opcodes
  constant LB_op_c   : std6_st := "100000";  -- Load Byte
  constant LBU_op_c  : std6_st := "100100";  -- Load Byte Unsigned
  constant LH_op_c   : std6_st := "100001";  -- Load Halfword
  constant LHU_op_c  : std6_st := "100101";  -- Load Halfword Unsigned
  constant LW_op_c   : std6_st := "100011";  -- Load Word
  constant LL_op_c   : std6_st := "110000";  -- Load Lined Word
  constant LUI_op_c  : std6_st := "001111";  -- Load Upper Immediate
  constant LWL_op_c  : std6_st := "100010";  -- Load Word Left
  constant LWR_op_c  : std6_st := "100110";  -- Load Word Right
  constant PREF_op_c : std6_st := "110011";  -- Prefetc
  constant SB_op_c   : std6_st := "101000";  -- Store Byte
  constant SH_op_c   : std6_st := "101001";  -- Store Halfword
  constant SW_op_c   : std6_st := "101011";  -- Store Word
  constant SWL_op_c  : std6_st := "101010";  -- Store Word Left
  constant SWR_op_c  : std6_st := "101110";  -- Store Word Right
  constant SC_op_c   : std6_st := "111000";  -- Store Conditional Word

  --special 1 opcode 000000
  constant SYNC_fun_c    : std6_st := "001111";  -- Synchronize Shared Memory
  constant SYSCALL_fun_c : std6_st := "001100";  -- System Call


-------------------------------------------------------------------------------
-- MOVE INSTRUCTIONS
-------------------------------------------------------------------------------
  -- special 1 opcode = 00000
  constant MFHI_fun_c : std6_st := "010000";  -- Move From HI Register
  constant MFLO_fun_c : std6_st := "010010";  -- Move From Low Register
  constant MOVN_fun_c : std6_st := "001011";  -- Move to Conditional on Not Zero
  constant MOVZ_fun_c : std6_st := "001010";  -- Move Conditional on Zero
  constant MTHI_fun_c : std6_st := "010001";  -- Move to HI Register
  constant MTLO_fun_c : std6_st := "010011";  -- Move to LO Register

-------------------------------------------------------------------------------
-- TRAP INSTRUCTIONS 
-- kada saznam sta je mozda i smislim da ih odradim :D :D :D : D
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- OTHER STUFF
-------------------------------------------------------------------------------
  type rw_t is (read_c, write_c);

  type AluOp_t is (
    alu_add, alu_addu, alu_div, alu_divu, alu_mult, alu_multu, alu_slt, alu_sltu,
    alu_sub, alu_subu,
    alu_clo, alu_clz, alu_madd, alu_maddu, alu_msub, alu_msubu, alu_mul,
    alu_addi, alu_addiu, alu_slti, alu_sltiu,
    alu_and, alu_xor, alu_nor, alu_or,
    alu_andi, alu_ori, alu_xori,
    alu_sll, alu_sllv, alu_sra, alu_srav, alu_srl, alu_srlv,
    alu_lb, alu_lbu, alu_lh, alu_lhu, alu_lw, alu_ll, alu_lui, alu_lwl, alu_lwr,
    alu_pref, alu_sb, alu_sh, alu_sw, alu_swl, alu_swr, alu_sc,
    alu_sync, alu_syscall,
    alu_mfhi, alu_mflo, alu_movn, alu_movz, alu_mthi, alu_mtlo,
    alu_nop);                               -- alu operations

end package Definitions_pkg;

