module odsD.test.dataStructure.skiplist.SkiplistSSet;

import odsD.dataStructure.skiplist.SkiplistSSet;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto set = new SkiplistSSet!(long, "a < b")();
  assert(set.size == 0);

  set.add(2);
  set.add(5);
  set.add(4);
  assert(set.size == 3);

  auto r1 = set.find(3); // <- InputRange(4, 5)
  assert(r1.equal([4, 5]));
  auto r2 = set.find(4); // <- InputRange(4, 5)
  assert(r2.equal([4, 5]));
  auto r3 = set.find(10); // <- InputRange()
  assert(r3.empty);

  assert(set.add(100));
  assert(!set.add(2)); // 2 already exists

  assert(set.remove(5));
  assert(!set.remove(5)); // 5 was already removed

  assert(set.size == 3);
  assert(set.find(0).equal([2, 4, 100]));

  assert(set.exists(2) && set.exists(4) && set.exists(100));
  assert(!set.exists(5) && !set.exists(10));

  set.clear();
  assert(set.size == 0);
}

unittest {
  writeln(__FILE__, ": Reverse order");

  auto set1 = new SkiplistSSet!(long, "a < b")();
  auto set2 = new SkiplistSSet!(long, "a > b")();

  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(x; xs) {
    set1.add(x);
    set2.add(x);
  }

  import std.array;
  import std.range : retro;
  assert(equal(set1.find(long.min), set2.find(long.max).array.retro));
  assert(equal(set1.find(long.max), set2.find(long.min).array.retro));
}

unittest {
  writeln(__FILE__, ": Use of a defined struct");

  struct Vec {
    long x, y;
    @property long lengthSq() {
      return x*x + y*y;
    }
  }

  auto set = new SkiplistSSet!(Vec, "a.lengthSq < b.lengthSq")();

  assert(set.add(Vec(10, 20)));
  assert(set.add(Vec(0, 0)));
  assert(set.add(Vec(3, 4)));
  assert(!set.add(Vec(-3, 4))); // Vec(3, 4).lengthSq == Vec(-3, 4).lengthSq

  assert(set.size == 3);
  assert(set.find(Vec(0, 0)).equal(
    [Vec(0, 0), Vec(3, 4), Vec(10, 20)]
  ));
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  long n = 1000;
  long[] xs = randomArray!long(n);

  auto set = new SkiplistSSet!long();
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

  auto set = new SkiplistSSet!long();
  uint iter = 10^^5;
  auto timeLimit = 2000.msecs;

  long[] xs = randomArray!long(iter);
  long[] ys;

  // SkiplistSSet should be able to execute `add`, `find`, 'exists' and `remove` 10^^5 times within 2000 ms because the average time complexity is O(log n)."

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
