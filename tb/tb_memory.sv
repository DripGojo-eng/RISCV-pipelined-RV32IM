module tb_memory();
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    logic [31:0] imem_addr;
    logic [31:0] imem_instr;

    imem dut_imem (
        .addr(imem_addr),
        .instr(imem_instr)
    );

    logic        dmem_we;
    logic [31:0] dmem_addr;
    logic [31:0] dmem_data;
    logic [31:0] dmem_rdata;

    dmem dut_dmem (
        .clk(clk),
        .we(dmem_we),
        .addr(dmem_addr),
        .data(dmem_data),
        .rdata(dmem_rdata)
    );

    initial begin
        $display("        Starting Memory Tests           ");
        
        $monitor("Time: %0t | IMEM[Addr:%0d]=%h | DMEM[WE:%b, Addr:%0d] W:%h -> R:%h", 
                 $time, imem_addr, imem_instr, dmem_we, dmem_addr, dmem_data, dmem_rdata);

        imem_addr = 0;
        dmem_we   = 0;
        dmem_addr = 0;
        dmem_data = 0;
        #10;
        $display("\n--- Testing IMEM Reads ---");
        imem_addr = 32'd0; 
        #10;
        
        imem_addr = 32'd4; 
        #10;
        
        imem_addr = 32'd8; 
        #10;
        $display("\n--- Testing DMEM Writes and Reads ---");
        
        @(negedge clk);
        dmem_we   = 1;
        dmem_addr = 32'd12;
        dmem_data = 32'hDEADBEEF;

        @(negedge clk);
        dmem_addr = 32'd16;
        dmem_data = 32'hCAFEBABE;

        @(negedge clk);
        dmem_we   = 0;
        dmem_addr = 32'd12; 
        
        @(negedge clk);
        dmem_addr = 32'd16; 
        
        @(negedge clk);
        $display("\nMemory Tests Complete!");
        $finish;
    end
endmodule