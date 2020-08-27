`timescale  1ns / 1ps
module alu(a,b,aluop,aluout,s);
    input [31:0] a;
    input [31:0] b;
    input [3:0] aluop;
    input [4:0] s;
    output reg [31:0] aluout;

    integer i;

    always @(*)
    begin
        case (aluop)
            4'b0000: aluout<=a+b; //ADD
            4'b0001: aluout<=a-b;//SUB
            4'b0010: aluout<=a|b;  // ORI/OR
            4'b0011: 
            begin
                if(a[31]==b[31])
                    aluout<=(a<b)?1:0;
                else
                    if(a[31]==1&&b[31]==0)
                        aluout<=1;
                    else
                        aluout<=0;
            end
            // SLT/SLTI
            4'b0100:
                aluout<=(b<<s); //SLL
            4'b0101:
                aluout<=(b>>s); //SRL
            4'b0110:
                begin
                    aluout<=(b>>s);
                    if(b[31]==1)
                    begin
                        for(i=31;i>=32-s;i=i-1)
                        begin
                            aluout[i]<=1;
                        end
                    end
                end
                //SRA
            4'b0111:
                aluout<=(b<<a[4:0]); //SLLV
            4'b1000:
                aluout<=(b>>a[4:0]); //SRLV
            4'b1001:
               begin
                    aluout<=(b>>a[4:0]);
                    if(b[31]==1)
                    begin
                        for(i=31;i>=32-a[4:0];i=i-1)
                        begin
                            aluout[i]<=1;
                        end
                    end
                end
                //SRAV
            4'b1010:
                aluout<=a & b; // AND/ANDI
            4'b1011:
                aluout<=a ^ b; // XOR/XORI
            4'b1100:
                aluout<=~(a | b); // NOR
            4'b1101:
                aluout<=a;  //directly out
            4'b1110: 
            begin
                aluout<=(({1'b0,a}<{1'b0,b})?{31'b0,1'b1}:32'b0); //SLTIU
            end
            default ;
        endcase
    end
endmodule // alu