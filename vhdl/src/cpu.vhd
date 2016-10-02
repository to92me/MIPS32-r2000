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
-- 
-- file			: cpu.vhd 
-- module		: CPU  
-- description	: CPU is top module of design. It contains instances of components: 
-- 				- Registers
--				- ControlUnit
--				- AluControlUnit 
-- 				- Alu (Arithmetic logic unit ) 
--				- PCunit ( ProgramCounterUnit ) 
--				- SignExtand 
--
-------------------------------------------------------------------------------
-- todo			: 
-------------------------------------------------------------------------------
-- comments		: 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;





entity cpu is
	port(
		clk        : in  std_logic;     
		rst        : in  std_logic;     
		debug      : in  std_logic;     
		-- rom interface 
		rom_addr   : out std32_st;
		rom_data   : in  std32_st;
--		rom_rst    : out std_logic; 
		-- memory interface 
		mem_we     : out std_logic;
		mem_rdData : in  std32_st;
		mem_addr   : out std32_st;
		mem_wrData : out std32_st
	);
end entity cpu;


architecture behavioral of cpu is

	component registers
		port(
			clk     : in  std_logic;
			rst     : in  std_logic;
			rdAddr1 : in  std_logic_vector(4 downto 0);
			rdAddr2 : in  std_logic_vector(4 downto 0);
			rdData1 : out std_logic_vector(31 downto 0);
			rdData2 : out std_logic_vector(31 downto 0);
			wrAddr  : in  std_logic_vector(4 downto 0);
			wrData  : in  std32_st;
			wr      : in  std_logic
		);
	end component registers;

	component AluControlUnit is
		port(
			cu_operation : in  AluOp_t;
			func         : in  std6_st;
			operation    : out AluOp_t);
	end component AluControlUnit;

	component alu is
		port(
			operand1  : in  std32_st;
			operand2  : in  std32_st;
			operation : in  AluOp_t;
			result    : out std32_st;
--			result64  : out std32_st;
			zero 	  : out std_logic);
	end component alu;
		
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

	component PcCounterUnit
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

	component SignExtand
		port(
			in_s16  : in  std16_st;
			out_s32 : out std32_st
		);
	end component SignExtand;


	-- GP registers  
	signal reg_rdAddr1 : std5_st;
	signal reg_rdAddr2 : std5_st;
	signal reg_wrAddr  : std5_st;
	signal reg_rdData1 : std32_st;
	signal reg_rdData2 : std32_st;
	signal reg_wrData  : std32_st;
	signal reg_wr      : std_logic;

	-- alu control unit
	signal alucu_cu_operation : AluOp_t;
	signal alucu_func         : std6_st;
	signal alucu_operation    : AluOp_t;

	--alu unit
	signal alu_operand1  : std32_st;
	signal alu_operand2  : std32_st;
	signal alu_result    : std32_st;
--	signal alu_result64  : std64_st;
	signal alu_operation : AluOp_t;
	signal alu_zero 	 : std_logic; 

	--control unit 
	signal cu_opcode                : std6_st;
	signal cu_register_write        : std_logic;
	signal cu_memory_write          : std_logic;
	signal cu_mem_to_reg            : std_logic;
	signal cu_register_destination  : std_logic;
	signal cu_alu_operation         : AluOp_t;
	signal cu_alu_source            : std_logic;
	signal cu_jump 					: std_logic;
	signal cu_branch 				: std_logic; 

	--PCUnit
	signal pcu_pc       : std32_st;
	signal pcu_pc_src   : std_logic;
	signal pcu_jump     : std_logic;
	signal pcu_sign_imm : std32_st;
	signal pcu_instr    : std26_st;

	--SignExtend 
	signal se_in_s16  : std16_st;
	signal se_out_s32 : std32_st;

	signal instruction : std32_st;

	--instruction parts 
	alias opcode_a    : std6_st is instruction(31 downto 26);
	alias rs_a        : std5_st is instruction(25 downto 21);
	alias rt_a        : std5_st is instruction(20 downto 16);
	alias rd_a        : std5_st is instruction(15 downto 11);
	alias sa_a        : std5_st is instruction(10 downto 6);
	alias func_a      : std6_st is instruction(5 downto 0);
	alias ins_index_a : std26_st is instruction(25 downto 0);
	alias imm_a       : std16_st is instruction(15 downto 0);


begin                
	register_c : registers
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

	alucontrolunit_c : AluControlUnit
		port map(
			cu_operation => alucu_cu_operation,
			func         => alucu_func,
			operation    => alucu_operation);

	alu_c : alu
		port map(
			operand1  => alu_operand1,
			operand2  => alu_operand2,
			result    => alu_result,
--			result64  => alu_result64,
			operation => alu_operation,
			zero      => alu_zero);

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
			jump                 => cu_jump
		);

	PcCounterUnit_c : PcCounterUnit
		port map(
			clk      => clk,
			rst      => rst,
			pc       => pcu_pc,
			pc_src   => pcu_pc_src,
			jump     => pcu_jump,
			sign_imm => pcu_sign_imm,
			instr    => pcu_instr
		);
		
	SignExtand_c : SignExtand port map(
		in_s16  => se_in_s16,
		out_s32 => se_out_s32
	); 
	
	-- MUX-es 
	alu_operand2  <= reg_rdData2 when ( cu_alu_source = '0' ) else se_out_s32; 
	reg_wrData  <=  alu_result when ( cu_mem_to_reg = '0') else mem_rdData; 
	reg_wrAddr  <=   rt_a when ( cu_register_destination = '0' ) else rd_a;  
	
	-- AND gate 
	pcu_pc_src   <= alu_zero and cu_branch; 
	
	-- connections of memory interface and components 
	mem_we  <=  cu_memory_write;
	mem_wrData  <=  reg_rdData2; 
	mem_addr	 <=  alu_result; 
	 
	-- connections of rom interface and components 
	rom_addr  <=  pcu_pc; 
	instruction  <= rom_data;
	
	--internal connections 
	
	-- Register inputs 
	reg_rdAddr1  <=  rs_a; 
	reg_rdAddr2  <=  rt_a;
	reg_wr  <=  cu_register_write; 
	-- reg_wrAddr and reg_wrData wired in mux-es section  
	  
	--AluControlUnit inputs
	alucu_cu_operation  <= cu_alu_operation; 
	alucu_func  <= func_a; 
	
	--Alu inputs
	alu_operand1  <=  reg_rdData1; 
	--alu_operand2 wired in mux-es section
	alu_operation  <= alucu_operation; 
	
	--ControlUnit inputs
	cu_opcode  <=  opcode_a;
	
	--PCunit inputs
	-- pcu_pc_src wired in and section 
	pcu_jump   <=  cu_jump; 
	pcu_sign_imm  <= se_out_s32; 
	pcu_instr  <=  ins_index_a;
	
	--sign extend unit inputs 
	se_in_s16  <= imm_a;   
	 
	
	

end architecture behavioral;
