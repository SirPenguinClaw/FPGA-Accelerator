`default_nettype none
module ADD4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,
    output logic [3:0] sum,
    output logic       cout
);
    logic [3:0] p, g;
    logic [4:0] c;

    // bit propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // carry chain: each carry depends on the previous carry
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // sums and final carry out
    assign sum  = p ^ c[3:0];
    assign cout = c[4];

endmodule
`default_nettype wire