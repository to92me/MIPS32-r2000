-------------------------------------------------------------------------------
--                           PC UNIT 
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
-- file         : PCUnit.vhd
-- module       : PCUnit 
-- description  : this unit calculates next address of PC ( program counter ) 
--				  next address can be:
--				  - current address +4 ( next instruction ) 
-- 				  - branch address ( current + got from instruction ) 
-- 				  - jump address ( current + got from instruction ) 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity PcCounterUnit is
	port(
		clk      : in  std_logic;
		rst      : in  std_logic;
		pc       : out std32_st;
		pc_src   : in  std_logic;
		jump     : in  std_logic;
		sign_imm : in  std32_st;
		instr    : in  std26_st
	);
end entity PcCounterUnit;

architecture RTL of PcCounterUnit is
	signal pc_next            : std32_st;
	signal pc_next_to_jmp_mux : std32_st;
	signal pc_plus_4          : std32_st;
	signal pc_next_branch     : std32_st;
	signal pc_next_jump       : std32_st;
	signal pc_current         : std32_st;
begin
	  
--	pc_plus_4 connects output of adder of 4 and output of d-ff and input of PC source Mux
	pc_plus_4      <= pc_current + 4;
	pc_next_jump   <= pc_plus_4(31 downto 28) & instr & "00";
	pc_next_branch <= (std32_st(unsigned(sign_imm) sll 2)) + pc_plus_4;

	pc_next_to_jmp_mux <= pc_next_branch when (pc_src = '1') else pc_plus_4;
	pc_next            <= pc_next_jump when (jump = '1') else pc_next_to_jmp_mux;
	
	pc  <= pc_current;

	pc_update : process(clk, rst) is
	begin
		if (clk'event and clk = '1') then
			pc_current <= pc_next;
		end if;
		if (rst = '1') then
--			pc_currect <= #16#BFC00000 -- this should be real reset value for pc couter 
			pc_current <= std32_zero_c;
		end if;
	end process pc_update;
end architecture RTL;
