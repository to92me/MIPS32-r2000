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
-- file         : alu_tb.vhd 
-- module       : alu_tb 
-- description  : alu test bench is small quick verification for alu design 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library modelsim_lib;
use modelsim_lib.util.all;
library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;
use STD.textio.all;
use work.Definitions_pkg.all;


entity Alu_ft_tb is
end entity Alu_ft_tb;

architecture Behavioral of Alu_ft_tb is
	component Alu_ft
		port(
			operand1  : in  std32_st;
			operand2  : in  std32_st;
			operation : in  AluOp_t;
			result    : out std32_st;
			zero      : out std_logic
		);
	end component Alu_ft;

	signal alu_operand1    : std32_st;
	signal alu_operand2    : std32_st;
	signal alu_operation   : AluOp_t;
	signal alu_result      : std32_st;
	--  signal alu_result64  : std32_st;
	signal alu_zero        : std_logic;
	constant wait_time     : time    := 2 ns;
	constant seed_array    : integer := 3;
	constant seed_operand1 : integer := 7;
	constant seed_operand2 : integer := 3;
	constant no_alu_operations :integer :=  13;
	
begin                                   -- architecture Behavioral

	Alu_ft_c : Alu_ft
		port map(
			operand1  => alu_operand1,
			operand2  => alu_operand2,
			operation => alu_operation,
			result    => alu_result,
			zero      => alu_zero);
	--------------------------------------------------------------
	-- DATA DRIVERS 
	--------------------------------------------------------------
	-- operands driver 
	--------------------------------------------------------------
	operands_driver : process is
		variable operand1 : integer;
		variable operand2 : integer;
	begin
		operand1 := 1;
		operand2 := 1;

		alu_operand1 <= std32_zero_c;
		alu_operand2 <= std32_zero_c;
		wait for (wait_time * 20);

		alu_operand1 <= std32_one_c;
		alu_operand2 <= std32_one_c;
		wait for (wait_time * 20);

		alu_operand1 <= std32_zero_c;
		alu_operand2 <= std32_one_c;
		wait for (wait_time * 20);

		alu_operand1 <= std32_one_c;
		alu_operand2 <= std32_zero_c;
		wait for (wait_time * 20);

		for i in 0 to 10000 loop
			operand1     := operand1 * seed_operand1;
			operand2     := operand2 * seed_operand2;
			alu_operand1 <= std32_st(to_unsigned(operand1, alu_operand1'length));
			alu_operand2 <= std32_st(to_unsigned(operand2, alu_operand2'length));
			wait for wait_time;
		end loop;
	end process operands_driver;

	--------------------------------------------------------------
	-- operation driver 
	--------------------------------------------------------------
	operation_driver : process is
		type AluOpA_t is array (0 to no_alu_operations-1) of AluOp_t;
		variable operation_a : AluOpA_t := (alu_or, alu_nor, alu_xor, alu_and, alu_add, alu_addu, alu_sub, alu_subu, alu_sllv, alu_srlv, alu_slt, alu_sltu, alu_slt);
		variable iterator    : integer;
	begin
		iterator := 1;
		for i in 0 to 100 loop
			alu_operation <= operation_a(iterator);
			iterator      := iterator + seed_array;
			if iterator > no_alu_operations-1 then
				iterator := iterator - no_alu_operations;
			end if;
			wait for wait_time;
		end loop;
	end process operation_driver;

	--------------------------------------------------------------
	-- DATA CHECKERS 
	--------------------------------------------------------------
	-- zero checker 
	--------------------------------------------------------------	
	zero_checker : process(alu_zero) is
	begin
		if (alu_operand1 = alu_operand2) then
			if (alu_zero = '1') then
			--				report "Zeko OK!"; 
			else
				report "Zero ERROR - should be 1";
			end if;
		else
			if (alu_zero = '0') then
			--				report "Zeko OK!"; 
			else
				report "Zero ERROR - should be 0";
			end if;
		end if;
	end process zero_checker;

	--------------------------------------------------------------
	-- result checker 
	--------------------------------------------------------------
	result_checker : process(alu_result) is
	begin
		case alu_operation is
			when alu_add =>
				if (signed(alu_result) = (signed(alu_operand1) + signed(alu_operand2))) then
				--					report "alu_add OK!";
				else
					report "alu_add ERROR!";
				end if;
			when alu_addu =>
				if (unsigned(alu_result) = (unsigned(alu_operand1) + unsigned(alu_operand2))) then
				--					report "alu_addu OK!";
				else
					report "alu_addu ERROR!";
				end if;
			when alu_div =>
				if (signed(alu_result) = (signed(alu_operand1) / signed(alu_operand2))) then
				--					report "alu_div OK!";
				else
					report "alu_div ERROR!";
				end if;
			when alu_divu =>
				if (unsigned(alu_result) = (unsigned(alu_operand1) / unsigned(alu_operand2))) then
				--					report "alu_divu OK!";
				else
					report "alu_divu ERROR!";
				end if;

			--						when alu_mult =>
			--				null;
			--			when alu_multu =>
			--				null;
			--			when alu_slt =>
			--				null;
			--			when alu_sltu =>
			--				null;
			when alu_sub =>
				if (signed(alu_result) = (signed(alu_operand1) - signed(alu_operand2))) then
				--					report "alu_sub OK!";
				else
					report "alu_sub ERROR!";
				end if;
			when alu_subu =>
				if (unsigned(alu_result) = (unsigned(alu_operand1) - unsigned(alu_operand2))) then
				--					report "alu_subu OK!";
				else
					report "alu_subu ERROR!";
				end if;
			--			when alu_clo =>
			--				null;
			--			when alu_clz =>
			--				null;
			--			when alu_madd =>
			--				null;
			--			when alu_maddu =>
			--				null;
			--			when alu_msub =>
			--				null;
			--			when alu_msubu =>
			--				null;
			--			when alu_mul =>
			--				null;
			when alu_and =>
				if (alu_result = (alu_operand1 and alu_operand2)) then
				--					report "alu_and OK!";
				else
					report "alu_and ERROR!";
				end if;
			when alu_xor =>
				if (alu_result = (alu_operand1 xor alu_operand2)) then
				--					report "alu_xor OK!";
				else
					report "alu_xor ERROR!";
				end if;
			when alu_nor =>
				if (alu_result = (alu_operand1 nor alu_operand2)) then
				--					report "alu_nor OK!";
				else
					report "alu_nor ERROR!";
				end if;
			when alu_or =>
				if (alu_result = (alu_operand1 or alu_operand2)) then
				--					report "alu_or OK!";
				else
					report "alu_or ERROR!";
				end if;
			when alu_sll =>
				if (unsigned(alu_result) = (unsigned(alu_operand1) sll to_integer(signed(alu_operand2)))) then
				--					report "alu_sll OK!";
				else
					report "alu_sll ERROR!";
				end if;
			--			when alu_sllv =>
			--				null;
			--			when alu_sra =>
			--				null;
			--			when alu_srav =>
			--				null;
			when alu_srl =>
				if (unsigned(alu_result) = (unsigned(alu_operand1) srl to_integer(unsigned(alu_operand2)))) then
				--					report "alu_srl OK!";
				else
					report "alu_srl ERROR!";
				end if;
			--			when alu_srlv =>
			--				null;
			--			when alu_not =>
			--				null;
			--			when alu_nop =>
			--				null;
			when others =>
				null;
		end case;
	end process result_checker;
	
	--------------------------------------------------------------
    -- FAULT TOLERANT  
    --------------------------------------------------------------
    -- signal forcer  
    --------------------------------------------------------------
    singnal_forcer : process is
    
    constant alu_path1 : String(1 to 27) := "/Alu_ft_tb/Alu_ft_c/Alu_c__";
    constant alu_path2 : String(1 to 8)  := "/alu_6c/";
    
    constant alu_part_result   : String(1 to 6) := "result";
    constant alu_part_operand1 : String(1 to 8) := "operand1";
    constant alu_part_operand2 : String(1 to 8) := "operand2";
    constant alu_part_zero     : String(1 to 4) := "zero";
    
    type AluFtPat_t is array (9 downto 0) of String(1 to 32);
	variable alu_ft_pat : AluFtPat_t := (std32_pat0_c, std32_pat1_c, std32_pat2_c, std32_pat3_c, std32_pat4_c, std32_pat5_c, std32_pat6_c, std32_pat7_c, std32_pat8_c, std32_pat9_c);
	
	variable iterator      : integer := 1;
	variable iterator_aluc : integer; 
	
	variable alu_path_operand1 	: String(1 to 44);
	variable alu_path_operand2 	: String(1 to 44);	
	variable alu_path_zero 		: String(1 to 40);
	variable alu_path_result 	: String(1 to 42);
	    
    begin
		
		--wait for (wait_time / 2);

		
		
		for i in 0 to 5 loop
			alu_path_operand1 := alu_path1 & integer'Image(i) & alu_path2 & alu_part_operand1; 
			alu_path_operand2 := alu_path1 & integer'Image(i) & alu_path2 & alu_part_operand2;
			alu_path_result   := alu_path1 & integer'Image(i) & alu_path2 & alu_part_result;
			alu_path_zero 	  := alu_path1 & integer'Image(i) & alu_path2 & alu_part_zero; 
			
			for j in 0 to 2 loop
			
				wait for (wait_time / 2); 
				
				if ( j = 0) then
					signal_force(alu_path_result, alu_ft_pat(iterator), 0 ns, freeze, wait_time,0);
				
				elsif ( j = 1) then
					signal_force(alu_path_zero, "1", 0 ns, freeze, wait_time,0);
				
				else 
					signal_force(alu_path_result, alu_ft_pat(iterator), 0 ns, freeze, wait_time,0);
					signal_force(alu_path_zero, "1", 0 ns, freeze, wait_time ,0);
				end if; 
				
				wait for (wait_time / 2); 
				
			end loop;
		end loop;
			
		iterator := iterator + seed_array;
		if iterator > 10-1 then
			iterator := iterator - 10;		
		end if;
		
      --wait for (wait_time /2);
      --signal_force("/Alu_ft_tb/Alu_ft_c/Alu_c__0/alu_6c/zero", "1", 0 ns, freeze, wait_time ,1);
      --wait for (wait_time /2);
      --wait for wait_time;    
    end process singnal_forcer;     	

end architecture Behavioral;


