-------------------------------------------------------------------------------
--
--                           CPU 
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
-- Revision 0.01 - File Create
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

-------------------------------------------------------------------------------
-- entity
-------------------------------------------------------------------------------

entity cpu is
  port (
    clk       : in std_logic;           -- main clock signal
    rst       : in std_logic;           -- reset signal active high
    interrupt : in std_logic;           -- interupt signal active high
    debug     : in std_logic);          -- for debuging - writeing logs to tcl
-- console 
end entity cpu;

-------------------------------------------------------------------------------
-- architecture
-------------------------------------------------------------------------------

architecture behavioral of cpu is
  -----------------------------------------------------------------------------
  -- compoonents
  -----------------------------------------------------------------------------
  -- registers unit 
  component registers is
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      rdAddr1 : in  std_logic_vector(4 downto 0);
      rdAddr2 : in  std_logic_vector(4 downto 0);
      rdData1 : out std_logic_vector(31 downto 0);
      rdData2 : out std_logic_vector(31 downto 0);
      wrAddr  : in  std_logic_vector(4 downto 0);
      wrData  : in  std32_st;
      wr      : in  std_logic);
  end component registers;

  -- memory unit 
  component memory is
    port (
      clk    : in  std_logic;
      wr     : in  std_logic;
      rd     : in  std_logic;
      rdData : out std32_st;
      addr   : in  std5_st;
      wrData : in  std32_st);
  end component memory;

  -- rom unit 
  component rom is
    port (
      addr : in  std10_st;
      data : out std32_st;
      rst  : in  std_logic;
      clk  : in  std_logic);
  end component rom;

  -- alu control unit 
  component alucontrolunit is
    port (
      opcode    : in  std6_st;
      rt        : in  std5_st;
      func      : in  std6_st;
      operation : out AluOp_t);
  end component alucontrolunit;

  -- alu unit 
  component alu is
    port (
      operand1  : in  std32_st;
      operand2  : in  std32_st;
      operation : in  AluOp_t;
      result    : out std32_st;
      result64  : out std32_st);
  end component alu;



  -----------------------------------------------------------------------------
  -- SIGNALS
  -----------------------------------------------------------------------------

  -- GP registers  
  signal reg_rdAddr1 : std5_st;
  signal reg_rdAddr2 : std5_st;
  signal reg_wrAddr  : std5_st;
  signal reg_rdData1 : std32_st;
  signal reg_rdData2 : std32_st;
  signal reg_wrData  : std32_st;
  signal reg_wr      : std_logic;

  -- memory 
  signal mem_addr   : std5_st;
  signal mem_wrData : std32_st;
  signal mem_rdData : std32_st;
  signal mem_wr     : std_logic;
  signal mem_rd     : std_logic;

  -- rom
  signal rom_addr : std10_st;
  signal rom_data : std32_st;

  -- alu control unit
  signal alucon_opcode    : std6_st;
  signal alucon_rt        : std5_st;
  signal alucon_func      : std6_st;
  signal alucon_operation : AluOp_t;

  --alu unit
  signal alu_operand1  : std32_st;
  signal alu_operand2  : std32_st;
  signal alu_result    : std32_st;
  signal alu_result64  : std32_st;
  signal alu_operation : AluOp_t;

  signal instruction_v : std32_st;


-------------------------------------------------------------------------------
-- begin
-------------------------------------------------------------------------------

begin  -- architecture behavioral
  -- port maps for components
  register_c : registers
    port map (
      clk     => clk,
      rst     => rst,
      rdAddr1 => reg_rdAddr1,
      rdAddr2 => reg_rdAddr2,
      rdData1 => reg_rdData1,
      rdData2 => reg_rdData2,
      wrAddr  => reg_wrAddr,
      wrData  => reg_wrData,
      wr      => reg_wr);

  rom_c : rom
    port map (
      clk  => clk,
      rst  => rst,
      addr => rom_addr,
      data => rom_data);

  memory_c : memory
    port map (
      clk    => clk,
      wr     => mem_wr,
      rd     => mem_rd,
      rdData => mem_rdData,
      wrData => mem_wrData,
      addr   => mem_addr);

  alucontrolunit_c : alucontrolunit
    port map (
      opcode    => alucon_opcode,
      rt        => alucon_rt,
      func      => alucon_func,
      operation => alu_operation);


  alu_c : alu
    port map (
      operand1  => alu_operand1,
      operand2  => alu_operand2,
      result    => alu_result,
      result64  => alu_result64,
      operation => alu_operation);



  main_process : process (clk, rst) is
    variable lo_v, hi_v : std32_st;
    variable pc_v       : integer;      -- program counter

    alias opcode_a    : std6_st is instruction_v(31 downto 26);  -- operation first 6 bits of instruction
    alias rs_a        : std5_st is instruction_v(25 downto 21);  -- rs register address
    alias rt_a        : std5_st is instruction_v(20 downto 16);  -- rt register address
    alias rd_a        : std5_st is instruction_v(15 downto 11);  -- rd register address
    alias sa_a        : std5_st is instruction_v(10 downto 6);
    alias func_a      : std6_st is instruction_v(5 downto 0);
    alias ins_index_a : std26_st is instruction_v(25 downto 0);
    alias imm_a       : std16_st is instruction_v(15 downto 0);


  begin  -- process main_process
    if rst = '0' then                   -- asynchronous reset (active low)
      pc_v := 0;

    elsif clk'event and clk = '1' then  -- rising clock edge

      -- IF ( instruction fetch ) phase 
      --reading instructin from rom
      rom_addr      <= conv_std_logic_vector(pc_v, 10);
      instruction_v := rom_data;

      -- ID ( instruction decode ) & RF ( register fetch ) phase 
      --decodeing instruction 
      --writeing sources addresses to register 
      reg_wr <= read_c; 
      reg_rdAddr1   <= rs_a;
      reg_rdAddr2 <=  rt_a;

      -- EX ( execute ) phase
      -- decode opertaion
      -- execute operaton in ALU 
      alucon_opcode <= opcode_a;
      alucon_func   <= func_a;
      alu_operand1 <= reg_rdData1;
      -- if operation is I type then 
      if operation = (alu_addi or alu_addiu or alu_slti or
                      alu_sltiu or alu_andi or alu_ori or
                      alu_xori) then
        alu_operand2 <= imm_a;
      else
        alu_operand2 <= reg_rdData2;
      end if;

      alu_operation <= alucon_operation;
      
      

    end if;
  end process main_process;


end architecture behavioral;
