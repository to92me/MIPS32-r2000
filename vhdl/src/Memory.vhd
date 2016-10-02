-------------------------------------------------------------------------------
--                           Memory 
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
-- file         : memory.vhd 
-- module       : Memory 
-- description  : Memory is part of Test Bench for CPU. It is RAM memory for CPU.
--				  size of this memory is 512MB. 
-------------------------------------------------------------------------------
-- todo         : TODO make memory work, half word and byte addressable 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity memory is

	--  generic (
	--    memory_file : string := "memory.dat");  

	port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		we     : in  std_logic;
		rdData : out std32_st;
		addr   : in  std32_st;
		wrData : in  std32_st);

end entity memory;

architecture behavioral of memory is
begin
	memory_process : process(clk, we, addr, rst) is
		type memory_t_arr is array (0 to 2 ** 14 - 1) of std32_st; -- 
		variable memory_v : memory_t_arr;
	begin
		if (rising_edge(rst)) then
			for j in 0 to 2 ** 14 - 1 loop
				memory_v(j) := std32_zero_c;
				rdData      <= std32_zero_c;
			end loop;
		elsif (we = '1') then
			if (rising_edge(clk)) then
				memory_v(to_integer(unsigned(addr))) := wrData;
				report "writing data to RAM. addr:" & integer'image(to_integer(unsigned(addr))) & ", data: " & integer'image(to_integer(unsigned(wrData)));
			end if;
		else
			rdData <= memory_v(to_integer(unsigned(addr)));
		end if;
	end process memory_process;

end architecture behavioral;


