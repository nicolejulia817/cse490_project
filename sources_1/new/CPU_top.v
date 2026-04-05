`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 02:42:43 PM
// Design Name: 
// Module Name: CPU_top
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


module CPU_top(
    input wire clk,
    input wire reset,
    
    //debug/board i/o outputs, will figure out later
    output wire[15:0] io_pc,
    output wire[15:0] io_curr_inst,
    output wire[15:0] io_alu_result
    );
    
    wire [15:0] pc_curr;
    wire [15:0] pc_next;
    wire [15:0] pc_plus2;
    wire [15:0] inst; //instruction from cpu_fetch
    
    //CU wires
    wire [2:0] aluop;
    wire ALUsrc; //0 is for register, 1 is for imm
    wire Branch; //0 is dont take, 1 is take branch
    wire ImmSel; //0 is 0 extend, 1 is sign extend
    wire MemWrite;  
    wire MemtoReg; 
    wire RegWrite;
    wire BEQflag;
    wire Jump;
    
    //regfile outputs
    wire [15:0] rs_out;
    wire [15:0] rt_rd_out;
    
    //alu outputs
    wire [15:0] alu_out;
    wire aluzero;
    
    //data mem outputs
    wire [15:0] mem_out;
    
    //instruction decode
    wire [3:0] opcode = inst[15:12];
    wire [3:0] rd_in     = inst[11:8];
    wire [3:0] rs_in     = inst[7:4];
    wire [3:0] func   = inst[3:0];
    
    //muxes and immgen
    wire [15:0] imm_ext = ImmSel ? {{12{func[3]}}, func} : {12'b0, func};
    wire [15:0] alu_src = ALUsrc ? imm_ext : rt_rd_out;
    wire [15:0] reg_write = MemtoReg ? mem_out : alu_out;
    
    //jump logic
    wire [11:0] jaddr = inst [11:0];
    
    assign pc_plus2 = pc_curr + 16'd2;
    
    wire [15:0] branch_target = pc_plus2 + (imm_ext <<< 1);
    
    wire [15:0] j_sext = {{4{jaddr[11]}}, jaddr};
    wire [15:0] j_target  = pc_plus2 + (j_sext <<< 1);
    
    wire take_branch = Branch & (BEQflag ? ~aluzero : aluzero); 
    
    assign pc_next = Jump? j_target : 
                     take_branch ? branch_target : 
                     pc_plus2;
    
    assign io_curr_inst = inst;
    assign io_alu_result = alu_out;
    assign io_pc = pc_curr;
    PC pc(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_curr)
        );
   
   IM #(
    .MEM_SIZE_BYTES(64)
    ) im (
        .addr(pc_curr),
        .instr(inst)
   );
   
   CU cu(
    .opcode(opcode),
    .func(func),
    .ALUop(aluop),
    .ALUsrc(ALUsrc),
    .Branch(Branch),
    .ImmSel(ImmSel),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .BEQflag(BEQflag),
    .Jump(Jump)
    );
    
    RegisterFile #(
        .NUM_REGS(16),
        .DATA_WIDTH(16)
    ) regfile (
        .clk(clk),
        .read_reg_1(rs_in),
        .read_data_1(rs_out),
        .read_reg_2(rd_in),
        .read_data_2(rt_rd_out),
        .write_reg(rd_in),
        .write_data(reg_write),
        .reg_write(RegWrite)
    );
    
    ALU alu(
        .rs(rs_out),
        .rdimm(alu_src),
        .ALUop(aluop),
        .zero(aluzero),
        .ALU_out(alu_out)
    );
    
    Mem #(
        .ADDR_DATA_WIDTH(16),
        .MEM_SIZE_WORDS(64)
    ) mem(
        .clk(clk),
        .rw_addr(alu_out[6:0]),
        .data(rt_rd_out),
        .MemWrite(MemWrite),
        .MemOut(mem_out)
   );
    
endmodule
