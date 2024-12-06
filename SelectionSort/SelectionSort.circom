include "../node_modules/circomlib/circuits/comparators.circom";

pragma circom 2.1.4;

template CalculateTotal(n) {
    signal input in[n];
    signal output out;

    signal sums[n];

    sums[0] <== in[0];

    for (var i = 1; i < n; i++) {
        sums[i] <== sums[i-1] + in[i];
    }

    out <== sums[n-1];
}

template QuinSelector(choices) {
    signal input in[choices];
    signal input index;
    signal output out;
    
    // Ensure that index < choices
    component lessThan = LessThan(4);
    lessThan.in[0] <== index;
    lessThan.in[1] <== choices;
    lessThan.out === 1;

    component calcTotal = CalculateTotal(choices);
    component eqs[choices];

    // For each item, check whether its index equals the input index.
    for (var i = 0; i < choices; i ++) {
        eqs[i] = IsEqual();
        eqs[i].in[0] <== i;
        eqs[i].in[1] <== index;

        // eqs[i].out is 1 if the index matches. As such, at most one input to
        // calcTotal is not 0.
        calcTotal.in[i] <== eqs[i].out * in[i];
    }

    // Returns 0 + 0 + 0 + item
    out <== calcTotal.out;
}


template Minimum(n) {
  signal input in[n];

  signal output min;
  signal output idx;

  // Do calculations here 
  var min_ = in[0];
  var idx_ = 0;

  for (var i = 1; i < n; i++) {
    if (in[i] < min_) {
      min_ = in[i];
      idx_ = i;
    }
  }

  min <-- min_;
  idx <-- idx_;

  // Prove that the value of min is at index idx
  component selector = QuinSelector(n);
  selector.in <== in;
  selector.index <== idx;
  selector.out === min;

  // Prove that min is really min relative to all in[i]
  component lessThanEq[n];

  for (var i = 0; i < n; i++) {
    lessThanEq[i] = LessEqThan(252);
    lessThanEq[i].in[0] <== min;
    lessThanEq[i].in[1] <== in[i];
    lessThanEq[i].out === 1;
  }
}


template Swap(n) {
  signal input in[n];
  signal input i_1;
  signal input i_2;

  signal output out[n];

  signal iEq1[n];
  signal iEq2[n];
  
  component eq1[n];
  component eq2[n];

  signal oneEqTwo;
  oneEqTwo <== IsEqual()([i_1, i_2]);
  
  // otherwise[i] = 1 if (i != i_1 and i != i_2) or (i == i_1 and i == i_2)
  signal otherwise[n];

  signal intermediateSwap1[n];
  signal intermediateSwap2[n];

  signal combinedIntermediate[n];
  
  // branchConditions[i] != 0 if i == i_1 or i == i_2 and i_1 != i_2
  signal branchConditions[n];

  signal i_1_value;
  signal i_2_value;

  component selector_i1 = QuinSelector(n);
  selector_i1.in <== in;
  selector_i1.index <== i_1;
  i_1_value <== selector_i1.out;

  component selector_i2 = QuinSelector(n);
  selector_i2.in <== in;
  selector_i2.index <== i_2;
  i_2_value <== selector_i2.out;

  for (var i = 0; i < n; i++) {
    eq1[i] = IsEqual();
    eq1[i].in[0] <== i;
    eq1[i].in[1] <== i_1;
    iEq1[i] <== eq1[i].out;

    eq2[i] = IsEqual();
    eq2[i].in[0] <== i;
    eq2[i].in[1] <== i_2;
    iEq2[i] <== eq2[i].out;

    // Swap values between i_1_value & i_2_value
    intermediateSwap1[i] <== iEq2[i] * i_1_value;
    intermediateSwap2[i] <== iEq1[i] * i_2_value;

    combinedIntermediate[i] <== intermediateSwap1[i] + intermediateSwap2[i];
    branchConditions[i] <== (1 - oneEqTwo) * combinedIntermediate[i];

    otherwise[i] <== 1 - (iEq1[i] + iEq2[i]) + 2 * iEq1[i] * iEq2[i];

    out[i] <== (otherwise[i] * in[i]) + branchConditions[i];
  }  
}

template ArrayLastM(n, m) {
  assert(m <= n);

  signal input in[n];
  signal output out[m];

  component selectors[n];

  var j = 0;
  for (var i = n - m; i < n; i++) {
    selectors[j] = QuinSelector(n);
    selectors[j].in <== in;
    selectors[j].index <== i;
    out[j] <== selectors[j].out;

    j++;
  }
}


/// UNFINISHED ///
template SelectionSort(n) {
  signal input in[n];
  signal output out[n];

  /// Pre-computation step ///
  var min_index;
  var toSort[n];

  for (var i = 0; i < n; i++) {
    toSort[i] = in[i];
  }

  for (var i = 0; i < n - 1; i++) {
    min_index = i;

    for (var j = i + 1; j < n; j++) {
      if (toSort[j] < toSort[min_index]) {
        min_index = j;
      }
    }

    // Swap step
    var temp = toSort[i];
    toSort[i] = toSort[min_index];
    toSort[min_index] = temp;
  }

  for (var i = 0; i < n; i++) {
    out[i] <-- toSort[i];
  }
  /// End of pre-computation step ///


  // Verification step
  component min[n];
  component swap[n];

  // HELP: Can we make this store an array of arrays?
  component lastM[n];

  signal sorted[n];

  signal minElements[n];
  signal minIndices[n];
  
  for (var i = 0; i < n; i++) {
    var m = n - i;

    lastM[i] = ArrayLastM(n, m);
    lastM[i].in <== out;

    // TODO: Investigate how to process the last M elements
    // We cannot do this due to n & m AND circom lack of support for 2d signals
    lastM[i].out ==> sorted;

    // Find the minimum element in the last M elements
    // Can we replace this with a component that finds the nth smallest element? This won't be selection sort anymore
    min[i] = Minimum(m);
    min[i].in <== sorted;
    min[i].min ==> minElements[i];
    min[i].idx ==> minIndices[i];

    // Swapping step between current and min index
    swap[i] = Swap(n);
    swap[i].in <== out;
    swap[i].i_1 <== minIndices[i];
    swap[i].i_2 <== i;
    out[i] <== swap[i].out;
  }
}
