-------------------------------------------------------------------------------
--                           ROM 
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
-- file         : rom.vhd 
-- module       : Rom
-- description  : ROM ( read only memory ). In this memory are stored all 
--				  instructions 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Definitions_pkg.all;

entity rom32 is
	port(
		rst  : in  std_logic;
		addr : in  std32_st;
		data : out std32_st
	);
end entity rom32;

architecture RTL of rom32 is
	type rom_t is array (0 to 2 ** 19 - 1) of std8_st;
	signal rom_0 : rom_t;

	alias rom30_cs is addr(31 downto 19);
	alias rom30_addr is addr(18 downto 0); -- this is module of 512Mb 

begin

	data <= rom_0(TO_INTEGER(unsigned(rom30_addr) + 3)) & rom_0(TO_INTEGER(unsigned(rom30_addr) + 2)) & rom_0(TO_INTEGER(unsigned(rom30_addr) + 1)) & rom_0(TO_INTEGER(unsigned(rom30_addr)));


	reset_values : process(rst) is
		variable i, j : integer;
	begin
		if (rising_edge(rst)) then
			for i in 0 to (2 ** 19 - 2) loop
				rom_0(i)  <= "00000000"; 
			end loop;
