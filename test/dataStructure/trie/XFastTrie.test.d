module odsD.test.dataStructure.trie.XFastTrie;

import odsD.dataStructure.trie.XFastTrie;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto trie = new XFastTrie!long();
  assert(trie.size == 0);

  trie.add(2);
  trie.add(5);
  trie.add(4);
  assert(trie.size == 3);

  auto m1 = trie.find(2);
  assert(m1.isJust && m1.get == 2);
  auto m2 = trie.find(3);
  assert(m2.isJust && m2.get == 4); // 4 == min(x \in {2, 5, 4} | x >= 3)
  auto m3 = trie.find(10);
  assert(m3.isNone);

  assert(trie.add(100));
  assert(!trie.add(2)); // 2 already exists

  assert(trie.remove(2));
  assert(trie.remove(5));
  assert(!trie.remove(5)); // 5 was already removed

  assert(trie.size == 2);
  assert(trie.exists(4) && trie.exists(100));
  assert(!trie.exists(2) && !trie.exists(5) && !trie.exists(10));

  trie.clear();
  assert(trie.size == 0);
}

unittest {
  writeln(__FILE__, ": Use of a defined struct");

  struct Vec {
    int x, y;
  }
  ulong vecToUlong(Vec v) {
    return (cast(ulong)cast(uint)v.x) + ((cast(ulong)cast(uint)v.y) << 32);
  }
  Vec ulongToVec(ulong v) {
    return Vec(cast(int)cast(uint)v, cast(int)cast(uint)(v >> 32));
  }

  auto trie = new XFastTrie!(Vec, ulong, vecToUlong, ulongToVec)();

  assert(trie.add(Vec(10, 20)));
  assert(trie.add(Vec(0, 0)));
  assert(trie.add(Vec(3, 4)));
  assert(trie.add(Vec(-3, 4)));

  assert(trie.size == 4);
  assert(trie.exists(Vec(0, 0)));
  assert(trie.exists(Vec(-3, 4)));
  assert(trie.exists(Vec(3, 4)));
  assert(!trie.exists(Vec(1000, 1000)));

  assert(trie.remove(Vec(3, 4)));
  assert(!trie.exists(Vec(3, 4)) && trie.exists(Vec(-3, 4)));
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  long n = 1000;
  long[] xs = randomArray!long(n);

  auto trie = new XFastTrie!long();
  bool[long] aa;

  auto rnd = Random(unpredictableSeed);

  foreach(x; xs) {
    assert(trie.add(x) != aa.get(x, false));
    aa[x] = true;
  }

  foreach(x; xs.randomSample(xs.length*2/3, rnd)) {
    assert(trie.remove(x) == aa.remove(x));
  }

  foreach(x; xs) {
    assert(trie.exists(x) == aa.get(x, false));
  }
}
