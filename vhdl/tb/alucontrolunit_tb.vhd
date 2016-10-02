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


entity alucontrolunit_tb is

end entity alucontrolunit_tb;


architecture Behavioral of alucontrolunit_tb is

  component AluControlUnit is
    port (
      cu_operation : in  AluOp_t;
      func         : in  std6_st;
      operation    : out AluOp_t);
  end component AluControlUnit;

  signal acu_cu_operation : AluOp_t;
  signal acu_operation    : AluOp_t;
  signal acu_func         : std6_st;

  constant clk_period : time := 1 ns;

begin  -- architecture Behavioral

  alucontrolunit_c : AluControlUnit
    port map (
      cu_operation => acu_cu_operation,
      operation    => acu_operation,
      func         => acu_func);

  process is
    variable tmp : AluOp_t;
  begin  -- process
    wait for 2 ns;
    acu_cu_operation <= alu_add;
    wait for 1 ns;
    acu_cu_operation <= alu_xor;
    wait for 1 ns;
    acu_func         <= SUB_fun_c;
    acu_cu_operation <= alu_special1;
    wait for 1 ns;
    acu_cu_operation <= alu_special2;
    acu_func         <= MADD_fun_c;


    wait for 1 ns;
  end process;

end architecture Behavioral;
