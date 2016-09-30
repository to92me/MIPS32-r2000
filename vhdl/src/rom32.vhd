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
	-- 	00000000 00100111 00000000 00100000 add $0 $1 $7 
--	   	00000000 00100111 00101000 00100000 add $5 $1 $7 

--	   	00100000 01000001 00000000 00001100 	2041000c addi $1 $2 12
-- 	   	00100000 01000111 00000000 00001101		2047000d addi $7 $2 13
--		00000000 00100111 00101000 00100000		00272820 add $5 $1 $7 

--	rom_0(3)  <=  "00000000";
--	rom_0(2)  <=  "00100111";
--	rom_0(1)  <=  "00000000";
--	rom_0(0)  <=  "00100000";
	
	data <= rom_0(TO_INTEGER(unsigned(rom30_addr) + 3)) & rom_0(TO_INTEGER(unsigned(rom30_addr) + 2)) & rom_0(TO_INTEGER(unsigned(rom30_addr) + 1)) & rom_0(TO_INTEGER(unsigned(rom30_addr)));

	--	with rom30_cs select data <=
	--		rom_0(TO_INTEGER(unsigned(addr))) when "00",
	--		rom_1(TO_INTEGER(unsigned(addr))) when "01",
	--		rom_2(TO_INTEGER(unsigned(addr))) when "10",
	--		rom_3(TO_INTEGER(unsigned(addr))) when others;

	reset_values : process(rst) is
		variable i, j : integer;
	begin
		if (rising_edge(rst)) then
			for i in 0 to (2 ** 19 - 2) loop
				rom_0(i)  <= "00000000"; 
			end loop;
			rom_0(3)  <=  "00100000";
			rom_0(2)  <=  "01000001";
			rom_0(1)  <=  "00000000";
			rom_0(0)  <=  "00001100";
			
			rom_0(7)  <=  "00100000";
			rom_0(6)  <=  "01000111";
			rom_0(5)  <=  "00000000";
			rom_0(4)  <=  "00001101";
			
			rom_0(11)  <=  "00000000";
			rom_0(10)  <=  "00100111";
			rom_0(9)  <=  "00101000";
			rom_0(8)  <=  "00100000";
		end if;
	end process reset_values;

end architecture RTL;
