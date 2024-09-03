`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 09:12:15
// Design Name: 
// Module Name: BitExample
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



   
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 2018/07/30 21:43:04
    // Design Name: 
    // Module Name: BitComputer_Top
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
    
    //{ input      CLK100MHZ,
        //按key--d，发声
    //}
    module BitExample(
        input        clk,
        input      rst_n,
        input wire            key_l, //正面上下左右中间
        input wire            key_r,
        input wire            key_u,
        input wire            key_d,
        input wire         key_c,//center
        input wire [7:0]    sw, //source  
        output wire [7:0]  led,
        output wire buzzer, 
        
         //seg7
           output    wire [6:0] seg7_0_7bit,
           output   wire  [6:0] seg7_1_7bit,
           output   wire  [3:0] seg7_0_an,//段选
           output    wire [3:0] seg7_1_an,
           output   wire  seg7_0_dp,
           output    wire seg7_1_dp,
           
        //rs232
         input            rxd,        // RS232 RXD pin
         output    wire       txd,        // RS232 RXD pin
        //vga
            output wire[3:0] VGA_B,
            output wire[3:0] VGA_R,
            output wire [3:0] VGA_G,
            output wire VGA_HS,
            output wire VGA_VS,//,
        
        inout  [6:0]       EXT_IO);
        
        reg [31:0] count;
        wire clk50m;//_out;
        wire [29:0] rgb30;  
        
        always @(posedge clk or negedge rst_n)
        begin 
            if(!rst_n)
             count <= 0;
             else count <= count+1;    
        end
        assign led = count[31:24];
        
        
        seg7decimal seg7_0(
            .x          (count[31:16]),
            .clk        (clk),
            .clr        (rst_n),
            .a_to_g     (seg7_0_7bit),
            .an         (seg7_0_an),
            .dp         (seg7_0_dp)
            );
        
          seg7decimal seg7_1(
            .x          (count[31:16]),
            .clk        (clk),
            .clr        (rst_n),
            .a_to_g     (seg7_1_7bit),
            .an         (seg7_1_an),
            .dp         (seg7_1_dp)
            );
        
             
            
             
             vga_char vga0(    .clk(clk), .rst_n(rst_n), .hsync(VGA_HS), .vsync(VGA_VS),.vga_r(VGA_R),.vga_g(VGA_G),.vga_b(VGA_B));    // VGA控制
                   
              //buzzer
             // clk_wiz_0 pll0(.clkin(clk),.reset(key_u),.c0(clk50m));
              beep beep0(.clk_50M(clk),.rst(key_d),.speaker(buzzer));
             
        
   
        
    endmodule


