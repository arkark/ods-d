module odsD.test.dataStructure.externalMemory.BTree;

import odsD.dataStructure.externalMemory.BTree;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto tree = new BTree!long(128);
  assert(tree.size == 0);
  tree.add(2);
  tree.add(5);
  tree.add(4);
  assert(tree.size == 3);

  auto m1 = tree.find(2);
  assert(m1.isJust && m1.get == 2);
  auto m2 = tree.find(3);
  assert(m2.isJust && m2.get == 4); // 4 == min(x \in {2, 5, 4} | x >= 3)
  auto m3 = tree.find(10);
  assert(m3.isNone);

  assert(tree.add(100));
  assert(!tree.add(2)); // 2 already exists

  assert(tree.remove(2));
  assert(tree.remove(5));
  assert(!tree.remove(5)); // 5 was already removed

  assert(tree.size == 2);
  assert(tree.exists(4) && tree.exists(100));
  assert(!tree.exists(2) && !tree.exists(5) && !tree.exists(10));

  tree.clear();
  assert(tree.size == 0);
}

unittest {
  writeln(__FILE__, ": Use of a defined struct");

  struct Vec {
    long x, y;
    @property long lengthSq() {
      return x*x + y*y;
    }
  }

  auto tree = new BTree!(Vec, "a.lengthSq < b.lengthSq")(2);

  assert(tree.add(Vec(10, 20)));
  assert(tree.add(Vec(0, 0)));
  assert(tree.add(Vec(3, 4)));
  assert(!tree.add(Vec(-3, 4))); // Vec(3, 4).lengthSq == Vec(-3, 4).lengthSq

  assert(tree.size == 3);
  assert(tree.exists(Vec(0, 0)));
  assert(tree.exists(Vec(-3, -4)));
  assert(!tree.exists(Vec(1000, 1000)));
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  size_t n = 1000;
  long[] xs = randomArray!long(n);

  auto tree = new BTree!long(2);
  bool[long] aa;

  auto rnd = Random(unpredictableSeed);

  foreach(x; xs) {
    assert(tree.add(x) != aa.get(x, false));
    aa[x] = true;
  }

  foreach(x; xs.randomSample(xs.length*2/3, rnd)) {
    assert(tree.remove(x) == aa.remove(x));
  }

  foreach(x; xs) {
    auto result = tree.find(x);
    assert(result.isNone || result.get >= x);
  }

  foreach(x; xs) {
    assert(tree.exists(x) == aa.get(x, false));
  }

  foreach(x; xs) {
    assert(tree.remove(x) == aa.remove(x));
  }

  assert(tree.size == 0);
}
