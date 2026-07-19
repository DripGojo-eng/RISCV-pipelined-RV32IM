`timescale 1ns/1ps
import alupkg::*;

module alu_tb();
    logic [31:0] a;
    logic [31:0] b;
    alu_op_e opcode;
    logic [31:0] result;
    logic zero;

    ALU dut(
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    initial begin
        $display("Starting ALU");
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        a = 32'd15; b = 32'd5; opcode = ADD; #10;
        if (result !== 32'd40) $error("ADD failed!");
        
        a = 32'd100; b = 32'd100; opcode = SUB; #10;
        if (result !== 32'd0) $error("SUB failed!");
        if (zero !== 1'b1) $error("Zero flag failed to assert!");

        a = -32'd16; b = 32'd2; opcode = SRA; #10;
        if ($signed(result) !== -32'd4) $error("SRA failed!");

        a = -32'd5; b = 32'd10; opcode = MULH; #10;

        if (result !== 32'hFFFFFFFF) $error("MULH failed!");

        a = 32'd42; b = 32'd0; opcode = DIV; #10;
        if (result !== 32'hFFFFFFFF) $error("DIV by zero failed RISC-V spec!");

        $display("Verification Complete. If no errors printed, the ALU is perfect!");
        $finish;
    end
endmodule