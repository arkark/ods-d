module odsD.dataStructure.arrayBasedList.RootishArrayStack;

class RootishArrayStack(T) {
  import odsD.dataStructure.arrayBasedList.ArrayStack;
  import std.math : sqrt, ceil;
  import std.format;

private:
  ArrayStack!(T[]) blocks = new ArrayStack!(T[])();
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
    assert(i < n, format!"Attempting to fetch the %sth element of an RootishArrayStack with size == %s"(i, n));
  } do {
    size_t b = i2b(i);
    size_t j = i - b*(b + 1)/2;
    return blocks.get(b)[j];
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an RootishArrayStack with size == %s"(i, n));
  } do {
    size_t b = i2b(i);
    size_t j = i - b*(b + 1)/2;
    T y = blocks.get(b)[j];
    blocks.get(b)[j] = x;
    return y;
  }

  // O(1)
  void clear() {
    n = 0;
    blocks.clear;
  }

  // amortized O(1 + n - i)
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of an RootishArrayStack with size == %s"(x, i, n));
  } do {
    size_t r = blocks.size;
    glow();
    n++;
    foreach_reverse(j; i+1..n) {
      set(j, get(j - 1));
    }
    set(i, x);
  }

  // amortized O(n - i)
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of an RootishArrayStack with size == %s"(i, n));
  } do {
    T x = get(i);
    foreach(j; i+1..n) {
      set(j - 1, get(j));
    }
    n--;
    size_t r = blocks.size;
    shrink();
    return x;
  }

  // amortized O(1)
  void push(T x) {
    add(n, x);
  }

  // amortized O(1)
  T pop() in {
    assert(n > 0, "Attempting to fetch the back of an empty RootishArrayStack");
  } do {
    return remove(n - 1);
  }

private:
  // index to block
  size_t i2b(size_t i) {
    return cast(size_t)(ceil(
      (-3.0 + sqrt(9.0 + 8.0*i)) / 2.0
    ) + 0.5);
  }

  void glow() {
    size_t r = blocks.size;
    while (r*(r + 1)/2 < n+1) {
      blocks.push(new T[blocks.size + 1]);
      r++;
    }
  }

  void shrink() {
    size_t r = blocks.size;
    while(r >= 2 && (r - 2)*(r - 1)/2 >= n) {
      blocks.pop();
      r--;
    }
  }
}
