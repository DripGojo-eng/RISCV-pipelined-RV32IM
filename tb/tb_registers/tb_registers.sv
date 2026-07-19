module registers_tb();
    logic clk, w_ena;
    logic [4:0] a1, a2, a3;
    logic [31:0] wd, rd1, rd2;

    registers dut(.clk(clk),
    .w_ena(w_ena),
    .a1(a1), .a2(a2), .a3(a3),
    .wd(wd), .rd1(rd1), .rd2(rd2));
    
    always #5 clk = ~clk;

    initial begin
        clk = 0; w_ena = 0;
        $display("Testing Register File...");

        // 1. Write 100 to x5
        #10 w_ena = 1; a3 = 5'd5; wd = 32'd100;

        // 2. Read back from x5
        #10 w_ena = 0; a1 = 5'd5;
        #1  if (rd1 !== 32'd100) $display("Error: x5 failed");
            else $display("Success: x5 is 100");

        // 3. Test x0 hardwired to 0
        #10 w_ena = 1; a3 = 5'd0; wd = 32'hFFFFFFFF; 
        #10 w_ena = 0; a1 = 5'd0;
        #1  if (rd1 !== 32'd0) $display("Error: x0 is not 0!");
            else $display("Success: x0 is hardwired to 0");

        $finish; 
    end
endmodule