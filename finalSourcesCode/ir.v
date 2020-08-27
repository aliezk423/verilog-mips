`timescale  1ns / 1ps
module IR(clk,rst,IRwr,imout,instr);
    input clk,rst;
    input IRwr;
    input [31:0] imout;
    output [31:0] instr;

    reg[31:0] t;

    assign instr=t;

    always @(posedge clk) 
    begin
        if(rst)
            t<=0;
        else if(IRwr)
            t<=imout;
    end
endmodule