-------------------------------------------------------------------------------
--
--                          ALU CONTROL UNIT TESTBENCH 
--
-------------------------------------------------------------------------------
-- 
-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: alu control unit testbench 
-- Module Name: alucontrolunit_tb - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1
-- Description:
--      Testbecnch for quick partially testing component 
--     
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--      
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
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;


entity alucontrolunit_tb is

end entity alucontrolunit_tb;


architecture Behavioral of alucontrolunit_tb is

  component alucontrolunit is
    port (
      opcode    : in  std6_st;
      rt        : in  std5_st;
      func      : in  std6_st;
      operation : out AluOp_t);
  end component alucontrolunit;

  signal acu_opcode    : std6_st;
  signal acu_func      : std6_st;
  signal acu_operation : AluOp_t;
  signal acu_rt        : std5_st;

  constant clk_period : time := 1 ns;

begin  -- architecture Behavioral

  alucontrolunit_c : alucontrolunit
    port map (
      opcode    => acu_opcode,
      func      => acu_func,
      operation => acu_operation,
      rt        => acu_rt);

  process is
    variable tmp : AluOp_t;
  begin  -- process
    wait for 2 ns;
    acu_opcode <= ADDI_op_c;
    wait for 1 ns;
    --tmp        := acu_operation;
    wait for 1 ns;
    acu_opcode <= special1_c;
    acu_func   <= ADDU_fun_c;
    wait for 1 ns;
    acu_opcode <= special2_c;
    acu_func   <= MADD_fun_c;
    wait for 1 ns;
    acu_opcode <= "111111";
  end process;

end architecture Behavioral;
