pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;

    // Check if denominator is zero
    component isZero = IsZero();
    isZero.in <== denominator;
    isZero.out === 0;

    out <-- numerator \ denominator;

    // Get remainder 
    signal remainder;
    remainder <-- numerator % denominator;

    // Enforce constraint that remainder < denominator
    component isLessThan = LessThan(n);
    isLessThan.in[0] <== remainder;
    isLessThan.in[1] <== denominator;
    isLessThan.out === 1;

    // Enforce constraint that numerator == denominator * out + remainder
    component isEqual = IsEqual();
    isEqual.in[0] <== numerator;
    isEqual.in[1] <== denominator * out + remainder;
    isEqual.out === 1;
}

component main = IntDivOut(252);
