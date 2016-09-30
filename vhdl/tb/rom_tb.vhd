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

entity rom_tb is
end entity rom_tb;

architecture behavioral of rom_tb is
	component rom
		port(
			addr : in  std5_st;
			data : out std32_st
		);
	end component rom;

	signal rom_addr : std5_st;
	signal rom_data : std32_st;

	type rom_t is array (0 to 31) of std32_st; -- rom memory type
	signal rom_v : rom_t;               -- instance of rom_type

begin
	rom_c : rom port map(
			addr => rom_addr,
			data => rom_data
		);

	rom_v(0)  <= std32_one_c;
	rom_v(1)  <= std32_zero_c;
	rom_v(2)  <= std32_one_c;
	rom_v(3)  <= std32_zero_c;
	rom_v(4)  <= std32_one_c;
	rom_v(5)  <= std32_zero_c;
	rom_v(6)  <= std32_one_c;
	rom_v(7)  <= std32_zero_c;
	rom_v(8)  <= std32_one_c;
	rom_v(9)  <= std32_zero_c;
	rom_v(10) <= std32_one_c;
	rom_v(11) <= std32_zero_c;
	rom_v(12) <= std32_one_c;
	rom_v(13) <= std32_zero_c;
	rom_v(14) <= std32_one_c;
	rom_v(15) <= std32_zero_c;
	rom_v(16) <= std32_one_c;
	rom_v(17) <= std32_zero_c;
	rom_v(18) <= std32_one_c;
	rom_v(19) <= std32_zero_c;
	rom_v(20) <= std32_one_c;
	rom_v(21) <= std32_zero_c;
	rom_v(22) <= std32_one_c;
	rom_v(23) <= std32_zero_c;
	rom_v(24) <= std32_one_c;
	rom_v(25) <= std32_zero_c;
	rom_v(26) <= std32_one_c;
	rom_v(27) <= std32_zero_c;
	rom_v(28) <= std32_one_c;
	rom_v(29) <= std32_zero_c;
	rom_v(30) <= std32_one_c;
	rom_v(31) <= std32_zero_c;

	data_checker : process is
	begin
		for i in 0 to 31 loop
			wait  for 10ns; 
			rom_addr <= std_logic_vector(to_unsigned(i, rom_addr'length));
			wait for 1ns; 
			if (rom_data = rom_v(i)) then
			
			else
				report "Data error"; 
			end if;

		end loop;

	end process data_checker;
	

end architecture behavioral; 