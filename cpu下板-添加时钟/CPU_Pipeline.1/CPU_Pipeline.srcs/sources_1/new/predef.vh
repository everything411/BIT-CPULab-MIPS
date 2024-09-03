// inst & func def
`define INST_SW     6'b101011
`define INST_LW     6'b100011
`define INST_BEQ    6'b000100
`define INST_J      6'b000010
`define INST_ADDI   6'b001000
`define INST_ADDIU  6'b001001
`define INST_ANDI   6'b001100
`define INST_ORI    6'b001101
`define INST_XORI   6'b001110
`define INST_LUI    6'b001111
`define INST_FUNC   6'b000000
`define FUNC_NOP    6'b000000
`define FUNC_ADD    6'b100000
`define FUNC_ADDU   6'b100001
`define FUNC_SUB    6'b100010
`define FUNC_SUBU   6'b100011
`define FUNC_XOR    6'b100110
`define FUNC_AND    6'b100100
`define FUNC_OR     6'b100101
`define FUNC_NOR    6'b100111

// inst_type id def
`define ID_SW       0
`define ID_LW       1
`define ID_BEQ      2
`define ID_J        3
`define ID_LUI      4
`define ID_XOR      5
`define ID_ADD      6
`define ID_ADDIU    7
`define ID_ORI      8
`define ID_XORI     9
`define ID_ANDI     10
`define ID_ADDI     11
`define ID_ADDU     12
`define ID_AND      13
`define ID_OR       14
`define ID_NOR      15
`define ID_SUB      16
`define ID_NULL     17

// alu cmd def
`define ALU_ADD     0
`define ALU_SUB     1
`define ALU_AND     2
`define ALU_XOR     3
`define ALU_SLT     4
`define ALU_SLL     5
`define ALU_LUI     6
`define ALU_ADDU    7
`define ALU_ORI     8
`define ALU_XORI    9
`define ALU_ANDI    10
`define ALU_OR      11
`define ALU_NOR     12
`define ALU_NULL    13