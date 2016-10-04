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

entity PcUnit_tb is
end entity PcUnit_tb;

architecture RTL of PcUnit_tb is
	component PcUnit is
		port(
			clk      : in  std_logic;
			rst      : in  std_logic;
			pc       : out std32_st;
			pc_src   : in  std_logic;
			jump     : in  std_logic;
			sign_imm : in  std32_st;
			instr    : in  std26_st
		);
	end component PcUnit;

	signal c_clk      : std_logic;
	signal c_rst      : std_logic;
	signal c_pc       : std32_st;
	signal c_pc_src   : std_logic;
	signal c_jump     : std_logic;
	signal c_sign_imm : std32_st;
	signal c_instr    : std26_st;

	signal rand_num     : integer := 0;
	--	signal pc_plus_4: std32_st; 
	signal tmp          : std32_st;
	signal check_jump   : std32_st;
	signal check_branch : std32_st;

begin
	PcUnit_c : PcUnit
		port map(
			clk      => c_clk,
			rst      => c_rst,
			pc       => c_pc,
			pc_src   => c_pc_src,
			jump     => c_jump,
			sign_imm => c_sign_imm,
			instr    => c_instr
		);

	c_instr    <= "11111111111111111111111111";
	c_sign_imm <= "00000000111100001111000011111111";

	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- clock driver 
	--------------------------------------------------------------	

	clk_generator : process is
	begin
		c_clk <= '0';
		wait for 10 ns;
		c_clk <= '1';
		wait for 10 ns;
	end process clk_generator;

	--------------------------------------------------------------
	-- reset driver 
	--------------------------------------------------------------
	rst_generator : process is
	begin
		c_rst <= '1';
		wait for 10 ns;
		c_rst <= '0';
		wait;
	end process rst_generator;

	--------------------------------------------------------------
	-- jump driver 
	--------------------------------------------------------------
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

	--------------------------------------------------------------
	-- pc src - branch driver 
	--------------------------------------------------------------
	pc_src_generator : process is
	begin
		--		c_sign_imm  <= std32_one_c; 
		c_pc_src <= '0';
		wait for 522 ns;
		c_pc_src <= '1';
		wait for 40 ns;
		c_pc_src <= '0';
	end process pc_src_generator;

	--------------------------------------------------------------
	-- DATA CHECKERS 
	--------------------------------------------------------------
	-- pc out checker 
	--------------------------------------------------------------
	pc_out_checker : process(c_clk, c_rst) is
		variable L         : line;
		variable pc_plus_4 : std32_st;
	begin
		if (c_rst = '1') then
			pc_plus_4 := std32_zero_c;
			tmp       <= pc_plus_4;
		end if;

		if (c_clk'event and c_clk = '1') then
			--			wait for 1 ns; 
			tmp        <= pc_plus_4;
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
			tmp       <= pc_plus_4;
		end if;

	end process pc_out_checker;

end architecture RTL;
