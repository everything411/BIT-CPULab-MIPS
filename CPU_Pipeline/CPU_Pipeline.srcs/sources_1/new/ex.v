`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 18:31:31
// Design Name: 
// Module Name: ex
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
`include "predef.vh"

module ex(
//    input  wire        clk,
//    input  wire        rst,

    //input           pc_jmp,
    //input           pc_br,
    //input   [15:0]  pc_offset,
    //input   [25:0]  pc_target,
    input  [3:0]    alu_op,
    input  [31:0]   alu_in1,
    input  [31:0]   alu_in2,

    output [31:0]   alu_out,
//    output wire        alu_err,
    output          pausereq,
    output wire     alu_zero
    );
    reg err;
    reg zero;

    wire [31:0] in1   = alu_in1;
    wire [31:0] in2   = alu_in2;
    wire [31:0] in2_u = {16'b0, alu_in2[15:0]};
    wire [4:0]  sa    = alu_in1[10:6];
    
    wire [31:0] o_ori  = in1 | in2_u;
    wire[31:0]  o_or  = in1 | in2;
    wire [31:0] o_xor = in1 ^ in2;
    wire[31:0]  o_and = in1 & in2;
    wire[31:0]  o_nor = ~(in1 | in2);
    wire [31:0] o_xori = in1 ^ in2_u;
    wire[31:0]  o_andi = in1 & in2_u;
    wire [31:0] o_lui = {alu_in2[15:0], 16'b0};
    
    wire [32:0] in1_e = {alu_in1[31], alu_in1};
    wire [32:0] in2_e = {alu_in2[31], alu_in2};
    
    wire [32:0] o_add = in1_e + in2_e;
    wire [32:0] o_addu = in1_e + in2_e;
    wire [32:0] o_sub = in1_e - in2_e;

    assign alu_out = (alu_op == `ALU_ADD) ? o_add[31:0] :
                     (alu_op == `ALU_ADDU) ? o_addu[31:0] :
                     (alu_op == `ALU_SUB) ? o_sub[31:0] :
                     (alu_op == `ALU_XOR ) ? o_xor  :
                     (alu_op == `ALU_OR) ? o_or :
                     (alu_op == `ALU_AND) ? o_and   :
                     (alu_op == `ALU_NOR) ? o_nor   :
                     (alu_op == `ALU_XORI) ? o_xori :
                     (alu_op == `ALU_ANDI) ? o_andi :
                     (alu_op == `ALU_LUI) ? o_lui : 
                     (alu_op == `ALU_ORI) ? o_ori : 32'b0;

    assign pausereq = 1'b0;
    assign alu_zero = (alu_out == 32'b0) ? 1 : 0;
//    assign alu_err = err;
endmodule
