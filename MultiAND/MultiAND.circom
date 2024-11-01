pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that takes an array of signals `in` and
// returns 1 if all of the signals are 1. If any of the
// signals are 0 return 0. If any of the signals are not
// 0 or 1 the circuit should not be satisfiable.

template MultiAND(n) {
    signal input in[n];
    signal output out;

    // Sanity check that inputs are either 0 or 1
    for (var i = 0; i < n; i++) {
        in[i] * (in[i] - 1) === 0;
    }

    signal intermediate[n];
    intermediate[0] <== in[0];

    for (var i = 0; i < n - 1; i++) {
        intermediate[i + 1] <== intermediate[i] * in[i + 1];
    }

    out <== intermediate[n - 1];
}

component main = MultiAND(4);
