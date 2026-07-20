module imem(
    input  logic [31:0] addr,
    output logic [31:0] instr
);
    logic [31:0] ROM[0:1023];
    initial begin
        $readmemh("machine_code.hex", ROM); 
    end
    assign instr = ROM[addr[31:2]];

endmodule