package alupkg;
typedef enum logic[4:0] {
    //Base integer ISA RV32I
    ADD,
    SUB,
    AND,
    OR,
    XOR,
    SLL,
    SRL,
    SRA,
    SLT,
    SLTU,


    //Extension ISA RV32IM 
    MUL,
    MULH,
    MULHSU,
    MULHU,
    DIV,
    DIVU,
    REM,
    REMU,

    //None OP
    NONE
} alu_op_e;

endpackage