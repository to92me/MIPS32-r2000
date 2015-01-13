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


entity alu_tb is

end entity alu_tb;


architecture Behavioral of alu_tb is

  component alu is
    port (
      operand1  : in  std32_st;
      operand2  : in  std32_st;
      operation : in  AluOp_t;
      result    : out std32_st;
      result64  : out std32_st);
  end component alu;

  signal alu_operand1  : std32_st;
  signal alu_operand2  : std32_st;
  signal alu_operation : AluOp_t;
  signal alu_result    : std32_st;
  signal alu_result64  : std32_st;

begin  -- architecture Behavioral

  alu_c : alu
    port map (
      operand1  => alu_operand1,
      operand2  => alu_operand2,
      operation => alu_operation,
      result    => alu_result,
      result64  => alu_result64);

  test_process : process is
  begin  -- process test_process
    wait for 1 ns;
    alu_operand1  <= "00000000000000000000000000000111";
    alu_operand2  <= "00000000000000000000000000000011";
    alu_operation <= alu_or;
    wait for 1 ns;
    alu_operand1  <= "00000000000000000000001100000111";
    alu_operand2  <= "00000000001100000000000000000011";
    alu_operation <= alu_nor;
  end process test_process;

end architecture Behavioral;


