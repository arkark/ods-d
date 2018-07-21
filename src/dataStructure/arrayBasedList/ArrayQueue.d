module odsD.dataStructure.arrayBasedList.ArrayQueue;

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
    n++;
    set(n - 1, x);
  }

  // amortized O(1)
  alias push = add;

  // amortized O(1)
  // @return: removed value
  T remove() in {
    assert(n > 0, "Attempting to fetch the front of an empty ArrayQueue");
  } do {
    T x = get(0);
    offset = (offset + 1)%xs.length;
    n--;
    if (xs.length >= 3*n) {
      resize();
    }
    return x;
  }

  // amortized O(1)
  alias pop = remove;

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
    assert(n <= xs.length);
    assert(offset <= xs.length);
  }
}
