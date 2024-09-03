`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 14:30:08
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    input           clk,
    input           rst,

    input   [5:0]   pause,
    input           id_cu_c4,
    input   [3:0]   id_cu_cA,  // alu cmd
    input   [4:0]   id_inst_id,
    //input           id_pc_jmp,
    //input           id_pc_br,
    //input   [15:0]  id_pc_offset,
    //input   [25:0]  id_pc_target,
    input   [31:0]  id_alu_in1,
    input   [31:0]  id_alu_in2,
    input   [4:0]   id_reg_wa,
    input           id_data_we,
    input   [31:0]  id_data_wdata,
    input           id_reg_we,

    output  reg     ex_cu_c4,   //to ex_mem
    output reg[3:0] ex_cu_cA,   //to ex
    output reg[4:0] ex_inst_id, //back to id
    //output  reg     ex_pc_jmp,  //to ex
    //output  reg     ex_pc_br,   //to ex
    //output reg[15:0] ex_pc_offset,  //to ex
    //output reg[25:0] ex_pc_target,  //to ex
    output reg[31:0] ex_alu_in1,    //to ex
    output reg[31:0] ex_alu_in2,    //to ex
    output reg[4:0] ex_reg_wa,  //to ex_mem
    output  reg     ex_data_we, //to ex_mem
    output reg[31:0] ex_data_wdata, //to ex_mem
    output  reg     ex_reg_we   //to ex_mem
    );

    always @(posedge clk) begin
        if(!rst) begin
            ex_cu_c4 <= 1'b0;
            ex_cu_cA <= 4'b0000;
            ex_inst_id <= 5'd0;
            //ex_pc_jmp <= 1'b0;
            //ex_pc_br <= 1'b0;
            //ex_pc_offset <= 16'h0000;
            //ex_pc_target <= 26'd0;
            ex_alu_in1 <= 32'd0;
            ex_alu_in2 <= 32'd0;
            ex_reg_wa <= 5'd0;
            ex_data_we <= 1'b0;
            ex_data_wdata <= 32'd0;
            ex_reg_we <= 1'b0;
        end
        else if(pause[2]==1'b1 && pause[3]==1'b0) begin
            ex_cu_c4 <= 1'b0;
            ex_cu_cA <= 4'b0000;
            ex_inst_id <= 5'd0;
            //ex_pc_jmp <= 1'b0;
            //ex_pc_br <= 1'b0;
            //ex_pc_offset <= 16'h0000;
            //ex_pc_target <= 26'd0;
            ex_alu_in1 <= 32'd0;
            ex_alu_in2 <= 32'd0;
            ex_reg_wa <= 5'd0;
            ex_data_we <= 1'b0;
            ex_data_wdata <= 32'd0;
            ex_reg_we <= 1'b0;
        end
        else if(pause[2]==1'b0) begin
            ex_cu_c4 <= id_cu_c4;
            ex_cu_cA <= id_cu_cA;
            ex_inst_id <= id_inst_id;
            //ex_pc_jmp <= id_pc_jmp;
            //ex_pc_br <= id_pc_br;
            //ex_pc_offset <= id_pc_offset;
            //ex_pc_target <= id_pc_target;
            ex_alu_in1 <= id_alu_in1;
            ex_alu_in2 <= id_alu_in2;
            ex_reg_wa <= id_reg_wa;
            ex_data_we <= id_data_we;
            ex_data_wdata <= id_data_wdata;
            ex_reg_we <= id_reg_we;
        end
    end
endmodule
