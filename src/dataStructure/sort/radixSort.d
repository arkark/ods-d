module odsD.dataStructure.sort.radixSort;

import std.algorithm;
import std.traits;

// O((w/d)(n + 2^d))
// @sideEffect: xs
void radixSort(T)(ref T[] xs)
if (isIntegral!T) in {
  assert(xs.all!(x => 0<=x && x<(1L<<32)));
} do {
  size_t w = 32;
  size_t d = 8;
  assert(w%d == 0);

  foreach(p; 0..w/d) {
    long[] cs = new long[1<<d];
    foreach(x; xs) {
      cs[(x >> (d*p)) & ((1<<d) - 1)]++;
    }
    foreach(i; 1..1<<d) {
      cs[i] += cs[i-1];
    }

    T[] ys = new T[xs.length];
    foreach_reverse(x; xs) {
      ys[--cs[(x >> (d*p)) & ((1<<d) - 1)]] = x;
    }
    xs = ys;
  }
}
