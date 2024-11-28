pragma circom 2.1.4;

include "multiplexer.circom";
include "comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template Pow() {
   // TODO: Is it possible to not use "n" here?
   var n = 100;

   signal input a[2];
   signal output c;

   /// Pre compute step
   var base = a[0];
   var exponent = a[1];

   signal power[n];

   power[0] <== 1;
   for (var i = 1; i < n; i++) {
      power[i] <== power[i - 1] * base;
   }
   /// End of pre compute step

   /// Ensure that exponent < n
   signal inLTn;
   inLTn <== LessThan(252)([exponent, n]);
   inLTn === 1;

   // Multiplexing to get the result
   component mux = Multiplexer(1, n);
   mux.sel <== exponent;

   for (var i = 0; i < n; i++) {
      mux.inp[i][0] <== power[i];
   }

   c <== mux.out[0];
}


component main = Pow();

