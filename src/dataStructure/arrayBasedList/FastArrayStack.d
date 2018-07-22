module odsD.dataStructure.arrayBasedList.FastArrayStack;

import std.format;
import std.algorithm;
import core.stdc.string : memcpy, memmove;

class FastArrayStack(T) {

protected:
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
    assert(i < n, format!"Attempting to fetch the %sth element of a StackArrayStack with size == %s"(i, n));
  } do {
    return xs[i];
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a StackArrayStack with size == %s"(i, n));
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
    assert(i <= n, format!"Attempting to add %s to the %sth index of a StackArrayStack with size == %s"(x, i, n));
  } do {
    if (n + 1 >= xs.length) {
      resize();
    }
    memmove(xs.ptr + (i + 1), xs.ptr + i, T.sizeof * (n - i)); //
    xs[i] = x;
    n++;
  }

  // amortized O(n - i)
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a StackArrayStack with size == %s"(i, n));
  } do {
    T x = xs[i];
    memmove(xs.ptr + i, xs.ptr + (i + 1), T.sizeof * (n - i - 1)); //
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

protected:
  // O(n)
  void resize() {
    T[] ys = new T[max(2*n, 1)];
    memcpy(ys.ptr, xs.ptr, T.sizeof * min(xs.length, ys.length)); //
    xs = ys;
  }

  invariant {
    assert(n <= xs.length);
  }
}
