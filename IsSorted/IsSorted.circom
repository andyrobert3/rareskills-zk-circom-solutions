pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];

    component LessEqThan[3];

    // Check that in[i] <= in[i + 1] for all i
    for (var i = 0; i < 3; i++) {
        LessEqThan[i] = LessEqThan(252);
        LessEqThan[i].in[0] <== in[i];
        LessEqThan[i].in[1] <== in[i + 1];
        LessEqThan[i].out === 1;
    }
}

component main = IsSorted();
