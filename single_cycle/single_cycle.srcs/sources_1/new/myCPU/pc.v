`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/20 20:35:35
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
    
    input           pc_jmp,
    input           pc_br,
    input   [15:0]  pc_off,
    input   [25:0]  pc_tgt,
    
    output  [31:0]  pc_val
    );
    
    reg [31:0] pc_reg;
    
    wire [31:0] pc_ds;  // delay slot
    assign pc_ds = pc_reg + 32'h4;
        
//    wire [31:0] new_pc = (pc_jmp == 1) ? pc_tgt : (pc_reg + ((pc_br == 1) ? (pc_off << 2 + 32'h4) : 32'h4));
    
    always @(posedge clk or negedge rst) begin
        if (!rst) pc_reg <= 32'hbfc00000;
        else if (pc_jmp) pc_reg <= {pc_ds[31:28], pc_tgt[25:0], 2'b00};
        else if (pc_br) pc_reg <= pc_ds + (pc_off << 2);
        else pc_reg <= pc_ds;
    end
    
    assign pc_val = pc_reg;
    
endmodule
