pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/poseidon.circom";

template IsPermutation(n) {
    signal input a[n];
    signal input b[n];

    component hash = Poseidon(2*n);
    for (var i = 0; i < n; i++) {
        hash.inputs[i] <== a[i];
        hash.inputs[i + n] <== b[i];
    }

    signal challenge <== hash.out;

    signal prodA[n];
    signal prodB[n];

    prodA[0] <== challenge - a[0];
    prodB[0] <== challenge - b[0];

    for (var i = 1; i < n; i++) {
        prodA[i] <== (challenge - a[i]) * prodA[i-1];
        prodB[i] <== (challenge - b[i]) * prodB[i-1];
    }

    prodA[n-1] === prodB[n-1];
}

component main = IsPermutation(3);