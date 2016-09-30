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
-- file         : 
-- module       : 
-- description  : 
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
    addr : in  std5_st;  -- input adress for readnig instruction and registers
    data : out std32_st);              -- clock

end entity rom;

architecture rom of rom is
  type rom_t is array (0 to 31) of std32_st;  -- rom memory type
  signal rom_v : rom_t;            -- instance of rom_type

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

  -- purpose: read file and store it in rom_v memory 
  -- type   : combinational
  -- inputs : 
  -- outputs: 
--  read_file : process is
--    type std32_st_file_t is file of std32_st;
--    file asm_f           : std32_st_file_t open read_mode is assembly_file;
    --   file asm_f : text open read_mode is assembly_file;
---    variable line_number : integer := 0;  -- for line in integer
--    variable tmp         : std32_st;

--  begin  -- process read_file
--    while not endfile(asm_f) loop
--      read(asm_f, tmp);
--     rom_v(line_number) := tmp;
--     line_number      := line_number + 1;
--   end loop;
--  end process read_file;

	data <= rom_v(TO_INTEGER(unsigned(addr)));

end architecture rom;
