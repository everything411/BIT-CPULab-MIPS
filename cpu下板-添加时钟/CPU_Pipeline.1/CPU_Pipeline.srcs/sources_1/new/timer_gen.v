
`timescale 1ns / 1ps
module timer_gen # (
    parameter   CLK_FREQ = 100000000       
    ) (
    input               i_sys_rst           ,
    input               i_sys_clk           , 
    output  reg         o_tick_10hz   
    );
    reg         o_pulse_1khz        ; 
    reg         o_pulse_100hz       ; 
    reg         o_pulse_10hz       ; 
    reg         o_pulse_1hz        ; 
    reg         o_tick_1khz        ; 
    reg         o_tick_100hz       ; 
    reg         o_tick_1hz          ;  
    reg [15:0]  r_cnt_1khz      ; // 62500
    reg [2:0]   r_cnt_100hz     ;
    reg [2:0]   r_cnt_10hz      ;
    reg [2:0]   r_cnt_1hz       ;
    reg         r_clk_1khz      ;
    reg         r_clk_1khz_d0   ;
    reg         r_clk_100hz     ;
    reg         r_clk_100hz_d0  ; 
    reg         r_clk_10hz      ;
    reg         r_clk_10hz_d0   ; 
    reg         r_clk_1hz       ;
    reg         r_clk_1hz_d0    ; 
 
    always @ (posedge i_sys_clk)
    begin
        if (i_sys_rst)
        begin
            r_cnt_1khz  <= 16'd0;
            r_clk_1khz  <= 1'b0;
        end
        else if (r_cnt_1khz == (CLK_FREQ / 2000) - 1)
        begin
            r_cnt_1khz  <= 16'd0;
            r_clk_1khz  <= ~r_clk_1khz;
        end
        else
        begin
            r_cnt_1khz  <= r_cnt_1khz + 1'b1;
            r_clk_1khz  <= r_clk_1khz;
        end
    end
 
    always @ (posedge i_sys_clk)
    begin
        r_clk_1khz_d0   <= r_clk_1khz;
        if (i_sys_rst)
        begin
            r_cnt_100hz <= 4'd0;
            r_clk_100hz <= 1'b0;
        end
        else if (~r_clk_1khz_d0 & r_clk_1khz)
        begin
            if (r_cnt_100hz == 4'd4)
            begin
                r_cnt_100hz <= 4'd0;
                r_clk_100hz <= ~r_clk_100hz;
            end
            else
            begin
                r_cnt_100hz <= r_cnt_100hz + 1'b1;
                r_clk_100hz <= r_clk_100hz;
            end
        end
    end
 
    always @ (posedge i_sys_clk)
    begin
        r_clk_100hz_d0  <= r_clk_100hz;
        if (i_sys_rst)
        begin
            r_cnt_10hz  <= 4'd0;
            r_clk_10hz  <= 1'b0;
        end
        else if (~r_clk_100hz_d0 & r_clk_100hz)
        begin
            if (r_cnt_10hz == 4'd4)
            begin
                r_cnt_10hz  <= 0;
                r_clk_10hz  <= ~r_clk_10hz;
            end
            else
            begin
                r_cnt_10hz  <= r_cnt_10hz + 1'b1;
                r_clk_10hz  <= r_clk_10hz;
            end
        end
    end
 
    always @ (posedge i_sys_clk)
    begin
        r_clk_10hz_d0   <= r_clk_10hz;
        if (i_sys_rst)
        begin
            r_cnt_1hz   <= 4'd0;
            r_clk_1hz   <= 1'b0;
        end
        else if (~r_clk_10hz_d0 & r_clk_10hz)
        begin
            if (r_cnt_1hz == 4'd4)
            begin
                r_cnt_1hz   <= 4'd0;
                r_clk_1hz   <= ~r_clk_1hz;
            end
            else
            begin
                r_cnt_1hz   <= r_cnt_1hz + 1'b1;
                r_clk_1hz   <= r_clk_1hz;
            end
        end
    end
 
    always @ (posedge i_sys_clk)
    begin
        o_pulse_1khz    <= r_clk_1khz;
        o_pulse_100hz   <= r_clk_100hz;
        o_pulse_10hz    <= r_clk_10hz;
        o_pulse_1hz     <= r_clk_1hz;
        o_tick_1khz     <= r_clk_1khz & (~r_clk_1khz_d0);
        o_tick_100hz    <= r_clk_100hz & (~r_clk_100hz_d0);
        o_tick_10hz     <= r_clk_10hz & (~r_clk_10hz_d0);
        o_tick_1hz      <= r_clk_1hz & (~r_clk_1hz_d0);
    end
 
endmodule
