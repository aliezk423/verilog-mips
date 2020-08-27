`timescale  1ns / 1ps
module dm_4k(addr,din,we,clk,dmop,dout);
    input [11:2] addr;
    input [31:0] din;
    input we;
    input clk;
    input [2:0] dmop;
    output [31:0] dout;

    reg [31:0] dm[1023:0]; 
    
    assign dout=dm[addr];

    always @(posedge clk)
    begin
        if(we)
        case(dmop)
            3'b000:
                dm[addr]=din; //st
            3'b001:
                dm[addr][15:0]=din[15:0];
            3'b010:
                dm[addr][31:16]=din[15:0];
                //sh
            3'b011:
                dm[addr][7:0]=din[7:0];
            3'b100:
                dm[addr][15:8]=din[7:0];
            3'b101:
                dm[addr][23:16]=din[7:0];
            3'b110:
                dm[addr][31:24]=din[7:0];
                //sb
            default: ;
        endcase
    end
endmodule // dm