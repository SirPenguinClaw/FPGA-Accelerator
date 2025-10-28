module example1_tb();
    
    // Declare signals
    // Global signals
    logic clk;

    // Signals
    logic a, b, sum, carry;

    example1 iDUT( .a(a), .b(b), .sum(sum), .carry(carry));

    // Generate clk
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        a = 1;
        b = 1;

        @(posedge clk); 
        $display("sum=%d, carry=%d", sum, carry);
    end

endmodule