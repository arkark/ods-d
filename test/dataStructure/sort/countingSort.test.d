module odsD.test.dataStructure.sort.countingSort;

import odsD.dataStructure.sort.countingSort;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  long[] xs = [5, 1, 3];
  xs.countingSort(10);
  assert(xs.equal([1, 3, 5]));

}

unittest {
  writeln(__FILE__, ": Random array");

  long n = 1000;
  long k = 10000;

  auto rnd = Random(unpredictableSeed);
  long[] xs = new long[n];
  foreach(ref x; xs) {
    x = uniform(0, k, rnd);
  }

  long[] ys = xs.dup;
  long[] zs = xs.dup;
  ys.countingSort(k);
  zs.sort();
  assert(ys.equal(zs));
}
