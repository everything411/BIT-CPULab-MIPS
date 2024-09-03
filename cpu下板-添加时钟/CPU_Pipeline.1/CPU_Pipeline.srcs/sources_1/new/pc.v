`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 13:52:55
// Design Name: 
// Module Name: pc
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


module pc(
    input           clk,
    input           rst,
    
    input   [5:0]   pause,  //from control
    input           pc_jmp,
    input           pc_br,
    input   [15:0]  pc_offset,
    input   [25:0]  pc_target,
    
    output  [31:0]  pc_value
    );
    reg [31:0] pc_reg;
    wire [31:0] pc_ds;  // delay slot
    assign pc_ds = pc_reg + 32'h4;

    always @(posedge clk) begin
        if (!rst) pc_reg <= 32'h00000000;
        else if (pause[0]==1'b0) begin
            if (pc_jmp) pc_reg <= {pc_ds[31:28], pc_target[25:0], 2'b00};
            else if (pc_br) pc_reg <= pc_reg + (pc_offset << 2);
            else pc_reg <= pc_ds;
        end
    end
    
    assign pc_value = pc_reg;
endmodule
