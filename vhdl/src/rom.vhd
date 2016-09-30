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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Definitions_pkg.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;

entity rom is
--  generic (
--    assembly_file : string := "assembly.dat");
  port (
    addr : in  std5_st;  -- input address for reading instruction and registers
    data : out std32_st);         -- output data from address 

end entity rom;

architecture rom of rom is
  type rom_t is array (0 to 31) of std32_st;  
  signal rom_v : rom_t;            

begin  -- architecture rom
	rom_v(0)  <=  std32_one_c;
	rom_v(1)  <=  std32_zero_c;
	rom_v(2)  <=  std32_one_c;
	rom_v(3)  <=  std32_zero_c;
	rom_v(4)  <=  std32_one_c;
	rom_v(5)  <=  std32_zero_c;
	rom_v(6)  <=  std32_one_c;
	rom_v(7)  <=  std32_zero_c;
	rom_v(8)  <=  std32_one_c;
	rom_v(9)  <=  std32_zero_c;
	rom_v(10)  <=  std32_one_c;
	rom_v(11)  <=  std32_zero_c;
	rom_v(12)  <=  std32_one_c;
	rom_v(13)  <=  std32_zero_c;
	rom_v(14)  <=  std32_one_c;
	rom_v(15)  <=  std32_zero_c;
	rom_v(16)  <=  std32_one_c;
	rom_v(17)  <=  std32_zero_c;
	rom_v(18)  <=  std32_one_c;
	rom_v(19)  <=  std32_zero_c;
	rom_v(20)  <=  std32_one_c;
	rom_v(21)  <=  std32_zero_c; 
	rom_v(22)  <=  std32_one_c;
	rom_v(23)  <=  std32_zero_c; 
	rom_v(24)  <=  std32_one_c;
	rom_v(25)  <=  std32_zero_c; 
	rom_v(26)  <=  std32_one_c;
	rom_v(27)  <=  std32_zero_c; 
	rom_v(28)  <=  std32_one_c;
	rom_v(29)  <=  std32_zero_c; 
	rom_v(30)  <=  std32_one_c;
	rom_v(31)  <=  std32_zero_c; 



	data <= rom_v(TO_INTEGER(unsigned(addr)));

end architecture rom;
