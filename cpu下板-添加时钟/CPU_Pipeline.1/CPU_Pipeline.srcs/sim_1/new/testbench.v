`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/10 11:02:59
// Design Name: 
// Module Name: testbench
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


module testbench(
    );
    reg clk;
    reg rstn;

    initial begin
        clk = 0;
        rstn = 0;
        # 100 rstn = 1;
    end

    always # 5 clk = ~clk;

    cpu_pipeline my_cpu_pipeline(
        .clk(clk),
        .rstn(rstn)
    );
endmodule
