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
