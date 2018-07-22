module odsD.dataStructure.skiplist.SkiplistList;

import std.format;
import std.range;
import std.algorithm;
import std.random;
import std.functional;
import std.traits;

class SkiplistList(T) {

protected:
  Random rnd;

  enum size_t maxHeight = 32;
  Node sentinel;

  size_t n;
  size_t height;

public:
  this(){
    rnd = Random(unpredictableSeed);
    clear();
  }

  // O(maxHeight)
  size_t size() {
    return n;
  }

  // O(maxHeight)
  void clear() {
    n = 0;
    height = 0;
    sentinel = new Node(T.init, 0);
  }

  // average O(log n)
  T get(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SkiplistList with size == %s"(i, n));
  } do {
    return findPred(i).nexts[0].x;
  }

  // average O(log n)
  // @return: previous ith value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SkiplistList with size == %s"(i, n));
  } do {
    Node node = findPred(i).nexts[0];
    T y = node.x;
    node.x = x;
    return y;
  }

  // average O(log n)
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of a SkiplistList with size == %s"(x, i, n));
  } do {
    Node newNode = new Node(x, pickHeight());
    height = max(height, newNode.height);
    add(i, newNode);
  }

  // average O(log n)
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SkiplistList with size == %s"(i, n));
  } do {
    T x;

    Node node = sentinel;
    long j = -1;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && j + node.lengths[r] < i) {
        j += node.lengths[r];
        node = node.nexts[r];
      }
      node.lengths[r]--;
      if (j + node.lengths[r] + 1 == i && node.nexts[r] !is null) {
        x = node.nexts[r].x;
        node.lengths[r] += node.nexts[r].lengths[r];
        node.nexts[r] = node.nexts[r].nexts[r];
        if (node is sentinel && node.nexts[r] is null) {
          if (height > 0) height--;
        }
      }
    }

    n--;
    return x;
  }

  // average O(log n)
  void pushFront(T x) {
    add(0, x);
  }

  // average O(log n)
  void pushBack(T x) {
    add(n, x);
  }

  // average O(log n)
  // @return: removed value
  T popFront() in {
    assert(n > 0, "Attempting to fetch the front of an empty SkiplistList");
  } body {
    return remove(0);
  }

  // average O(log n)
  // @return: removed value
  T popBack() in {
    assert(n > 0, "Attempting to fetch the back of an empty SkiplistList");
  } body {
    return remove(n - 1);
  }

protected:
  Node findPred(size_t i) {
    Node node = sentinel;
    long j = -1;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && j + node.lengths[r] < i) {
        j += node.lengths[r];
        node = node.nexts[r];
      }
    }
    return node;
  }

  size_t pickHeight() {
    size_t bits = rnd.uniform!size_t;
    size_t h = 0;
    for(size_t i=0; bits>>i&1; i++) {
      h++;
    }
    return min(maxHeight, h);
  }

  void add(size_t i, Node newNode) {
    Node node = sentinel;
    long j = -1;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && j + node.lengths[r] < i) {
        j += node.lengths[r];
        node = node.nexts[r];
      }
      node.lengths[r]++;
      if (r <= newNode.height) {
        newNode.nexts[r] = node.nexts[r];
        node.nexts[r] = newNode;
        newNode.lengths[r] = node.lengths[r] - (i - j);
        node.lengths[r] = i - j;
      }
    }

    n++;
  }

  class Node {
    T x;
    size_t height;
    size_t[] lengths;
    Node[] nexts;
    this(T x, size_t height) {
      this.x = x;
      this.height = height;
      this.lengths.length = maxHeight + 1;
      this.nexts.length = maxHeight + 1;
    }
  }

  invariant {
    assert(height <= maxHeight);
  }
}
