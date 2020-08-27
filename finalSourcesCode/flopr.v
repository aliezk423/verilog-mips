`timescale  1ns / 1ps
module flopr #(parameter WIDTH=32)
              (clk,rst,fin,fout);
              
    input clk,rst;
    input [WIDTH-1:0] fin;
    output [WIDTH-1:0] fout;

    reg[WIDTH-1:0] treg;

    always @(posedge clk)
    begin
        if(rst)
            treg<=0;
        else
            treg<=fin;
    end

    assign fout=treg;

endmodule //flopr