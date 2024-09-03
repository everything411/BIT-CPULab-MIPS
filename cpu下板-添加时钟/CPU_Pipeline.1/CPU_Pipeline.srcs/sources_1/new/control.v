`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/12 18:47:43
// Design Name: 
// Module Name: control
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


module control(
    input           pausereq_from_id,
    input           pausereq_from_ex,
    output reg[5:0] pause
    );

    always @(*) begin
        if(pausereq_from_ex==1'b1) begin
            pause <= 6'b001111;
        end else if(pausereq_from_id==1'b1) begin
            pause <= 6'b000111;
        end else begin
            pause <= 6'b000000;
        end
    end
endmodule
