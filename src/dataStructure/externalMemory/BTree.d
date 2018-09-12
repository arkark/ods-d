module odsD.dataStructure.externalMemory.BTree;

import std.algorithm;
import std.functional;
import std.format;
import odsD.util.Maybe;
import odsD.util.functions;
import odsD.dataStructure.externalMemory.BlockStore;

class BTree(T, alias less = "a < b")
if (is(typeof(binaryFun!less(T.init, T.init)) == bool)) {

protected:
  alias _less = binaryFun!less;
  alias _eq = (a, b) => !_less(a, b) && !_less(b, a);

  size_t n;

  size_t B;
  size_t rootIndex;

  BlockStore!Node blockStore;

public:
  this(size_t B) in {
    assert(B >= 2, format!"B is %s, but must be g2"(B));
  } do {
    blockStore = new BlockStore!Node();
    this.B = B;
    clear();
  }

  void clear() {
    rootIndex = (new Node).id;
    n = 0;
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(log n)
  // @return: min{ y \in this | y >= x }
  Maybe!T find(T x) {
    Maybe!T res = None!T;
    Maybe!size_t next = Just(rootIndex);
    while(next.isJust) {
      size_t blockIndex = next.get;
      Node node = blockStore.readBlock(blockIndex);
      size_t i = findIt(node.keys, x);
      if (i%2 == 1) {
        return node.keys[i/2];
      }
      if (node.keys[i/2].isJust) {
        res = node.keys[i/2];
      }
      next = node.children[i/2];
    }
    return res;
  }

  // O(log n)
  bool exists(T x) {
    Maybe!T res = find(x);
    return res.isJust && _eq(res.get, x);
  }

  // amortized O(B + log n)
  // @return:
  //  true  ... if x was added successfully
  //  false ... if x already exists
  bool add(T x) {
    Maybe!Node _node;
    try {
      _node = addRecursive(x, rootIndex);
    } catch (DuplicateValueException e) {
      return false;
    }
    if (_node.isJust) {
      Node node = _node.get;
      Node newRoot = new Node;
      T y = node.remove(0);
      blockStore.writeBlock(node.id, node);
      newRoot.children[0] = Just(rootIndex);
      newRoot.keys[0] = Just(y);
      newRoot.children[1] = Just(node.id);
      rootIndex = newRoot.id;
      blockStore.writeBlock(rootIndex, newRoot);
    }
    n++;
    return true;
  }

  // amortized O(B + log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    if (removeRecursive(x, rootIndex)) {
      n--;
      Node root = blockStore.readBlock(rootIndex);
      if (root.size == 0 && n > 0) {
        rootIndex = root.children[0].get;
      }
      return true;
    } else {
      return false;
    }
  }

