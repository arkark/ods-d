module odsD.dataStructure.sort.mergeSort;

import std.functional;

// O(n log n)
// @sideEffect: xs
void mergeSort(alias less = "a < b", T)(T[] xs)
if (is(typeof(binaryFun!less(T.init, T.init)))) {

  if (xs.length <= 1) return;
  T[] ls = xs[0..$/2].dup;
  T[] rs = xs[$/2..$].dup;
  ls.mergeSort!less();
  rs.mergeSort!less();
  merge!less(ls, rs, xs);

}

private void merge(alias less = "a < b", T)(T[] ls, T[] rs, T[] xs)
if (is(typeof(binaryFun!less(T.init, T.init)))) {
  alias _less = binaryFun!less;

  size_t l = 0;
  size_t r = 0;
  foreach(ref x; xs) {
    if (l == ls.length) {
      x = rs[r++];
    } else if (r == rs.length) {
      x = ls[l++];
    } else if (_less(ls[l], rs[r])) {
      x = ls[l++];
    } else {
      x = rs[r++];
    }
  }

}
