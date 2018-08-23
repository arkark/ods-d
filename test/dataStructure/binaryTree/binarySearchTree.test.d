module odsD.test.dataStructure.binaryTree.BinarySearchTree;

import odsD.dataStructure.binaryTree.BinarySearchTree;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto tree = new BinarySearchTree!(long, "a < b")();
  assert(tree.size == 0);

  tree.add(2);
  tree.add(5);
  tree.add(4);
  assert(tree.size == 3);

  auto m1 = tree.findEQ(2);
  assert(m1.isJust && m1.get == 2);
  auto m2 = tree.findEQ(5);
  assert(m2.isJust && m2.get == 5);
  auto m3 = tree.findEQ(10);
  assert(m3.isNone);

  auto m4 = tree.find(2);
  assert(m4.isJust && m4.get == 2);
  auto m5 = tree.find(3);
  assert(m5.isJust && m5.get == 4); // 4 == min(x \in {2, 5, 4} | x >= 3)
  auto m6 = tree.find(10);
  assert(m6.isNone);

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

  auto tree = new BinarySearchTree!(Vec, "a.lengthSq < b.lengthSq")();

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

  long n = 1000;
  long[] xs = randomArray!long(n);

  auto tree = new BinarySearchTree!long();
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
    assert(tree.exists(x) == aa.get(x, false));
  }
}
