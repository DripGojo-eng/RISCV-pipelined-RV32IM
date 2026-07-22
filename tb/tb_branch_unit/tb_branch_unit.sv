module tb_branch_unit();

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] pc;
    logic [31:0] imm;
    logic [2:0]  funct3;
    logic        branch;
    logic        jump;
    logic        jalr;

    logic        branch_taken;
    logic [31:0] branch_target;

    wire signed [31:0] rs1_signed = rs1_data;
    wire signed [31:0] rs2_signed = rs2_data;

    branchunit dut (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .pc(pc),
        .imm(imm),
        .funct3(funct3),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    initial begin
        $display("========================================");
        $display("       Branch Unit Verification         ");
        $display("========================================");
        
        // Updated $monitor to use the new intermediate signed wires
        $monitor("Time:%0t | Br:%b Jmp:%b JALR:%b f3:%b | rs1:%d rs2:%d | Taken:%b Target:%h", 
                 $time, branch, jump, jalr, funct3, rs1_signed, rs2_signed, branch_taken, branch_target);

        rs1_data = 0; rs2_data = 0; pc = 32'h00000040; imm = 32'h00000010;
        funct3 = 0; branch = 0; jump = 0; jalr = 0;
        #10;

        $display("\n--- Testing BEQ ---");
        branch = 1; funct3 = 3'b000; 
        
        rs1_data = 32'd50; rs2_data = 32'd50;
        #10;
        if (branch_taken !== 1 || branch_target !== 32'h00000050) $display("FAIL: BEQ Taken");

        rs1_data = 32'd50; rs2_data = 32'd51;
        #10;
        if (branch_taken !== 0) $display("FAIL: BEQ Not Taken");

        $display("\n--- Testing BLT (Signed) ---");
        funct3 = 3'b100;
        
        rs1_data = -32'd5; rs2_data = 32'd5;
        #10;
        if (branch_taken !== 1) $display("FAIL: BLT Taken");

        rs1_data = 32'd5; rs2_data = -32'd5;
        #10;
        if (branch_taken !== 0) $display("FAIL: BLT Not Taken");

        $display("\n--- Testing BLTU (Unsigned) ---");
        funct3 = 3'b110;
        
        rs1_data = -32'd5; rs2_data = 32'd5;
        #10;
        if (branch_taken !== 0) $display("FAIL: BLTU Not Taken");

        $display("\n--- Testing JAL & JALR ---");
        branch = 0; 
        
        jump = 1; jalr = 0; pc = 32'h00000100; imm = 32'h00000020;
        #10;
        if (branch_taken !== 1 || branch_target !== 32'h00000120) $display("FAIL: JAL");

        jump = 0; jalr = 1; rs1_data = 32'h00000201; imm = 32'h00000010;
        #10;
        if (branch_taken !== 1 || branch_target !== 32'h00000210) $display("FAIL: JALR");

        $display("\nVerification Complete!");
        $finish;
    end

endmodule