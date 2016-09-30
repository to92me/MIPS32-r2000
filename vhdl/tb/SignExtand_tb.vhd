-------------------------------------------------------------------------------
--                           CPU 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.definitions_pkg.all;

entity SignExtand_tb is
end entity SignExtand_tb;

architecture RTL of SignExtand_tb is
	component SignExtand
		port(
			in_s16  : in  std16_st;
			out_s32 : out std32_st
		);
	end component SignExtand;

	signal se_in_s16  : std16_st;
	signal se_out_s32 : std32_st;

begin
	SignExtand_c : SignExtand
		port map(
			in_s16  => se_in_s16,
			out_s32 => se_out_s32
		);

	input_generator : process is
		variable i   : integer;
		variable tmp : std_logic;
	begin
		tmp := '0';
		for i in 0 to 1000 loop
			tmp := tmp xor '1';

			if (tmp = '0') then
				se_in_s16 <= std_logic_vector(to_signed((i * 32), se_in_s16'length));
			else
				se_in_s16 <= std_logic_vector(to_signed((i * (-32)), se_in_s16'length));
			end if;

			wait for 1 ns;

			if (tmp = '0') then
				if (se_out_s32 = std_logic_vector(to_signed((i * 32), se_out_s32'length))) then
				-- it is ok 
				else
					report "Positive number error";
				end if;
			else
				if (se_out_s32 = std_logic_vector(to_signed((i * (-32)), se_out_s32'length))) then
--					report "negative number OK";
				-- it is ok 
				else
					report "negative number error";
				end if;
			end if;
			wait for 10 ns;

		end loop;
	end process input_generator;

end architecture RTL;
