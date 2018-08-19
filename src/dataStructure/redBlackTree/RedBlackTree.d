module odsD.dataStructure.redBlackTree.RedBlackTree;

import odsD.util.Maybe;
import std.algorithm;
import std.functional;

class RedBlackTree(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  Node nil;
  Node root;

  size_t n;

public:
  this() {
    nil = new Node;
    nil.color = Color.Black;
    clear();
  }

  void clear() {
    root = nil;
    n = 0;
  }

  size_t size() {
    return n;
  }

  // O(log n)
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

  // O(log n)
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

  // O(log n)
  bool exists(T x) {
    return findEQ(x).isJust;
  }

  // O(log n)
  // @return:
  //   true  ... if x was added successfully
  //   false ... if x already exists
  bool add(T x) {
    Node node = createNode(x);
    Node parent = findLast(x);

    if (addChild(parent, node)) {
      addFixup(node);
      return true;
    } else {
      return false;
    }
  }

  // O(log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    Node u = findLast(x);
    if (u is nil || !_eq(u.x, x)) {
      return false;
    }
    Node w = u.right;
    if (w is nil) {
      w = u;
      u = w.left;
    } else {
      while(w.left !is nil) {
        w = w.left;
      }
      u.x = w.x;
      u = w.right;
    }
    splice(w);
    u.color += w.color;
    u.parent = w.parent;
    removeFixup(u);
    return true;
  }

protected:
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

  void pushBlack(Node node) in {
    assert(node !is nil);
  } do {
    node.color--;
    node.left.color++;
    node.right.color++;
  }

  void pullBlack(Node node) in {
    assert(node !is nil);
  } do {
    node.color++;
    node.left.color--;
    node.right.color--;
  }

  void flipLeft(Node node) {
    swap(node.color, node.right.color);
    rotateLeft(node);
  }

  void flipRight(Node node) {
    swap(node.color, node.left.color);
    rotateRight(node);
  }

  // O(log n)
  void addFixup(Node node) {
    while(node.color == Color.Red) {
      if (node is root) {
        node.color = Color.Black;
        return;
      }
      Node parent = node.parent;
      if (parent.left.color == Color.Black) {
        assert(parent.right is node);
        flipLeft(parent);
        node = parent;
        parent = node.parent;
      }
      if (parent.color == Color.Black) {
        return;
      }
      Node grand = parent.parent;
      assert(grand !is nil && grand is node.parent.parent);
      if (grand.right.color == Color.Black) {
        flipRight(grand);
        return;
      } else {
        pushBlack(grand);
        node = grand;
      }
    }
  }

  // O(log n)
  void removeFixup(Node node) {
    while(node.color == Color.DoubleBlack) {
      if (node is root) {
        node.color = Color.Black;
      } else if (node.parent.left.color == Color.Red) {
        node = removeFixupCase1(node);
      } else if (node is node.parent.left) {
        node = removeFixupCase2(node);
      } else {
        node = removeFixupCase3(node);
      }
    }
    if (node !is root) {
      Node parent = node.parent;
      if (parent.right.color == Color.Red && parent.left.color == Color.Black) {
        flipLeft(parent);
      }
    }
  }

  Node removeFixupCase1(Node u) {
    flipRight(u.parent);
    return u;
  }

  Node removeFixupCase2(Node u) {
    Node w = u.parent;
    Node v = w.right;
    pullBlack(w);
    flipLeft(w);
    assert(w.color == Color.Red);
    Node q = w.right;
    if (q.color == Color.Red) {
      rotateLeft(w);
      flipRight(v);
      pushBlack(q);
      if (v.right.color == Color.Red) {
        flipLeft(v);
      }
      return q;
    } else {
      return v;
    }
  }

  Node removeFixupCase3(Node u) {
    Node w = u.parent;
    Node v = w.left;
    pullBlack(w);
    flipRight(w);
    Node q = w.left;
    if (q.color == Color.Red) {
      rotateRight(w);
      flipLeft(v);
      pushBlack(q);
      return q;
    } else {
      if (v.left.color == Color.Red) {
        pushBlack(v);
        return v;
      } else {
        flipLeft(v);
        return w;
      }
    }
  }


  Node createNode(T x) {
    Node node = new Node;
    node.x = x;
    node.parent = nil;
    node.left = nil;
    node.right = nil;
    node.color = Color.Red;
    return node;
  }

  enum Color {
    Red         = 0,
    Black       = 1,
    DoubleBlack = 2
  }

  class Node {
    T x;
    Node parent;
    Node left;
    Node right;
    Color color;
    this() {
      x = T.init;
    }
  }

}
