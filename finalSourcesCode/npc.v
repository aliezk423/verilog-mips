`timescale  1ns / 1ps
module npc(pc,npcop,mem,nout,rs);
    input [31:2] pc;
    input [1:0] npcop;
    input [31:0] mem;
    input [31:0] rs;
    output reg[31:2] nout;
    
    always @(*)
    begin
        case (npcop)
            2'b00:nout<=pc+1;  //normal
            2'b01:nout<=pc+{{14{mem[15]}},mem[15:0]}; // beq/bne/blez/bgtz/bltz/bgez
            2'b10:nout<={pc[31:28],mem[25:0]};   //j/jal
            2'b11:nout<=rs[31:2];  // jr/jalr
        endcase
    end
endmodule // npc