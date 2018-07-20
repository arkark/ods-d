module odsD.dataStructure.arrayBasedList.ArrayDeque;

class ArrayDeque(T) {
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
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayDeque with size == %s"(i, n));
  } do {
    return xs[(offset + i)%$];
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayDeque with size == %s"(i, n));
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

  // amortized O(1 + min(i, n-i))
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of an ArrayDeque with size == %s"(x, i, n));
  } do {
    if (n + 1 >= xs.length) {
      resize();
    }
    n++;
    if (i < n/2) {
      offset = offset==0 ? xs.length-1 : offset-1;
      foreach(j; 0..i) {
        set(j, get(j + 1));
      }
    } else {
      foreach_reverse(j; i+1..n) {
        set(j, get(j-1));
      }
    }
    set(i, x);
  }

  // amortized O(1)
  void pushFront(T x) {
    add(0, x);
  }

  // amortized O(1)
  void pushBack(T x) {
    add(n, x);
  }

  // amortized O(1 + min(i, n-i))
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayDeque with size == %s"(i, n));
  } do {
    T x = get(i);
    if (i < n/2) {
      foreach_reverse(j; 0..i) {
        set(j + 1, get(j));
      }
      offset = (offset + 1)%xs.length;
    } else {
      foreach(j; i+1..n) {
        set(j - 1, get(j));
      }
    }
    n--;
    if (xs.length >= 3*n) {
      resize();
    }
    return x;
  }

  // amortized O(1)
  T popFront() in {
    assert(n > 0, "Attempting to fetch the front of an empty ArrayDeque");
  } do {
    return remove(0);
  }

  // amortized O(1)
  T popBack() in {
    assert(n > 0, "Attempting to fetch the back of an empty ArrayDeque");
  } do {
    return remove(n - 1);
  }

private:
  // O(n)
  void resize() {
    T[] ys = new T[max(2*n, 1)];
    foreach(i; 0..n) {
      ys[i] = get(i);
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
  uint iter = 10^^7;
  auto timeLimit = 2000.msecs;

  // ArrayDeque should be able to execute `pushFront`, `pushBack`, `popFront` and `popBack` 10^^7 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("pushFront", () => deque.pushFront(0))(iter, timeLimit);
  testTimeComplexity!("popFront", () => deque.popFront())(iter, timeLimit);
  testTimeComplexity!("pushBack", () => deque.pushBack(0))(iter, timeLimit);
  testTimeComplexity!("popBack", () => deque.popBack())(iter, timeLimit);
}
