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
	--	signal rom_1 : rom_t;
	--	signal rom_2 : rom_t;
	--	signal rom_3 : rom_t;

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
--			rom_0(3)  <=  "00100000";
--			rom_0(2)  <=  "01000001";
--			rom_0(1)  <=  "00000000";
--			rom_0(0)  <=  "00001100";
--			
--			rom_0(7)  <=  "00100000";
--			rom_0(6)  <=  "01000111";
--			rom_0(5)  <=  "00000000";
--			rom_0(4)  <=  "00001101";
--			
--			rom_0(11)  <=  "00000000";
--			rom_0(10)  <=  "00100111";
--			rom_0(9)  <=  "00101000";
--			rom_0(8)  <=  "00100000";
--			
--			rom_0(15)  <=  "10101100";
--			rom_0(14)  <=  "00000101";
--			rom_0(13)  <=  "00000000";
--			rom_0(12)  <=  "00000000";
--			
--			rom_0(19)  <=  "10001100";
--			rom_0(18)  <=  "00000110";
--			rom_0(17)  <=  "00000000";
--			rom_0(16)  <=  "00000000";
			
--			rom_0(3)  <=  "00100000";
--			rom_0(2)  <=  "01000001";
--			rom_0(1)  <=  "00000000";
--			rom_0(0)  <=  "00001100";
--			rom_0(7)  <=  "00100000";
--			rom_0(6)  <=  "01000111";
--			rom_0(5)  <=  "00000000";
--			rom_0(4)  <=  "00001101";
--			rom_0(11)  <=  "00000000";
--			rom_0(10)  <=  "00100111";
--			rom_0(9)  <=  "00101000";
--			rom_0(8)  <=  "00100000";
--			rom_0(15)  <=  "10101100";
--			rom_0(14)  <=  "00000101";
--			rom_0(13)  <=  "00000000";
--			rom_0(12)  <=  "00000000";
--			rom_0(19)  <=  "10001100";
--			rom_0(18)  <=  "00000001";
--			rom_0(17)  <=  "00000000";
--			rom_0(16)  <=  "00000000";
--			rom_0(23)  <=  "00001000";
--			rom_0(22)  <=  "00000000";
--			rom_0(21)  <=  "00000000";
--			rom_0(20)  <=  "00000010";


rom_0(3)  <=  "00100000";
rom_0(2)  <=  "01000100";
rom_0(1)  <=  "00000000";
rom_0(0)  <=  "00000001";
rom_0(7)  <=  "00100000";
rom_0(6)  <=  "01000101";
rom_0(5)  <=  "00000000";
rom_0(4)  <=  "00001100";
rom_0(11)  <=  "00100000";
rom_0(10)  <=  "01000110";
rom_0(9)  <=  "00000000";
rom_0(8)  <=  "00001101";
rom_0(15)  <=  "00000000";
rom_0(14)  <=  "10000101";
rom_0(13)  <=  "00111000";
rom_0(12)  <=  "00100000";
rom_0(19)  <=  "00000000";
rom_0(18)  <=  "11100100";
rom_0(17)  <=  "00111000";
rom_0(16)  <=  "00100010";
rom_0(23)  <=  "00010000";
rom_0(22)  <=  "11100100";
rom_0(21)  <=  "11111111";
rom_0(20)  <=  "11111010";
rom_0(27)  <=  "00001000";
rom_0(26)  <=  "00000000";
rom_0(25)  <=  "00000000";
rom_0(24)  <=  "00000100";
			
		end if;
	end process reset_values;

end architecture RTL;
