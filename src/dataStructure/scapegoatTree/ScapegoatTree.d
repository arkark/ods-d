module odsD.dataStructure.scapegoatTree.ScapegoatTree;

import odsD.util.Maybe;
import std.math;
import std.functional;

class ScapegoatTree(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  Node nil;

  Node root;
  size_t n;
  size_t q;

public:
  this() {
    nil = new Node;
    clear();
  }

  void clear() {
    root = nil;
    n = 0;
    q = 0;
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

  // amortized O(log n)
  // @return:
  //  true  ... if x was added successfully
  //  false ... if x already exists
  bool add(T x) {
    Node node = createNode(x);

    long d = addWithDepth(node);
    if (d < 0) return false;

    if (d > log(q) / log(3.0/2.0)) {
      Node scapegoat = node.parent;
      size_t a = size(scapegoat);
      size_t b = size(scapegoat.parent);
      while(3*a <= 2*b) {
        scapegoat = scapegoat.parent;
        a = size(scapegoat);
        b = size(scapegoat.parent);
      }
      rebuild(scapegoat.parent);
    }
    return true;
  }

  // amortized O(log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    Node node = findLast(x);
    if (node !is nil && _eq(node.x, x)) {
      remove(node);
      if (2*n < q) {
        if (root !is nil) rebuild(root);
        q = n;
      }
      return true;
    } else {
      return false;
    }
  }

protected:
  size_t size(Node node) {
    if (node is nil) return 0;
    return 1 + size(node.left) + size(node.right);
  }

  size_t depth(Node node) {
    size_t d = 0;
    while(node !is root) {
      node = node.parent;
      d++;
    }
    return d;
  }

  void rebuild(Node subRoot) {
    size_t subN = size(subRoot);
    Node parent = subRoot.parent;
    Node[] nodes = new Node[subN];

    size_t _subN = packIntoArray(subRoot, nodes);
    assert(_subN == subN);

    Node newSubRoot = buildBalanced(nodes, 0, subN);
    if (parent is nil) {
      root = newSubRoot;
      root.parent = nil;
    } else if (parent.right is subRoot) {
      parent.right = newSubRoot;
      parent.right.parent = parent;
    } else {
      parent.left = newSubRoot;
      parent.left.parent = parent;
    }
  }

  size_t packIntoArray(Node subRoot, Node[] nodes, size_t i = 0) {
    if (subRoot is nil) return i;
    i = packIntoArray(subRoot.left, nodes, i);
    nodes[i++] = subRoot;
    return packIntoArray(subRoot.right, nodes, i);
  }

  Node buildBalanced(Node[] nodes, size_t left, size_t right) {
    if (left >= right) return nil;

    size_t mid = (left + right)/2;
    nodes[mid].left = buildBalanced(nodes, left, mid);
    nodes[mid].right = buildBalanced(nodes, mid + 1, right);
    if (nodes[mid].left !is nil) nodes[mid].left.parent = nodes[mid];
    if (nodes[mid].right !is nil) nodes[mid].right.parent = nodes[mid];
    return nodes[mid];
  }

  // return -1 if node.x already exists
  long addWithDepth(Node node) {
    Node parent = findLast(node.x);
    if (addChild(parent, node)) {
      return depth(node);
    } else {
      return -1;
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
    n++; q++;
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

  void remove(Node node) {
    if (node.left is nil || node.right is nil) {
      splice(node);
    } else {
      Node leaf = node.right;
      while(leaf.left !is nil) {
        leaf = leaf.left;
      }
      node.x = leaf.x;
      splice(leaf);
    }
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
