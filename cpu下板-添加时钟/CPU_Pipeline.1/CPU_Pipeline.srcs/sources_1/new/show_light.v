`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/25 21:58:42
// Design Name: 
// Module Name: show_light
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


module show_light(
    input       I_clk,              //
    input       I_rst_n,            //
    input       [7:0] I_show_num,   //input data
    output      [6:0] O_led,        //段选
    output      [1:0] O_px          //位选
    );

    //parameter   C_COUNTER_NUM = 1000000;    
    parameter   C_COUNTER_NUM = 10; //计数器峰值

    reg  [3:0]  R_temp;             //当前显示的4bit数据寄存器        
    reg  [1:0]  R_px_temp;          //段选信号寄存器
    reg  [32:0] R_counter;          //计数器寄存器

    wire [7:0]  W_show_num; 

    assign W_show_num = I_show_num;

    always@(posedge I_clk or negedge I_rst_n)
    begin
        if(!I_rst_n)          
        begin       //reset
            R_px_temp <= 2'b01;
            R_temp <= W_show_num[3:0];
            R_counter <= 0;
        end
        else if(R_px_temp == 2'b01 && R_counter >= C_COUNTER_NUM)
        begin       //high 4-bit data
            R_temp <= W_show_num[7:4];
            R_px_temp <= 2'b10;
            R_counter <= 0;
        end
        else if(R_px_temp == 2'b10 && R_counter >= C_COUNTER_NUM)
        begin       //low 4-bit data
            R_temp <= W_show_num[3:0];
            R_px_temp <= 2'b01;
            R_counter <= 0;
        end
        else
        begin
            R_counter <= R_counter + 1;
        end
    end

    assign O_led[0] = (R_temp == 4'b0000||R_temp == 4'b0001||R_temp == 4'b0111
                            ||R_temp == 4'b1100)?0:1;
    assign O_led[1] = (R_temp == 4'b0001||R_temp == 4'b0010||R_temp == 4'b0011
                            ||R_temp == 4'b0111||R_temp == 4'b1101)?0:1;
    assign O_led[2] = (R_temp == 4'b0001||R_temp == 4'b0011||R_temp == 4'b0100
                            ||R_temp == 4'b0101||R_temp == 4'b0111||R_temp == 4'b1001)?0:1;
    assign O_led[3] = (R_temp == 4'b0001||R_temp == 4'b0100||R_temp == 4'b0111
                            ||R_temp == 4'b1010||R_temp == 4'b1111)?0:1;
    assign O_led[4] = (R_temp == 4'b0010||R_temp == 4'b1100||R_temp == 4'b1110
                            ||R_temp == 4'b1111)?0:1;
    assign O_led[5] = (R_temp == 4'b0101||R_temp == 4'b0110||R_temp == 4'b1011
                            ||R_temp == 4'b1100||R_temp == 4'b1110||R_temp == 4'b1111)?0:1;
    assign O_led[6] = (R_temp == 4'b0001||R_temp == 4'b0100||R_temp == 4'b1011
                            ||R_temp == 4'b1101)?0:1;
    assign O_px = R_px_temp;   
endmodule
