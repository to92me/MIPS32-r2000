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
		mem_to_reg           : out std_logic; -- control's mux after memory. Chose if data to registers is from ALu or from memory 
		register_destination : out std_logic; -- first mux - if it's 1 <- rs is wrAddr ( I type )   0 <- rt is wrAddr ( R type )  
		alu_operation        : out AluOp_t;	  -- decoded opcode for alu control unit 
		alu_source           : out std_logic; -- mux in front of alu  -- if it's 0 <- operand is from register   1 <- operand is from instruction 
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
		data_path_conf_pack_R_type when special1_c,
		data_path_conf_pack_R_type when special2_c,
		
		data_path_conf_pack_Load when LW_op_c,
		data_path_conf_pack_Store when SW_op_c, 
		
--		data_path_conf_pack_othI_type when (ADDI_op_c or ADDIU_op_c or ANDI_op_c or ORI_op_c or XORI_op_c),
		data_path_conf_pack_othI_type when ADDI_op_c,
		data_path_conf_pack_othI_type when ADDIU_op_c,
		data_path_conf_pack_othI_type when ANDI_op_c,
		data_path_conf_pack_othI_type when ORI_op_c,
		data_path_conf_pack_othI_type when XORI_op_c, 
		
		data_path_conf_pack_Branch when BEQ_op_c, 
		data_path_conf_pack_Jump when J_op_c,
		data_path_conf_pack_other when others; 
	
	
--	mux_select : process(opcode) is
--	begin
--		if (opcode = special1_c) or (opcode = special2_c) then
--			-- R type instruction
--			-- R type instructions are instructions that operate only with register 
--			register_destination <= '1'; -- because reg address to store data is in Rd filed ( 15 downto 11  of instruction ) ( reminder to me! )  
--			register_write       <= '1';
--			alu_source           <= '0';
--			memory_write         <= '0';
--			mem_to_reg           <= '0';
--			branch               <= '0';
--			jump                 <= '0';
--
--		elsif (opcode = LW_op_c) then
--			-- Load instructions ( I type ) 
--			-- Load instructions are special variant of I type of instructions. They read some data from RAM and store them in some register 
--			register_destination <= '0'; -- 
--			register_write       <= '1';
--			alu_source           <= '1';
--			memory_write         <= '0';
--			mem_to_reg           <= '1';
--			branch               <= '0';
--			jump                 <= '0';
--		elsif (opcode = SW_op_c) then
--			-- Store instructions ( I type ) 
--			-- Store instructions are special variant of I type of instructions. They write to RAM some data
--			register_destination <= '0';
--			register_write       <= '0';
--			alu_source           <= '1';
--			memory_write         <= '1';
--			mem_to_reg           <= '0';
--			branch               <= '0';
--			jump                 <= '0';
--		elsif (opcode = ADDI_op_c) or (opcode = ADDIU_op_c) or (opcode = ANDI_op_c) or (opcode = ORI_op_c) or (opcode = XORI_op_c) then
--			-- other I type instructions 
--			-- I type of instructions uses one register and immediate from instruction 
--			register_destination <= '0';
--			register_write       <= '1';
--			alu_source           <= '1';
--			memory_write         <= '0';
--			mem_to_reg           <= '0';
--			branch               <= '0';
--			jump                 <= '0';
--		elsif(opcode = BEQ_op_c) then 
--			register_destination <= '0';
--			register_write       <= '0';
--			alu_source           <= '0';
--			memory_write         <= '0';
--			mem_to_reg           <= '0';
--			branch               <= '1';
--			jump                 <= '0';
--		elsif(opcode = J_op_c) then 	
--			register_destination <= '0';
--			register_write       <= '0';
--			alu_source           <= '0';
--			memory_write         <= '0';
--			mem_to_reg           <= '0';
--			branch               <= '0';
--			jump                 <= '1';
--		else
--			-- za cega je ovo ?
--			register_destination <= '0';
--			register_write       <= '0';
--			alu_source           <= '0';
--			memory_write         <= '0';
--			mem_to_reg           <= '0';
--			branch               <= '0';
--			jump                 <= '0';
----			report "CPU-CU NaI"; 
--		end if;
--
--	end process mux_select;

--	opcide_decode : process(opcode) is
--	begin                               -- process opcide_decode
--		case opcode is
--			when special1_c => alu_operation <= alu_special1;
--			when special2_c => alu_operation <= alu_special2;
--			when ADDI_op_c  => alu_operation <= alu_add;
--			when ADDIU_op_c => alu_operation <= alu_addu;
--			when ANDI_op_c  => alu_operation <= alu_and;
--			when ORI_op_c   => alu_operation <= alu_or;
--			when XORI_op_c  => alu_operation <= alu_xor; 	
--			when SW_op_c  => alu_operation  <= alu_add;
--			when LW_op_c  => alu_operation  <= alu_add;
--			when BEQ_op_c => alu_operation  <= alu_nop;  	
--			when others     => alu_operation <= alu_nop;
--		end case;
--	end process opcide_decode;
	
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
		alu_nop when others;  

end architecture Behavioral;
