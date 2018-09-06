module odsD.dataStructure.trie.XFastTrie;

import odsD.util.Maybe;
import std.format;
import std.functional;
import  odsD.dataStructure.hashTable.LinearHashTable;

class XFastTrie(T, S = size_t, alias intValue = format!"cast(%s)a"(S.stringof), alias value = format!"cast(%s)a"(T.stringof))
if (is(typeof(unaryFun!intValue(T.init)) == S) && is(typeof(unaryFun!value(S.init)) == T)) {

protected:
  alias _intValue = unaryFun!intValue;
  alias _value = unaryFun!value;

  LinearHashTable!Node[] tables;

  Node dummy;

  Node root;
  size_t n;
  enum size_t w = S.sizeof * 8;

public:
  // O(1)
  this() {
    dummy = new Node;
    root = new Node;
    tables.length = w + 1;
    foreach(i; 0..w+1) {
      tables[i] = new LinearHashTable!Node;
    }
    clear();
  }

  // O(1)
  void clear() {
    root.jump = dummy;
    root.parent = root.prev = root.next = null;
    root.prefix = 0;
    dummy.prev = dummy.next = dummy;
    n = 0;
    foreach(i; 0..w+1) {
      tables[i].clear;
    }
    tables[0].add(root);
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(log w)
  // @return: min{ y \in this | y >= x }
  Maybe!T find(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
  } do {
    size_t l = 0;
    size_t r = w+1;
    size_t ix = _intValue(x);
    Node u;
    while(r - l > 1) {
      size_t c = (l + r)/2;
      Node v = new Node;
      v.prefix = ix >>> (w-c);
      if (tables[c].exists(v)) {
        l = c;
        u = tables[c].find(v).get;
      } else {
        r = c;
      }
    }
    assert(u !is null);

    if (l == w) {
      return Just(u.x);
    }

    size_t bit = (ix >>> (w-l-1))&1;
    u = bit==0 ? u.jump : u.jump.next;
    return u is dummy ? None!T : Just(u.x);
    // u = bit==0 ? u.jump.prev : u.jump;
    // return u.next is dummy ? None!T : Just(u.next.x);
  }

  // O(log w)
  bool exists(T x) {
    Maybe!T res = find(x);
    return res.isJust && res.get==x;
  }

  // O(w)
  // @return:
  //  true  ... if x was added successfully
  //  false ... if x already exists
  bool add(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
  } do {
    size_t i = 0;
    size_t bit = 0;
    size_t ix = _intValue(x);
    Node node = root;
    for(; i<w; i++) {
      bit = (ix >>> (w-i-1)) & 1;
      if (node.children[bit] is null) break;
      node = node.children[bit];
    }
    if (i == w) {
      assert(node.x == x);
      return false;
    }
    Node prev = bit==1 ? node.jump : node.jump.prev;
    node.jump = null;
    for(; i<w; i++) {
      bit = (ix >>> (w-i-1)) & 1;
      node.children[bit] = new Node;
      node.children[bit].parent = node;
      node = node.children[bit];
    }
    node.x = x;
    node.prev = prev;
    node.next = prev.next;
    node.prev.next = node;
    node.next.prev = node;
    Node v = node.parent;
    while(v !is null) {
      if (
        (v.prev is null && (v.jump is null || _intValue(v.jump.x) > ix)) ||
        (v.next is null && (v.jump is null || _intValue(v.jump.x) < ix))
      ) {
        v.jump = node;
      }
      v = v.parent;
    }

    n++;
    addNodeToTable(x);
    return true;
  }

  // O(log n)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
  } do {
    size_t bit = 0;
    size_t ix = _intValue(x);
    Node node = root;
    foreach(i; 0..w) {
      bit = (ix >>> (w-i-1)) & 1;
      if (node.children[bit] is null) return false;
      node = node.children[bit];
    }
    assert(node.x == x);
    node.prev.next = node.next;
    node.next.prev = node.prev;
    Node v = node;
    size_t j = 0;
    for(; j<w; j++) {
      bit = (ix >>> j) & 1;
      v.parent.children[bit] = null;
      tables[w-j].remove(v); // remove the Node from tables
      v = v.parent;
      if (v.children[bit^1] !is null) break;
    }
    assert(j < w);
    bit = (ix >>> j) & 1;
    v.jump = node.children[bit^1];
    v = v.parent;
    j++;
    for(; j<w; j++) {
      bit = (ix >>> j) & 1;
      if (v.jump is node) {
        v.jump = node.children[bit^1];
      }
      v = v.parent;
    }
    n--;
    return true;
  }

protected:
  void addNodeToTable(T x) {
    size_t ix = _intValue(x);
    Node node = root;
    foreach(i; 1..w+1) {
      node = node.children[(ix >>> (w-i))&1];
      node.prefix = ix >>> (w-i);
      tables[i].add(node);
    }
  }

  class Node {
    T x;
    S prefix;
    Node parent;
    Node[2] children;
    Node jump;
    this() {
      this.x = T.init;
      this.prefix = S.init;
    }
    @property Node prev() { return children[0]; }
    @property Node prev(Node v) { return children[0] = v; }
    @property Node next() { return children[1]; }
    @property Node next(Node v) { return children[1] = v; }
    override size_t toHash() const @safe pure nothrow {
      return prefix.hashOf;
    }
    override bool opEquals(Object o) const @safe pure nothrow {
      Node that = cast(Node) o;
      return that !is null && this.prefix == that.prefix;
    }
  }
}
