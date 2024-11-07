pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Be sure to solve IntSqrt before solving this 
// puzzle. Your goal is to compute the square root
// in the provided function, then constrain the answer
// to be true using your work from the previous puzzle.
// You can use the Bablyonian/Heron's or Newton's
// method to compute the integer square root. Remember,
// this is not the modular square root.


function intSqrtFloor(x) {
    // compute the floor of the
    // integer square root

   if (x == 0) {
    return 0;
   }

   if (x == 1) {
    return 1;
   }

    var r = x;
    var l = 0;

    while (r - l > 1) {
        // Integer division
        var m = (r + l) \ 2;

        if (m * m <= x) {
            l = m;
        } else {
            r = m;
        }
    }

    return l;
}

template IntSqrtOut(n) {
    signal input in;
    signal output out;

    signal sqrt <-- intSqrtFloor(in);

    // constrain out using your
    // work from IntSqrt

    // Signal range checks
    component lteIn = LessEqThan(n);
    lteIn.in[0] <== in;
    lteIn.in[1] <== (2 ** n) - 1;
    lteIn.out === 1;

    component lteSqrt = LessEqThan(n);
    lteSqrt.in[0] <== sqrt;
    lteSqrt.in[1] <== (2 ** n) - 1;
    lteSqrt.out === 1;

    // Special cases:
    // 1. a -> 0, b -> 0
    // 2. a -> 1, b -> 1
    component isAZeroBZero = IsEqual();
    isAZeroBZero.in[0] <== in;
    isAZeroBZero.in[1] <== 0;
    signal c1 <== isAZeroBZero.out;

    component isAOneBOne = IsEqual();
    isAOneBOne.in[0] <== in;
    isAOneBOne.in[1] <== 1;
    signal c2 <== isAOneBOne.out;

    // Else condition
    signal c3 <== 1 - (c1 + c2);

    // Enforce integer square roots
    component isLessThan = LessEqThan(n);
    isLessThan.in[0] <== (sqrt - 1) * (sqrt - 1);
    isLessThan.in[1] <== in;

    component isGreaterThan = GreaterThan(n);
    isGreaterThan.in[0] <== (sqrt + 1) * (sqrt + 1);
    isGreaterThan.in[1] <== in;

    // Constraint for if else conditions
    signal enforceIntegerSqrt <== isLessThan.out * isGreaterThan.out;
    c1 + c2 + (c3 * enforceIntegerSqrt) === 1;
    out <== sqrt;

}

component main = IntSqrtOut(252);
