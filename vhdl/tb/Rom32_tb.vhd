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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Definitions_pkg.all;

entity Rom32_tb is
end entity Rom32_tb;

architecture RTL of Rom32_tb is
	component Rom32
		port(
			rst  : in  std_logic;
			addr : in  std32_st;
			data : out std32_st
		);
	end component Rom32;
	signal rom32_addr : std32_st;
	signal rom32_data : std32_st;
	signal rom32_rst  : std_logic;
begin
	Rom32_c : Rom32
		port map(
			rst  => rom32_rst,
			addr => rom32_addr,
			data => rom32_data
		);
	
	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- address driver 
	--------------------------------------------------------------	
	address_generator : process is
		variable iterator : unsigned(18 downto 0) := to_unsigned(0, 19);
	begin
		loop
			rom32_addr <= std_logic_vector(resize(iterator, rom32_addr'length));
			iterator   := iterator + 1;
			wait for 0.1 ns;
			wait for 0.1 ns;
			exit when (iterator = 2 ** 19 - 5);
		end loop;
	end process address_generator;
	
	--------------------------------------------------------------
	-- reset driver 
	--------------------------------------------------------------	
	reset_generator : process is
	begin
		rom32_rst  <= '0';
		wait for 1ps; 
		rom32_rst  <= '1'; 
		wait for 1ns; 
		rom32_rst  <= '0'; 
		wait; 
	end process reset_generator;
end architecture RTL;
