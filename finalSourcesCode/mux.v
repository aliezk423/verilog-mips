`include "instructionDef.v"
`timescale  1ns / 1ps

module aluSrcMux(ain,rt,alusrc,aout);
    input [31:0] ain;
    input [31:0] rt;
    input alusrc;
    output reg [31:0] aout;
    always @(ain or rt or alusrc) 
    begin
        case(alusrc)
            1'b0:aout<=rt;
            1'b1:aout<=ain;
        endcase
    end
endmodule //用来确定运算数的多路选择器

module regDstMux(rt,rd,regdst,rout);
    input [4:0] rt;
    input [4:0] rd;
    input [1:0] regdst;
    output reg[4:0] rout;

    always @(rt or rd or regdst) 
    begin
        case (regdst)
            2'b00:rout<=rt;  //写入rt
            2'b01:rout<=rd;  //写入rd
            2'b10:rout<=5'b11111; //写入reg[31]
            default:rout<=0;
        endcase
    end
endmodule  //用于确定写入哪个寄存器的多路选择器

module memtoRegMux (aluout,dmout,pcout,memtoreg,hiOut,loOut,mout);
    input [31:0] aluout;
    input [31:0] dmout;
    input [31:2] pcout;
    input [2:0] memtoreg;
    input [31:0] hiOut;
    input [31:0] loOut;
    output reg[31:0] mout;

    always @(aluout,dmout,pcout,memtoreg) 
    begin
        case (memtoreg)
            3'b000:mout<=aluout; //alu计算结果写回
            3'b001:mout<=dmout;  //dm结果写回
            3'b010:mout<={pcout,2'b00};   //跳转存pc
            3'b011:mout<=hiOut;     //存HI
            3'b100:mout<=loOut;     //存LO
            default :;
        endcase
    end
endmodule //用于确定写入寄存器内容的多路选择器

module dmMux(addr,op,dmop);
    input [1:0] addr;
    input [5:0] op;
    output [2:0] dmop;

    reg [2:0] t;

    assign dmop=t;

    always @(*) 
    begin
        case(op)
            `SW_OP:
                t=3'b000;
            `SH_OP:
                if(addr==2'b00)
                    t=3'b001;
                else
                    t=3'b010;
            `SB_OP:
                if(addr==2'b00)
                    t=3'b011;
                else if(addr==2'b01)
                    t=3'b100;
                else if(addr==2'b10)
                    t=3'b101;
                else 
                    t=3'b110;
            default: ; 
        endcase
    end
endmodule

module rdmMux (addr,op,din,rout);
    input [1:0] addr;
    input [5:0] op;
    input [31:0] din;
    output [31:0] rout;

    reg[31:0] t;

    assign rout=t;

    always @(*) begin
        case(op)
            `LW_OP:
                t=din;
            `LH_OP:
                if(addr==2'b00)
                    t={{16{din[15]}},din[15:0]};
                else
                    t={{16{din[31]}},din[31:16]};
            `LHU_OP:
                if(addr==2'b00)
                    t={16'b0,din[15:0]};
                else
                    t={16'b0,din[31:16]};
            `LB_OP:
                if(addr==2'b00)
                    t={{24{din[7]}},din[7:0]};
                else if(addr==2'b01)
                    t={{24{din[15]}},din[15:8]};
                else if(addr==2'b10)
                    t={{24{din[23]}},din[23:16]};
                else
                    t={{24{din[31]}},din[31:24]};
            `LBU_OP:
                if(addr==2'b00)
                    t={24'b0,din[7:0]};
                else if(addr==2'b01)
                    t={24'b0,din[15:8]};
                else if(addr==2'b10)
                    t={24'b0,din[23:16]};
                else
                    t={24'b0,din[31:24]};
            default: ;
        endcase
    end
endmodule //mux