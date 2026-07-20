module dmem(
    input logic we, clk,
    input logic [31:0] addr, data,
    output logic [31:0] rdata
);
    reg [31:0] ram [0:1023];
    assign rdata = ram[addr[31:2]];
    always @(posedge clk) begin
        if(we) ram[addr[31:2]] <= data;
    end

endmodule