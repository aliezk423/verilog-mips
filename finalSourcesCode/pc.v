`timescale  1ns / 1ps
module pc(clk,rst,PCwr,nPC,pcout);
    input clk;
    input rst;
    input PCwr;
    input[31:2] nPC;
    output[31:2] pcout;

    reg[31:2] pc;
    reg[1:0] t;
    
    assign pcout=pc;
    
    always @(posedge clk)
    begin
        if(rst)
            {pc,t}<=32'h00003000;
        else if(PCwr)
            pc<=nPC;
     end     
endmodule //pc
