module odsD.dataStructure.heap.BinaryHeap;

import odsD.util.Maybe;
import std.algorithm;
import std.functional;

// Binary Heap
//   - Min Heap: the root node has the **minimum** value among all nodes.
class BinaryHeap(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  T[] xs;
  size_t n;

public:
  // O(1)
  this() {
    clear();
  }

  // O(1)
  void clear() {
    n = 0;
    xs = [];
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(log n)
  void add(T x) {
    if (n+1 > xs.length) {
      resize();
    }
    xs[n++] = x;
    bubbleUp(n - 1);
  }

  // O(log n)
  // @return: removed value
  T remove() in {
    assert(n > 0, "Attempting to fetch the front of an empty BinaryHeap");
  } do {
    T x = xs[0];
    xs[0] = xs[--n];
    trickleDown(0);
    if (3*n < xs.length) {
      resize();
    }
    return x;
  }


protected:
  size_t left(size_t i) {
    return 2*i + 1;
  }

  size_t right(size_t i) {
    return 2*i + 2;
  }

  size_t parent(size_t i) in {
    assert(i > 0);
  } do {
    return (i - 1)/2;
  }

  void bubbleUp(size_t i) {
    while(i > 0) {
      size_t p = parent(i);
      if (!_less(xs[i], xs[p])) break;
      swap(xs[i], xs[p]);
      i = p;
    }
  }

  void trickleDown(size_t i) {
    while(true) {
      size_t l = left(i);
      size_t r = right(i);
      auto target = None!size_t;
      if (r < n && _less(xs[r], xs[i])) {
        if (_less(xs[l], xs[r])) {
          target = Just(l);
        } else {
          target = Just(r);
        }
      } else if (l < n && _less(xs[l], xs[i])) {
        target = Just(l);
      }

      if (target.isNone) break;
      size_t j = target.get;
      swap(xs[i], xs[j]);
      i = j;
    }
  }

  // O(n)
  void resize() {
    T[] ys = new T[max(2*n, 1)];
    foreach(i; 0..n) {
      ys[i] = xs[i];
    }
    xs = ys;
  }

}
