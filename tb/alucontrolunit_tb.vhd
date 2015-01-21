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
      cu_operation : in  AluOp_t;
      func         : in  std6_st;
      operation    : out AluOp_t);
  end component alucontrolunit;

  signal acu_cu_operation : AluOp_t;
  signal acu_operation    : AluOp_t;
  signal acu_func         : std6_st;

  constant clk_period : time := 1 ns;

begin  -- architecture Behavioral

  alucontrolunit_c : alucontrolunit
    port map (
      cu_operation => acu_cu_operation,
      operation    => acu_operation,
      func         => acu_func);

  process is
    variable tmp : AluOp_t;
  begin  -- process
    wait for 2 ns;
    acu_cu_operation <= alu_addiu;
    wait for 1 ns;
    acu_cu_operation <= alu_xori;
    wait for 1 ns;
    acu_func         <= ADDU_fun_c;
    acu_cu_operation <= alu_special1;


    wait for 1 ns;

    acu_cu_operation <= alu_special2;
    acu_func         <= MADD_fun_c;


    wait for 1 ns;
  end process;

end architecture Behavioral;
