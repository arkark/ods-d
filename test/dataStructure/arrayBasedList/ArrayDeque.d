module odsD.test.dataStructure.arrayBasedList.ArrayDeque;

import odsD.dataStructure.arrayBasedList.ArrayDeque;
import odsD.test.testFunctions;

unittest {
  writeln(__FILE__, ": Some operations");

  auto deque = new ArrayDeque!long();
  assert(deque.size == 0);

  deque.pushBack(2);
  deque.pushBack(5);
  deque.pushFront(3);
  assert(deque.size == 3);
  assert(deque.get(0) == 3 && deque.get(1) == 2 && deque.get(2) == 5);

  assert(deque.remove(1) == 2);
  assert(deque.size == 2);
  assert(deque.get(0) == 3 && deque.get(1) == 5);

  deque.add(0, 10);
  assert(deque.size == 3);
  assert(deque.get(0) == 10 && deque.get(1) == 3 && deque.get(2) == 5);

  assert(deque.popFront() == 10);
  assert(deque.size == 2);
  assert(deque.get(0) == 3 && deque.get(1) == 5);

  assert(deque.popBack() == 5);
  assert(deque.size == 1);
  assert(deque.get(0) == 3);

  deque.clear();
  assert(deque.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `pushFront`");

  auto deque = new ArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.pushFront(xs[i]);
    assert(deque.size == i+1);
    assert(deque.get(0) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == xs[n-i-1]);
  }
}

unittest {
  writeln(__FILE__, ": Random `pushBack`");

  auto deque = new ArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.pushBack(xs[i]);
    assert(deque.size == i+1);
    assert(deque.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `popFront`");

  auto deque = new ArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.pushBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.popFront() == xs[i]);
    assert(deque.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `popBack`");

  auto deque = new ArrayDeque!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    deque.pushBack(xs[i]);
  }
  foreach(i; 0..n) {
    assert(deque.popBack() == xs[n-i-1]);
    assert(deque.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `set`");

  auto deque = new ArrayDeque!long();
  long n = 1000;
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    deque.pushBack(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(deque.set(i, xs2[i]) == xs1[i]);
    assert(deque.get(i) == xs2[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  auto deque = new ArrayDeque!long();
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
  writeln(__FILE__, ": Time complexity");

  auto deque = new ArrayDeque!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // ArrayDeque should be able to execute `pushFront`, `pushBack`, `popFront` and `popBack` 10^^7 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("pushFront", () => deque.pushFront(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => deque.popFront())(iter, timeLimit);
  testTimeComplexity!("pushBack", () => deque.pushBack(0))(iter, timeLimit);
  testTimeComplexity!("popBack", () => deque.popBack())(iter, timeLimit);
}
