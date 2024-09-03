`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 18:32:09
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    input           clk,
    input           rst,

    input   [5:0]   pause,
    input   [31:0]  ex_alu_out, //from ex
    input           ex_cu_c4,   //from id_ex
    input   [4:0]   ex_reg_wa,  //from id_ex
    input           ex_data_we, //from id_ex
    input   [31:0]  ex_data_wdata,  //from id_ex
    input           ex_reg_we,  //from id_ex

    output reg[31:0] mem_alu_out,   //to mem and writeback
    output  reg     mem_cu_c4,      //to wb
    output reg[4:0] mem_reg_wa,     //to wb
    output  reg     mem_data_we,    //to mem
    output reg[31:0] mem_data_wdata,//to mem
    output  reg     mem_reg_we      //to wb
    );

    always @(posedge clk) begin
        if(!rst) begin
            mem_alu_out <= 32'h00000000;
            mem_cu_c4 <= 1'b0;
            mem_reg_wa <= 5'b00000;
            mem_reg_we <= 1'b0;
            mem_data_we <= 1'b0;
            mem_data_wdata <= 32'h00000000;
        end
        else if(pause[3]==1'b1 && pause[4]==1'b0) begin
            mem_alu_out <= 32'h00000000;
            mem_cu_c4 <= 1'b0;
            mem_reg_wa <= 5'b00000;
            mem_reg_we <= 1'b0;
            mem_data_we <= 1'b0;
            mem_data_wdata <= 32'h00000000;
        end
        else if(pause[3]==1'b0) begin
            mem_alu_out <= ex_alu_out;
            mem_cu_c4 <= ex_cu_c4;
            mem_reg_wa <= ex_reg_wa;
            mem_reg_we <= ex_reg_we;
            mem_data_we <= ex_data_we;
            mem_data_wdata <= ex_data_wdata;
        end
    end
endmodule
