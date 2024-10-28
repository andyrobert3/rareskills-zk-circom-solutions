pragma circom 2.1.4;

include "comparators.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
   // Your Code Here..
   signal input a[3];
   signal output c;

   component isZero1 = IsZero();
   component isZero2 = IsZero();

   isZero1.in <== a[0] - a[1];
   isZero2.in <== a[1] - a[2];
   
   // Return true / false
   c <== isZero1.out * isZero2.out;
}

component main = Equality();