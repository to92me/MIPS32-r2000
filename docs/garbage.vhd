--case opcode is
  -- when  => ;
  -- when others => null;
  -- end case;
  -- when special1_c =>


  -- morao sam izbaciti jer za with select moram korisiti sigal koji kasni " za
  -- takt" u ondosu na process koji sam morao ubaciti zbog if naredbe
  -- prebaceno je sve u process tj  u case 
  --with func select 
  --  special1_v <=  
  --  alu_add     when ADD_fun_c,
  --  alu_addu    when ADDU_fun_c,
  --  alu_div     when DIV_fun_c,
  --  alu_divu    when DIVU_fun_c,
  --  alu_mult    when MULT_fun_c,
  --  alu_multu   when MULTU_fun_c,
  --  alu_slt     when SLT_fun_c,
  --  alu_sltu    when SLTU_fun_c,
  --  alu_sub     when SUB_fun_c,
  --  alu_subu    when SUBU_fun_c,
  --  alu_and     when AND_fun_c,
  --  alu_nor     when NOR_fun_c,
  --  alu_or      when OR_fun_c,
  --  alu_xor     when XOR_fun_c,
  --  alu_sll     when SLL_fun_c,
  --  alu_sllv    when SLLV_fun_c,
  --  alu_sra     when SRA_fun_c,
  --  alu_srav    when SRAV_fun_c,
  --  alu_srl     when SRL_fun_c,
  --  alu_srlv    when SRLV_fun_c,
  --  alu_sync    when SYNC_fun_c,
  --  alu_syscall when SYSCALL_fun_c,
  --  alu_mfhi    when MFHI_fun_c,
  --  alu_mflo    when MFLO_fun_c,
  --  alu_movn    when MOVN_fun_c,
  --  alu_movz    when MOVZ_fun_c,
  --  alu_mthi    when MTHI_fun_c,
  --  alu_mtlo    when MTLO_fun_c,
  --  alu_nop     when others;

  --with func select
  --  special2_v <= 
  --  alu_clo   when CLO_fun_c,
  --  alu_clz   when CLZ_fun_c,
  --  alu_madd  when MADD_fun_c,
  --  alu_maddu when MADDU_fun_c,
  --  alu_msub  when MSUB_fun_c,
  --  alu_msubu when MSUBU_fun_c,
  --  alu_mul   when MULT_fun_c,
  --  alu_nop   when others;


  ---- when others => -- update this should  global control unit do :) 
  --with opcode select
  --  operation <=
  --  special1_v when special1_c,
  --  special2_v when special2_c,
  --  alu_addi   when ADDI_op_c,
  --  alu_addiu  when ADDIU_op_c,
  --  alu_slti   when SLTI_op_c,
  --  alu_sltiu  when SLTIU_op_c,
  --  alu_andi   when ANDI_op_c,
  --  alu_ori    when ORI_op_c,
  --  alu_lb     when LB_op_c,
  --  alu_lbu    when LBU_op_c,
  --  alu_lh     when LH_op_c,
  --  alu_lhu    when LHU_op_c,
  --  alu_lw     when LW_op_c,
  --  alu_ll     when LL_op_c,
  --  alu_lui    when LUI_op_c,
  --  alu_lwl    when LWL_op_c,
  --  alu_lwr    when LWR_op_c,
  --  alu_pref   when PREF_op_c,
  --  alu_sb     when SB_op_c,
  --  alu_sh     when SH_op_c,
  --  alu_sw     when SW_op_c,
  --  alu_swl    when SWL_op_c,
  --  alu_swr    when SWR_op_c,
  --  alu_sc     when SC_op_c,
  --  alu_nop    when others;
  ----end case;
  
  
  
  
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  
--operation_select : process (opcode) is
--begin  -- process operation_select
--  with opcode select
--    alu_operation <=
--    alu_special1 when special1_c,
--    alu_special2 when special2_c,
--    alu_addi     when ADDI_op_c,
--    alu_addiu    when ADDIU_op_c,
--    alu_slti     when SLTI_op_c,
--    alu_sltiu    when SLTIU_op_c,
--    alu_andi     when ANDI_op_c,
--    alu_ori      when ORI_op_c,
--    alu_lb       when LB_op_c,
--    alu_lbu      when LBU_op_c,
--    alu_lh       when LH_op_c,
--    alu_lhu      when LHU_op_c,
--    alu_lw       when LW_op_c,
--    alu_ll       when LL_op_c,
--    alu_lui      when LUI_op_c,
--    alu_lwl      when LWL_op_c,
--    alu_lwr      when LWR_op_c,
--    alu_pref     when PREF_op_c,
--    alu_sb       when SB_op_c,
--    alu_sh       when SH_op_c,
--    alu_sw       when SW_op_c,
--    alu_swl      when SWL_op_c,
--    alu_swr      when SWR_op_c,
--    alu_sc       when SC_op_c,
--    alu_nop      when others;
--end process operation_select;









  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
from memory 





--    if clk'event and clk = '1' then     -- rising clock edge
--      if (wr = '1' and rd /= '1') then
--        memory_v(to_integer(unsigned(addr))) <=  wrData;
--      elsif (rd = '1' and wr /= '1')  then
--        rdData <= memory_v(to_integer(unsigned(addr)));
--      end if;
--    end if;



++++++++++++===========================================++++++++++++==++=++==++=++=++=+=++==++++=
form ram 


  -- purpose: read file and store it in rom_v memory 
  -- type   : combinational
  -- inputs : 
  -- outputs: 
--  read_file : process is
--    type std32_st_file_t is file of std32_st;
--    file asm_f           : std32_st_file_t open read_mode is assembly_file;
    --   file asm_f : text open read_mode is assembly_file;
---    variable line_number : integer := 0;  -- for line in integer
--    variable tmp         : std32_st;

--  begin  -- process read_file
--    while not endfile(asm_f) loop
--      read(asm_f, tmp);
--     rom_v(line_number) := tmp;
--     line_number      := line_number + 1;
--   end loop;
--  end process read_file;
