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
use STD.TEXTIO.all; 
--use IEEE.STD_LOGIC_UNSIGNED.all; 
--use IEEE.STD_LOGIC_ARITH.all;

entity Rom32 is
	port(
		rst  : in  std_logic;
		addr : in  std32_st;
		data : out std32_st
	);
end entity Rom32;

architecture behave of Rom32 is
	
	alias rom30_cs is addr(31 downto 19);
	alias rom30_addr is addr(18 downto 0); -- this is module of 512Mb 
	
begin
	process is
		file mem_file 		   : TEXT;
		variable L             : line;
		variable ch            : character;
		variable index, result : integer;
		variable resultstd 	   : std32_st; 
		type ramtype is array (0 to 2 ** 19 - 1) of std8_st;
		variable mem : ramtype;
	begin
		-- initialize memory from file
		for i in 0 to 2 ** 19 - 1 loop           -- set all contents low
			mem(i) := x"00";
		end loop;
		index := 0;
		FILE_OPEN(mem_file, "/home/tome/Work/projects/mips/src/mips32-utils/book_example/app2.hex", READ_MODE);
		while not endfile(mem_file) loop
			readline(mem_file, L);
			result := 0;
			for i in 1 to 8 loop
				read(L, ch);
				if '0' <= ch and ch <= '9' then
					result := result * 16 + character'pos(ch) - character'pos('0');
				elsif 'a' <= ch and ch <= 'f' then
					result := result * 16 + character'pos(ch) - character'pos('a') + 10;
				else
					report "Format error on line" & integer'image(index) severity error;
				end if;
			end loop;
			resultstd := std_logic_vector(to_unsigned(result, 32)); 
			mem(index+3) := resultstd(31 downto 24);  
			mem(index+2) := resultstd(23 downto 16);
			mem(index+1) := resultstd(15 downto 8);
			mem(index) := resultstd(7 downto 0);
			index      := index + 4;
		end loop;
		
		-- read memory
		loop
			data <= mem(TO_INTEGER(unsigned(rom30_addr) + 3)) & mem(TO_INTEGER(unsigned(rom30_addr) + 2)) & mem(TO_INTEGER(unsigned(rom30_addr) + 1)) & mem(TO_INTEGER(unsigned(rom30_addr)));
			wait on addr;
		end loop;
	end process;
end;

