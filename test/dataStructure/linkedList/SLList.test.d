module odsD.test.dataStructure.linkedList.SLList;

import odsD.dataStructure.linkedList.SLList;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto list = new SLList!long();
  assert(list.size == 0);

  list.insertFront(2); // pop -> [2]
  list.insertFront(5); // pop -> [5, 2]
  list.insertBack(3);  // add -> [5, 2, 3]
  assert(list.size == 3);

  assert(list.removeFront() == 5);
  assert(list.removeFront() == 2);
  assert(list.removeFront() == 3);
  assert(list.size == 0);

  list.push(1000);
  assert(list.size == 1);
  list.clear();
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `insertFront`");

  auto list = new SLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertFront(xs[i]);
    assert(list.size == i+1);
  }
  foreach(i; 0..n) {
    assert(list.removeFront() == xs[n-i-1]);
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `insertBack`");

  auto list = new SLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.insertBack(xs[i]);
    assert(list.size == i+1);
  }
  foreach(i; 0..n) {
    assert(list.removeFront() == xs[i]);
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto list = new SLList!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // SLList should be able to execute `insertFront`, `insertBack` and `removeFront` 10^^6 times within 2000 ms because the time complexity is O(1)."
  testTimeComplexity!("insertFront", () => list.insertFront(0))(iter, timeLimit);
  testTimeComplexity!("removeFront", () => list.removeFront())(iter, timeLimit);
  testTimeComplexity!("insertBack", () => list.insertBack(0))(iter, timeLimit);
  testTimeComplexity!("removeFront", () => list.removeFront())(iter, timeLimit);
}
