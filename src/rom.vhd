-------------------------------------------------------------------------------
--
--                              ROM
--
-------------------------------------------------------------------------------

-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Create Date: 11/26/2014 11:50:04 AM
-- Design Name: Rom
-- Module Name: rom - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1 (Linux) 
-- Description:
--     rom model with predefined memory that will be processed
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer :
--
--
-------------------------------------------------------------------------------
--
--  Revision 1.0
--  Mentor : Rastislav Struharek
--  Revision 0.01 - file Created
--  Additional Comments :
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Definitions_pkg.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;

entity rom is
  generic (
    assembly_file : string := "assembly.dat");
  port (
    addr : in  std10_st;  -- input adress for readnig instruction and registers
    data : out std32_st;                -- opcode output 32 bits
    rst  : in  std_logic;
    clk  : in  std_logic);              -- clock

end entity rom;

architecture rom of rom is
  type rom_t is array (0 to 127) of std32_st;  -- rom memory type
  shared variable rom_v : rom_t;               -- instance of rom_type

begin  -- architecture rom


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



  reading_process : process (clk, rst) is


  begin  -- process reading_process
    if clk'event and clk = '1' then     -- rising clock edge
      data <= rom_v(TO_INTEGER(unsigned(addr)));
    end if;
  end process reading_process;


end architecture rom;
