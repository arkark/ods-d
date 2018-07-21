module odsD.dataStructure.arrayBasedList.ArrayStack;

class ArrayStack(T) {
  import std.algorithm : max;
  import std.format;

private:
  T[] xs;
  size_t n;

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
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayStack with size == %s"(i, n));
  } do {
    return xs[i];
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayStack with size == %s"(i, n));
  } do {
    T y = xs[i];
    xs[i] = x;
    return y;
  }

  // O(1)
  void clear() {
    n = 0;
    xs = [];
  }

  // amortized O(1 + n - i)
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of an ArrayStack with size == %s"(x, i, n));
  } do {
    if (n + 1 >= xs.length) {
      resize();
    }
    foreach_reverse(j; i..n) {
      xs[j+1] = xs[j];
    }
    xs[i] = x;
    n++;
  }

  // amortized O(1 + n - i)
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an ArrayStack with size == %s"(i, n));
  } do {
    T x = xs[i];
    foreach(j; i+1..n) {
      xs[j-1] = xs[j];
    }
    n--;
    if (xs.length >= 3*n) {
      resize();
    }
    return x;
  }

  // amortized O(1)
  void push(T x) {
    add(n, x);
  }

  // amortized O(1)
  T pop() in {
    assert(n > 0, "Attempting to fetch the back of an empty ArrayStack");
  } do {
    return remove(n - 1);
  }

package:
  // O(1)
  void setArray(T[] xs, size_t n) {
    this.xs = xs;
    this.n = n;
  }

private:
  // O(n)
  void resize() {
    T[] ys = new T[max(2*n, 1)];
    foreach(i; 0..n) {
      ys[i] = xs[i];
    }
    xs = ys;
  }

  invariant {
    assert(n >= 0);
    assert(n <= xs.length);
  }
}

/* Unit Tests */

import util.testFunctions;

unittest {
  writeln(__FILE__, ": Some operations");

  auto stack = new ArrayStack!long();
  assert(stack.size == 0);

  stack.push(2);
  stack.push(5);
  stack.push(3);
  assert(stack.size == 3);
  assert(stack.get(0) == 2 && stack.get(1) == 5 && stack.get(2) == 3);

  assert(stack.remove(1) == 5);
  assert(stack.size == 2);
  assert(stack.get(0) == 2 && stack.get(1) == 3);

  stack.add(0, 10);
  assert(stack.size == 3);
  assert(stack.get(0) == 10 && stack.get(1) == 2 && stack.get(2) == 3);

  assert(stack.pop() == 3);
  assert(stack.size == 2);
  assert(stack.get(0) == 10 && stack.get(1) == 2);

  stack.clear();
  assert(stack.size == 0);
}

unittest {
  writeln(__FILE__, ": Random `push`");

  auto stack = new ArrayStack!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    stack.push(xs[i]);
    assert(stack.size == i+1);
    assert(stack.get(i) == xs[i]);
  }
  foreach(i; 0..n) {
    assert(stack.get(i) == xs[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `pop`");

  auto stack = new ArrayStack!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  foreach(i; 0..n) {
    stack.push(xs[i]);
  }
  foreach(i; 0..n) {
    assert(stack.pop() == xs[n-i-1]);
    assert(stack.size == n-i-1);
  }
}

unittest {
  writeln(__FILE__, ": Random `set`");

  auto stack = new ArrayStack!long();
  long n = 1000;
  long[] xs1 = randomArray!long(n);
  long[] xs2 = randomArray!long(n);

  foreach(i; 0..n) {
    stack.push(xs1[i]);
  }
  foreach(i; 0..n) {
    assert(stack.set(i, xs2[i]) == xs1[i]);
    assert(stack.get(i) == xs2[i]);
  }
}

unittest {
  writeln(__FILE__, ": Random `add` and `remove`");

  auto stack = new ArrayStack!long();
  long n = 1000;
  long[] xs = randomArray!long(n);

  // reverse insertion
  foreach(i; 0..n) {
    stack.add(0, xs[i]);
    assert(stack.size == i+1);
  }
  foreach(i; 0..n) {
    assert(stack.get(i) == xs[n-i-1]);
  }
  foreach(i; 0..n) {
    assert(stack.remove(0) == xs[n-i-1]);
  }
  assert(stack.size == 0);
}

unittest {
  writeln(__FILE__, ": Time complexity");

  auto stack = new ArrayStack!long();
  uint iter = 10^^7;
  auto timeLimit = 2000.msecs;

  // ArrayStack should be able to execute `push` and `pop` 10^^7 times within 2000 ms because the time complexity is amortized O(1)."
  testTimeComplexity!("push", () => stack.push(0))(iter, timeLimit);
  testTimeComplexity!("pop", () => stack.pop())(iter, timeLimit);
}
