`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2026 02:18:21 PM
// Design Name: 
// Module Name: CU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU(
    input wire [3:0] opcode,
    input wire [3:0] func,
    output reg [2:0] ALUop,
    output reg ALUsrc, //0 is for register, 1 is for imm
    output reg Branch, //0 is dont take, 1 is take branch
    output reg BEQflag, //0 is BEQ, 1 is BNE
    output reg Jump,
    output reg ImmSel, //0 is 0 extend, 1 is sign extend
    output reg MemWrite,  
    output reg MemtoReg, 
    output reg RegWrite
    );
    //opcodes
    localparam ALU_R = 4'b0000;
    localparam LW  = 4'b0001;
    localparam SW  = 4'b0010;
    localparam ADDI = 4'b0011;
    localparam BEQ = 4'b0100;
    localparam BNE = 4'b0101;
    localparam JMP = 4'b0110;
    //func codes
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam SLL = 4'b0010;
    localparam AND = 4'b0011;
    
    //main execution loop, constant
    always @(*) begin
        //defaults
        ALUop    = 3'b000;
        RegWrite = 0;
        ALUsrc   = 0;
        ImmSel   = 0;
        Branch   = 0;
        MemWrite = 0;
        MemtoReg = 0;
        BEQflag  = 0;
        Jump     = 0;
        case (opcode)
         ALU_R:
            case (func)
                ADD: begin
                    ALUop = 3'b000;
                    RegWrite = 1;
                    ALUsrc = 0;
                    ImmSel = 0;
                    end
                SUB: begin
                    ALUop = 3'b100;
                    RegWrite = 1;
                    ALUsrc = 0;
                    ImmSel = 0;
                    end
                SLL: begin
                    ALUop = 3'b010;
                    RegWrite = 1;
                    ALUsrc = 0;
                    ImmSel = 0;
                    end
                AND: begin
                    ALUop = 3'b011;
                    RegWrite = 1;
                    ALUsrc = 0;
                    ImmSel = 0;
                    end
            endcase
         LW: begin
                ALUop = 3'b000;
                ALUsrc = 1;
                ImmSel = 1;
                MemtoReg = 1;
                RegWrite = 1;
            end
         SW: begin
                ALUop = 3'b000;
                ALUsrc = 1;
                ImmSel = 1;
                MemWrite = 1;
             end
         ADDI: begin
                ALUop = 3'b000;
                ALUsrc = 1;
                ImmSel = 1;
                RegWrite = 1;
                end
         BEQ: begin
                ALUop = 3'b100;
                Branch = 1;
                BEQflag = 0;
                ImmSel = 1;
                end
         BNE: begin
                ALUop = 3'b100;
                Branch = 1;
                BEQflag = 1;
                ImmSel = 1;
             end
         JMP: Jump =1; 
        endcase
        
    end 
    endmodule
