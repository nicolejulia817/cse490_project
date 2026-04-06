`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 06:26:00 PM
// Design Name: 
// Module Name: DataMem
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


module RegisterFile #(
    parameter NUM_REGS  = 16,   //$s0-$s15
    parameter DATA_WIDTH = 16   // bits wide
)(
    input  wire        clk,

    // rs
    input  wire [3:0]  read_reg_1,
    output wire [15:0] read_data_1,

    // rt/rd 
    input  wire [3:0]  read_reg_2,
    output wire [15:0] read_data_2,

    // Write (result from ALU or data memory (lw))
    input  wire [3:0]  write_reg,
    input  wire [15:0] write_data,
    input  wire        reg_write
);

    // 16 registers, each 16 bits wide
    reg [15:0] registers [0:NUM_REGS-1];

    integer i;
    initial begin
        for (i = 0; i < NUM_REGS; i = i + 1) begin
            registers[i] = 16'd0;
        end
    end
    
    assign read_data_1 = (read_reg_1 == 4'd0) ? 16'd0 : registers[read_reg_1];
    assign read_data_2 = (read_reg_2 == 4'd0) ? 16'd0 : registers[read_reg_2];
    
    always @(posedge clk) begin
        if (reg_write && write_reg != 4'd0) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule