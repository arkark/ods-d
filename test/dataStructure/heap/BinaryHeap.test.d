module odsD.test.dataStructure.heap.BinaryHeap;

import odsD.dataStructure.heap.BinaryHeap;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  auto heap = new BinaryHeap!(long, "a < b")();
  assert(heap.size == 0);

  heap.add(2);
  heap.add(5);
  heap.add(4);
  assert(heap.size == 3);

  assert(heap.remove() == 2);
  assert(heap.remove() == 4);
  assert(heap.remove() == 5);
  assert(heap.size == 0);

  heap.add(100);
  heap.add(3);
  assert(heap.size == 2);
  assert(heap.front() == 3);
  assert(heap.size == 2);

  heap.clear();
  assert(heap.size == 0);
}

unittest {
  writeln(__FILE__, ": Use of a defined struct");

  struct Vec {
    long x, y;
    @property long lengthSq() {
      return x*x + y*y;
    }
  }

  auto heap = new BinaryHeap!(Vec, "a.lengthSq < b.lengthSq")();

  heap.add(Vec(10, 20));
  heap.add(Vec(0, 0));
  heap.add(Vec(3, 4));
  heap.add(Vec(-3, 4));

  assert(heap.size == 4);
  assert(heap.remove().lengthSq == 0*0);
  assert(heap.remove().lengthSq == 5*5);
  assert(heap.remove().lengthSq == 5*5);
  assert(heap.remove() == Vec(10, 20));
  assert(heap.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  long n = 1000;
  long[] xs = randomArray!long(n);

  auto heap = new BinaryHeap!long();
  long[] ys = [];

  foreach(i, x; xs) {
    heap.add(x);
    ys ~= x;
    ys.sort!"a<b";

    if(i%2 != 0) {
      assert(heap.remove() == ys[0]);
      ys = ys[1..$];
    }
  }
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto heap = new BinaryHeap!long();
  uint iter = 10^^5;
  auto timeLimit = 2000.msecs;

  long[] xs = randomArray!long(iter);
  long[] ys;

  // BinaryHeap should be able to execute `add` and `remove` 10^^5 times within 2000 ms because the time complexity is O(log n)."

  ys = xs;
  testTimeComplexity!("add", {
    heap.add(ys[0]);
    ys = ys[1..$];
  })(iter, timeLimit);

  testTimeComplexity!("remove", {
    heap.remove();
  })(iter, timeLimit);

}
