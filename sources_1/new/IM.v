`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicole Oszczypala
// 
// Create Date: 03/05/2026 04:12:22 PM
// Design Name:16-bit processor
// Module Name: IM
// Project Name: CSE 490 Project 1 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IM #(
    parameter MEM_SIZE_BYTES = 128
)(
    input  wire [15:0] addr, 
    output wire [15:0] instr
);
    // Array 64, 1 byte @ each index
    reg [7:0] mem [0:MEM_SIZE_BYTES-1];

    integer i;
    initial begin
        // Clear memory
        for (i = 0; i < MEM_SIZE_BYTES; i = i + 1)
            mem[i] = 8'h00;
            

        // addi R1, R0, 5
        mem[0]  = 8'h31; mem[1]  = 8'h05;
        // add  R1 = R2 + R1
        mem[4]  = 8'h01; mem[5]  = 8'h20;
        // sub  R1 = R2 - R1
        mem[6]  = 8'h01; mem[7]  = 8'h21;
        // and  R3 = R1 & R2
        mem[8]  = 8'h03; mem[9]  = 8'h23;
        // sll  R1 = R1 << R2
        mem[10] = 8'h01; mem[11] = 8'h22;
        // sw   mem[R0+0] = R1
        mem[12] = 8'h21; mem[13] = 8'h00;
        // lw   R4 = mem[R0+0]
        mem[14] = 8'h14; mem[15] = 8'h00;
        // beq  R4, R1, +2  (branches to 0x18 if equal)
        mem[16] = 8'h44; mem[17] = 8'h12;
        // jmp  +0  (infinite loop / halt)
        mem[18] = 8'h60; mem[19] = 8'h00;
        // bne  R4, R2, -4
        mem[20] = 8'h54; mem[21] = 8'h2E;
        
        
        //// alternate test sequence
        //      0: addi R1, R0, 5    (R1 = 5)
        //mem[0]  = 8'h31; mem[1]  = 8'h05;
        
        //// 2: addi R2, R0, 2    (R2 = 2)
        //mem[2]  = 8'h32; mem[3]  = 8'h02;
        
        //// 4: add  R1, R2       (R1 = R2 + R1 = 2 + 5 = 7)
        //mem[4]  = 8'h01; mem[5]  = 8'h20;
        
        //// 6: sll  R1, R2       (R1 = R2 << R1 = 2 << 7 = 256)
        //mem[6]  = 8'h01; mem[7]  = 8'h22;
        
        //// 8: sw   R1, 2(R0)    (Mem[Word 1] = R1)
        //mem[8]  = 8'h21; mem[9]  = 8'h02;
        
        //// 10: lw  R3, 2(R0)    (R3 = Mem[Word 1] = 256)
        //mem[10] = 8'h13; mem[11] = 8'h02;
        
        //// 12: sub R3, R1       (R3 = R1 - R3 = 256 - 256 = 0)
        //mem[12] = 8'h03; mem[13] = 8'h11;
        
        //// 14: beq R3, R0, +1   (If R0 == R3, Jump over the next instruction)
        //mem[14] = 8'h43; mem[15] = 8'h01;
        
        //// 16: addi R3, R0, 7   (TRAP! If your branch fails, you hit this)
        //mem[16] = 8'h33; mem[17] = 8'h07;
        
        //// 18: jmp -1           (Infinite loop / Halt)
        //mem[18] = 8'h60; mem[19] = 8'hFF;
    end
    // read
    assign instr = { mem[addr], mem[addr + 1] };  // [15:8] , [7:0]

endmodule