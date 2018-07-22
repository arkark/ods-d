module odsD.test.dataStructure.linkedList.SEList;

import odsD.dataStructure.linkedList.SEList;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto list = new SEList!long(100);
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

  auto list = new SEList!long(100);
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

  auto list = new SEList!long(100);
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

  auto list = new SEList!long(100);
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

  auto list = new SEList!long(100);
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

  auto list = new SEList!long(100);
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
  writeln(__FILE__, ": Random `add` and `remove`");

  auto list = new SEList!long(100);
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

  size_t blockSize = 100;
  auto list = new SEList!long(blockSize);
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // SEList should be able to execute `insertBack` and `removeBack` 10^^6 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("insertBack", () => list.insertBack(0))(iter, timeLimit);
  testTimeComplexity!("removeBack", () => list.removeBack())(iter, timeLimit);

  // SEList should be able to execute `insertFront` and `removeFront` 10^^6/blockSize times within 2000 ms because the time complexity is amortized O(blockSize)."
  testTimeComplexity!("insertFront", () => list.insertFront(0))(iter/blockSize, timeLimit);
  testTimeComplexity!("removeFront", () => list.removeFront())(iter/blockSize, timeLimit);
}
