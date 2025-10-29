module ADD64 (
    input  logic [63:0] a,
    input  logic [63:0] b,
    input  logic        cin,
    output logic [63:0] sum,
    output logic        cout
);

    logic [3:0] carry;
    logic [15:0] sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;
    logic carry1_0, carry1_1, carry2_0, carry2_1, carry3_0, carry3_1;

    // First 16 bits (no duplication)
    ADD16 add0 (
        .a   (a[15:0]),
        .b   (b[15:0]),
        .cin (cin),
        .sum (sum[15:0]),
        .cout(carry[0])
    );

    // Second 16 bits (carry-select)
    ADD16 add1_0 (
        .a   (a[31:16]),
        .b   (b[31:16]),
        .cin (1'b0),
        .sum (sum1_0),
        .cout(carry1_0)
    );
    ADD16 add1_1 (
        .a   (a[31:16]),
        .b   (b[31:16]),
        .cin (1'b1),
        .sum (sum1_1),
        .cout(carry1_1)
    );
    assign sum[31:16] = carry[0] ? sum1_1 : sum1_0;
    assign carry[1]   = carry[0] ? carry1_1 : carry1_0;

    // Third 16 bits (carry-select)
    ADD16 add2_0 (
        .a   (a[47:32]),
        .b   (b[47:32]),
        .cin (1'b0),
        .sum (sum2_0),
        .cout(carry2_0)
    );
    ADD16 add2_1 (
        .a   (a[47:32]),
        .b   (b[47:32]),
        .cin (1'b1),
        .sum (sum2_1),
        .cout(carry2_1)
    );
    assign sum[47:32] = carry[1] ? sum2_1 : sum2_0;
    assign carry[2]   = carry[1] ? carry2_1 : carry2_0;

    // Fourth 16 bits (carry-select)
    ADD16 add3_0 (
        .a   (a[63:48]),
        .b   (b[63:48]),
        .cin (1'b0),
        .sum (sum3_0),
        .cout(carry3_0)
    );
    ADD16 add3_1 (
        .a   (a[63:48]),
        .b   (b[63:48]),
        .cin (1'b1),
        .sum (sum3_1),
        .cout(carry3_1)
    );
    assign sum[63:48] = carry[2] ? sum3_1 : sum3_0;
    assign cout       = carry[2] ? carry3_1 : carry3_0;

endmodule