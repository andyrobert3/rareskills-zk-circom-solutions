pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

// Create a circuit that is satisfied if
// in[0] is the floor of the integer
// sqrt of in[1]. For example:
// 
// int[2, 5] accept
// int[2, 5] accept
// int[2, 9] reject
// int[3, 9] accept
//
// If b is the integer square root of a, then
// the following must be true:
//
// (b - 1)(b - 1) < a
// (b + 1)(b + 1) > a
// 
// be careful when verifying that you 
// handle the corner case of overflowing the 
// finite field. You should validate integer
// square roots, not modular square roots

template IntSqrt(n) {
    signal input in[2];

    // Check that in[0] is at least 1
    component GreaterEqThan = GreaterEqThan(n);
    GreaterEqThan.in[0] <== in[0];
    GreaterEqThan.in[1] <== 1;
    GreaterEqThan.out === 1;

    // Check if it overflows the field via the bits
    component num2bitsDecrement = Num2Bits(n);
    num2bitsDecrement.in <== (in[0] - 1) * (in[0] - 1);
    component num2bitsIncrement = Num2Bits(n);
    num2bitsIncrement.in <== (in[0] + 1) * (in[0] + 1);

    // Enforce integer square roots
    component isLessThan = LessEqThan(n);
    isLessThan.in[0] <== (in[0] - 1) * (in[0] - 1);
    isLessThan.in[1] <== in[1];
    isLessThan.out === 1;

    component isGreaterThan = GreaterThan(n);
    isGreaterThan.in[0] <== (in[0] + 1) * (in[0] + 1);
    isGreaterThan.in[1] <== in[1];
    isGreaterThan.out === 1;
}

component main = IntSqrt(252);
