-------------------------------------------------------------------------------
--
--                              MEMORY 
--
-------------------------------------------------------------------------------

-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Create Date: 11/26/2014 11:50:04 AM
-- Design Name: Memory
-- Module Name: Memory - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1
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
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;


entity memory is

  generic (
    memory_file : string := "memory.dat");  -- memory file for debuging

  port (
    clk    : in  std_logic;             -- clock
    wr     : in  std_logic;             -- write bit
    rd     : in  std_logic;             -- read bit 
    rdData : out std32_st;              -- reading data
    addr   : in  std5_st;               -- addres
    wrData : in  std32_st);             -- writeing data to memory

end entity memory;


architecture behavioral of memory is

begin  -- architecture behavioral

  -- purpose: memory process
  -- type   : sequential
  -- inputs : clk, 
  -- outputs: 
  memory_process : process (clk) is
    type memory_t_arr is array (0 to 30) of std32_st;  -- memory type is array
                                                       -- of 31 registers of 32
                                                       -- bits 
    variable memory_v : memory_t_arr;   -- instance od memory type

  begin  -- process memory_process

    if clk'event and clk = '1' then     -- rising clock edge
      if (wr = '1' and rd /= '1') then
        memory_v(to_integer(unsigned(addr))) := wrData;
      elsif (rd = '1' and wr /= '1')  then
        rdData <= memory_v(to_integer(unsigned(addr)));
      end if;
    end if;
  end process memory_process;

end architecture behavioral;
