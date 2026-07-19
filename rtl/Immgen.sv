module immgen(
    input logic [31:0] inst,
    output logic [31:0] immext
);
    logic [6:0] opcode;
    assign opcode = inst[6:0];

    always_comb begin
        case(opcode)
            // I-Type: ADDI, LW, JALR
            7'b0010011, 7'b0000011, 7'b1100111: immext = {{20{inst[31]}}, inst[31:20]};
            // S-Type: SW
            7'b0100011: 
                immext = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            // B-Type: BEQ, BNE, BLT...
            7'b1100011: 
                immext = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

            // U-Type: LUI, AUIPC
            7'b0110111, 7'b0010111: 
                immext = {inst[31:12], 12'b0};

            // J-Type: JAL
            7'b1101111: 
                immext = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

            default: immext = 32'b0;
        endcase
    end
endmodule