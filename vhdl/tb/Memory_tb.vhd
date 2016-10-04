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


library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity Memory_tb is
end entity Memory_tb;

architecture behavioral of Memory_tb is
	type memory_t_arr is array (0 to 2 ** 14 - 1) of std32_st;

	component memory
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			we     : in  std_logic;
			rdData : out std32_st;
			addr   : in  std32_st;
			wrData : in  std32_st
		);
	end component memory;

	signal clk        : std_logic;
	signal rst        : std_logic;
	signal mem_we     : std_logic;
	signal mem_rdData : std32_st;
	signal mem_addr   : std32_st;
	signal mem_wrData : std32_st;

	signal memory_v : memory_t_arr;

	constant clk_period : time := 0.1 ns;

	signal temp_data : std32_st;
begin
	Memory_c : Memory port map(
			clk    => clk,
			rst    => rst,
			we     => mem_we,
			rdData => mem_rdData,
			addr   => mem_addr,
			wrData => mem_wrData
		);

	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- clock driver 
	--------------------------------------------------------------	
	clk_generator : process is
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process clk_generator;

	--------------------------------------------------------------
	-- reset driver 
	--------------------------------------------------------------	
	rst_generator : process is
		variable i : integer;
	begin
		rst <= '0';
		wait for clk_period / 20;
		rst <= '1';
		wait for clk_period / 20;
		rst <= '0';
		wait;
	end process rst_generator;

	--------------------------------------------------------------
	-- write enable driver 
	--------------------------------------------------------------
	wr_generator : process is
	begin
		mem_we <= '0';
		wait for clk_period;
		mem_we <= '1';
		wait for 200 ns;
		mem_we <= '0';
		wait for 200 ns;
		mem_we <= '1';
		wait for 200 ns;
		mem_we <= '0';
		wait for 200 ns;
		mem_we <= '1';
	end process wr_generator;
	
	
	--------------------------------------------------------------
	-- data driver 
	--------------------------------------------------------------
	register_data_generator : process is
		--		variable tmp : std_logic_vector(31 downto 0); -- for results;
		--		variable L : line;
		variable i, j : integer;
	begin
		mem_addr   <= std32_zero_c;
		mem_wrData <= std32_zero_c;
		for i in 0 to 2 ** 14 - 1 loop
			wait until clk'event and clk = '1';
			--			wait for clk_period / 5;
			mem_addr <= std_logic_vector(to_unsigned(i, mem_addr'length));
			wait for 1 ns;
			if (mem_we = '1') then
				mem_wrData <= std_logic_vector(to_unsigned((1000 * i), mem_wrData'length));
			else
				wait for clk_period / 5;
				temp_data <= memory_v(i);
				--				if (temp_data = mem_rdData) then
				if (memory_v(i) = mem_rdData) then
				else
					report "Reg read ERROR, internal mem data: ";
				end if;
			end if;
		end loop;
	end process register_data_generator;

	--------------------------------------------------------------
	-- DATA CHECKERS 
	--------------------------------------------------------------
	-- data storing in internal memory for checking 
	--------------------------------------------------------------
	register_data_storer : process(clk, rst) is
	begin
		if rst = '1' then               -- asynchrony reset active at high
			for j in 0 to 2 ** 14 - 1 loop
				memory_v(j) <= std32_zero_c;
			end loop;
		elsif (rising_edge(clk) and mem_we = '1') then
			memory_v(to_integer(unsigned(mem_addr))) <= mem_wrData;
		end if;
	end process register_data_storer;

end architecture behavioral;