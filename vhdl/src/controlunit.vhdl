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
-- todo         : TODO uraditi data configuration for J and BEQ 
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
begin
	mux_select : process(opcode) is
	begin
		if (opcode = special1_c) or (opcode = special2_c) then
			-- R type instruction
			-- R type instructions are instructions that operate only with register 
			register_destination <= '1'; -- because reg address to store data is in Rd filed ( 15 downto 11  of instruction ) ( reminder to me! )  
			register_write       <= '1';
			alu_source           <= '0';
			memory_write         <= '0';
			mem_to_reg           <= '0';
			branch               <= '0';
			jump                 <= '0';

		elsif (opcode = LB_op_c) or (opcode = LBU_op_c) or (opcode = LH_op_c) or (opcode = LHU_op_c) or (opcode = LW_op_c) or (opcode = LL_op_c) or (opcode = LUI_op_c) or (opcode = LWL_op_c) or (opcode = LW_op_c) then
			-- Load instructions ( I type ) 
			-- Load instructions are special variant of I type of instructions. They read some data from RAM and store them in some register 
			register_destination <= '0'; -- 
			register_write       <= '1';
			alu_source           <= '1';
			memory_write         <= '0';
			mem_to_reg           <= '1';
			branch               <= '0';
			jump                 <= '0';
		elsif (opcode = SB_op_c) or (opcode = SH_op_c) or (opcode = SW_op_c) or (opcode = SWL_op_c) or (opcode = SWR_op_c) or (opcode = SC_op_c) then
			-- Store instructions ( I type ) 
			-- Store instructions are special variant of I type of instructions. They write to RAM some data
			register_destination <= '0';
			register_write       <= '0';
			alu_source           <= '1';
			memory_write         <= '1';
			mem_to_reg           <= '0';
			branch               <= '0';
			jump                 <= '0';
		elsif (opcode = ADDI_op_c) or (opcode = ADDIU_op_c) or (opcode = SLTI_op_c) or (opcode = SLTIU_op_c) or (opcode = ANDI_op_c) or (opcode = ORI_op_c) or (opcode = XORI_op_c) then
			-- other I type instructions 
			-- I type of instructions uses one register and immediate from instruction 
			register_destination <= '0';
			register_write       <= '1';
			alu_source           <= '1';
			memory_write         <= '0';
			mem_to_reg           <= '0';
			branch               <= '0';
			jump                 <= '0';
		elsif(opcode = BEQ_op_c) then 
			register_destination <= '0';
			register_write       <= '0';
			alu_source           <= '0';
			memory_write         <= '0';
			mem_to_reg           <= '0';
			branch               <= '1';
			jump                 <= '0';
		elsif(opcode = J_op_c) then 	
			register_destination <= '0';
			register_write       <= '0';
			alu_source           <= '0';
			memory_write         <= '0';
			mem_to_reg           <= '0';
			branch               <= '0';
			jump                 <= '1';
		else
			-- TODO ostale su nam jos Jump instrukcije i podesiti data path i branch i za to podesiti data path 
			-- za cega je ovo ? TODO 
			register_destination <= '0';
			register_write       <= '0';
			alu_source           <= '0';
			memory_write         <= '0';
			mem_to_reg           <= '0';
			branch               <= '0';
			jump                 <= '0';
		end if;

	end process mux_select;

	opcide_decode : process(opcode) is
	begin                               -- process opcide_decode
		case opcode is
			when special1_c => alu_operation <= alu_special1;
			when special2_c => alu_operation <= alu_special2;
			when ADDI_op_c  => alu_operation <= alu_add;
			when ADDIU_op_c => alu_operation <= alu_addu;
			-- redukovane alu instrukcije do ovoga TODO redukovati ostale 
--			when SLTI_op_c  => alu_operation <= alu_slti;
--			when SLTIU_op_c => alu_operation <= alu_sltiu;
			when ANDI_op_c  => alu_operation <= alu_and;
			when ORI_op_c   => alu_operation <= alu_or;
			when XORI_op_c  => alu_operation <= alu_xor; 
--			when LB_op_c    => alu_operation <= alu_lb;
--			when LBU_op_c   => alu_operation <= alu_lbu;
--			when LH_op_c    => alu_operation <= alu_lh;
--			when LHU_op_c   => alu_operation <= alu_lhu;
--			when LW_op_c    => alu_operation <= alu_lw;
--			when LL_op_c    => alu_operation <= alu_ll;
--			when LUI_op_c   => alu_operation <= alu_lui;
--			when LWL_op_c   => alu_operation <= alu_lwr;
--			when LWR_op_c   => alu_operation <= alu_lwr;
--			when PREF_op_c  => alu_operation <= alu_pref;
--			when SB_op_c    => alu_operation <= alu_sb;
--			when SH_op_c    => alu_operation <= alu_sh;
--			when SWR_op_c   => alu_operation <= alu_swr;
--			when SWL_op_c   => alu_operation <= alu_swl;
--			when SC_op_c    => alu_operation <= alu_sc;
			
			when SW_op_c  => alu_operation  <= alu_add;
			when LW_op_c  => alu_operation  <= alu_add;
			when BEQ_op_c => alu_operation  <= alu_nop;  
				
--			when 
			
			when others     => alu_operation <= alu_nop;
		end case;

	end process opcide_decode;



end architecture Behavioral;
