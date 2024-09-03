`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 20:21:58
// Design Name: 
// Module Name: mem
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


module mem(
//    input  wire        clk,
//    input  wire        rst,
    input   [31:0]  alu_out,
    input   [31:0]  data_wdata,
    input           data_we,

    output          ram_we,
    output  [31:0]  ram_addr,
    output  [31:0]  ram_wdata
    );

    assign ram_we = data_we;
    assign ram_addr = alu_out;
    assign ram_wdata = data_wdata;
endmodule
