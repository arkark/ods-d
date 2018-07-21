module odsD.test.dataStructure.arrayBasedList.ArrayQueue;

import odsD.dataStructure.arrayBasedList.ArrayQueue;
import odsD.test.testFunctions;

unittest {
  writeln(__FILE__, ": Some operations");

  auto queue = new ArrayQueue!long();
  assert(queue.size == 0);

  queue.push(2);
  queue.push(5);
  queue.push(3);
  assert(queue.size == 3);
  assert(queue.get(0) == 2 && queue.get(1) == 5 && queue.get(2) == 3);

  assert(queue.remove() == 2);
  assert(queue.size == 2);
  assert(queue.get(0) == 5 && queue.get(1) == 3);

  queue.add(10);
  assert(queue.size == 3);
  assert(queue.get(0) == 5 && queue.get(1) == 3 && queue.get(2) == 10);

  queue.clear();
  assert(queue.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `push`");

  auto queue = new ArrayQueue!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    queue.push(xs[i]);
    assert(queue.size == i+1);
    assert(queue.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(queue.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `pop`");

  auto queue = new ArrayQueue!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    queue.push(xs[i]);
  }
  foreach(i; 0..n) {
    assert(queue.pop() == xs[i]);
    assert(queue.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `get` and `set`");

  auto queue = new ArrayQueue!long();
  long n = 1000;
  long m = 100;
  assert(m <= n);
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    queue.push(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(queue.set(i, xs2[i]) == xs1[i]);
    assert(queue.get(i) == xs2[i]);
  }
  foreach(i; 0..m) {
    queue.pop();
  }
  foreach(i; 0..n-m) {
    assert(queue.set(i, xs1[i]) == xs2[m+i]);
    assert(queue.get(i) == xs1[i]);
  }

}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto stack = new ArrayQueue!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // ArrayQueue should be able to execute `push` and `pop` 10^^6 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("push", () => stack.push(0))(iter, timeLimit);
  testTimeComplexity!("pop", () => stack.pop())(iter, timeLimit);
}
