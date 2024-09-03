`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 21:22:47
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input           clk,
    input           rst,

    input   [5:0]   pause,
    input   [31:0]  mem_alu_out,
    input           mem_cu_c4,
    input   [4:0]   mem_reg_wa,
    input           mem_reg_we,
    input   [31:0]  mem_ram_rdata,

    output [31:0]   mem_reg_wdata,
    output reg[31:0] wb_reg_wdata,
    output reg[4:0] wb_reg_wa,
    output reg      wb_reg_we
    );
    wire [31:0] reg_wvalue;
    assign reg_wvalue = (mem_cu_c4 == 1) ? mem_ram_rdata : mem_alu_out;
    assign mem_reg_wdata = reg_wvalue;

    always @(posedge clk) begin
        if(!rst) begin
            wb_reg_wdata <= 32'h00000000;
            wb_reg_wa <= 5'b00000;
            wb_reg_we <= 1'b0;
        end
        else if(pause[4]==1'b1 && pause[5]==1'b0) begin
            wb_reg_wdata <= 32'h00000000;
            wb_reg_wa <= 5'b00000;
            wb_reg_we <= 1'b0;
        end
        else if(pause[4]==1'b0) begin
            wb_reg_wdata <= reg_wvalue;
            wb_reg_wa <= mem_reg_wa;
            wb_reg_we <= mem_reg_we;
        end
    end
endmodule
