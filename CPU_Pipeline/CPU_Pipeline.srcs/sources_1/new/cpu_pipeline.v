`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 13:49:44
// Design Name: 
// Module Name: cpu_pipeline
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


module cpu_pipeline(
    input   wire    rstn,
    input   wire    clk,
    output wire[31:0] value_to_digit
    );
    wire[31:0]  inst_rom_addr;
    wire[31:0]  inst_rom_rdata;

    wire        pc_jmp;     // in: from id
    wire        pc_br;      // in: from id
    wire [15:0] pc_offset;     // in: from id
    wire [25:0] pc_target;     // in: from id
    wire [31:0] pc_value;     // out: to rom
    wire [5:0]  pause;

    pc _pc(
        .clk(clk),
        .rst(rstn),
        .pause(pause),
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_offset(pc_offset),
        .pc_target(pc_target),
        .pc_value(pc_value)
    );
    assign inst_rom_addr = pc_value;

    inst_rom inst_rom_4k(
        .a(inst_rom_addr[11:2]),                    // input wire [9 : 0] a
        .spo(inst_rom_rdata)                        // output wire [31 : 0] spo
    );

    wire[31:0]  inst_if_out = inst_rom_rdata;
    wire[31:0]  inst_id_in;

    if_id _if_id(
        .clk(clk),
        .rst(rstn),
        .pause(pause),
        .if_inst(inst_if_out),
        .id_inst(inst_id_in)
    );

    wire [31:0] reg_rd1;    // 
    wire [31:0] reg_rd2;    // 
    wire        reg_we_ex_out;
    wire[4:0]   reg_wa_ex_out;
    wire[31:0]  reg_wdata_ex_out;
    wire        reg_we_mem_out;
    wire[4:0]   reg_wa_mem_out;
    wire[31:0]  reg_wdata_mem_out;
    wire        cu_c4_id_out;
    wire[3:0]   cu_cA_id_out;
    wire[31:0]  alu_in1_id_out;
    wire[31:0]  alu_in2_id_out;
    wire[4:0]   reg_wa_id_out;
    wire        reg_we_id_out;
    wire        data_we_id_out;
    wire[31:0]  data_wdata_id_out;
    wire        pausereq_from_id;

    wire       reg_we;
    wire[4:0]  reg_ra1;
    wire[4:0]  reg_ra2;
    wire[4:0]  reg_wa;
    wire[31:0] reg_wd;
    wire[4:0]   id_inst_id;
    wire[4:0]   ex_inst_id;

    id _id(
        .instr(inst_id_in),
        .pre_inst_id(ex_inst_id),
        .reg_rd1(reg_rd1),
        .reg_rd2(reg_rd2),
        .ex_reg_we(reg_we_ex_out),
        .ex_reg_wa(reg_wa_ex_out),
        .ex_reg_wdata(reg_wdata_ex_out),
        .mem_reg_we(reg_we_mem_out),
        .mem_reg_wa(reg_wa_mem_out),
        .mem_reg_wdata(reg_wdata_mem_out),
        .cu_c4(cu_c4_id_out),
        .cu_cA(cu_cA_id_out),
        .inst_id(id_inst_id),
        .pausereq(pausereq_from_id),
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_offset(pc_offset),
        .pc_target(pc_target),
        .reg_ra1(reg_ra1),
        .reg_ra2(reg_ra2),
        .alu_in1(alu_in1_id_out),
        .alu_in2(alu_in2_id_out),
        .reg_wa(reg_wa_id_out),
        .data_we(data_we_id_out),
        .data_wdata(data_wdata_id_out),
        .reg_we(reg_we_id_out)
    );

    regfile _regfile(
        .clk(clk),
        .rst(rstn),
        .reg_we(reg_we),
        .reg_ra1(reg_ra1),
        .reg_ra2(reg_ra2),
        .reg_wa(reg_wa),
        .reg_wd(reg_wd),
        .reg_rd1(reg_rd1),
        .reg_rd2(reg_rd2),
        .val_to_digit(value_to_digit)
    );

    wire        cu_c4_ex_in;
    wire[3:0]   cu_cA_ex_in;
    wire[31:0]  alu_in1_ex_in;
    wire[31:0]  alu_in2_ex_in;
    wire[4:0]   reg_wa_ex_in;
    wire        reg_we_ex_in;
    wire        data_we_ex_in;
    wire[31:0]  data_wdata_ex_in;    

    id_ex _id_ex(
        .clk(clk),
        .rst(rstn),
        .pause(pause),
        .id_cu_c4(cu_c4_id_out),
        .id_cu_cA(cu_cA_id_out),
        .id_inst_id(id_inst_id),
        .id_alu_in1(alu_in1_id_out),
        .id_alu_in2(alu_in2_id_out),
        .id_reg_wa(reg_wa_id_out),
        .id_data_we(data_we_id_out),
        .id_data_wdata(data_wdata_id_out),
        .id_reg_we(reg_we_id_out),
        .ex_cu_c4(cu_c4_ex_in),
        .ex_cu_cA(cu_cA_ex_in),
        .ex_inst_id(ex_inst_id),
        .ex_alu_in1(alu_in1_ex_in),
        .ex_alu_in2(alu_in2_ex_in),
        .ex_reg_wa(reg_wa_ex_in),
        .ex_data_we(data_we_ex_in),
        .ex_data_wdata(data_wdata_ex_in),
        .ex_reg_we(reg_we_ex_in)
    );

    wire[31:0]  alu_out_ex_out;
    wire        alu_zero;
    wire        pausereq_from_ex;

    ex _ex(
        .alu_op(cu_cA_ex_in),
        .alu_in1(alu_in1_ex_in),
        .alu_in2(alu_in2_ex_in),
        .alu_out(alu_out_ex_out),
        .pausereq(pausereq_from_ex),
        .alu_zero(alu_zero)
    );

    wire        cu_c4_ex_out = cu_c4_ex_in;
    wire        data_we_ex_out = data_we_ex_in;
    wire[31:0]  data_wdata_ex_out = data_wdata_ex_in;
    assign reg_we_ex_out = reg_we_ex_in;
    assign reg_wa_ex_out = reg_wa_ex_in;
    assign reg_wdata_ex_out = alu_out_ex_out;
    wire[31:0]  alu_out_mem_in;
    wire        cu_c4_mem_in;
    wire[4:0]   reg_wa_mem_in;
    wire        reg_we_mem_in;
    wire        data_we_mem_in;
    wire[31:0]  data_wdata_mem_in;

    ex_mem _ex_mem(
        .clk(clk),
        .rst(rstn),
        .pause(pause),
        .ex_alu_out(alu_out_ex_out),
        .ex_cu_c4(cu_c4_ex_out),
        .ex_reg_wa(reg_wa_ex_out),
        .ex_data_we(data_we_ex_out),
        .ex_data_wdata(data_wdata_ex_out),
        .ex_reg_we(reg_we_ex_out),
        .mem_alu_out(alu_out_mem_in),
        .mem_cu_c4(cu_c4_mem_in),
        .mem_reg_wa(reg_wa_mem_in),
        .mem_data_we(data_we_mem_in),
        .mem_data_wdata(data_wdata_mem_in),
        .mem_reg_we(reg_we_mem_in)
    );

    wire        ram_we;
    wire[31:0]  ram_wdata;
    wire[31:0]  ram_addr;

    mem _mem(
        .alu_out(alu_out_mem_in),
        .data_wdata(data_wdata_mem_in),
        .data_we(data_we_mem_in),
        .ram_we(ram_we),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata)
    );

    wire[31:0]  ram_rdata;

    data_ram data_ram_4k(
        .a(ram_addr[11:2]),                         // input wire [9 : 0] a
        .d(ram_wdata),                              // input wire [31 : 0] d
        .clk(clk),                                  // input wire clk
        .we(ram_we),                               // input wire we
        .spo(ram_rdata)                             // output wire [31 : 0] spo
    );

    assign reg_we_mem_out = reg_we_mem_in;
    assign reg_wa_mem_out = reg_wa_mem_in;
    //assign reg_wdata_mem_out = alu_out_mem_in;

    mem_wb _mem_wb(
        .clk(clk),
        .rst(rstn),
        .pause(pause),
        .mem_alu_out(alu_out_mem_in),
        .mem_cu_c4(cu_c4_mem_in),
        .mem_reg_wa(reg_wa_mem_out),
        .mem_reg_we(reg_we_mem_out),
        .mem_ram_rdata(ram_rdata),
        .mem_reg_wdata(reg_wdata_mem_out),
        .wb_reg_wdata(reg_wd),
        .wb_reg_wa(reg_wa),
        .wb_reg_we(reg_we)
    );

    control _control(
        .pausereq_from_id(pausereq_from_id),
        .pausereq_from_ex(pausereq_from_ex),
        .pause(pause)
    );
endmodule
