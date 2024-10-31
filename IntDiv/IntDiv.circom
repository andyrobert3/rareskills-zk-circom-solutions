pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if `numerator`,
// `denominator`, `quotient`, and `remainder` represent
// a valid integer division. You will need a comparison check, so
// we've already imported the library and set n to be 252 bits.
//
// Hint: integer division in Circom is `\`.
// `/` is modular division
// `%` is integer modulus

template IntDiv(n) {
    signal input numerator;
    signal input denominator;
    signal input quotient;
    signal input remainder;

    // Check if denominator is zero
    component isZero = IsZero();
    isZero.in <== denominator;
    isZero.out === 0;

    // Make sure remainder < denominator
    component isLessThan = LessThan(n);
    isLessThan.in[0] <== remainder;
    isLessThan.in[1] <== denominator;
    isLessThan.out === 1;

    component isEqual = IsEqual();
    isEqual.in[0] <== numerator;
    isEqual.in[1] <== denominator * quotient + remainder;
    isEqual.out === 1;
}

component main = IntDiv(252);
