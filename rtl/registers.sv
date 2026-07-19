module registers(
    input logic clk, w_ena,
    input logic [4:0] a1, a2, a3,
    input logic [31:0] wd,
    output logic [31:0] rd1, rd2
);
    logic [31:0] regs [31:0];

    always_ff @(posedge clk) begin
        if(w_ena & (a3!=5'b0)) begin
            regs[a3] <= wd;
        end
    end

    assign rd1 = (a1==5'b0)? 32'b0:regs[a1];
    assign rd2 = (a2==5'b0)? 32'b0:regs[a2];
endmodule