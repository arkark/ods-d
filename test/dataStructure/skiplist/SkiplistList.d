module odsD.test.dataStructure.skiplist.SkiplistList;

import odsD.dataStructure.skiplist.SkiplistList;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto list = new SkiplistList!long();
  assert(list.size == 0);

  list.pushBack(2);
  list.pushBack(5);
  list.pushFront(3);
  assert(list.size == 3);
  assert(list.get(0) == 3 && list.get(1) == 2 && list.get(2) == 5);

  assert(list.remove(1) == 2);
  assert(list.size == 2);
  assert(list.get(0) == 3 && list.get(1) == 5);

  list.add(0, 10);
  assert(list.size == 3);
  assert(list.get(0) == 10 && list.get(1) == 3 && list.get(2) == 5);

  assert(list.popFront() == 10);
  assert(list.size == 2);
  assert(list.get(0) == 3 && list.get(1) == 5);

  assert(list.popBack() == 5);
  assert(list.size == 1);
  assert(list.get(0) == 3);

  list.clear();
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `pushFront`");

  auto list = new SkiplistList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushFront(xs[i]);
    assert(list.size == i+1);
    assert(list.get(0) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.get(i) == xs[n-i-1]);
  }
}

unittest {
  writeln(__FILE__, ": Random `pushBack`");

  auto list = new SkiplistList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushBack(xs[i]);
    assert(list.size == i+1);
    assert(list.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `popFront`");

  auto list = new SkiplistList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.popFront() == xs[i]);
    assert(list.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `popBack`");

  auto list = new SkiplistList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(list.popBack() == xs[n-i-1]);
    assert(list.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `set`");

  auto list = new SkiplistList!long();
  long n = 1000;
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushBack(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(list.set(i, xs2[i]) == xs1[i]);
    assert(list.get(i) == xs2[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  auto list = new SkiplistList!long();
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
  writeln(__FILE__, ": Time complexity");

  auto list = new SkiplistList!long();
  uint iter = 10^^5;
  auto timeLimit = 2000.msecs;

  // SkiplistList should be able to execute `pushFront`, `pushBack`, `popFront` and `popBack` 10^^5 times within 2000 ms because the time complexity is average O(log n)."
  testTimeComplexity!("pushFront", () => list.pushFront(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => list.popFront())(iter, timeLimit);
  testTimeComplexity!("pushBack", () => list.pushBack(0))(iter, timeLimit);
  testTimeComplexity!("popBack", () => list.popBack())(iter, timeLimit);
}
