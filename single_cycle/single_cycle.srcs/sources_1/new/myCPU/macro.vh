
// inst & func def
`define INST_LUI    6'b001111
`define INST_ORI    6'b001101
`define INST_SW     6'b101011
`define INST_LW     6'b100011
`define INST_BEQ    6'b000100
`define INST_J      6'b000010
`define INST_ADDIU  6'b001001
`define INST_FUNC   6'b000000
`define FUNC_ADD    6'b100000
`define FUNC_SUB    6'b100010

// inst_type id def
`define ID_SW       0
`define ID_LW       1
`define ID_BEQ      2
`define ID_J        3
`define ID_LUI      4
`define ID_ORI      5
`define ID_ADD      6
`define ID_NULL     7
`define ID_ADDIU    8
`define ID_SUB      9

// alu cmd def
`define ALU_ADD     0
`define ALU_SUB     1
`define ALU_AND     2
`define ALU_OR      3
`define ALU_SLT     4
`define ALU_SLL     5
`define ALU_LUI     6
`define ALU_NULL    7
`define ALU_ADDIU   8
`define ALU_SUB     9
