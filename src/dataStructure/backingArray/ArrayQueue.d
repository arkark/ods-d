module odsD.dataStructure.backingArray.ArrayQueue;

class ArrayQueue(T) {
  import std.algorithm : max;
  import std.format;

private:
  T[] xs;
  size_t n;
  size_t offset;

public:
  // O(1)
  this() {
    clear();
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(1)
  T get(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayQueue with size == %s"(i, n));
  } do {
    return xs[(offset + i)%$];
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayQueue with size == %s"(i, n));
  } do {
    T y = xs[(offset + i)%$];
    xs[(offset + i)%$] = x;
    return y;
  }

  // O(1)
  void clear() {
    offset = 0;
    n = 0;
    xs = [];
  }

  // amortized O(1)
  void add(T x) {
    if (n + 1 >= xs.length) {
      resize();
    }
    xs[(offset + n)%$] = x;
    n++;
  }

  alias push = add;

  // amortized O(1)
  // @return: removed value
  T remove() in {
    assert(n > 0, "Attempting to fetch the front of an empty ArrayQueue");
  } do {
    T x = xs[offset];
    offset = (offset + 1)%xs.length;
    n--;
    if (xs.length >= 3*n) {
      resize();
    }
    return x;
  }

  alias pop = remove;

private:
  // O(n)
  void resize() {
    T[] ys = new T[max(2*n, 1)];
    foreach(i; 0..n) {
      ys[i] = xs[(offset + i)%$];
    }
    xs = ys;
    offset = 0;
  }

  invariant {
    assert(n >= 0);
    assert(n <= xs.length);
    assert(offset <= xs.length);
  }
}

/* Unit Tests */

import util.testFunctions;

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
  writeln(__FILE__, ": Time complexity");

  auto stack = new ArrayQueue!long();
  uint iter = 10^^7;
  auto timeLimit = 2000.msecs;

  // ArrayQueue should be able to execute `push` and `pop` 10^^7 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("push", () => stack.push(0))(iter, timeLimit);
  testTimeComplexity!("pop", () => stack.pop())(iter, timeLimit);
}
