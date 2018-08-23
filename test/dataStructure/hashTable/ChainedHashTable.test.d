module odsD.test.dataStructure.hashTable.ChainedHashTable;

import odsD.dataStructure.hashTable.ChainedHashTable;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto set = new ChainedHashTable!long();
  assert(set.size == 0);

  set.add(2);
  set.add(5);
  set.add(4);
  assert(set.size == 3);

  auto m1 = set.find(2);
  assert(m1.isJust && m1.get == 2);
  auto m2 = set.find(5);
  assert(m2.isJust && m2.get == 5);
  auto m3 = set.find(10);
  assert(m3.isNone);

  assert(set.add(100));
  assert(!set.add(2)); // 2 already exists

  assert(set.remove(5));
  assert(!set.remove(5)); // 5 was already removed

  assert(set.size == 3);
  assert(set.exists(2) && set.exists(4) && set.exists(100));
  assert(!set.exists(5) && !set.exists(10));

  set.clear();
  assert(set.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  long n = 1000;
  long[] xs = randomArray!long(n);

  auto set = new ChainedHashTable!long();
  bool[long] aa;

  auto rnd = Random(unpredictableSeed);

  foreach(x; xs) {
    assert(set.add(x) != aa.get(x, false));
    aa[x] = true;
  }

  foreach(x; xs.randomSample(xs.length*2/3, rnd)) {
    assert(set.remove(x) == aa.remove(x));
  }

  foreach(x; xs) {
    assert(set.exists(x) == aa.get(x, false));
  }
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto set = new ChainedHashTable!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  long[] xs = randomArray!long(iter);
  long[] ys;

  // ChainedHashTable should be able to execute `add`, `find`, 'exists' and `remove` 10^^6 times within 2000 ms because the average time complexity is amortized and average O(1)."

  ys = xs;
  testTimeComplexity!("add", {
    set.add(ys[0]);
    ys = ys[1..$];
  })(iter, timeLimit);

  ys = xs;
  testTimeComplexity!("find", {
    assert(set.find(ys[0]).get == ys[0]);
    ys = ys[1..$];
  })(iter, timeLimit);

  ys = xs;
  testTimeComplexity!("exists", {
    assert(set.exists(ys[0]));
    ys = ys[1..$];
  })(iter, timeLimit);

  ys = xs;
  testTimeComplexity!("remove", {
    set.remove(ys[0]);
    ys = ys[1..$];
  })(iter, timeLimit);


}
