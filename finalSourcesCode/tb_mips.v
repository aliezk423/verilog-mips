`timescale  1ns / 1ps

module tb_mips();

    reg clk, rst;
    
   mips U_MIPS(clk,rst);
   
   initial 
   begin
      $readmemh( "C:/My_Projects/mips/project_1/project_1.srcs/sources_1/code.txt" , U_MIPS.U_IM.im) ;
      $monitor("PC = 0x%8X, IR = 0x%8X , DM0 = 0x%8X , DM1 = 0x%8X , DM2 = 0x%8X , DM3 = 0x%8X , DM4 = 0x%8X , DM5 = 0x%8X , DM6 = 0x%8X , DM7 = 0x%8X , DM8 = 0x%8X , DM9 = 0x%8X , DM10 = 0x%8X " ,  {U_MIPS.U_PC.pcout,2'b00} , U_MIPS.instr , U_MIPS.U_DM.dm[0] , U_MIPS.U_DM.dm[1] , U_MIPS.U_DM.dm[2] , U_MIPS.U_DM.dm[3] , U_MIPS.U_DM.dm[4] , U_MIPS.U_DM.dm[5] , U_MIPS.U_DM.dm[6] , U_MIPS.U_DM.dm[7] , U_MIPS.U_DM.dm[8] , U_MIPS.U_DM.dm[9] , U_MIPS.U_DM.dm[10] ); 
      rst=0;
      rst=1;
      clk=0;
      clk=1;
      #10
      rst = 0;
      forever #5
      begin
         clk=~clk;
      end
   end

endmodule