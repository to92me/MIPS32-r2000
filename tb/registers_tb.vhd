-------------------------------------------------------------------------------
--
--                          GP REGISTGERS TESTBENCH 
--
-------------------------------------------------------------------------------
-- 
-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: registers testbench 
-- Module Name: registers_tb - Behavioral
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

entity registers_tb is
end entity registers_tb;

architecture behavioral of registers_tb is


  -- instance of registers component 
  component registers is
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      rdAddr1 : in  std_logic_vector(4 downto 0);
      rdAddr2 : in  std_logic_vector(4 downto 0);
      rdData1 : out std32_st; 
      rdData2 : out std_logic_vector(31 downto 0);
      wrAddr  : in  std_logic_vector(4 downto 0);
      wrData  : in  std_logic_vector(31 downto 0);
      wr      : in  std_logic);
  end component registers;

  -- signals for wireing component and simulation 
  signal reg_rdAddr1  : std_logic_vector(4 downto 0);
  signal reg_rdAddr2  : std_logic_vector(4 downto 0);
  signal reg_wrAddr   : std_logic_vector(4 downto 0);
  signal reg_rdData1  : std_logic_vector(31 downto 0);
  signal reg_rdData2  : std_logic_vector(31 downto 0);
  signal reg_wrData   : std_logic_vector(31 downto 0);
  signal reg_wr       : std_logic;
  signal clk          : std_logic;
  signal rst          : std_logic := '0';
  constant clk_period : time      := 1 ns;  -- constant for clock period 

begin  -- architecture behavioral

  registers_c : registers
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



  -- purpose: generating clock signal
  -- type   : combinational 
  clk_process : process is
  begin  -- process clk_process
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process clk_process;

  -- purpose: test signals for development testing
  -- type   : combinational
  simulation_process : process is
    variable tmp : std_logic_vector(31 downto 0);  -- for results;
    variable L   : line;
  begin  -- process simulation_process
    wait for 2 ns;
    write(L, string'("entered simlation"));
    writeline(output, L);
    write(L, string'("selecting addres : "));
    write(L, string'("00001"));
    write(L, string'(" .. "));
    reg_wr      <= '1';                 -- writeing register mode, wr = '1' 
    reg_wrAddr  <= "00001";             -- sleciting adress for new data 
    reg_wrData  <= x"AAAAAAAA";         -- writeing data (AAAAAAAA, A = 1010)
    -- to selected addres 
    wait for 1 ns;                      -- wating for 1 ns than reading sam
    -- adress
    write(L, string'("reading"));
    writeline(output, L);
    reg_wr      <= '0';
    reg_rdAddr1 <= "00001";
    tmp         := reg_wrData;
    wait for 1 ns;

    rst <= '1';                         -- reseting memory
    wait for 1 ns;
    rst <= '0';
    write(L, string'("reseted"));
    writeline(output, L);
    wait for 1 ns;


    wait for 2 ns;
    reg_wr      <= '1';                 -- writeing register mode, wr = '1' 
    reg_wrAddr  <= "00001";             -- sleciting adress for new data 
    reg_wrData  <= x"AAAAAAAA";         -- writeing data (AAAAAAAA, A = 1010)
    -- to selected addres 
    wait for 1 ns;                      -- wating for 1 ns than reading sam
    -- adress 
    reg_wr      <= '0';
    reg_rdAddr1 <= "00001";
    tmp         := reg_wrData;
    wait for 1 ns;



  end process simulation_process;

end architecture behavioral;
