module odsD.test.dataStructure.binaryTree.BinaryTree;

import odsD.dataStructure.binaryTree.BinaryTree;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  import std.algorithm : map;
  auto tree = new BinaryTree;

  assert(tree.size(tree.root) == 0);

  auto ns = [
    tree.root = tree.createNode(),
    tree.root.left = tree.createNode(),
    tree.root.left.left = tree.createNode(),
    tree.root.left.right = tree.createNode(),
    tree.root.right = tree.createNode()
  ];
  tree.root.left.parent = tree.root;
  tree.root.left.left.parent = tree.root.left;
  tree.root.left.right.parent = tree.root.left;
  tree.root.right.parent = tree.root;

  assert(ns.map!(n => tree.depth(n)).equal(
    [0, 1, 2, 2, 1]
  ));
  assert(ns.map!(n => tree.size(n)).equal(
    [5, 3, 1, 1, 1]
  ));
  assert(ns.map!(n => tree.height(n)).equal(
    [2, 1, 0, 0, 0]
  ));

  size_t size = tree.size2;
  assert(size == 5);

  static size_t n;
  static auto inc = (BinaryTree.Node node) => n++;

  n = 0;
  tree.traverse!inc(tree.root);
  assert(n == size);

  n = 0;
  tree.traverse2!inc();
  assert(n == size);

  n = 0;
  tree.bfTraverse!inc();
  assert(n == size);

  tree.clear();
  assert(tree.size2 == 0);

}
