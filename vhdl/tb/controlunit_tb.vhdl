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
-- file         : controlunit_tb.vhd 
-- module       : controlunit_ 
-- description  : controlunit_tb is test bench for quick unit level verification 
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

entity controlunit_tb is
end entity controlunit_tb;

architecture Behavioral of controlunit_tb is
	component ControlUnit
		port(
			opcode               : in  std6_st;
			register_write       : out std_logic;
			memory_write         : out std_logic;
			mem_to_reg           : out std_logic;
			register_destination : out std_logic;
			alu_operation        : out AluOp_t;
			alu_source           : out std_logic;
			branch               : out std_logic;
			jump                 : out std_logic
		);
	end component ControlUnit;

	signal cu_opcode               : std6_st;
	signal cu_register_write       : std_logic;
	signal cu_memory_write         : std_logic;
	signal cu_mem_to_reg           : std_logic;
	signal cu_register_destination : std_logic;
	signal cu_alu_operation        : AluOp_t;
	signal cu_alu_source           : std_logic;
	signal cu_branch               : std_logic;
	signal cu_jump				   : std_logic; 

	signal tmp_opcode  : std6_st;
	constant wait_time : time := 1 ns;

begin                                   -- architecture Behavioral 
	controlunit_c : ControlUnit
		port map(
			opcode               => cu_opcode,
			register_write       => cu_register_write,
			memory_write         => cu_memory_write,
			mem_to_reg           => cu_mem_to_reg,
			register_destination => cu_register_destination,
			alu_operation        => cu_alu_operation,
			alu_source           => cu_alu_source,
			branch               => cu_branch,
			jump				 => cu_jump);


	cu_opcode <= tmp_opcode;

--------------------------------------------------------------
-- DATA DRIVERS 
--------------------------------------------------------------
	opcode_driver : process is
	begin
		wait for wait_time;
		tmp_opcode <= special1_c;
		wait for wait_time;
		tmp_opcode <= ADDI_op_c;
		wait for wait_time;
		tmp_opcode <= special2_c;
		wait for wait_time;
		tmp_opcode <= ADDIU_op_c;
		wait for wait_time;
		tmp_opcode <= ANDI_op_c;
		wait for wait_time;
		tmp_opcode <= ORI_op_c;
		wait for wait_time;
		tmp_opcode <= XORI_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= BEQ_op_c;
		wait for wait_time;
		tmp_opcode <= J_op_c;
		wait for wait_time;
		
		
		wait for wait_time;
		tmp_opcode <= special1_c;
		wait for wait_time;
		tmp_opcode <= ADDI_op_c;
		wait for wait_time;
		tmp_opcode <= special2_c;
		wait for wait_time;
		tmp_opcode <= ADDIU_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= J_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		wait for wait_time;
		tmp_opcode <= LW_op_c;
		wait for wait_time;
		tmp_opcode <= SW_op_c;
		
		
	end process opcode_driver;

--------------------------------------------------------------
-- DATA CHECKERS 
--------------------------------------------------------------
-- Data path configuration checker 
--------------------------------------------------------------
	cu_data_paht_configuraton_checker : process (cu_alu_source, cu_branch, cu_mem_to_reg, cu_memory_write, cu_register_destination, cu_register_write) is 
	begin
		if(tmp_opcode = special1_c) or (tmp_opcode = special2_c) then 
			if( cu_register_destination = '1') and
			 (cu_register_write 		= '1') and 
			 (cu_alu_source 			= '0') and 
			 (cu_memory_write 			= '0') and 
			 (cu_mem_to_reg 			= '0') and 
			 (cu_branch		 			= '0') and 
			 (cu_jump 					= '0') then 
--			 	report "R instruction data path configuration OK!"; 
			else 
				report "R instruction data path ERROR!!!"; 
			end if;
		elsif (tmp_opcode = LB_op_c) or 
		(tmp_opcode = LBU_op_c) or 
		(tmp_opcode = LH_op_c) or 
		(tmp_opcode = LHU_op_c) or 
		(tmp_opcode = LW_op_c) or 
		(tmp_opcode = LL_op_c) or 
		(tmp_opcode = LUI_op_c) or 
		(tmp_opcode = LWL_op_c) or 
		(tmp_opcode = LW_op_c) then
			if( cu_register_destination = '0') and
			 (cu_register_write 		= '1') and 
			 (cu_alu_source 			= '1') and 
			 (cu_memory_write 			= '0') and 
			 (cu_mem_to_reg 			= '1') and 
			 (cu_branch 				= '0') and 
			 (cu_jump 					= '0') then 
--			 	report "Store instructions data path configuration OK!"; 
			else 
				report "Store instruction data path ERROR!!!"; 
			end if;
		elsif (tmp_opcode = SB_op_c) or 
		(tmp_opcode = SH_op_c) or 
		(tmp_opcode = SW_op_c) or 
		(tmp_opcode = SWL_op_c) or 
		(tmp_opcode = SWR_op_c) or 
		(tmp_opcode = SC_op_c) then
			if -- register_destinatino is not important, =X 
			 (cu_register_write 		= '0') and 
			 (cu_alu_source 			= '1') and 
			 (cu_memory_write 			= '1') and 
			   -- mem_to reg is not important, =X 
			 (cu_branch 				= '0') and 
			 (cu_jump 					= '0') then 
