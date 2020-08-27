`timescale  1ns / 1ps
module md(mdop,a,b,hiOut,loOut,done);
    input [2:0] mdop;
    input [31:0] a;
    input [31:0] b;
    output [31:0] hiOut;
    output [31:0] loOut;
    output reg done;
    
    reg[63:0] res;
    reg[31:0] t;
    integer i;
    reg[31:0] HI,LO;
    reg sign;
    reg signr;
    reg [61:0] ta;
    reg [61:0] tb;
    reg [32:0] tempa;
    reg [32:0] tempb;
    reg [32:0] temp;
    reg tt;
    reg [63:0] Ta;
    reg [63:0] Tb;

    assign hiOut=HI;
    assign loOut=LO;

    always @(*) 
    begin
        done=1'b0;
        case(mdop)
            3'b000:
            begin
                res={32'b0,b};
                t=(~a+1);
                tt=1'b0;
                for(i=0;i<32;i=i+1)
                begin
                    if(res[0]==tt)
                    begin
                        tt=res[0];
                        sign=res[63];
                        res=(res>>1);
                        res[63]=sign;
                    end
                    else if(res[0]==1'b1&&tt==1'b0)
                    begin
                        tt=res[0];
                        temp=res[63:32];
                        temp=temp+t;
                        res[63:32]=temp;
                        sign=res[63];
                        res=(res>>1);
                        res[63]=sign;
                    end
                    else
                        begin
                            tt=res[0];
                            temp=res[63:32];
                            temp=temp+a;
                            res[63:32]=temp;
                            sign=res[63];
                            res=(res>>1);
                            res[63]=sign;
                        end
                end
                HI=res[63:32];
                LO=res[31:0];
                done=1'b1;
            end  //MULT
            3'b001:
            begin
                res=0;
                for(i=31;i>-1;i=i-1)
                    res=((res<<1)+((b[i]==1'b1)?a:0));
                HI=res[63:32];
                LO=res[31:0];
                done=1'b1;
            end  //MULTU
            3'b010:
            begin
                if(a[31]==1'b1)
                    signr=1;
                else
                    signr=0;
                if(a[31]-b[31]==1'b0)
                    sign=0;
                else sign=1;
                if(a[31]==1'b1)
                begin
                    tempa=~a+1;
                    ta={31'b0,tempa[30:0]};
                end
                else
                    ta={31'b0,a[30:0]};
                if(b[31]==1'b1)
                begin
                    tempb=~b+1;
                    tb={tempb[30:0],31'b0};
                end
                else
                    tb={b[30:0],31'b0};
                for(i=0;i<31;i=i+1)
                begin
                    ta=(ta<<1);
                    if(ta>=tb)
                        ta=ta-tb+1;
                end
                HI={0,ta[61:31]};  //余数
                LO={0,ta[30:0]};  //商
                if(signr==1'b1)
                    HI=~HI+1;
                if(sign==1'b1)
                    LO=~LO+1;
                done=1'b1; 
            end  //DIV
            3'b011:
            begin
                Ta={32'b0,a};
                Tb={b,32'b0};
                for(i=0;i<32;i=i+1)
                begin
                    Ta=Ta<<1;
                    if(Ta>=Tb)
                        Ta=Ta-Tb+1;
                end
                HI=Ta[63:32];
                LO=Ta[31:0];  
                done=1'b1; 
            end  //DIVU
            3'b100:
            begin
                HI=a;   
            end  //MTHI
            3'b101:
            begin
                LO=a; 
            end  //MTLO
            default: ;
        endcase
    end
endmodule