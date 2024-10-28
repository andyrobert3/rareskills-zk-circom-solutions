pragma circom 2.1.8;

include "comparators.circom";

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    component isZeros[n];
    signal intermediate[n];

    // Check if k is in the list
    for (var i = 0; i < n; i++) {
        isZeros[i] = IsZero();

        // Check if in[i] - k is zero, isZeros[i].out will be 1 
        isZeros[i].in <== in[i] - k;
        intermediate[i] <== 1 - isZeros[i].out; // 1 if in[i] - k is not zero, 0 otherwise
    }

    // If there is one "0", then k is in the list (use multiplication to enforce this)
    signal running[n];
    running[0] <== intermediate[0];
    for (var i = 1; i < n; i++) {
        running[i] <== running[i - 1] * intermediate[i];
    }
    
    component isZero = IsZero();
    isZero.in <== running[n - 1];

    // Returns 1 if k is in the list, 0 otherwise
    out <== isZero.out;
}

component main = HasAtLeastOne(4);
