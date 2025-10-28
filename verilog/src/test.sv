module test(input a, b, output sum, carry);
    assign sum = a ^ b;      // XOR for sum
    assign carry = a & b;    // AND for carry
endmodule