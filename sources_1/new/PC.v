`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2026 08:57:36 PM
// Design Name: 
// Module Name: PC
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
module PC(
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] pc_next,
    output reg  [15:0] pc
);
    always @(posedge clk) begin
        if (reset) pc <= 16'd0;
        else       pc <= pc_next;
    end
endmodule