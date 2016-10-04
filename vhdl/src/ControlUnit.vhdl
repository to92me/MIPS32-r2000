-------------------------------------------------------------------------------
--                           CONTROL UNIT 
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
-- file         : controlunit.vhd
-- module       : ControlUnit
-- description  : ControlUnit decodes instruction got from ROM. With information
--				  from opcode this unit adjusts data path. Adjusting of data 
--				  path is done by generating output signals that will configure 
--				  MUX-es in cpu.
--
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

entity ControlUnit is
	port(
		opcode               : in  std6_st;
		register_write       : out std_logic; -- enables write to register 
		memory_write         : out std_logic; -- enables write to memory 
		mem_to_reg           : out std_logic; -- controls MUX after memory. Chose if data to registers is from ALu or from memory 
		register_destination : out std_logic; -- controls MUX in front of register write address.  if it's 1: Rs part of instruction is wrAddr (I type),  if 0: Rt part of instruction is wrAddr (R type)  
		alu_operation        : out AluOp_t;	  -- decoded opcode for ALU control unit 
		alu_source           : out std_logic; -- MUX in front of ALU  -- if it's 0: operand2 is from register : operand2 is from instruction 
		branch               : out std_logic; -- controls PC. Will it jump to branch address or on standard next +4 address	
		jump                 : out std_logic); -- controls PC. Will it jump on jump address or on standard next +4 address  

end entity ControlUnit;

architecture Behavioral of ControlUnit is
	constant data_path_conf_pack_R_type : std_logic_vector(6 downto 0) 		:= "1100000"; 
	constant data_path_conf_pack_Load   : std_logic_vector(6 downto 0) 		:= "0110100"; 
	constant data_path_conf_pack_Store  : std_logic_vector(6 downto 0) 		:= "0011000";
	constant data_path_conf_pack_othI_type: std_logic_vector (6 downto 0)	:= "0110000"; 
	constant data_path_conf_pack_Branch : std_logic_vector(6 downto 0) 		:= "0000010";
	constant data_path_conf_pack_Jump : std_logic_vector(6 downto 0) 		:= "0000001"; 
	constant data_path_conf_pack_other : std_logic_vector(6 downto 0)		:= "0000000"; 
	
	--one 7 bit vector for all outputs of configuration data path.Each bit in vector represents 
	--one configuration signal
	--This way all configuration sets will be stored in ROM. 
	signal data_path_conf :std_logic_vector(6 downto 0); 
	

	alias data_path_conf_register_destination is data_path_conf(6); 
	alias data_path_conf_register_write is data_path_conf(5); 
	alias data_path_conf_alu_source is data_path_conf(4); 
	alias data_path_conf_memory_write is data_path_conf(3);
	alias data_path_conf_mem_to_reg is data_path_conf(2);  
	alias data_path_conf_branch is data_path_conf(1); 
	alias data_path_conf_jump is data_path_conf(0); 
begin
	
	register_destination  <=  data_path_conf_register_destination; 
	register_write  <= data_path_conf_register_write;
	alu_source  <= data_path_conf_alu_source;
	memory_write  <=  data_path_conf_memory_write; 
	mem_to_reg  <=  data_path_conf_mem_to_reg;
	branch  <= data_path_conf_branch;
	jump  <= data_path_conf_jump; 
	
	with opcode select data_path_conf   <= 
		--configure data path for R type of instructions
		data_path_conf_pack_R_type when special1_c,
		data_path_conf_pack_R_type when special2_c,
		
		-- configure data path for Load instructions 
		data_path_conf_pack_Load when LW_op_c,
		-- configure data path for Store instructions
		data_path_conf_pack_Store when SW_op_c, 
		
		-- configure data path for I type instructions except Load and Store instructions 
		data_path_conf_pack_othI_type when ADDI_op_c,
		data_path_conf_pack_othI_type when ADDIU_op_c,
		data_path_conf_pack_othI_type when ANDI_op_c,
		data_path_conf_pack_othI_type when ORI_op_c,
		data_path_conf_pack_othI_type when XORI_op_c, 
		
		--configure data path for Branch instructions 
		data_path_conf_pack_Branch when BEQ_op_c, 
		
		--configure data path for Jump instructions 
		data_path_conf_pack_Jump when J_op_c,
		
		--if any other configuration set all to 0 because this 
		--means there is no such instruction in this CPU currently instruction set
		data_path_conf_pack_other when others; 
	
	-- decoding opcode 
	with opcode select alu_operation  <= 
		alu_special1 when special1_c,
		alu_special2 when special2_c,
		alu_add when ADDI_op_c,
		alu_addu when ADDIU_op_c,
		alu_and when ANDI_op_c, 
		alu_or when ORI_op_c,
		alu_xor when XORI_op_c,
		alu_add when SW_op_c,
		alu_add when LW_op_c,
		alu_nop when BEQ_op_c,
		alu_nop when J_op_c,
		alu_slt when SLTI_op_c, 
		alu_nop when others;  

end architecture Behavioral;
