module odsD.test.dataStructure.linkedList.SLList;

import odsD.dataStructure.linkedList.SLList;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto list = new SLList!long();
  assert(list.size == 0);

  list.pushFront(2); // pop -> [2]
  list.pushFront(5); // pop -> [5, 2]
  list.pushBack(3);  // add -> [5, 2, 3]
  assert(list.size == 3);

  assert(list.popFront() == 5);
  assert(list.popFront() == 2);
  assert(list.popFront() == 3);
  assert(list.size == 0);

  list.push(1000);
  assert(list.size == 1);
  list.clear();
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `pushFront`");

  auto list = new SLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushFront(xs[i]);
    assert(list.size == i+1);
  }
  foreach(i; 0..n) {
    assert(list.popFront() == xs[n-i-1]);
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `pushBack`");

  auto list = new SLList!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    list.pushBack(xs[i]);
    assert(list.size == i+1);
  }
  foreach(i; 0..n) {
    assert(list.popFront() == xs[i]);
  }
  assert(list.size == 0);
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto list = new SLList!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // SLList should be able to execute `pushFront`, `pushBack` and `popFront` 10^^6 times within 2000 ms because the time complexity is O(1)."
  testTimeComplexity!("pushFront", () => list.pushFront(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => list.popFront())(iter, timeLimit);
  testTimeComplexity!("pushBack", () => list.pushBack(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => list.popFront())(iter, timeLimit);
}
