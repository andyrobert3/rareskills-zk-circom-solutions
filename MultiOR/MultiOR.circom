pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that returns true when at least one
// element is 1. It should return false if all elements
// are 0. It should be unsatisfiable if any of the inputs
// are not 0 or not 1.

template MultiOR(n) {
    signal input in[n];
    signal output out;

    // Sanity check that inputs are either 0 or 1
    for (var i = 0; i < n; i++) {
        in[i] * (in[i] - 1) === 0;
    }

    signal intermediate[n];
    intermediate[0] <== (1 - in[0]);

    for (var i = 0; i < n - 1; i++) {
        intermediate[i + 1] <== intermediate[i] * (1 - in[i + 1]);
    }

    out <== (1 - intermediate[n - 1]);
}

component main = MultiOR(4);
