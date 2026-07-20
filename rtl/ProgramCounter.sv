module progcount(
    input logic clk, rst,
    input logic [31:0] nextpc,
    output logic [31:0] pc
);
    always_ff @(posedge clk or posedge rst) begin
        if(rst) pc<=32'b0;
        else pc<=nextpc;
    end
endmodule