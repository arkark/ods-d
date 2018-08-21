module odsD.dataStructure.sort.countingSort;

import std.algorithm;
import std.traits;

// O(n + k)
// @sideEffect: xs
void countingSort(T)(ref T[] xs, T k)
if (isIntegral!T) in {
  assert(xs.all!(x => x<k), "All elements of `xs` must be less than `k`");
} do {

  long[] cs = new long[k];
  foreach(x; xs) {
    cs[x]++;
  }
  foreach(i; 1..k) {
    cs[i] += cs[i-1];
  }

  T[] ys = new T[xs.length];
  foreach_reverse(x; xs) {
    ys[--cs[x]] = x;
  }

  xs = ys;
}
