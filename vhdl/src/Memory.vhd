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
-- todo         : TODO make memory work, half word and byte addressable. 
-------------------------------------------------------------------------------
-- comments     : For version tow memory will be byte addressable. 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity Memory is

	port(
		clk    : in  std_logic; --clock: because write is on rising edge 
		rst    : in  std_logic; -- asynchron reset
		we     : in  std_logic; -- write enable 
		rdData : out std32_st;  -- data read from memory 
		addr   : in  std32_st;  -- address on witch data will be written or read. Depends on we signal 
		wrData : in  std32_st); -- data for writing to memory 

end entity Memory;

architecture behavioral of Memory is
begin
	memory_process : process(clk, we, addr, rst) is
		type memory_t_arr is array (0 to 2 ** 14 - 1) of std32_st; --512MB of memory 
		variable memory_v : memory_t_arr;
	begin
		--on rising edge of reset set whole memory to 0 and output to 0 
		if (rising_edge(rst)) then
			for j in 0 to 2 ** 14 - 1 loop
				memory_v(j) := std32_zero_c;
				rdData      <= std32_zero_c;
			end loop;
		-- on rising edge and we='1' write data to memrory
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


