module odsD.dataStructure.arrayBasedList.ArrayDeque;

import std.format;
import std.algorithm;

class ArrayDeque(T) {

protected:
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
  void insertFront(T x) {
    add(0, x);
  }

  // amortized O(1)
  void insertBack(T x) {
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
  T removeFront() in {
    assert(n > 0, "Attempting to fetch the front of an empty ArrayDeque");
  } do {
    return remove(0);
  }

  // amortized O(1)
  T removeBack() in {
    assert(n > 0, "Attempting to fetch the back of an empty ArrayDeque");
  } do {
    return remove(n - 1);
  }

protected:
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
