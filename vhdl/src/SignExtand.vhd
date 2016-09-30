-------------------------------------------------------------------------------
--                           SignExtand 
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
-- file         : SignExtand.vhd 
-- module       : SignExtand
-- description  : SignExtand it extends signed 16 bit input to signed 32 bit 
--				  data
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions_pkg.all;

entity SignExtand is
	port(
		in_s16  : in  std16_st;
		out_s32 : out std32_st
	);
end entity SignExtand;

architecture RTL of SignExtand is
begin
	out_s32 <= std_logic_vector(resize(signed(in_s16), out_s32'length));
end architecture RTL;
