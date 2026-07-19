import alupkg::*;

module tb_control();

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic funct7b30, funct7b25;

    logic regw, alusrc, memw, branch, jump, jalr_flag;
    logic [1:0] res_src, a_src;
    alu_op_e alu_control;

    Control dut (
        .opcode(opcode), .funct3(funct3), 
        .funct7b30(funct7b30), .funct7b25(funct7b25),
        .regw(regw), .alusrc(alusrc), .memw(memw), 
        .res_src(res_src), .a_src(a_src),
        .branch(branch), .jump(jump), .jalr_flag(jalr_flag),
        .alu_control(alu_control)
    );

    initial begin
        $display("Starting Control Unit Test...");
        $monitor("Time: %0t | Op: %b | RegW: %b | ALUSrc: %b | MemW: %b | ASrc: %b | ALU_Op: %0d", 
                 $time, opcode, regw, alusrc, memw, a_src, alu_control);

        // Test 1: R-Type ADD
        opcode = 7'b0110011; funct3 = 3'b000; funct7b30 = 0; funct7b25 = 0;
        #10; 
        if (regw !== 1 || alu_control !== ADD) $display("ERROR: R-Type ADD failed");

        // Test 2: R-Type SUB
        opcode = 7'b0110011; funct3 = 3'b000; funct7b30 = 1; funct7b25 = 0;
        #10;
        if (alu_control !== SUB) $display("ERROR: R-Type SUB failed");

        // Test 3: I-Type ADDI
        opcode = 7'b0010011; funct3 = 3'b000; funct7b30 = 0; funct7b25 = 0;
        #10;
        if (regw !== 1 || alusrc !== 1 || alu_control !== ADD) $display("ERROR: I-Type ADDI failed");

        // Test 4: Load Word (LW)
        opcode = 7'b0000011; funct3 = 3'b010; funct7b30 = 0; funct7b25 = 0;
        #10;
        if (memw !== 0 || res_src !== 2'b01 || alusrc !== 1) $display("ERROR: Load failed");

        // Test 5: Store Word (SW)
        opcode = 7'b0100011; funct3 = 3'b010; funct7b30 = 0; funct7b25 = 0;
        #10;
        if (memw !== 1 || regw !== 0) $display("ERROR: Store failed");

        // Test 6: Branch (BEQ)
        opcode = 7'b1100011; funct3 = 3'b000; funct7b30 = 0; funct7b25 = 0;
        #10;
        if (branch !== 1 || alu_control !== SUB) $display("ERROR: Branch failed");

        // Test 7: LUI 
        opcode = 7'b0110111; funct3 = 3'b000; funct7b30 = 0; funct7b25 = 0;
        #10;
        if (regw !== 1 || a_src !== 2'b10 || alu_control !== ADD) $display("ERROR: LUI failed");

        $display("Control Unit Test Complete!");
        $finish;
    end
endmodule