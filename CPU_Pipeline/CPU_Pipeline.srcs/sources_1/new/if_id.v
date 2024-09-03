`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 14:13:19
// Design Name: 
// Module Name: if_id
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


module if_id(
    input           clk,
    input           rst,

    input   [5:0]   pause,
    input   [31:0]  if_inst,

    output reg[31:0] id_inst
    );

    always @(posedge clk) begin
        if(!rst) begin
            id_inst <= 32'h00000000;
        end
        else if(pause[1]==1'b1 && pause[2]==1'b0) begin
            id_inst <= 32'h00000000;
        end 
        else if(pause[1]==1'b0) begin
            id_inst <= if_inst;
        end
    end
endmodule
