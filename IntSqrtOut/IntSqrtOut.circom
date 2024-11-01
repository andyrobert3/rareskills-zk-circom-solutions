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

    out <-- intSqrtFloor(in);

    // constrain out using your
    // work from IntSqrt

    // Check that "in" is at least 1
    component GreaterEqThan = GreaterEqThan(n);
    GreaterEqThan.in[0] <== in;
    GreaterEqThan.in[1] <== 1;
    GreaterEqThan.out === 1;

    // Check if it overflows the field via the bits
    component num2bitsDecrement = Num2Bits(n);
    num2bitsDecrement.in <== (out - 1) * (out - 1);
    component num2bitsIncrement = Num2Bits(n);
    num2bitsIncrement.in <== (out + 1) * (out + 1);

    // Enforce integer square roots
    component isLessThan = LessEqThan(n);
    isLessThan.in[0] <== (out - 1) * (out - 1);
    isLessThan.in[1] <== in;
    isLessThan.out === 1;

    component isGreaterThan = GreaterThan(n);
    isGreaterThan.in[0] <== (out + 1) * (out + 1);
    isGreaterThan.in[1] <== in;
    isGreaterThan.out === 1;
}

component main = IntSqrtOut(252);
