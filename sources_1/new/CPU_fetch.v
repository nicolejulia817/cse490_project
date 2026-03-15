`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2026 08:57:36 PM
// Design Name: 
// Module Name: CPU_fetch
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
module CPU_fetch(
    input  wire clk,
    input  wire reset,
    output wire [15:0] pc_dbg,
    output wire [15:0] instr_dbg
);
    wire [15:0] pc, pc_next;
    wire [15:0] instr;

    PC pc0(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    IM im0(
        .addr(pc),
        .instr(instr)
    );

    wire [3:0]  opcode = instr[15:12];
    wire [11:0] jaddr  = instr[11:0];

    wire [15:0] pc_plus2 = pc + 16'd2;

    wire [15:0] j_sext = {{4{jaddr[11]}}, jaddr};
    wire [15:0] j_off  = (j_sext <<< 1);

    wire is_jmp = (opcode == 4'b0110);

    assign pc_next = is_jmp ? (pc_plus2 + j_off) : pc_plus2;

    assign pc_dbg    = pc;
    assign instr_dbg = instr;
endmodule