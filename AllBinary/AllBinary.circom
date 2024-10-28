pragma circom 2.1.8;

include "comparators.circom";
include "bitify.circom";



template Add32Bits() {
    signal input in1;
    signal input in2;

    signal output out;

    component lessThan1 = LessThan(32);
    component lessThan2 = LessThan(32);

    lessThan1.in[0] <== in1;
    lessThan1.in[1] <== 2 ** 32;
    lessThan1.out === 1;

    lessThan2.in[0] <== in2;
    lessThan2.in[1] <== 2 ** 32;
    lessThan2.out === 1;

    signal sum;

    sum <== in1 + in2;

    component num2bits = Num2Bits(33);
    component bits2num = Bits2Num(32);

    num2bits.in <== sum;

    for (var i = 0; i < 32; i++) {
        bits2num.in[i] <== num2bits.out[i];
    }

    out <== bits2num.out;
}

// Create constraints that enforces all signals
// in `in` are binary, i.e. 0 or 1.
template AllBinary(n) {
    signal input in[n];

    for (var i = 0; i < n; i++) {
        in[i] * (in[i] - 1) === 0;
    }
}

component main = AllBinary(4);