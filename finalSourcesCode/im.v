`timescale  1ns / 1ps
module im_4k(addr,dout);
    input [11:2] addr;
    output [31:0]dout;

    reg [31:0] im[1023:0];
    
    assign dout=im[addr];
endmodule // im