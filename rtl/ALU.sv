import alupkg::*;
module ALU(
    input logic [31:0] a,
    input logic [31:0] b,
    input alu_op_e opcode,

    output logic [31:0] result,
    output logic zero
    );
    logic signed [31:0] signed_a;
    logic signed [31:0] signed_b;
    assign signed_a = $signed(a);
    assign signed_b = $signed(b);

    logic signed [63:0] mul_ss; //signed*signed
    logic signed [63:0] mul_su; //signed*unsigned
    logic [63:0] mul_uu;        //unsigned*unsigned

    assign mul_ss = signed_a*signed_b;
    assign mul_su = signed_a * $signed({1'b0,b});
    assign mul_uu = {32'b0,a}*{32'b0,b};

    always_comb begin
        result = 32'b0;
        case (opcode)
            ADD: result = a+b;
            SUB: result = a-b;
            AND: result = a&b;
            OR:  result = a|b;
            XOR: result = a^b;

            SLL: result = a << b[4:0];
            SRL: result = a >> b[4:0];
            SRA: result = signed_a >>> b[4:0];

            SLT: result = (signed_a < signed_b)? 32'b1:32'b0;
            SLTU: result = (a < b)? 32'b1:32'b0;

            MUL:    result = mul_ss[31:0];
            MULH:   result = mul_ss[63:32];
            MULHSU: result = mul_su[62:32];
            MULHU:  result = mul_uu[63:32];

            DIV: begin
                if (b == 0) 
                    result = 32'hFFFFFFFF; // Div by zero rule
                else if (signed_a == -32'd2147483648 && signed_b == -1) 
                    result = signed_a;     // Overflow rule
                else 
                    result = signed_a / signed_b;
            end
            DIVU: begin
                if (b == 0) result = 32'hFFFFFFFF;
                else        result = a / b;
            end
            REM: begin
                if (b == 0) 
                    result = a; // Remainder by zero rule
                else if (signed_a == -32'd2147483648 && signed_b == -1) 
                    result = 32'b0; // Overflow rule
                else 
                    result = signed_a % signed_b;
            end
            REMU: begin
                if (b == 0) result = a;
                else        result = a % b;
            end
            default: result = 32'b0;
        endcase
    end
    assign zero = (result==32'b0);
endmodule
