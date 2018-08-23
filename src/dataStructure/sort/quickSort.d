module odsD.dataStructure.sort.quickSort;

import std.functional;
import std.algorithm;
import std.random;

// average O(n log n)
// @sideEffect: xs
void quickSort(alias less = "a < b", T)(T[] xs)
if (is(typeof(binaryFun!less(T.init, T.init)) == bool)) {
  quickSort!less(xs, 0, xs.length);
}

private void quickSort(alias less = "a < b", T)(T[] xs, size_t i, size_t n)
if (is(typeof(binaryFun!less(T.init, T.init)) == bool)) {
  alias _less = binaryFun!less;
  auto rnd = Random(unpredictableSeed);

  if (n <= 1) return;
  T x = xs[i + uniform(0, n, rnd)];

  size_t l = 0;
  size_t r = i+n;
  size_t j = l;
  while(j < r) {
    if (_less(xs[j], x)) {
      swap(xs[j++], xs[l++]);
    } else if (_less(x, xs[j])) {
      swap(xs[j], xs[--r]);
    } else {
      j++;
    }
  }

  quickSort!less(xs, i, l-i+1);
  quickSort!less(xs, r, n-(r-i));

}
