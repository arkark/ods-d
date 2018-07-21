module odsD.dataStructure.arrayBasedList.DualArrayDeque;

class DualArrayDeque(T) {
  import odsD.dataStructure.arrayBasedList.ArrayStack;
  import std.algorithm : max;
  import std.format;

private:
  ArrayStack!T frontStack = new ArrayStack!T();
  ArrayStack!T backStack = new ArrayStack!T();

public:
  // O(1)
  this() {
    clear();
  }

  // O(1)
  size_t size() {
    return frontStack.size + backStack.size;
  }

  // O(1)
  T get(size_t i) in {
    assert(i < size, format!"Attempting to fetch the %sth element of an DualArrayDeque with size == %s"(i, size));
  } do {
    if (i < frontStack.size) {
      return frontStack.get(frontStack.size - i - 1);
    } else {
      return backStack.get(i - frontStack.size);
    }
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < size, format!"Attempting to fetch the %sth element of an DualArrayDeque with size == %s"(i, size));
  } do {
    if (i < frontStack.size) {
      return frontStack.set(frontStack.size - i - 1, x);
    } else {
      return backStack.set(i - frontStack.size, x);
    }
  }

  // O(1)
  void clear() {
    frontStack.clear;
    backStack.clear;
  }

  // amortized O(1 + min(i, n-i))
  void add(size_t i, T x) in {
    assert(i <= size, format!"Attempting to add %s to the %sth index of an DualArrayDeque with size == %s"(x, i, size));
  } do {
    if (i < frontStack.size) {
      frontStack.add(frontStack.size - i, x);
    } else {
      backStack.add(i - frontStack.size, x);
    }
    balance();
  }

  // amortized O(1)
  void pushFront(T x) {
    add(0, x);
  }

  // amortized O(1)
  void pushBack(T x) {
    add(size, x);
  }

  // amortized O(1 + min(i, n-i))
  // @return: removed value
  T remove(size_t i) in {
    assert(i < size, format!"Attempting to fetch the %sth element of an DualArrayDeque with size == %s"(i, size));
  } do {
    T x;
    if (i < frontStack.size) {
      x = frontStack.remove(frontStack.size - i - 1);
    } else {
      x = backStack.remove(i - frontStack.size);
    }
    balance();
    return x;
  }

  // amortized O(1)
  T popFront() in {
    assert(size > 0, "Attempting to fetch the front of an empty DualArrayDeque");
  } do {
    return remove(0);
  }

  // amortized O(1)
  T popBack() in {
    assert(size > 0, "Attempting to fetch the back of an empty DualArrayDeque");
  } do {
    return remove(size - 1);
  }

private:
  // O(n)
  void balance() {
    if (isUnbalance) {
      size_t frontN = size/2;
      size_t backN = size - frontN;
      T[] frontXs = new T[max(2*frontN, 1)];
      T[] backXs = new T[max(2*backN, 1)];
      foreach(i; 0..frontN) {
        frontXs[frontN-i-1] = get(i);
      }
      foreach(i; 0..backN) {
        backXs[i] = get(frontN + i);
      }
      frontStack.setArray(frontXs, frontN);
      backStack.setArray(backXs, backN);
    }
  }

  bool isUnbalance() {
    return 3*frontStack.size < backStack.size || 3*backStack.size < frontStack.size;
  }
}

/* Unit Tests */

import util.testFunctions;

unittest {
  writeln(__FILE__, ": Some operations");

  auto deque = new DualArrayDeque!long();
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

  auto deque = new DualArrayDeque!long();
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

  auto deque = new DualArrayDeque!long();
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

  auto deque = new DualArrayDeque!long();
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

  auto deque = new DualArrayDeque!long();
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

  auto deque = new DualArrayDeque!long();
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
  writeln(__FILE__, ": Time complexity");

  auto deque = new DualArrayDeque!long();
  uint iter = 10^^6;
  auto timeLimit = 2000.msecs;

  // DualArrayDeque should be able to execute `pushFront`, `pushBack`, `popFront` and `popBack` 10^^6 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("pushFront", () => deque.pushFront(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => deque.popFront())(iter, timeLimit);
  testTimeComplexity!("pushBack", () => deque.pushBack(0))(iter, timeLimit);
  testTimeComplexity!("popBack", () => deque.popBack())(iter, timeLimit);
}
