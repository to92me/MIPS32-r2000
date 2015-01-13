-------------------------------------------------------------------------------
--
--                          GP REGISTGERS 
--
-------------------------------------------------------------------------------
-- 
-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: RegistersModel
-- Module Name: mips_registers - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1
-- Description:r
--      32 GP registers of mips32
--      two reading registers at same time
--      one writeing register at same time
--      32 architecture
--      5 bits adress buss for selecting
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--      1.  Nisam siguran da li je reset asinhron ( cini mi se da jeste ) i da li
--      je aktivan da nizak ili visok nivo
--      2.  Proveriti za upis za wrReg = "00000" da li je moguc
--
-------------------------------------------------------------------------------
--
-- Revision 1.0
-- Mentor: Rastislav Struharek
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity registers is

  port (
    clk     : in  std_logic;            -- clock signal
    rst     : in  std_logic;            -- asinchron reset
    rdAddr1 : in  std_logic_vector(4 downto 0);  -- address of register 1 for reading operation
    rdAddr2 : in  std_logic_vector(4 downto 0);  -- address of register 2 for reading from register
    rdData1 : out std_logic_vector(31 downto 0);  -- data from 1 selected register 32 bits of data
    rdData2 : out std_logic_vector(31 downto 0);  -- data from 2 selected register 32 bits of data
    wrAddr  : in  std_logic_vector(4 downto 0);  -- address of register for writeing to register operation 5 bits
    wrData  : in  std32_st;    -- input data for writeing to register operation
    wr      : in  std_logic);  -- input bit for choesing write or read option (for easier writeing code we created new type called rwType )

end entity registers;

architecture Behavioral of registers is

begin  -- architecture Behavioral

  -- purpose: general process for useing registers
  -- type   : sequential
  -- inputs : clk, rst, rdReg1, rdReg2, wrReg, wrData;
  -- outputs: rdData1, rdData2,
  reg_process : process (clk, rst) is
    type register_f_t is file of std32_st;
    type register_t_arr is array (0 to 31) of std32_st;  -- register is array of 32 "registers" = subtype std32_t
    variable registers_v : register_t_arr;  -- instance of register_t
    --  file register_f : register_f_t open read_mode is "register_file";
    variable L           : line;        -- for writting to command line
  begin  -- process reg_process

    if rst = '1' then                   -- asinchrone reset active at hight
      for i in 0 to 31 loop             -- if reseted all registers are set to
        -- "00..000"
        registers_v(i) := std32_zero_c;
      end loop;  -- i

    elsif rising_edge(clk) then         -- sinchron operations of:
      if wr = '0' then                  -- reading from register
        rdData1 <= registers_v(TO_INTEGER(unsigned(rdAddr1)));
        rdData2 <= registers_v(TO_INTEGER(unsigned(rdAddr2)));

      else                              -- writeing to register
        registers_v(TO_INTEGER(unsigned(wrAddr))) := wrData;  -- TOME - u nekim
      -- kodovima sam nasao da se upisuje za vrednost "00000" - proveriti
      -- ubaciti dodatni if ako je tacno
      end if;
    end if;
  end process reg_process;
end architecture Behavioral;
