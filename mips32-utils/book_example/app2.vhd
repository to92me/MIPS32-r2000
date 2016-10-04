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
rom_0(3)  <=  "00100000";
rom_0(2)  <=  "00000010";
rom_0(1)  <=  "00000000";
rom_0(0)  <=  "00000101";
rom_0(7)  <=  "00100000";
rom_0(6)  <=  "00000011";
rom_0(5)  <=  "00000000";
rom_0(4)  <=  "00001100";
rom_0(11)  <=  "00100000";
rom_0(10)  <=  "01100111";
rom_0(9)  <=  "11111111";
rom_0(8)  <=  "11110111";
rom_0(15)  <=  "00000000";
rom_0(14)  <=  "11100010";
rom_0(13)  <=  "00100000";
rom_0(12)  <=  "00100101";
rom_0(19)  <=  "00000000";
rom_0(18)  <=  "01100100";
rom_0(17)  <=  "00101000";
rom_0(16)  <=  "00100100";
rom_0(23)  <=  "00000000";
rom_0(22)  <=  "10100100";
rom_0(21)  <=  "00101000";
rom_0(20)  <=  "00100000";
rom_0(27)  <=  "00010000";
rom_0(26)  <=  "10100111";
rom_0(25)  <=  "00000000";
rom_0(24)  <=  "00001010";
rom_0(31)  <=  "00000000";
rom_0(30)  <=  "01100100";
rom_0(29)  <=  "00100000";
rom_0(28)  <=  "00101010";
rom_0(35)  <=  "00010000";
rom_0(34)  <=  "10000000";
rom_0(33)  <=  "00000000";
rom_0(32)  <=  "00000001";
rom_0(39)  <=  "00100000";
rom_0(38)  <=  "00000101";
rom_0(37)  <=  "00000000";
rom_0(36)  <=  "00000000";
rom_0(43)  <=  "00000000";
rom_0(42)  <=  "11100010";
rom_0(41)  <=  "00100000";
rom_0(40)  <=  "00101010";
rom_0(47)  <=  "00000000";
rom_0(46)  <=  "10000101";
rom_0(45)  <=  "00111000";
rom_0(44)  <=  "00100000";
rom_0(51)  <=  "00000000";
rom_0(50)  <=  "11100010";
rom_0(49)  <=  "00111000";
rom_0(48)  <=  "00100010";
rom_0(55)  <=  "10101100";
rom_0(54)  <=  "01100111";
rom_0(53)  <=  "00000000";
rom_0(52)  <=  "01000100";
rom_0(59)  <=  "10001100";
rom_0(58)  <=  "00000010";
rom_0(57)  <=  "00000000";
rom_0(56)  <=  "01010000";
rom_0(63)  <=  "00001000";
rom_0(62)  <=  "00000000";
rom_0(61)  <=  "00000000";
rom_0(60)  <=  "00010001";
rom_0(67)  <=  "00100000";
rom_0(66)  <=  "00000010";
rom_0(65)  <=  "00000000";
rom_0(64)  <=  "00000001";
rom_0(71)  <=  "10101100";
rom_0(70)  <=  "00000010";
rom_0(69)  <=  "00000000";
rom_0(68)  <=  "01010100";
	end if;
	end process reset_values;

end architecture RTL;

