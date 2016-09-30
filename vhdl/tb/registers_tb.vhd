-------------------------------------------------------------------------------
--
--                          GP REGISTGERS TESTBENCH 
--
-------------------------------------------------------------------------------
-- 
-- Company: FTN
-- Engineer: Tomislav Tumbas
-- email: to92me@gmail.com
--
-------------------------------------------------------------------------------
--
-- Design Name: registers testbench 
-- Module Name: registers_tb - Behavioral
-- Project Name: MIPS32 RRISC ( reduced reduced instruction set )
-- Target Devices: xc7z030fbg676-3 (active)
-- Tool Versions: Xilinx Vivado 2014.3.1
-- Description:
--      Testbecnch for quick partially testing component 
--     
--
-------------------------------------------------------------------------------
--
-- Erros and comments by developer:
--      
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
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity registers_tb is
end entity registers_tb;

architecture behavioral of registers_tb is
	type register_t_arr is array (0 to 31) of std32_st; -- register is array of 32 "registers" = subtype std32_t
	-- instance of registers component 
	component registers is
		port(
			clk     : in  std_logic;
			rst     : in  std_logic;
			rdAddr1 : in  std_logic_vector(4 downto 0);
			rdAddr2 : in  std_logic_vector(4 downto 0);
			rdData1 : out std32_st;
			rdData2 : out std_logic_vector(31 downto 0);
			wrAddr  : in  std_logic_vector(4 downto 0);
			wrData  : in  std_logic_vector(31 downto 0);
			wr      : in  std_logic);
	end component registers;

	-- signals for wireing component and simulation 
	signal reg_rdAddr1  : std_logic_vector(4 downto 0);
	signal reg_rdAddr2  : std_logic_vector(4 downto 0);
	signal reg_wrAddr   : std_logic_vector(4 downto 0);
	signal reg_rdData1  : std_logic_vector(31 downto 0);
	signal reg_rdData2  : std_logic_vector(31 downto 0);
	signal reg_wrData   : std_logic_vector(31 downto 0);
	signal reg_wr       : std_logic;
	signal clk          : std_logic;
	signal rst          : std_logic;
	constant clk_period : time      := 10 ns; -- constant for clock period 
	signal registers_v  : register_t_arr;

begin                                   -- architecture behavioral

	registers_c : registers
		port map(
			clk     => clk,
			rst     => rst,
			rdAddr1 => reg_rdAddr1,
			rdAddr2 => reg_rdAddr2,
			rdData1 => reg_rdData1,
			rdData2 => reg_rdData2,
			wrAddr  => reg_wrAddr,
			wrData  => reg_wrData,
			wr      => reg_wr);

	-- purpose: generating clock signal
	-- type   : combinational 
	clk_generator : process is
	begin                               -- process clk_process
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process clk_generator;

	rst_generator : process is
		variable i : integer;
	begin
		rst <= '0';
		wait for clk_period / 10; 
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		wait;
	end process rst_generator;

	wr_generator : process is
	begin
		reg_wr <= '0';
		wait for clk_period / 5;
		reg_wr <= '1';
		wait for 200 ns;
		reg_wr <= '0';
		wait for 200 ns;
		reg_wr <= '1';
		wait for 200 ns;
		reg_wr <= '0';
		wait for 200 ns;
		reg_wr <= '1';
	end process wr_generator;

	register_data_generator : process is
		--		variable tmp : std_logic_vector(31 downto 0); -- for results;
		--		variable L : line;
		variable i, j : integer;
	begin                               -- process simulation_process
		for i in 0 to 31 loop
			wait until clk'event and clk = '1';
			wait for clk_period / 5;
			reg_wrAddr <= std_logic_vector(to_unsigned(i, reg_wrAddr'length));
			reg_wrData <= std_logic_vector(to_unsigned((1000 * i), reg_wrData'length));
		end loop;
	end process register_data_generator;

	register_data_storer : process(clk,rst) is
	begin
		if rst = '1' then               -- asynchrony reset active at high
			for j in 0 to 31 loop
--				report "RESET";       -- if reseted all registers are set to "00..000"
				registers_v(j) <= std32_zero_c;
			end loop;
		elsif (rising_edge(clk) and reg_wr = '1') then
			registers_v(to_integer(unsigned(reg_wrAddr))) <= reg_wrData;
		end if;
	end process register_data_storer;


	data_checker : process is
		variable k : integer;
	begin
		for k in 0 to 30 loop
			reg_rdAddr1 <= std_logic_vector(to_unsigned(k, reg_rdAddr1'length));
			reg_rdAddr2 <= std_logic_vector(to_unsigned((k + 1), reg_rdAddr1'length));
			wait for clk_period / 10;
			if (registers_v(k) = reg_rdData1) then
			--				report "Reg OK" severity note;
			else
				report "Reg read ERROR";
			end if;

			if (registers_v((k + 1)) = reg_rdData2) then
			--				report "Reg OK" severity note;
			else
				report "Reg read ERROR";
			end if;

		end loop;
	end process data_checker;

end architecture behavioral;
