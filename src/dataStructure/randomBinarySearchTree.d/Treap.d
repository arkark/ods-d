module odsD.dataStructure.randomBinarySearchTree.Treap;

import odsD.util.Maybe;
import std.random;
import std.functional;

class Treap(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  Random rnd;
  Node nil;

  Node root;
  size_t n;

public:
  this() {
    rnd = Random(unpredictableSeed);
    nil = new Node;
    clear();
  }

  void clear() {
    root = nil;
    n = 0;
  }

  size_t size() {
    return n;
  }

  // average O(log n)
  Maybe!T findEQ(T x) {
    Node node = root;
    while(node !is nil) {
      if (_less(x, node.x)) {
        node = node.left;
      } else if (_less(node.x, x)) {
        node = node.right;
      } else {
        return Just(node.x);
      }
    }
    return None!T;
  }

  // average O(log n)
  // @return: min{ y \in this | y >= x }
  Maybe!T find(T x) {
    Node node = root;
    Maybe!T result = None!T;
    while(node !is nil) {
      if (_less(x, node.x)) {
        result = Just(node.x);
        node = node.left;
      } else if (_less(node.x, x)) {
        node = node.right;
      } else {
        return Just(node.x);
      }
    }
    return result;
  }

  // average O(log n)
  bool exists(T x) {
    return findEQ(x).isJust;
  }

  // average O(log n)
  // @return:
  //  true  ... if x was added successfully
  //  false ... if x already exists
  bool add(T x) {
    Node parent = findLast(x);
    Node node = createNode(x);
    if (addChild(parent, node)) {
      bubbleUp(node);
      return true;
    } else {
      return false;
    }
  }

  // average O(log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    Node node = findLast(x);
    if (node !is nil && _eq(node.x, x)) {
      trickleDown(node);
      splice(node);
      return true;
    } else {
      return false;
    }
  }

protected:
  // (u, A, (w, B, C)) => (w, (u, A, B), C)
  void rotateLeft(Node u) {
    Node w = u.right;
    w.parent = u.parent;
    if (w.parent !is nil) {
      if (w.parent.left is u) {
        w.parent.left = w;
      } else {
        w.parent.right = w;
      }
    }
    u.right = w.left;
    if (u.right !is nil) {
      u.right.parent = u;
    }
    u.parent = w;
    w.left = u;
    if (u is root) {
      root = w;
      root.parent = nil;
    }
  }

  // (u, (w, A, B), C) => (w, A, (u, B, C))
  void rotateRight(Node u) {
    Node w = u.left;
    w.parent = u.parent;
    if (w.parent !is nil) {
      if (w.parent !is nil) {
        if (w.parent.left is u) {
          w.parent.left = w;
        } else {
          w.parent.right = w;
        }
      }
    }
    u.left = w.right;
    if (u.left !is nil) {
      u.left.parent = u;
    }
    u.parent = w;
    w.right = u;
    if (u is root) {
      root = w;
      root.parent = nil;
    }
  }

  void bubbleUp(Node node) {
    while(node.parent !is nil && node.parent.priority > node.priority) {
      if (node.parent.right is node) {
        rotateLeft(node.parent);
      } else {
        rotateRight(node.parent);
      }
    }
    if (node.parent is nil) {
      root = node;
    }
  }

  void trickleDown(Node node) {
    while(node.left !is nil || node.right !is nil) {
      if (node.left is nil) {
        rotateLeft(node);
      } else if (node.right is nil) {
        rotateRight(node);
      } else if (node.left.priority < node.right.priority) {
        rotateRight(node);
      } else {
        rotateLeft(node);
      }
      if (node is root) {
        root = node.parent;
      }
    }
  }

  Node findLast(T x) {
    Node node = root;
    Node prev = nil;
    while(node !is nil) {
      prev = node;
      if (_less(x, node.x)) {
        node = node.left;
      } else if (_less(node.x, x)) {
        node = node.right;
      } else {
        return node;
      }
    }
    return prev;
  }

  bool addChild(Node parent, Node child) in {
    assert(child !is null && child !is nil);
  } do {
    if (parent is nil) {
      root = child;
    } else {
      if (_less(child.x, parent.x)) {
        parent.left = child;
      } else if (_less(parent.x, child.x)) {
        parent.right = child;
      } else {
        return false; // child.x already exists
      }
      child.parent = parent;
    }
    n++;
    return true;
  }

  void splice(Node node) in {
    assert(node !is null && node !is nil);
  } do {
    Node child = node.left !is nil ? node.left : node.right;
    Node parent;
    if (node is root) {
      root = child;
      parent = nil;
    } else {
      parent = node.parent;
      if (parent.left is node) {
        parent.left = child;
      } else {
        parent.right = child;
      }
    }
    if (child !is nil) {
      child.parent = parent;
    }

    n--;
  }

  Node createNode(T x) {
    Node node = new Node;
    node.x = x;
    node.parent = nil;
    node.left = nil;
    node.right = nil;
    node.priority = rnd.uniform!size_t;
    return node;
  }

  class Node {
    T x;
    Node parent;
    Node left;
    Node right;
    size_t priority;
    this() {
      x = T.init;
    }
  }

}
