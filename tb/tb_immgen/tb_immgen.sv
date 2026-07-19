`timescale 1ns/1ps

module immgen_tb();

    logic [31:0] inst;
    logic [31:0] immext;

    immgen dut (
        .inst(inst),
        .immext(immext)
    );

    initial begin
        $dumpfile("immgen.vcd");
        $dumpvars(0, immgen_tb);

        $display("Starting ImmGen Verification...");

        // 1. Test I-Type (ADDI x1, x0, 1) -> 0x00100093
        // Opcode: 0010011, Imm: 000000000001 (1)
        inst = 32'h00100093; #10;
        $display("I-Type: inst=%h, imm=%d (expected 1)", inst, $signed(immext));

        // 2. Test S-Type (SW x2, 4(x1)) -> 0x0020A223
        // Opcode: 0100011, Imm: 4
        inst = 32'h0020A223; #10;
        $display("S-Type: inst=%h, imm=%d (expected 4)", inst, $signed(immext));

        // 3. Test U-Type (LUI x1, 0x12345) -> 0x123450B7
        inst = 32'h123450B7; #10;
        $display("U-Type: inst=%h, imm=%h (expected 12345000)", inst, immext);

        // 4. Test Negative I-Type (ADDI x1, x0, -1) -> 0xFFF00093
        inst = 32'hFFF00093; #10;
        $display("Neg I-Type: inst=%h, imm=%d (expected -1)", inst, $signed(immext));

        $display("ImmGen Verification Complete.");
        $finish;
    end
endmodule