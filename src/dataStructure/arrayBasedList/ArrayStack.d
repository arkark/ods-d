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
