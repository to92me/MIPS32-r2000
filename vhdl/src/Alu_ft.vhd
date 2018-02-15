-------------------------------------------------------------------------------
--                           DEFINITIONS AND CONSTANTS  
-------------------------------------------------------------------------------
-- developer	: Tomislav Tumbas
-- email 		: tumbas.tomislav@gmail.com 
-- college 		: Faculty of Technical Science (FTN) Novi Sad 
-- department 	: Microprocessor Systems and Algorithms
-------------------------------------------------------------------------------
-- mentor 		: Rastislav Struharik, Ph.D. 
-------------------------------------------------------------------------------
-- project 		: MIPS32 Fault Tolerant ALU
-------------------------------------------------------------------------------
-- file         : Alu_ft.vhd
-- module       : Alu 
-- description  : Fault tolerant Arithmetic logic unit 
-------------------------------------------------------------------------------
-- todo         : 
-------------------------------------------------------------------------------
-- comments     : 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use STD.textio.all;
use work.Definitions_pkg.all;

entity Alu_ft is
	port(
		operand1  : in  std32_st := std32_zero_c;	-- operand1 - got from registers 
		operand2  : in  std32_st := std32_zero_c;	-- operand2 - got from AluSource MUX (registers or immediate from instruction)
		operation : in  AluOp_t  := alu_add;		-- operation - this operation ALU should execute 
		result    : out std32_st := std32_zero_c;	-- result from operation 
		zero      : out std_logic:= '1'		    -- zero - signal for branch instructions (if operand1 == operand2 set zero to 1) 
	);

end entity Alu_ft;

architecture behavioral of Alu_ft is
   	component Alu is
        port(
            operand1  : in  std32_st;
            operand2  : in  std32_st;
            operation : in  AluOp_t;
            result    : out std32_st;
            zero      : out std_logic);
        end component Alu;
--   type AluOut_ar_t is array (natural range<>) of AluOut_rt; 
--   signal alu_out_6r : AluOut_ar_t(5 downto 0);
   
   type AluOut_at is array (natural range<>) of std33_st; 
   signal alu_out_6 : AluOut_at(5 downto 0);  
   
   signal correct_block_0 : std33_st := std33_zero_c; 
   signal correct_block_1 : std33_st := std33_zero_c;
   signal correct_block_2 : std33_st := std33_zero_c;
   
   signal result_tmp : std33_st := std33_zero_c;  
   
begin
    -- generate 6 ALU components
    Alu_c: 
    for i in 5 downto 0 generate
        alu_6c : Alu
            port map(
                operand1    => operand1,
                operand2    => operand2,
                operation   => operation,
                result      => alu_out_6(i)(31 downto 0),
                zero        => alu_out_6(i)(32)); 
    end generate; 
    
    -- Compare results of ALUs 
    correct_block_0 <= std33_zero_c when alu_out_6(0) = alu_out_6(1) else
                       std33_one_c;
    
    correct_block_1 <= std33_zero_c when alu_out_6(2) = alu_out_6(3) else
                       std33_one_c; 
     
    correct_block_2 <= std33_zero_c when alu_out_6(4) = alu_out_6(5) else
                       std33_one_c;
                                              
    -- generate output value 
    -- y = DEF' + CD'F + CD'E + AB'F + AB'E + AB'C
    --      where: A is result 0, C is result 2 and D is result 4
    --             B is output of compare block 0, D is output of compare block 1 and 
    --             F is output of compare block 2.  
    result_tmp <=   (alu_out_6(0) and (not correct_block_0) and alu_out_6(2)) or    -- AB'C
                    (alu_out_6(0) and (not correct_block_0) and alu_out_6(4)) or    -- AB'E 
                    (alu_out_6(0) and (not correct_block_0) and correct_block_2) or -- AB'F
                    (alu_out_6(2) and (not correct_block_1) and alu_out_6(4)) or    -- CD'E
                    (alu_out_6(2) and (not correct_block_1) and correct_block_2) or -- CD'F
                    (correct_block_1 and alu_out_6(4) and (not correct_block_2));     -- DEF'
    
    result <= result_tmp(31 downto 0); 
    zero   <= result_tmp(32);            
                    
end; 
