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

	signal check_pc       : std32_st;
	signal check_jump     : std32_st;
	signal check_branch   : std32_st;
	signal check_pc_plus4 : std32_st;
	signal check_pc_to_jump_mux : std32_st;
	signal check_pc_next  : std32_st;  

	constant seed_array_size : integer := 10;
	type seed_array_t is array (0 to seed_array_size - 1) of integer;
	signal seed_array           : seed_array_t := (2, 31, 3, 5, 7, 1, 426, 57268, 27, 200);
	shared variable seed_choser : integer;
	signal seed                 : integer;

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

	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- "random generator"
	--------------------------------------------------------------	
	seed_generator : process is
	begin
		seed_choser := 1;
		for i in 0 to 1000 loop
			seed_choser := seed_choser + (i mod seed_array_size);
			seed        <= seed_array(seed_choser mod seed_array_size);
			wait for 50 ns;
		end loop;
	end process seed_generator;

	instruction_generator : process is
		variable c_instr_v : std26_st;
	begin
		c_instr_v := std_logic_vector(to_unsigned(1, c_instr_v'length));
		for i in 0 to 1000 loop
			c_instr_v := std_logic_vector(unsigned(c_instr_v) + to_unsigned(seed, c_instr_v'length));
			c_instr   <= c_instr_v;
			wait for 10 ns;
		end loop;
	end process instruction_generator;

	c_sign_imm_generator : process is
		variable c_sign_imm_v : std32_st;
	begin
		c_sign_imm_v := std_logic_vector(to_unsigned(1, c_sign_imm_v'length));
		for i in 0 to 1000 loop
			c_sign_imm_v := std_logic_vector(unsigned(c_sign_imm_v) + to_unsigned(seed, c_sign_imm_v'length));
			c_sign_imm   <= c_sign_imm_v;
			wait for 10 ns;
		end loop;
	end process c_sign_imm_generator;

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

	check_pc_plus4 <= std32_st(unsigned(check_pc) + 4);
	check_jump     <= check_pc_plus4(31 downto 28) & (std28_st(unsigned(c_instr) & "00"));
	check_branch   <= (std32_st(unsigned(c_sign_imm) sll 2)) + check_pc_plus4;
	
	check_pc_to_jump_mux <= check_branch when (c_pc_src = '1') else check_pc_plus4;
	check_pc_next <= check_jump when (c_jump = '1') else check_pc_to_jump_mux;

	pc_out_checker : process(c_pc, c_clk, c_rst) is
	begin
		if (c_rst = '1') then
			check_pc <= x"00000000";

		elsif (rising_edge(c_clk)) then
			check_pc <= check_pc_next;
		else
			if (check_pc = c_pc) then
--				report "OK";
			else
				report "ERROR";
			end if;
		end if;

	end process pc_out_checker;

end architecture RTL;
