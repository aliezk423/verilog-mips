`timescale  1ns / 1ps
module ext (offset,extop,eout);
    input [15:0] offset;
    input [1:0] extop;
    output reg[31:0] eout;

    always @(*)
    begin
        case(extop)
            2'b00:eout<={{16{1'b0}},offset[15:0]};
            2'b01:eout<={{16{offset[15]}},offset[15:0]};
            2'b10:eout<={offset[15:0],{16{1'b0}}};
            default:eout<=0;
        endcase
    end
endmodule //ext