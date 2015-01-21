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


entity controlunit_tb is

end entity controlunit_tb;

architecture Behavioral of controlunit_tb is

  component controlunit is
    port (
      opcode               : in  std6_st;
      register_write       : out std_logic;
      memory_write         : out std_logic;
      memory_read          : out std_logic;
      mem_to_reg           : out std_logic;
      register_destination : out std_logic;
      alu_operation        : out AluOp_t;
      alu_source           : out std_logic;
      branch               : out std_logic);
  end component controlunit;

  
  signal cu_opcode               : std6_st;
  signal cu_register_write       : std_logic;
  signal cu_memory_write         : std_logic;
  signal cu_memory_read          : std_logic;
  signal cu_mem_to_reg           : std_logic;
  signal cu_register_destination : std_logic;
  signal cu_alu_operation        : AluOp_t;
  signal cu_alu_source           : std_logic;
  signal cu_branch               : std_logic;

begin  -- architecture Behavioral 
  controlunit_c : controlunit
    port map (
      opcode               => cu_opcode,
      register_write       => cu_register_write,
      memory_write         => cu_memory_write,
      memory_read          => cu_memory_read,
      mem_to_reg           => cu_mem_to_reg,
      register_destination => cu_register_destination,
      alu_operation        => cu_alu_operation,
      alu_source           => cu_alu_source,
      branch               => cu_branch);

 process is
 begin  -- process
   cu_opcode <= special1_c;
   wait for 1 ns;
   cu_opcode <= ADDI_op_c;
   wait for 1 ns;
   cu_opcode <= LUI_op_c;
   wait for 1 ns ;
   cu_opcode <= SC_op_c;
   wait for 1 ns ;
 end process;
  
end architecture Behavioral;
