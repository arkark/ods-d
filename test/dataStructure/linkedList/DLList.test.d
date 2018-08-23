module odsD.test.dataStructure.linkedList.DLList;

import odsD.dataStructure.linkedList.DLList;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto list = new DLList!long();
  assert(list.size == 0);

  list.insertBack(2); // -> [2]
  list.insertBack(5); // -> [2, 5]
  list.insertFront(3); // -> [3, 2, 5]
  assert(list.size == 3);
  assert(list.get(0) == 3 && list.get(1) == 2 && list.get(2) == 5);

  assert(list.remove(1) == 2); // -> [3, 5]
  assert(list.size == 2);
  assert(list.get(0) == 3 && list.get(1) == 5);

  list.add(0, 10); // -> [10, 3, 5]
  assert(list.size == 3);
  assert(list.get(0) == 10 && list.get(1) == 3 && list.get(2) == 5);

  assert(list.removeFront() == 10); // -> [3, 5]
  assert(list.size == 2);
  assert(list.get(0) == 3 && list.get(1) == 5);

  assert(list.removeBack() == 5); // -> [3]
  assert(list.size == 1);
  assert(list.get(0) == 3);

  list.clear(); // -> []
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `insertFront`");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertFront(xs[i]);
    assert(list.size == i+1);
    assert(list.get(0) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.get(i) == xs[n-i-1]);
  }
}

unittest {
  writeln(__FILE__, ": Random `insertBack`");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertBack(xs[i]);
    assert(list.size == i+1);
    assert(list.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `removeFront`");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.removeFront() == xs[i]);
    assert(list.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `removeBack`");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.removeBack() == xs[n-i-1]);
    assert(list.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `set`");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertBack(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(list.set(i, xs2[i]) == xs1[i]);
    assert(list.get(i) == xs2[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove` 1");

  auto list = new DLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  // reverse insertion
  foreach(i; 0..n) {
    list.add(0, xs[i]);
    assert(list.size == i+1);
  }
  foreach(i; 0..n) {
    assert(list.get(i) == xs[n-i-1]);
  }
  foreach(i; 0..n) {
    assert(list.remove(0) == xs[n-i-1]);
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove` 2");

  auto list = new DLList!long();
  long[] ys = [];

  long n = 1000;
  long[] xs = randomArray!long(n);
  auto rnd = Random(unpredictableSeed);

  foreach(i; 0..n) {
    auto j = uniform(0, list.size + 1, rnd);
    list.add(j, xs[i]);
    ys = ys[0..j] ~ xs[i] ~ ys[j..$];
  }
  foreach(i; 0..n) {
    assert(list.get(i) == ys[i]);
  }
  foreach(i; 0..n) {
    auto j = uniform(0, list.size, rnd);
    assert(list.remove(j) == ys[j]);
    ys = ys[0..j] ~ ys[j+1..$];
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto list = new DLList!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // DLList should be able to execute `insertFront`, `insertBack`, `removeFront` and `removeBack` 10^^6 times within 2000 ms because the time complexity is O(1)."
  testTimeComplexity!("insertFront", () => list.insertFront(0))(iter, timeLimit);
  testTimeComplexity!("removeFront", () => list.removeFront())(iter, timeLimit);
  testTimeComplexity!("insertBack", () => list.insertBack(0))(iter, timeLimit);
  testTimeComplexity!("removeBack", () => list.removeBack())(iter, timeLimit);
}
