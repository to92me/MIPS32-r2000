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

entity cpu_tb is
end entity cpu_tb;

architecture Behavioral of cpu_tb is
	component cpu
		port(
			clk        : in  std_logic;
			rst        : in  std_logic;
			debug      : in  std_logic;
			rom_addr   : out std32_st;
			rom_data   : in  std32_st;
			--			rom_rst    : out std_logic;
			mem_we     : out std_logic;
			mem_rdData : in  std32_st;
			mem_addr   : out std32_st;
			mem_wrData : out std32_st
		);
	end component cpu;

	component rom32
		port(
			rst  : in  std_logic;
			addr : in  std32_st;
			data : out std32_st
		);
	end component rom32;

	component memory
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			we     : in  std_logic;
			rdData : out std32_st;
			addr   : in  std32_st;
			wrData : in  std32_st
		);
	end component memory;

	signal clk            : std_logic;
	signal rst            : std_logic;
	signal debug          : std_logic;
	signal cpu_rom_addr   : std32_st;
	signal cpu_rom_data   : std32_st;
	--	signal cpu_rom_rst : std32_st; 
	signal cpu_mem_we     : std_logic;
	signal cpu_mem_rdData : std32_st;
	signal cpu_mem_wrData : std32_st;
	signal cpu_mem_addr   : std32_st;

begin
	cpu_c : cpu
		port map(
			clk        => clk,
			rst        => rst,
			debug      => debug,
			rom_addr   => cpu_rom_addr,
			rom_data   => cpu_rom_data,
			--			rom_rst    => cpu_rom_rst,
			mem_we     => cpu_mem_we,
			mem_rdData => cpu_mem_rdData,
			mem_addr   => cpu_mem_addr,
			mem_wrData => cpu_mem_wrData
		);

	rom32_c : rom32
		port map(
			rst  => rst,
			addr => cpu_rom_addr,
			data => cpu_rom_data
		);

	memory_c : memory
		port map(
			clk    => clk,
			rst    => rst,
			we     => cpu_mem_we,
			rdData => cpu_mem_rdData,
			addr   => cpu_mem_addr,
			wrData => cpu_mem_wrData
		);
	clock_generator : process is
	begin
		clk <= '0';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
	end process clock_generator;

	rst_generator : process is
	begin
		rst <= '0';
		wait for 0.5ns; 
		rst  <= '1';
		wait for 1ns; 
		rst  <= '0';
		wait; 
	end process rst_generator;

end architecture Behavioral; 
	   