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
use STD.textio.all;
use ieee.std_logic_unsigned.all;
use work.definitions_pkg.all;

entity PcCounterUnit_tb is
end entity PcCounterUnit_tb;

architecture RTL of PcCounterUnit_tb is
	component PcCounterUnit is
		port(
			clk      : in  std_logic;
			rst      : in  std_logic;
			pc       : out std32_st;
			pc_src   : in  std_logic;
			jump     : in  std_logic;
			sign_imm : in  std32_st;
			instr    : in  std26_st
		);
	end component PcCounterUnit;

	signal c_clk      : std_logic;
	signal c_rst      : std_logic;
	signal c_pc       : std32_st;
	signal c_pc_src   : std_logic;
	signal c_jump     : std_logic;
	signal c_sign_imm : std32_st;
	signal c_instr    : std26_st ;

	signal rand_num : integer := 0;
	--	signal pc_plus_4: std32_st; 
	signal tmp      : std32_st;
	signal check_jump :std32_st; 
	signal check_branch :std32_st; 

begin
	PcCounterUnit_c : PcCounterUnit
		port map(
			clk      => c_clk,
			rst      => c_rst,
			pc       => c_pc,
			pc_src   => c_pc_src,
			jump     => c_jump,
			sign_imm => c_sign_imm,
			instr    => c_instr
		);

	--	c_instr    <= std32_zero_c;
	--	c_sign_imm <= std32_zero_c;
	c_instr    <= "11111111111111111111111111";
	c_sign_imm <= "00000000111100001111000011111111";

	clk_generator : process is
	begin
		c_clk <= '0';
		wait for 10 ns;
		c_clk <= '1';
		wait for 10 ns;
	end process clk_generator;

	rst_generator : process is
	begin
		c_rst <= '1';
		wait for 10 ns;
		c_rst <= '0';
		wait;
	end process rst_generator;

	-- idiotic xilix. . . . 
	--	jmp_generator : process is
	--		variable seed1, seed2  : positive; -- seed values for random generator
	--		variable rand          : real;  -- random real-number value in range 0 to 1.0  
	--		variable range_of_rand_big : real := 1000.0; -- the range of random values created will be 0 to +1000.
	--		variable range_of_rand_small : real := 100.0;
	--	begin
	--		UNIFORM(seed1, seed2, rand);    -- generate random number
	--		rand_num <= integer(rand * range_of_rand_big); -- rescale to 0..1000, convert integer part 
	--		wait for rand_num * 1ns;
	--		c_jump  <= '1'; 
	--		rand_num <= integer(rand * range_of_rand_small); -- rescale to 0..1000, convert integer part 
	--		wait for rand_num * 1ns; 
	--		c_jump  <= '0'; 
	--	end process jmp_generator;

	--	init : process is
	--	begin
	--		c_pc  <=  std32_zero_c; 
	--		wait; 
	--	end process init;

	jump_generator : process is
	begin
		--		c_instr  <= std32_one_c;
		c_jump <= '0';
		wait for 252 ns;
		c_jump <= '1';
		wait for 30 ns;
		c_jump <= '0';
		wait; 
	end process jump_generator;

	pc_src_generator : process is
	begin
		--		c_sign_imm  <= std32_one_c; 
		c_pc_src <= '0';
		wait for 522 ns;
		c_pc_src <= '1';
		wait for 40 ns;
		c_pc_src <= '0';
	end process pc_src_generator;

	pc_out_checker : process(c_clk, c_rst) is
		variable L         : line;
		variable pc_plus_4 : std32_st;
	begin
--		tmp <= pc_plus_4;
		--		wait for 2ns; 


		if (c_rst = '1') then
			pc_plus_4 := std32_zero_c;
			tmp <= pc_plus_4;
		end if;

		if (c_clk'event and c_clk = '1') then
--			wait for 1 ns; 
		    tmp <= pc_plus_4;
		     check_jump <= pc_plus_4(31 downto 28) & (std28_st(unsigned(c_instr) sll 2));
			if (c_jump = '1') then
				if (c_pc = pc_plus_4(31 downto 28) & (std28_st(unsigned(c_instr) sll 2))) then
					write(L, time'IMAGE(now));
					write(L, string'("Jump OK!"));
					writeline(output, L);
				else
				    check_jump <= pc_plus_4(31 downto 28) & (std28_st(unsigned(c_instr) sll 2)); 
					write(L, time'IMAGE(now)); 
					write(L, string'("Jump ERROR!"));
----					write(L, std32_st(pc_plus_4(31 downto 28) & (std28_st(unsigned(c_instr(25 downto 0)) sll 2)))); 
----					write(L, c_pc);
--                    report "expected " & integer'image(to_integer(unsigned(pc_plus_4(31 downto 28) & (std28_st(unsigned(c_instr(25 downto 0)) sll 2))))); 
--					report "got " & integer'image(to_integer(unsigned(c_pc)));
					writeline(output, L);
				end if;
			else
				if (c_pc_src = '1') then
				check_branch <= (std32_st(unsigned(c_sign_imm) sll 2)) + pc_plus_4; 
					if (c_pc = (std32_st(unsigned(c_sign_imm) sll 2)) + pc_plus_4) then
						write(L, time'IMAGE(now));
						write(L, string'("Branch OK!"));
						writeline(output, L);
					else
					    check_branch <= (std32_st(unsigned(c_sign_imm) sll 2)) + pc_plus_4; 
						write(L, time'IMAGE(now));
						write(L, string'("Branch ERROR!"));
						writeline(output, L);
					end if;
				else
					if (c_pc = pc_plus_4) then
						write(L, time'IMAGE(now));
						write(L, string'("PC+4 OK!"));
						writeline(output, L);
					else
						write(L, time'IMAGE(now));
						write(L, string'("PC+4 ERROR!"));
						writeline(output, L);
					end if;
				end if;
			end if;

			pc_plus_4 := c_pc + 4;
			tmp <= pc_plus_4;
		end if;

	end process pc_out_checker;

end architecture RTL;
