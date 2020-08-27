`timescale  1ns / 1ps
module mips(clk,rst);
    input clk;
    input rst;

    wire[31:0] imout,instr,mout,dout,rd1,rd2,eout,aout,aluout,rdmout,drout,rd1r,rd2r,aluoutr,hiOut,loOut;
    wire memwrite,regwrite,alusrc,IRwr,PCwr,done;
    wire [1:0] regdst,npcop,extop;
    wire [3:0] aluop;
    wire [4:0] rout;
    wire [31:2] nout,pcout;
    wire [2:0] dmop,memtoreg,mdop;

    regDstMux U_MUX1(instr[20:16],instr[15:11],regdst,rout);
    aluSrcMux U_MUX2(eout,rd2r,alusrc,aout);
    pc U_PC(clk,rst,PCwr,nout,pcout);
    im_4k U_IM(pcout[11:2],imout);
    ctrl U_CTRL(clk,rst,done,instr,aluout,regdst,alusrc,regwrite,memwrite,extop,aluop,npcop,memtoreg,IRwr,PCwr,mdop);
    IR U_IR(clk,rst,IRwr,imout,instr);
    memtoRegMux U_MUX3(aluoutr,drout,pcout,memtoreg,hiOut,loOut,mout);
    gpr U_GPR(clk,rst,instr[25:21],instr[20:16],rout,mout,regwrite,rd1,rd2);
    flopr #(32) U_RD1_REG(clk,rst,rd1,rd1r);
    flopr #(32) U_RD2_REG(clk,rst,rd2,rd2r);
    md U_MD(mdop,rd1r,rd2r,hiOut,loOut,done);
    npc U_NPC(pcout,npcop,instr,nout,rd1r);
    ext U_EXT(instr[15:0],extop,eout);
    alu U_ALU(rd1r,aout,aluop,aluout,instr[10:6]);
    flopr #(32) U_ALU_REG(clk,rst,aluout,aluoutr);
    dmMux U_MUX4(aluoutr[1:0],instr[31:26],dmop);
    dm_4k U_DM(aluoutr[11:2],rd2r,memwrite,clk,dmop,dout);
    rdmMux U_MUX5(aluoutr[1:0],instr[31:26],dout,rdmout);
    flopr #(32) U_DM_REG(clk,rst,rdmout,drout);

endmodule