`define OPCODE_ANDREG 11'b?0001010???
`define OPCODE_ORRREG 11'b?0101010???
`define OPCODE_ADDREG 11'b?0?01011???
`define OPCODE_SUBREG 11'b?1?01011???

`define OPCODE_ADDIMM 11'b?0?10001???
`define OPCODE_SUBIMM 11'b?1?10001???

`define OPCODE_MOVZ   11'b110100101??

`define OPCODE_B      11'b?00101?????
`define OPCODE_CBZ    11'b?011010????

`define OPCODE_LDUR   11'b??111000010
`define OPCODE_STUR   11'b??111000000


`define ALU_AND   4'b0000
`define ALU_OR    4'b0001
`define ALU_ADD   4'b0010
`define ALU_SUB   4'b0110
`define ALU_PASSB 4'b0111

`define signext_B  2'b00
`define signext_CB 2'b01
`define signext_I  2'b10
`define signext_D  2'b11



module control(
    output reg reg2loc,
    output reg alusrc,
    output reg mem2reg,
    output reg regwrite,
    output reg memread,
    output reg memwrite,
    output reg branch,
    output reg uncond_branch,
    output reg [3:0] aluop,
    output reg [1:0] signop,
    input [10:0] opcode
);

always @(*)
begin
    casez (opcode)
        /* Add cases here for each instruction your processor supports */
        
        
        //LDUR
        `OPCODE_LDUR:
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'b1;
            mem2reg       <= 1'b1;
            regwrite      <= 1'b1;
            memread       <= 1'b1;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_ADD;
            signop        <= `signext_D;
        end
        
        //STUR
        `OPCODE_STUR:
        begin
            reg2loc       <= 1'b1;
            alusrc        <= 1'b1;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b1;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_ADD;
            signop        <= `signext_D;
        end
        
        //ADD
        `OPCODE_ADDREG:
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_ADD;
            signop        <= 2'bxx;
        end
        
        //SUB
        `OPCODE_SUBREG:
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_SUB;
            signop        <= 2'bxx;
        end
        
        //AND
        `OPCODE_ANDREG:
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_AND;
            signop        <= 2'bxx;
        end
        
        //ORR
        `OPCODE_ORRREG:
        begin
            reg2loc       <= 1'b0;
            alusrc        <= 1'b0;
            mem2reg       <= 1'b0;
            regwrite      <= 1'b1;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_OR;
            signop        <= 2'bxx;
        end
        
        //CBZ
        `OPCODE_CBZ:
        begin
            reg2loc       <= 1'b1;
            alusrc        <= 1'b0;
            mem2reg       <= 1'bx;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b1;
            uncond_branch <= 1'b0;
            aluop         <= `ALU_PASSB;
            signop        <= `signext_CB;
        end
        
        //B
        `OPCODE_B:
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'bx;
            mem2reg       <= 1'bx;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b1;
            aluop         <= `ALU_PASSB;
            signop        <= `signext_B;
        end
        

        default:
        begin
            reg2loc       <= 1'bx;
            alusrc        <= 1'bx;
            mem2reg       <= 1'bx;
            regwrite      <= 1'b0;
            memread       <= 1'b0;
            memwrite      <= 1'b0;
            branch        <= 1'b0;
            uncond_branch <= 1'b0;
            aluop         <= 4'bxxxx;
            signop        <= 2'bxx;
        end
    endcase
end
endmodule

