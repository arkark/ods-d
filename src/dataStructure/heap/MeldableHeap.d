module odsD.dataStructure.heap.MeldableHeap;

import odsD.util.Maybe;
import std.algorithm;
import std.functional;
import std.random;

// Meldable Heap
//   - Min Heap: the root node has the **minimum** value among all nodes.
class MeldableHeap(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)) == bool)) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  Random rnd;
  Node nil;

  Node root;
  size_t n;

public:
  // O(1)
  this() {
    rnd = Random(unpredictableSeed);
    nil = new Node;
    clear();
  }

  // O(1)
  void clear() {
    n = 0;
    root = nil;
  }

  // O(1)
  size_t size() {
    return n;
  }

  // average O(log n)
  void add(T x) {
    Node node = createNode(x);
    root = merge(node, root);
    root.parent = nil;
    n++;
  }

  // O(1)
  T front() in {
    assert(n > 0, "Attempting to fetch the front of an empty MeldableHeap");
  } do {
    return root.x;
  }

  // average O(log n)
  T remove() in {
    assert(n > 0, "Attempting to fetch the front of an empty MeldableHeap");
  } do {
    T x = root.x;
    root = merge(root.left, root.right);
    if (root !is nil) {
      root.parent = nil;
    }
    n--;
    return x;
  }

protected:
  // average O(log (h1.size + h2.size))
  Node merge(Node h1, Node h2) {
    if (h1 is nil) return h2;
    if (h2 is nil) return h1;
    if (_less(h2.x, h1.x)) return merge(h2, h1);

    if (uniform(0, 2, rnd) == 0) {
      h1.left = merge(h1.left, h2);
      if (h1.left !is nil) {
        h1.left.parent = h1;
      }
    } else {
      h1.right = merge(h1.right, h2);
      if (h1.right.parent !is nil) {
        h1.right.parent = h1;
      }
    }
    return h1;
  }

  Node createNode(T x) {
    Node node = new Node;
    node.x = x;
    node.parent = nil;
    node.left = nil;
    node.right = nil;
    return node;
  }

  class Node {
    T x;
    Node parent;
    Node left;
    Node right;
    this() {
      x = T.init;
    }
  }

}
