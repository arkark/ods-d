module odsD.test.dataStructure.hashTable.LinearHashTable;

import odsD.dataStructure.hashTable.LinearHashTable;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto set = new LinearHashTable!long();
  assert(set.size == 0);

  set.add(2);
  set.add(5);
  set.add(4);
  assert(set.size == 3);

  auto r1 = set.find(2);
  assert(r1.equal([2]));
  auto r2 = set.find(5);
  assert(r2.equal([5]));
  auto r3 = set.find(10);
  assert(r3.empty);

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

  auto set = new LinearHashTable!long();
  bool[long] aa;

  foreach(i, x; xs) {
    if (i%2 == 0) {
      assert(set.add(x) != aa.get(x, false));
      aa[x] = true;
    } else {
      assert(set.remove(x) == aa.remove(x));
    }
  }

  foreach(x; xs) {
    assert(set.exists(x) == aa.get(x, false));
  }
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto set = new LinearHashTable!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  long[] xs = randomArray!long(iter);
  long[] ys;

  // LinearHashTable should be able to execute `add`, `find`, 'exists' and `remove` 10^^6 times within 2000 ms because the average time complexity is amortized and average O(1)."

  ys = xs;
  testTimeComplexity!("add", {
    set.add(ys[0]);
    ys = ys[1..$];
  })(iter, timeLimit);

  ys = xs;
  testTimeComplexity!("find", {
    assert(set.find(ys[0]).front == ys[0]);
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
