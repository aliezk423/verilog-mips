`timescale  1ns / 1ps
module gpr(clk,rst,a1,a2,a3,wd,regWrite,rd1,rd2);
    input clk;
    input rst;
    input [4:0] a1;
    input [4:0] a2;
    input [4:0] a3;
    input [31:0] wd;
    input regWrite;
    output [31:0] rd1;
    output [31:0] rd2;
    reg [31:0] mipsReg[31:0];
    integer i;
    assign rd1=mipsReg[a1];
    assign rd2=mipsReg[a2];

    always @ (posedge clk) 
    begin
        if(rst)
            begin
                for(i=0;i<32;i=i+1)
                    mipsReg[i]<=0;
            end
        else if(regWrite && a3!=0)
                mipsReg[a3]<=wd;
            
    end
endmodule // gpr