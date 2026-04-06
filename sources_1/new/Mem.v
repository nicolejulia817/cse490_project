`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 02:13:42 PM
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


module Mem#(
    parameter ADDR_DATA_WIDTH = 16,
    parameter MEM_SIZE_WORDS = 64
)(
    input wire clk,
    input [6:0] rw_addr, //the top 9 bits are ignored and never reach the datamem block, as there are only 128 addresses 7 bits are enough.
    input [15:0] data,
    input wire MemWrite,
    output [15:0] MemOut
    );
    
    //128 byte memory (2 byte words * 64 words)
    reg [15:0] mem [63:0];
    
    //ignore LSB as it is byte addressed, but memory is word addressed as it is 16 bits per address. THis also means odd-byte access is not allowed and ensures hardware level alignment.
    wire [5:0] index = rw_addr[6:1];
    
    integer i;
    initial begin
        for(i=0;i<MEM_SIZE_WORDS;i=i+1) begin
             mem[i]=16'h0000;
        end
    end
    
    always @(posedge clk) begin
        if(MemWrite) begin
            mem[index] = data;
        end
    end
    
    assign MemOut = mem[index];
endmodule
