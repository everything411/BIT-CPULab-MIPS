`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 21:13:55
// Design Name: 
// Module Name: alu
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

`include "macro.vh"

module alu(
//    input  wire        clk,
//    input  wire        rst,
    
    input  wire [3:0]  alu_op,
    input  wire [31:0] alu_in1,
    input  wire [31:0] alu_in2,
   
//    output reg  [31:0] alu_out,
    output wire [31:0] alu_out,
//    output wire        alu_err,
    output wire        alu_zero
    );
    
    reg err;
    reg zero;
    
    wire [31:0] in1   = alu_in1;
    wire [31:0] in2   = alu_in2;
    wire [31:0] in2_u = {16'b0, alu_in2[15:0]};
    wire [4:0]  sa    = alu_in1[10:6];
    
    wire [31:0] o_or  = in1 | in2_u;
    wire [31:0] o_lui = {alu_in2[15:0], 16'b0};
    
    wire [32:0] in1_e = {alu_in1[31], alu_in1};
    wire [32:0] in2_e = {alu_in2[31], alu_in2};
    
    wire [32:0] o_add = in1_e + in2_e;
    wire [32:0] o_sub = in1_e - in2_e;
        
//    always @(posedge clk or negedge rst) begin
//        if (!rst) begin
//            err <= 0;
//        end
//        else if (alu_op == `ALU_ADD && o_add[32] != o_add[31]) err <= 1;
//        else if (alu_op == `ALU_SUB && o_sub[32] != o_add[31]) err <= 1;
//        else begin
//            err <= 0;
//        end
//    end
 
    assign alu_out = (alu_op == `ALU_ADD) ? o_add[31:0] :
                     (alu_op == `ALU_SUB) ? o_sub[31:0] :
                     (alu_op == `ALU_OR ) ? o_or  :
                     (alu_op == `ALU_LUI) ? o_lui : 32'b0;
                     
//    assign alu_out = get_alu_out(alu_op);
//    function [31:0] get_alu_out(input [3:0] alu_op);
//    begin
//        case (alu_op)
//            `ALU_ADD    : get_alu_out = o_add;
//            `ALU_SUB    : get_alu_out = o_sub;
//            `ALU_AND    : get_alu_out = o_and;
//            `ALU_OR     : get_alu_out = o_or;
//            `ALU_SLT    : get_alu_out = o_slt;
//            `ALU_SLL    : get_alu_out = o_sll;
//            default     : get_alu_out = 32'b0;
//        endcase
//    end
//    endfunction

//    always @(*) begin
//        case (alu_op)
//            `ALU_ADD    : alu_out <= o_add[31:0];
//            `ALU_SUB    : alu_out <= o_sub[31:0];
//            `ALU_OR     : alu_out <= o_or;
//            `ALU_LUI    : alu_out <= {alu_in2[15:0], 16'b0};
//            default     : alu_out <= 32'b0;
//        endcase
//    end
                     
    assign alu_zero = (alu_out == 32'b0) ? 1 : 0;
    
//    assign alu_err = err;
    
endmodule
