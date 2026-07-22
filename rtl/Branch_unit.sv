module branchunit(
    input  logic [31:0] rs1_data, rs2_data, pc, imm, 
    input  logic [2:0]  funct3,
    input  logic        branch, jump, jalr,

    output logic        branch_taken,
    output logic [31:0] branch_target
);

    logic eq, lt, ltu;
    logic condition_met;

    always_comb begin
        eq  = (rs1_data == rs2_data);
        lt  = ($signed(rs1_data) < $signed(rs2_data));
        ltu = (rs1_data < rs2_data);
    end

    always_comb begin
        if (branch) begin
            case (funct3)
                3'b000: condition_met = eq;
                3'b001: condition_met = !eq;
                3'b100: condition_met = lt;
                3'b101: condition_met = !lt;
                3'b110: condition_met = ltu;
                3'b111: condition_met = !ltu;
                default: condition_met = 1'b0;
            endcase
        end else begin
            condition_met = 1'b0;
        end
    end

    always_comb begin
        branch_taken = (branch & condition_met) | jump | jalr;
        
        if (jalr) begin
            branch_target = (rs1_data + imm) & 32'hFFFFFFFE;
        end else begin
            branch_target = pc + imm;
        end
    end

endmodule