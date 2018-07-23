module odsD.dataStructure.binaryTree.BinarySearchTree;

import odsD.util.Maybe;
import std.functional;

// Unbalanced Binary Search Tree
class BinarySearchTree(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)))) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  BTNode nil;
  BTNode root;

  size_t n;

public:
  this() {
    nil = new BTNode;
    clear();
  }

  void clear() {
    root = nil;
    n = 0;
  }

  size_t size() {
    return n;
  }

  // O(n)
  Maybe!T findEQ(T x) {
    BTNode node = root;
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

  // O(n)
  // @return: min{ y \in this | y >= x }
  Maybe!T find(T x) {
    BTNode node = root;
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

  // O(n)
  bool exists(T x) {
    return findEQ(x).isJust;
  }

  // O(n)
  // @return:
  //   true  ... if x was added successfully
  //   false ... if x already exists
  bool add(T x) {
    BTNode parent = findLast(x);
    return addChild(parent, createNode(x));
  }

  // O(n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    BTNode node = findLast(x);
    if (node !is nil && _eq(node.x, x)) {
      remove(node);
      return true;
    } else {
      return false;
    }
  }

protected:
  BTNode findLast(T x) {
    BTNode node = root;
    BTNode prev = nil;
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

  bool addChild(BTNode parent, BTNode child) in {
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

  void splice(BTNode node) in {
    assert(node !is null && node !is nil);
  } do {
    BTNode child = node.left !is nil ? node.left : node.right;
    BTNode parent;
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

  void remove(BTNode node) {
    if (node.left is nil || node.right is nil) {
      splice(node);
    } else {
      BTNode leaf = node.right;
      while(leaf.left !is nil) {
        leaf = leaf.left;
      }
      node.x = leaf.x;
      splice(leaf);
    }
  }

  BTNode createNode(T x) {
    BTNode node = new BTNode;
    node.x = x;
    node.parent = nil;
    node.left = nil;
    node.right = nil;
    return node;
  }

  class BTNode {
    T x;
    BTNode parent;
    BTNode left;
    BTNode right;
    this() {
      x = T.init;
    }
  }

}