--			 	report "Load instructions data path configuration OK!"; 
			else 
				report "Load instruction data path ERROR!!!"; 
			end if;
		elsif (tmp_opcode = ADDI_op_c) or
		 (tmp_opcode = ADDIU_op_c) or
		 (tmp_opcode = SLTI_op_c) or
		 (tmp_opcode = ANDI_op_c) or
		 (tmp_opcode = ORI_op_c) or
		 (tmp_opcode = XORI_op_c) or    
		 (tmp_opcode = SLTIU_op_c) then
		 	if( cu_register_destination = '0') and
			 (cu_register_write 		= '1') and 
			 (cu_alu_source 			= '1') and 
			 (cu_memory_write 			= '0') and 
			 (cu_mem_to_reg 			= '0') and 
			 (cu_branch		 			= '0') and 
			 (cu_jump 					= '0') then 
--			 	report "Other I type instructions data path configuration OK!"; 
			else 
				report "Other I type instructions instruction data path ERROR!!!"; 
			end if;
		elsif(tmp_opcode = BEQ_op_c) then 
			if -- register destination is not important 
			 (cu_register_write 		= '0') and 
			 (cu_alu_source 			= '0') and 
			 (cu_memory_write 			= '0') and 
			 -- mem_to_reg is not important  
			 (cu_branch		 			= '1') and 
			 (cu_jump 					= '0') then 
--			 	report "R instruction data path configuration OK!"; 
			else 
				report "R instruction data path ERROR!!!"; 
			end if;
		elsif(tmp_opcode = J_op_c) then 
			if -- register destination is not important 
			 (cu_register_write 		= '0') and 
			 -- alu_source is not important 
			 (cu_memory_write 			= '0') and 
			 -- mem_to_reg is not important  
			 -- branch is not important because at PC if jump si active next address is jump address ( 
			 -- 	branch mux is in front of jump mux so finale word has jump) 
			 (cu_jump 					= '1') then 
--			 	report "R instruction data path configuration OK!"; 
			else 
				report "R instruction data path ERROR!!!"; 
			end if;
		elsif(tmp_opcode = "UUUUUU") then 
			report "starting simulation opcode is UUUUUU"; 
		else
			report "Got unexpected OPCODE!!! data path case "; 
		end if; 
	end process cu_data_paht_configuraton_checker;
	
--------------------------------------------------------------
-- Alu operation checker 
--------------------------------------------------------------
	alu_operation_checker : process (cu_alu_operation) is
	begin
	case tmp_opcode is 
		when special1_c  =>  
			if(cu_alu_operation = alu_special1) then 
--				report "alu_special1 operation OK!";
			else 
				report "alu_special1 operation ERROR"; 
			end if; 
			
		when special2_c  => 
			if(cu_alu_operation = alu_special2) then 
--				report "alu_special2 operation OK!";
			else 
				report "alu_special2 operation ERROR"; 
			end if;
			
		when ADDI_op_c  => 
			if(cu_alu_operation = alu_add) then 
--				report "ADDI_op_c operation OK!";
			else 
				report "ADDI_op_c operation ERROR"; 
			end if;
			
		when ADDIU_op_c  =>
			if(cu_alu_operation = alu_addu) then 
--				report "ADDIU_op_c operation OK!";
			else 
				report "ADDIU_op_c operation ERROR"; 
			end if;
			
		when ANDI_op_c  => 
			if(cu_alu_operation = alu_and) then 
--				report "ANDI_op_c operation OK!";
			else 
				report "ANDI_op_c operation ERROR"; 
			end if;
			
		when ORI_op_c  => 
			if(cu_alu_operation = alu_or) then 
--				report "ORI_op_c operation OK!";
			else 
				report "ORI_op_c operation ERROR"; 
			end if;
			
		when XORI_op_c  => 
			if(cu_alu_operation = alu_xor) then 
--				report "XORI_op_c operation OK!";
			else 
				report "XORI_op_c operation ERROR"; 
			end if;
		
		when SW_op_c  => 
			if(cu_alu_operation = alu_add) then 
--				report "SW_op_c operation OK!";
			else 
				report "SW_op_c operation ERROR"; 
			end if;
		when LW_op_c  => 
			if(cu_alu_operation = alu_add) then 
--				report "LW_op_c operation OK!";
			else 
				report "LW_op_c operation ERROR"; 
			end if;
		when BEQ_op_c  => 
			if(cu_alu_operation = alu_nop) then 
--				report "BEQ_op_c operation OK!";
			else 
				report "BEQ_op_c operation ERROR"; 
			end if;
		when J_op_c  =>  
			if(cu_alu_operation = alu_nop) then 
--				report "J_op_c operation OK!";
			else 
				report "J_op_c operation ERROR"; 
			end if;
		when "UUUUUU" => 
			report "Starting simulation opcode is UUUUU"; 
		when others  =>  
			report "Got unexpected OPCODE!!!"; 
	end case; 
	end process alu_operation_checker;
end architecture Behavioral;
