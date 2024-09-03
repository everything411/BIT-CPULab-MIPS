`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2016 11:10:38 AM
// Design Name: 
// Module Name: vga_char
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


module vga_char(	
				clk,rst_n,		
				hsync,vsync,vga_r,vga_g,vga_b	// VGA����
			);

    input clk;	    // 100MHz
    input rst_n;	//��λ�ź� �޸�ע��
    output hsync;	      //��ͬ���ź�
    output vsync;	      //��ͬ���ź�
    output[3:0] vga_r;    //��ɫ����ź�
    output[3:0] vga_g;     //��ɫ����ź�
    output[3:0] vga_b;      //��ɫ����ź�

    reg[9:0] x_cnt;		//������
    reg[9:0] y_cnt;		//������
    reg clk_vga=0;    //vgaʱ��
    reg clk_cnt=0;     //��Ƶ����

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)  
            clk_vga <= 1'b0;
	    else if(clk_cnt==1)begin
	       clk_vga <= ~clk_vga;
	       clk_cnt<=0; 
        end
        else
            clk_cnt <= clk_cnt+1;
     end


        reg valid_yr;	//����ʾ��Ч�ź�
      always @ (posedge clk_vga or negedge rst_n)begin //480��
          if(!rst_n) valid_yr <= 1'b0;
          else if(y_cnt == 10'd32) valid_yr <= 1'b1;
          else if(y_cnt == 10'd511) valid_yr <= 1'b0;    
       end

      wire valid_y = valid_yr;

      reg valid_r;    
      always @ (posedge clk_vga or negedge rst_n)begin //640��
          if(!rst_n) valid_r <= 1'b0;
          else if((x_cnt == 10'd141) && valid_y) valid_r <= 1'b1;
          else if((x_cnt == 10'd781) && valid_y) valid_r <= 1'b0;
      end
      wire valid = valid_r;    

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) x_cnt <= 10'd0;
        else if(x_cnt == 10'd799) x_cnt <= 10'd0;
        else x_cnt <= x_cnt+1'b1;
     end

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) y_cnt <= 10'd0;
        else if(y_cnt == 10'd524) y_cnt <= 10'd0;
        else if(x_cnt == 10'd799) y_cnt <= y_cnt+1'b1;
     end

	// VGA��ͬ��,��ͬ���ź�
    reg hsync_r,vsync_r;	

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) hsync_r <= 1'b1;								
        else if(x_cnt == 10'd0) hsync_r <= 1'b0;	//����hsync�ź�
        else if(x_cnt == 10'd96) hsync_r <= 1'b1;
    end

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) vsync_r <= 1'b1;							
        else if(y_cnt == 10'd0) vsync_r <= 1'b0;	//����vsync�ź�
        else if(y_cnt == 10'd2) vsync_r <= 1'b1;
     end

    assign hsync = hsync_r;
    assign vsync = vsync_r;
    //�ֱ���640*480
    wire[9:0] x_dis;		//��������ʾ��Ч�����������ֵ0-639
    wire[9:0] y_dis;		//��������ʾ��Ч�����������ֵ0-479

    //��ȥ��������ת������������640*480
    assign x_dis = x_cnt - 10'd142;
 assign y_dis = y_cnt - 10'd33;
    parameter 		//"FPGA"�ĸ��ַ����ֿ�
                    char_line00 = 128'hFFFFFFFC07FFC00001FFF0000007C000,
                    char_line01 = 128'hFFFFFFFC07FFE00003FFF800000FE000,
                    char_line02 = 128'hFFFFFFFC07FFF00007FFFC00001CF000,
                    char_line03 = 128'hFFFFFFFC0783F8000FE0FE00001CF000,
                    char_line04 = 128'hFFFFFFFC0780FC001FC07F00003CF800,
                    char_line05 = 128'hFF80000007807E003F803F0000387800,
                    char_line06 = 128'hFF80000007803F007F001F0000787C00,
                    char_line07 = 128'hFF80000007801F007F00000000703C00,
                    char_line08 = 128'hFF80000007800F007E00000000F03E00,
                    char_line09 = 128'hFF80000007800F007C00000000E01E00,
                    char_line0a = 128'hFF80000007800F007800000001E01F00,
                    char_line0b = 128'hFF80000007801F0078FFFFF001C00F00,
                    char_line0c = 128'hFF80000007803F0078FFFFF003C00F80,
                    char_line0d = 128'hFF80000007807F0078FFFFF003800780,
                    char_line0e = 128'hFF8000000780FE0078FFFFF0078007C0,
                    char_line0f = 128'hFFFFFE000781FC0078007C0007FFFFC0,
                    char_line10 = 128'hFFFFFE000783F80078007C000FFFFFE0,
                    char_line11 = 128'hFFFFFE0007FFF00078007C000FFFFFE0,
                    char_line12 = 128'hFF80000007FFE00078007C001F8003F0,
                    char_line13 = 128'hFF80000007FFC00078007C001F8003F0,
                    char_line14 = 128'hFF8000000780000078007C003F8003F8,
                    char_line15 = 128'hFF8000000780000078007C003F0001F8,
                    char_line16 = 128'hFF800000078000007C00FC003E0000F8,
                    char_line17 = 128'hFF800000078000007E01FC003C000078,
                    char_line18 = 128'hFF800000078000007F03FC003C000078,
                    char_line19 = 128'hFF800000078000007F87FC003C000078,
                    char_line1a = 128'hFF800000078000003FFFFC003C000078,
                    char_line1b = 128'hFF800000078000001FFFFC003C000078,
                    char_line1c = 128'hFF800000078000000FFFFC003C000078,
                    char_line1d = 128'hFF8000000780000007FFF8003C000078,
                    char_line1e = 128'hFF8000000780000003FFF0003C000078,
                    char_line1f = 128'hFF8000000780000001FFE0007F0001FC;

    reg[6:0] char_bit;	
    always @(posedge clk_vga or negedge rst_n) //��640*480������ѡȡλ����ʾ�ַ�"FPGA"
        if(!rst_n) char_bit <= 7'h7f;
        else if(x_cnt == 10'd400) char_bit <= 7'd128;	//����ʾ��λ��yi�εݼ�
        else if(x_cnt > 10'd400 && x_cnt < 10'd528) char_bit <= char_bit-1'b1;

    reg[11:0] vga_rgb;
    always @ (posedge clk_vga) begin//���ÿһ�е��źţ�
        if(!valid) vga_rgb <= 12'b0000_0000_0000;
        else if(x_cnt >= 10'd400 && x_cnt < 10'd528) begin//=
            case(y_dis)
                10'd200: if(char_line00[char_bit]) vga_rgb <= 12'b1111_1111_1111;														//��ɫ���壬�������趨
                         else vga_rgb <= 12'b0000_0000_0000;	
                10'd201: if(char_line01[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;   
                10'd202: if(char_line02[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   
                10'd203: if(char_line03[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd204: if(char_line04[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;   
                10'd205: if(char_line05[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;  
                10'd206: if(char_line06[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;  
                10'd207: if(char_line07[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_00;	
                10'd208: if(char_line08[char_bit])vga_rgb <=12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;   
                10'd209: if(char_line09[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   
                10'd210: if(char_line0a[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;  			
                10'd211: if(char_line0b[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   			
                10'd212: if(char_line0c[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd213: if(char_line0d[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd214: if(char_line0e[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd215: if(char_line0f[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;                            
                10'd216: if(char_line10[char_bit]) vga_rgb <= 12'b1111_1111_1111;	
                      else vga_rgb <= 12'b0000_0000_0000;    
                10'd217: if(char_line11[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;   
                10'd218: if(char_line11[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd219: if(char_line13[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd220: if(char_line14[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                        else vga_rgb <= 12'b0000_0000_0000;   
                10'd221: if(char_line15[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   	
                10'd222: if(char_line16[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd223: if(char_line17[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    	
                10'd224: if(char_line18[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd225: if(char_line19[char_bit])vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd226: if(char_line1a[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    			
                10'd227: if(char_line1b[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    		
                10'd228: if(char_line1c[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd229: if(char_line1d[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                        else vga_rgb <= 12'b0000_0000_0000;    	
                10'd230: if(char_line1e[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   
                10'd231: if(char_line1f[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    			
            default: vga_rgb <= 12'h000;
            endcase
        end
        else vga_rgb <= 12'h000; 
    end  
    //basys3�ϵ�����ɫ����λ�����źţ���������ѡ�����λ��
    assign vga_r = vga_rgb[11:8];
    assign vga_g = vga_rgb[7:4];
    assign vga_b = vga_rgb[3:0];
endmodule