protected:
  // @return(i):
  //   i is odd => i/2 is key index
  //   i is even => i/2 is children index
  size_t findIt(Maybe!T[] keys, T x) {
    size_t l = 0;
    size_t r = keys.length;
    while(l < r) {
      size_t c = (l + r)/2;
      if (keys[c].isNone || _less(x, keys[c].get)) {
        r = c;
      } else if (_less(keys[c].get, x)) {
        l = c + 1;
      } else {
        return 2*c+1;
      }
    }
    return 2*l;
  }

  Maybe!Node addRecursive(T x, size_t blockIndex) {
    Node node = blockStore.readBlock(blockIndex);
    size_t i = findIt(node.keys, x);
    if (i%2 == 1) throw new DuplicateValueException();
    if (node.isLeaf) {
      node.add(x, None!size_t);
      blockStore.writeBlock(node.id, node);
    } else {
      assert(node.children[i/2].isJust);
      Maybe!Node _child = addRecursive(x, node.children[i/2].get);
      if (_child.isJust) {
        Node child = _child.get;
        T y = child.remove(0);
        blockStore.writeBlock(child.id, child);
        node.add(y, Just(child.id));
        blockStore.writeBlock(node.id, node);
      }
    }
    return node.isFull ? Just(node.split()) : None!Node;
  }

  bool removeRecursive(T x, size_t blockIndex) {
    Node node = blockStore.readBlock(blockIndex);
    size_t i = findIt(node.keys, x);
    if (i%2 == 1) {
      if (node.isLeaf) {
        T y = node.remove(i/2);
        assert(_eq(y, x));
      } else {
        assert(node.keys[i/2].isJust && _eq(node.keys[i/2].get, x));
        node.keys[i/2] = Just(removeSmallest(node.children[i/2+1].get));
        checkUnderflow(node, i/2+1);
      }
      return true;
    } else if (node.children[i/2].isJust && removeRecursive(x, node.children[i/2].get)) {
      checkUnderflow(node, i/2);
      return true;
    } else {
      return false;
    }
  }

  void merge(Node parent, size_t j, Node left, Node right) in {
    assert(parent.children[j].isJust && parent.children[j+1].isJust);
    assert(left.id == parent.children[j].get);
    assert(right.id == parent.children[j+1].get);
  } do {
    size_t ls = left.size;
    size_t rs = right.size;
    right.keys[0..rs].copy(left.keys[ls+1..ls+rs+1]);
    right.children[0..rs+1].copy(left.children[ls+1..ls+rs+2]);
    left.keys[ls] = parent.keys[j];
    parent.keys[j+1..$].copy(parent.keys[j..$-1]);
    parent.keys[$-1] = None!T;
    parent.children[j+2..$].copy(parent.children[j+1..$-1]);
    parent.children[$-1] = None!size_t;
  }

  // from left to right
  void shiftLR(Node parent, size_t j, Node left, Node right) in {
    assert(parent.children[j].isJust && parent.children[j+1].isJust);
    assert(left.id == parent.children[j].get);
    assert(right.id == parent.children[j+1].get);
  } do {
    size_t ls = left.size;
    size_t rs = right.size;
    assert(ls > rs + 1);
    size_t shift = (ls + rs)/2 - rs;
    right.keys[0..rs].retroCopy(right.keys[shift..rs+shift]);
    right.children[0..rs+1].retroCopy(right.children[shift..rs+1+shift]);
    right.keys[shift-1] = parent.keys[j];
    parent.keys[j] = left.keys[ls-shift];
    left.keys[ls-shift+1..ls].copy(right.keys[0..shift-1]);
    left.keys[ls-shift..ls] = None!T;
    left.children[ls-shift+1..ls+1].copy(right.children[0..shift]);
    left.children[ls-shift+1..ls+1] = None!size_t;
  }

  // from right to left
  void shiftRL(Node parent, size_t j, Node right, Node left) in {
    assert(parent.children[j].isJust && parent.children[j+1].isJust);
    assert(left.id == parent.children[j].get);
    assert(right.id == parent.children[j+1].get);
  } do {
    size_t rs = right.size;
    size_t ls = left.size;
    assert(rs > ls + 1);
    size_t shift = (ls + rs)/2 - ls;
    left.keys[ls] = parent.keys[j];
    right.keys[0..shift-1].copy(left.keys[ls+1..ls+shift]);
    right.children[0..shift].retroCopy(left.children[ls+1..ls+shift+1]);
    parent.keys[j] = right.keys[shift-1];
    right.keys[shift..rs].copy(right.keys[0..rs-shift]);
    right.keys[rs-shift..rs] = None!T;
    right.children[shift..rs+1].copy(right.children[0..rs-shift+1]);
    right.children[rs-shift+1..rs+1] = None!size_t;
  }

  void checkUnderflowZero(Node parent, size_t j) in {
    assert(j == 0);
  } do {
    Node left = blockStore.readBlock(parent.children[j].get);
    if (left.size < B-1) {
      Node right = blockStore.readBlock(parent.children[j+1].get);
      if (right.size > B) {
        shiftRL(parent, j, right, left);
      } else {
        merge(parent, j, left, right);
        parent.children[j] = Just(left.id);
      }
    }
  }

  void checkUnderflowNonZero(Node parent, size_t j) in {
    assert(j > 0);
  } do {
    Node right = blockStore.readBlock(parent.children[j].get);
    if (right.size < B-1) {
      Node left = blockStore.readBlock(parent.children[j-1].get);
      if (left.size > B) {
        shiftLR(parent, j-1, left, right);
      } else {
        merge(parent, j-1, left, right);
      }
    }
  }

  void checkUnderflow(Node parent, size_t j) {
    if (parent.children[j].isNone) return;
    if (j == 0) {
      checkUnderflowZero(parent, j);
    } else {
      checkUnderflowNonZero(parent, j);
    }
  }

  T removeSmallest(size_t blockIndex) {
    Node node = blockStore.readBlock(blockIndex);
    if (node.isLeaf) {
      return node.remove(0);
    } else {
      T x = removeSmallest(node.children[0].get);
      checkUnderflow(node, 0);
      return x;
    }
  }

  class Node {
    Maybe!T[] keys;
    Maybe!size_t[] children;
    size_t id;

    this() {
      id = blockStore.placeBlock(this);
      keys.length = 2*B - 1 + 1;
      children.length = 2*B + 1;
    }

    @property size_t size() {
      size_t l = 0;
      size_t r = keys.length;
      while(l < r) {
        size_t c = (l + r)/2;
        if (keys[c].isNone) {
          r = c;
        } else {
          l = c + 1;
        }
      }
      return l;
    }

    @property bool isLeaf() {
      return children[0].isNone;
    }
    @property bool isFull() {
      return keys[$-1].isJust;
    }

    bool add(T x, Maybe!size_t childIndex) {
      size_t i = findIt(keys, x);
      if (i%2 == 1) return false;
      if (i/2+1 < keys.length) keys[i/2..$-1].retroCopy(keys[i/2+1..$]);
      keys[i/2] = Just(x);
      if (i/2+1 < keys.length) children[i/2+1..$-1].retroCopy(children[i/2+2..$]);
      children[i/2+1] = childIndex;
      return true;
    }

    T remove(size_t j) {
      T x = keys[j].get;
      keys[j+1..$].copy(keys[j..$-1]);
      keys[$-1] = None!T;
      return x;
    }

    Node split() {
      Node right = new Node;
      size_t j = keys.length/2;
      this.keys[j..$].copy(right.keys[0..$-j]);
      this.keys[j..$] = None!T;
      this.children[j+1..$].copy(right.children[0..$-j-1]);
      this.children[j+1..$] = None!size_t;
      blockStore.writeBlock(this.id, this);
      return right;
    }
  }

  class DuplicateValueException : Exception {
    this(string file = __FILE__, size_t line = __LINE__) {
      super("", file, line);
    }
  }
}
