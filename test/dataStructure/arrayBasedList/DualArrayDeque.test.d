module odsD.test.dataStructure.arrayBasedList.DualArrayDeque;

import odsD.dataStructure.arrayBasedList.DualArrayDeque;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto deque = new DualArrayDeque!long();
  assert(deque.size == 0);

  deque.insertBack(2);
  deque.insertBack(5);
  deque.insertFront(3);
  assert(deque.size == 3);
  assert(deque.get(0) == 3 && deque.get(1) == 2 && deque.get(2) == 5);

  assert(deque.remove(1) == 2);
  assert(deque.size == 2);
  assert(deque.get(0) == 3 && deque.get(1) == 5);

  deque.add(0, 10);
  assert(deque.size == 3);
  assert(deque.get(0) == 10 && deque.get(1) == 3 && deque.get(2) == 5);

  assert(deque.removeFront() == 10);
  assert(deque.size == 2);
  assert(deque.get(0) == 3 && deque.get(1) == 5);

  assert(deque.removeBack() == 5);
  assert(deque.size == 1);
  assert(deque.get(0) == 3);

  deque.clear();
  assert(deque.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `insertFront`");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.insertFront(xs[i]);
    assert(deque.size == i+1);
    assert(deque.get(0) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == xs[n-i-1]);
  }
}

unittest {
  writeln(__FILE__, ": Random `insertBack`");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.insertBack(xs[i]);
    assert(deque.size == i+1);
    assert(deque.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `removeFront`");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.insertBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.removeFront() == xs[i]);
    assert(deque.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `removeBack`");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.insertBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.removeBack() == xs[n-i-1]);
    assert(deque.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `set`");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    deque.insertBack(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(deque.set(i, xs2[i]) == xs1[i]);
    assert(deque.get(i) == xs2[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove` 1");

  auto deque = new DualArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  // reverse insertion
  foreach(i; 0..n) {
    deque.add(0, xs[i]);
    assert(deque.size == i+1);
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == xs[n-i-1]);
  }
  foreach(i; 0..n) {
    assert(deque.remove(0) == xs[n-i-1]);
  }
  assert(deque.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove` 2");

  auto deque = new DualArrayDeque!long();
  long[] ys = [];

  long n = 1000;
  long[] xs = randomArray!long(n);
  auto rnd = Random(unpredictableSeed);

  foreach(i; 0..n) {
    auto j = uniform(0, deque.size + 1, rnd);
    deque.add(j, xs[i]);
    ys = ys[0..j] ~ xs[i] ~ ys[j..$];
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == ys[i]);
  }
  foreach(i; 0..n) {
    auto j = uniform(0, deque.size, rnd);
    assert(deque.remove(j) == ys[j]);
    ys = ys[0..j] ~ ys[j+1..$];
  }
  assert(deque.size == 0);
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto deque = new DualArrayDeque!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // DualArrayDeque should be able to execute `insertFront`, `insertBack`, `removeFront` and `removeBack` 10^^6 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("insertFront", () => deque.insertFront(0))(iter, timeLimit);
  testTimeComplexity!("removeFront", () => deque.removeFront())(iter, timeLimit);
  testTimeComplexity!("insertBack", () => deque.insertBack(0))(iter, timeLimit);
  testTimeComplexity!("removeBack", () => deque.removeBack())(iter, timeLimit);
}
