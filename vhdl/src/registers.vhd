-------------------------------------------------------------------------------
--                           REGISTERS  
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
-- file         : registers.vhd 
-- module       : Registers
-- description  : this are general purpose registers. There are 31 32-bit general 
--				  purpose registers and one 64-bit register 
-------------------------------------------------------------------------------
-- todo         : modifie last register to be 64-bit width 
-------------------------------------------------------------------------------
-- comments     : currently all 32 registers are 32-bit 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity registers is
	port(
		clk     : in  std_logic;
		rst     : in  std_logic;        -- asynchrony reset
		rdAddr1 : in  std_logic_vector(4 downto 0); -- address of register 1 for reading operation
		rdAddr2 : in  std_logic_vector(4 downto 0); -- address of register 2 for reading from register
		rdData1 : out std_logic_vector(31 downto 0); -- data from 1 selected register 32 bits of data
		rdData2 : out std_logic_vector(31 downto 0); -- data from 2 selected register 32 bits of data
		wrAddr  : in  std_logic_vector(4 downto 0); -- address of register for writing to register operation 5 bits
		wrData  : in  std32_st;         -- input data for writing to register operation
		wr      : in  std_logic);       -- input bit for choosing write or read option (for easier writing code we created new type called rwType )

end entity registers;

architecture Behavioral of registers is
	type register_t_arr is array (0 to 31) of std32_st;
	signal registers_v : register_t_arr;

begin
	--reading from registers is asynchronous operation
	rdData1 <= registers_v(TO_INTEGER(unsigned(rdAddr1)));
	rdData2 <= registers_v(TO_INTEGER(unsigned(rdAddr2)));
	
	-- writing to register synchronous operation 
	reg_process : process(clk, rst) is
	begin
		if rst = '1' then               -- asynchrony reset active at high
			for i in 0 to 31 loop       -- if reseted all registers are set to "00..000"
				registers_v(i) <= std32_zero_c;
			end loop;                   -- i

		elsif (rising_edge(clk) and wr = '1') then -- synchrony operations of:
			registers_v(TO_INTEGER(unsigned(wrAddr))) <= wrData;
			report "writing data to register. addr: " & integer'image(to_integer(unsigned(wrAddr))) & ", data: " & integer'image(to_integer(unsigned(wrData)));
		end if;
	end process reg_process;
end architecture Behavioral;
