pragma circom 2.1.8;

include "comparators.circom";

// Create a circuit that takes an array of four signals
// `in`and a signal s and returns is satisfied if `in`
// is the binary representation of `n`. For example:
// 
// Accept:
// 0,  [0,0,0,0]
// 1,  [1,0,0,0]
// 15, [1,1,1,1]
// 
// Reject:
// 0, [3,0,0,0]
// 
// The circuit is unsatisfiable if n > 15

template FourBitBinary() {
    signal input in[4];
    signal input n;

    // Sum the values in the array
    var sum = 0;
    var power = 1;

    for (var i = 3; i >= 0; i--) {
        in[i] * (in[i] - 1) === 0; // Check if in[i] is 0 or 1
        sum = sum + in[i] * power;
        power = power + power;
    }

    // Check n > 15
    component lt = LessThan(4); // Takes 4 bits
    lt.in[0] <== sum; // Number we are comparing
    lt.in[1] <== 16; // Max number is "16"
    lt.out === 1; // If n <= 15, then lt.out will be 1

    component isZero = IsZero();
    isZero.in <== n - sum;

    // Constraint to ensure circuit is unsatisfiable if n > 15
    isZero.out === 1;
}

component main{public [n]} = FourBitBinary();
