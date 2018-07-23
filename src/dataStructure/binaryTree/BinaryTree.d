module odsD.dataStructure.binaryTree.BinaryTree;

import odsD.dataStructure.arrayBasedList.ArrayDeque;
import std.algorithm;
import std.functional;

class BinaryTree {

  protected Node nil;
  Node root;

  this() {
    nil = new Node;
    clear();
  }

  void clear() {
    root = nil;
  }

  size_t depth(Node node) {
    size_t d = 0;
    while(node !is root) {
      node = node.parent;
      d++;
    }
    return d;
  }

  size_t size(Node node) {
    if (node is nil) return 0;
    return 1 + size(node.left) + size(node.right);
  }

  long height(Node node) {
    if (node is nil) return -1;
    return 1 + max(height(node.left), height(node.right));
  }

  void traverse(alias fun)(Node node) {
    if (node is nil) return;
    fun(node);
    traverse!fun(node.left);
    traverse!fun(node.right);
  }

  void traverse2(alias fun)() {
    Node node = root;
    Node prev = nil;
    Node next;
    while(node !is nil) {
      if (prev is node.parent) {
        fun(node);
        if (node.left !is nil) {
          next = node.left;
        } else if (node.right !is nil) {
          next = node.right;
        } else {
          next = node.parent;
        }
      } else if (prev is node.left) {
        if (node.right !is nil) {
          next = node.right;
        } else {
          next = node.parent;
        }
      } else {
        next = node.parent;
      }
      assert(next !is null);
      prev = node;
      node = next;
    }
  }

  private static size_t __n = 0;
  private enum __inc = (Node node) => __n++;
  size_t size2() {
    __n = 0;
    traverse2!__inc();
    return __n;
  }

  void bfTraverse(alias fun)() {
    auto queue = new ArrayDeque!Node();
    if (root !is nil) queue.insertBack(root);
    while(queue.size > 0) {
      Node node = queue.removeFront();
      fun(node);
      if (node.left !is nil) queue.insertBack(node.left);
      if (node.right !is nil) queue.insertBack(node.right);
    }
  }

  Node createNode() {
    Node node = new Node;
    node.parent = nil;
    node.left = nil;
    node.right = nil;
    return node;
  }

  class Node {
    Node parent;
    Node left;
    Node right;
    this() {}
  }

}
