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

    // Input range checks
    component lteA = LessEqThan(n);
    lteA.in[0] <== in[0];
    lteA.in[1] <== (2 ** n) - 1;
    lteA.out === 1;

    component lteB = LessEqThan(n);
    lteB.in[0] <== in[1];
    lteB.in[1] <== (2 ** n) - 1;
    lteB.out === 1;

    // Special cases:
    // 1. a -> 0, b -> 0
    // 2. a -> 1, b -> 1
    component isAZeroBZero = IsEqual();
    isAZeroBZero.in[0] <== in[0];
    isAZeroBZero.in[1] <== 0;
    signal c1 <== isAZeroBZero.out;

    component isAOneBOne = IsEqual();
    isAOneBOne.in[0] <== in[0];
    isAOneBOne.in[1] <== 1;
    signal c2 <== isAOneBOne.out;

    // Else condition
    signal c3 <== 1 - (c1 + c2);

    // Enforce integer square roots
    component isLessThan = LessEqThan(n);
    isLessThan.in[0] <== (in[0] - 1) * (in[0] - 1);
    isLessThan.in[1] <== in[1];

    component isGreaterThan = GreaterThan(n);
    isGreaterThan.in[0] <== (in[0] + 1) * (in[0] + 1);
    isGreaterThan.in[1] <== in[1];

    // Constraint for if else conditions
    signal enforceIntegerSqrt <== isLessThan.out * isGreaterThan.out;
    c1 + c2 + (c3 * enforceIntegerSqrt) === 1;
}

component main = IntSqrt(252);
