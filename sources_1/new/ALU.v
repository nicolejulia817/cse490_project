`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pranav Acharya
// 
// Create Date: 03/05/2026 04:12:22 PM
// Design Name: 
// Module Name: ALU
// Project Name: CSE 490 Project 1
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


module ALU(
    input wire [15:0] rs,
    input wire [15:0] rdimm,
    input wire [2:0] ALUop,
    output wire zero,
    output reg [15:0] ALU_out
    );
    //variable names for ALUop signals
    localparam ADD = 3'b000;
    localparam SUB = 3'b100;
    localparam SLL = 3'b010;
    localparam AND = 3'b011;
    //main execution loop, constant
    always @(*) begin
       case (ALUop)
        ADD: ALU_out = rs + rdimm;
        SUB: ALU_out = rs - rdimm;
        SLL: ALU_out = rs << rdimm[3:0];
        AND: ALU_out = rs & rdimm;
        default: ALU_out = 16'd0;
       endcase
             
    end
    
    assign zero = (ALU_out == 16'd0);
endmodule
