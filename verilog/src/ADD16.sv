`default_nettype none
module CLA4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,
    output logic [3:0] sum,
    output logic       cout,
    output logic       p,   // block propagate
    output logic       g    // block generate
);
    logic [3:0] p_bit, g_bit;
    logic [3:0] c;

    assign p_bit = a ^ b;
    assign g_bit = a & b;

    assign c[0] = cin;
    assign c[1] = g_bit[0] | (p_bit[0] & c[0]);
    assign c[2] = g_bit[1] | (p_bit[1] & c[1]);
    assign c[3] = g_bit[2] | (p_bit[2] & c[2]);
    assign cout = g_bit[3] | (p_bit[3] & c[3]);

    assign sum = p_bit ^ c;

    assign p = &p_bit; // all bits propagate -> propagate
    assign g = g_bit[3] | (p_bit[3] & g_bit[2]) | (p_bit[3] & p_bit[2] & g_bit[1]) | (p_bit[3] & p_bit[2] & p_bit[1] & g_bit[0]);
endmodule

module CLA16 (
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic        cin,
    output logic [15:0] sum,
    output logic        cout
);
    logic [3:0] p, g;
    logic [3:0] c;

    // Instantiate 4 CLA4 modules
    CLA4 cla0 (
        .a   (a[3:0]),
        .b   (b[3:0]),
        .cin (cin),
        .sum (sum[3:0]),
        .cout(), // not used
        .p   (p[0]),
        .g   (g[0])
    );
    CLA4 cla1 (
        .a   (a[7:4]),
        .b   (b[7:4]),
        .cin (c[1]),
        .sum (sum[7:4]),
        .cout(),
        .p   (p[1]),
        .g   (g[1])
    );
    CLA4 cla2 (
        .a   (a[11:8]),
        .b   (b[11:8]),
        .cin (c[2]),
        .sum (sum[11:8]),
        .cout(),
        .p   (p[2]),
        .g   (g[2])
    );
    CLA4 cla3 (
        .a   (a[15:12]),
        .b   (b[15:12]),
        .cin (c[3]),
        .sum (sum[15:12]),
        .cout(),
        .p   (p[3]),
        .g   (g[3])
    );

    // Carry calculation for each CLA4 block
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);
endmodule
`default_nettype wire