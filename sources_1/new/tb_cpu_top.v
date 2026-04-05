`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2026 12:54:41 PM
// Design Name: 
// Module Name: tb_cpu_top
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


module tb_cpu_top();
    
    reg clk;
    reg reset;

    wire [15:0] io_pc;
    wire [15:0] io_curr_inst;
    wire [15:0] io_alu_result;

    CPU_top cpu (
        .clk(clk),
        .reset(reset),
        .io_pc(io_pc),
        .io_curr_inst(io_curr_inst),
        .io_alu_result(io_alu_result)
    );

    // 10ns period = 100MHz clock 
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1; // clear the PC and registers

        // wait for 20ns (2 full clock cycles)
        #20;
        
        // drop reset to let the CPU start running
        reset = 0;
        
        //let program run
        #320; 

        $finish;
    end
endmodule
