`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:14:51
// Design Name: 
// Module Name: cpu
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


module mycpu (
    input         rstn,
    input         clk,

    output [31:0] inst_rom_addr,
    input  [31:0] inst_rom_rdata,

    output [31:0] data_ram_addr,
    output [31:0] data_ram_wdata,
    output        data_ram_wen,
    input  [31:0] data_ram_rdata
    );

    wire        pc_jmp;     // in: cu
    wire        pc_br;      // in: cu
    wire [15:0] pc_off;     // in: imem
    wire [25:0] pc_tgt;     // in: pc, imem
    wire [31:0] pc_val;     // out: imem
    pc _pc(
        .clk(clk),
        .rst(rstn),
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_off(pc_off),
        .pc_tgt(pc_tgt),
        .pc_val(pc_val)
    );
    
    wire        reg_we;     // in: cu
    wire [4:0]  reg_ra1;    // in: imem
    wire [4:0]  reg_ra2;    // in: imem
    wire [4:0]  reg_wa;     // in: imem
    wire [31:0] reg_wd;     // in: imem
    wire [31:0] reg_rd1;    // out: alu
    wire [31:0] reg_rd2;    // out: alu
    regfile _regfile(
        .clk(clk),
        .rst(rstn),
        .reg_we(reg_we),
        .reg_ra1(reg_ra1),
        .reg_ra2(reg_ra2),
        .reg_wa(reg_wa),
        .reg_wd(reg_wd),
        .reg_rd1(reg_rd1),
        .reg_rd2(reg_rd2)
    );
    
    wire [3:0]  alu_op;     // in: cu
    
    wire [31:0] alu_in1;    // in: imem, reg
    wire [31:0] alu_in2;    // in: imem, reg
    wire [31:0] alu_out;    // out: dmem, reg
    wire        alu_zero;   // out: pc
    alu _alu(
//        .clk(clk),
//        .rst(rstn),
        .alu_op(alu_op),
        .alu_in1(alu_in1),
        .alu_in2(alu_in2),
        .alu_out(alu_out),
        .alu_zero(alu_zero)
    );
    
    wire [31:0] instr;      // out: 
    assign inst_rom_addr = pc_val;
    assign instr = inst_rom_rdata;
    
    wire        d_we;       // in: dmem
    wire [31:0] d_rdata;    // out: reg
    assign data_ram_addr = alu_out;
    assign data_ram_wdata = reg_rd2;
    assign data_ram_wen = d_we;
    assign d_rdata = data_ram_rdata;

    wire [5:0]  opcode;     // in: imem
    wire [5:0]  func;       // in: imem
    wire        cu_c1;      // out: alu
    wire        cu_c2;      // out: reg
    wire        cu_c3;      // out: alu
    wire        cu_c4;      // out: reg
    wire        cu_br;      // out: pc
    control _cu(
//        .clk(clk),
//        .rst(rstn),
        .opcode(opcode),
        .func(func),
        .cu_c1(cu_c1),
        .cu_c2(cu_c2),
        .cu_c3(cu_c3),
        .cu_c4(cu_c4),
        .cu_cA(alu_op),
        .cu_jmp(pc_jmp),
        .cu_br(cu_br),
        .d_we(d_we),
        .reg_we(reg_we)
    );
    
    wire [31:0] imm_e;      // immediate 32 bit extended signed
    assign opcode   = instr[31:26];
    assign func     = instr[5:0];
    assign imm_e    = {{16{instr[15]}}, instr[15:0]};
    
    assign pc_tgt   = instr[25:0];
    assign pc_off   = instr[15:0];
    assign pc_br    = (cu_br == 1'b1) && (reg_rd1 == reg_rd2);
    
    assign reg_ra1  = instr[25:21];
    assign reg_ra2  = instr[20:16];
    assign reg_wa   = (cu_c2 == 1) ? instr[15:11] : instr[20:16];
    assign reg_wd   = (cu_c4 == 1) ? d_rdata : alu_out;
    
    assign alu_in1  = (cu_c3 == 1) ? imm_e : reg_rd1;
    assign alu_in2  = (cu_c1 == 1) ? imm_e : reg_rd2;
    
endmodule
