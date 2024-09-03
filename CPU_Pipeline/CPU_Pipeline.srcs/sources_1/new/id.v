`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 14:18:26
// Design Name: 
// Module Name: id
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
`include "predef.vh"

module id(
//    input           clk,
//    input           rst,

//    input   [5:0]   opcode,
//    input   [5:0]   func,
    input   [31:0]  instr,      //from if
    input   [4:0]   pre_inst_id,//from ex
    input   [31:0]  reg_rd1,    //from regfile
    input   [31:0]  reg_rd2,    //from regfile
    input           ex_reg_we,  //from ex
    input   [4:0]   ex_reg_wa,  //from ex
    input   [31:0]  ex_reg_wdata,//from ex
    input           mem_reg_we, //from mem
    input   [4:0]   mem_reg_wa, //from mem
    input   [31:0]  mem_reg_wdata,//from mem
    
    //output          cu_c1,  // using  c1 ? imm      : rt        as  alu_in2
    //output          cu_c2,  // using  c2 ? imm      : rs        as  alu_in1
    //output          cu_c3,  // using  c3 ? rd       : rt        as  alu_out
    output          cu_c4,  // using  c4 ? alu_out  : d_rdata   as  reg_wd
    output  [3:0]   cu_cA,  // alu cmd
    output  [4:0]   inst_id,
    output          pausereq,
    output          pc_jmp,
    output          pc_br,
    output  [15:0]  pc_offset,
    output  [25:0]  pc_target,
    output   [4:0]  reg_ra1,    //to regfile
    output   [4:0]  reg_ra2,    //to regfile
    output  [31:0]  alu_in1,    // in: imem, reg
    output  [31:0]  alu_in2,    // in: imem, reg
    output   [4:0]  reg_wa,
    output          data_we,
    output  [31:0]  data_wdata,
    output          reg_we
    );
    wire [5:0] opcode;
    wire [5:0] func;
    wire cu_c1;
    wire cu_c2;
    wire cu_c3;
    wire cu_br;
    assign opcode = instr[31:26];
    assign func   = instr[5:0];

    assign inst_id = get_inst_id(opcode, func);
    function [4:0] get_inst_id(input [5:0] opcode, input [5:0] func);
    begin
        case (opcode)
            `INST_LUI   : get_inst_id = `ID_LUI;
            `INST_ORI   : get_inst_id = `ID_ORI;
            `INST_ADDIU : get_inst_id = `ID_ADDIU;
            `INST_SW    : get_inst_id = `ID_SW;
            `INST_LW    : get_inst_id = `ID_LW;
            `INST_BEQ   : get_inst_id = `ID_BEQ;
            `INST_J     : get_inst_id = `ID_J;
            `INST_XORI  : get_inst_id = `ID_XORI;
            `INST_ANDI  : get_inst_id = `ID_ANDI;
            `INST_ADDI  : get_inst_id = `ID_ADDI;
            `INST_FUNC  : begin
                case (func)
                    `FUNC_ADD   : get_inst_id = `ID_ADD;
                    `FUNC_SUB   : get_inst_id = `ID_SUB;
                    `FUNC_XOR   : get_inst_id = `ID_XOR;
                    `FUNC_AND   : get_inst_id = `ID_AND;
                    `FUNC_OR    : get_inst_id = `ID_OR;
                    `FUNC_NOR   : get_inst_id = `ID_NOR;
                    `FUNC_ADDU  : get_inst_id = `ID_ADDU;
                    default     : get_inst_id = `ID_NULL;
                endcase
            end
            default     : get_inst_id = `ID_NULL;
        endcase
    end
    endfunction

    reg [17:0] mask_c1 = 18'b000000111110010011;
    assign cu_c1  = mask_c1[inst_id];

    assign cu_c2  = 1'b0;

    reg [17:0] mask_c3 = 18'b011111000001100000;
    assign cu_c3  = mask_c3[inst_id];
    assign reg_wa   = (cu_c3 == 1) ? instr[15:11] : instr[20:16];

    assign cu_c4  = (inst_id == `ID_LW ) ? 1 : 0;

    assign cu_cA  = get_alu_op(inst_id);
    function [3:0] get_alu_op(input [4:0] inst_id);
    begin
        case (inst_id)
            `ID_SW, `ID_LW, `ID_ADD : get_alu_op = `ALU_ADD;
            `ID_SUB                 : get_alu_op = `ALU_SUB;
            `ID_LUI                 : get_alu_op = `ALU_LUI;
            `ID_BEQ                 : get_alu_op = `ALU_SUB;
            `ID_ORI                 : get_alu_op = `ALU_ORI;
            `ID_ADDIU               : get_alu_op = `ALU_ADDU;
            `ID_ADDU                : get_alu_op = `ALU_ADDU;
            `ID_XOR                 : get_alu_op = `ALU_XOR;
            `ID_AND                 : get_alu_op = `ALU_AND;
            `ID_OR                  : get_alu_op = `ALU_OR;
            `ID_NOR                 : get_alu_op = `ALU_NOR;
            `ID_XORI                : get_alu_op = `ALU_XORI;
            `ID_ANDI                : get_alu_op = `ALU_ANDI;
            `ID_ADDI                : get_alu_op = `ALU_ADD;
            default                 : get_alu_op = `ALU_NULL;
        endcase
    end
    endfunction
    
    assign pc_jmp = (inst_id == `ID_J  ) ? 1 : 0;
    assign pc_target   = instr[25:0];

    reg [17:0] mask_regwe = 18'b011111111111110010;
    assign reg_we = mask_regwe[inst_id];

    wire [31:0] imm_e;
    assign imm_e    = {{16{instr[15]}}, instr[15:0]};

    assign reg_ra1 = instr[25:21];
    assign reg_ra2 = instr[20:16];

    reg pausereq_for_reg1_load;
    reg pausereq_for_reg2_load;
    wire pre_inst_is_load = (pre_inst_id == `ID_LW) ? 1'b1 : 1'b0;

    always @(*) begin
        if(pre_inst_is_load==1'b1 && ex_reg_we==1'b1 && ex_reg_wa==reg_ra1) begin
            pausereq_for_reg1_load <= 1'b1;
        end
        else pausereq_for_reg1_load <= 1'b0;
    end
    always @(*) begin
        if(pre_inst_is_load==1'b1 && ex_reg_we==1'b1 && ex_reg_wa==reg_ra2) begin
            pausereq_for_reg2_load <= 1'b1;
        end
        else pausereq_for_reg2_load <= 1'b0;
    end

    assign pausereq = pausereq_for_reg1_load | pausereq_for_reg2_load;

    assign alu_in1 = (cu_c2 == 1) ? imm_e : 
                     ((ex_reg_we==1'b1)&&(ex_reg_wa==reg_ra1)) ? ex_reg_wdata :
                     ((mem_reg_we==1'b1)&&(mem_reg_wa==reg_ra1)) ? mem_reg_wdata : reg_rd1;
    assign alu_in2 = (cu_c1 == 1) ? imm_e :
                     ((ex_reg_we==1'b1)&&(ex_reg_wa==reg_ra2)) ? ex_reg_wdata :
                     ((mem_reg_we==1'b1)&&(mem_reg_wa==reg_ra2)) ? mem_reg_wdata : reg_rd2;

    assign data_we   = (inst_id == `ID_SW ) ? 1 : 0;
    assign data_wdata = (data_we == 1'b0) ? 32'h00000000 :
                        ((ex_reg_we==1'b1)&&(ex_reg_wa==reg_ra2)) ? ex_reg_wdata :
                        ((mem_reg_we==1'b1)&&(mem_reg_wa==reg_ra2)) ? mem_reg_wdata : reg_rd2;

    assign cu_br  = (inst_id == `ID_BEQ) ? 1 : 0;
    assign pc_br  = (cu_br == 1'b1) && (alu_in1 == alu_in2);
    assign pc_offset   = instr[15:0];
endmodule
