module odsD.dataStructure.skiplist.SkiplistSSet;

import std.format;
import std.range;
import std.algorithm;
import std.random;
import std.functional;
import std.traits;

class SkiplistSSet(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);
  Random rnd;

  enum size_t maxHeight = 32;
  Node sentinel;

  size_t n;
  size_t height;
  Node[] stack;

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
    stack = new Node[maxHeight + 1];
  }

  // average O(log n)
  // @return: (y_0, y_1, ...) where y_0 = min{y \in this | y >= x} and y_0 <= y_1 <= ...
  auto find(T x) {
    Node node = findPredNode(x);
    return FindResult(node.nexts[0]);
  }
  static assert(isInputRange!(ReturnType!find));

  // average O(log n)
  bool exists(T x) {
    auto r = find(x);
    return !r.empty && _eq(r.front, x);
  }

  // average O(log n)
  // @return:
  //   true  ... if x was added successfully
  //   false ... if x already exists
  bool add(T x) {
    Node node = sentinel;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && _less(node.nexts[r].x, x)) {
        node = node.nexts[r];
      }
      if (node.nexts[r] !is null && _eq(node.nexts[r].x, x)) {
        return false;
      }
      stack[r] = node;
    }

    Node newNode = new Node(x, pickHeight());
    foreach(h; height+1..newNode.height+1) {
      stack[h] = sentinel;
    }
    height = max(height, newNode.height);
    foreach(i; 0..newNode.height+1) {
      newNode.nexts[i] = stack[i].nexts[i];
      stack[i].nexts[i] = newNode;
    }

    n++;
    return true;
  }

  // average O(log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    bool removed = false;
    Node node = sentinel;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && _less(node.nexts[r].x, x)) {
        node = node.nexts[r];
      }
      if (node.nexts[r] !is null && _eq(node.nexts[r].x, x)) {
        removed = true;
        node.nexts[r] = node.nexts[r].nexts[r];
        if (node is sentinel && node.nexts[r] is null) {
          if (height > 0) height--;
        }
      }
    }
    if (removed) {
      n--;
    }
    return removed;
  }

protected:
  Node findPredNode(T x) {
    Node node = sentinel;
    foreach_reverse(r; 0..height+1) {
      while(node.nexts[r] !is null && _less(node.nexts[r].x, x)) {
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

  class Node {
    T x;
    size_t height;
    Node[] nexts;
    this(T x, size_t height) {
      this.x = x;
      this.height = height;
      this.nexts.length = maxHeight + 1;
    }
  }

  struct FindResult {
  private:
    Node node;
  public:
    this(Node node) {
      this.node = node;
    }
    @property bool empty() {
      return node is null;
    }
    @property T front() in {
      assert(!empty, "Attempting to fetch the front of an FindResult of long");
    } body {
      return node.x;
    }
    void popFront() {
      node = node.nexts[0];
    }
  }

  invariant {
    assert(height <= maxHeight);
  }
}
