module odsD.test.dataStructure.sort.radixSort;

import odsD.dataStructure.sort.radixSort;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  long[] xs = [5, 1, 3];
  xs.radixSort();
  assert(xs.equal([1, 3, 5]));

}

unittest {
  writeln(__FILE__, ": Random array");

  long n = 1000;

  auto rnd = Random(unpredictableSeed);
  long[] xs = new long[n];
  foreach(ref x; xs) {
    x = uniform(0, 1L<<32, rnd);
  }

  long[] ys = xs.dup;
  long[] zs = xs.dup;
  ys.radixSort();
  zs.sort();
  assert(ys.equal(zs));
}
