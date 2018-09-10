module odsD.dataStructure.trie.YFastTrie;

import odsD.util.Maybe;
import std.random;
import std.format;
import std.functional;
import std.conv;
import odsD.dataStructure.trie.XFastTrie;
import odsD.dataStructure.randomBinarySearchTree.Treap;

class YFastTrie(T, S = size_t, alias intValue = to!S, alias value = to!T,  alias less = "a < b")
if (is(typeof(unaryFun!intValue(T.init)) == S) && is(typeof(unaryFun!value(S.init)) == T) && is(typeof(binaryFun!less(S.init, S.init)) == bool)) {

protected:
  alias _intValue = unaryFun!intValue;
  alias _value = unaryFun!value;

  alias XFT = XFastTrie!(
    Pair, S, p => p.ix,
    (ix) {
      // return Pair(ix); // -> compile error!
      auto p = Pair.init;
      p.ix = ix;
      return p;
    }
  );

  Random rnd;
  XFT xft;

  size_t n;

public:
  enum size_t w = XFT.w;

  // O(1)
  this() {
    rnd = Random(unpredictableSeed);
    xft = new XFT();
    clear();
  }

  // O(1)
  void clear() {
    xft.clear();
    xft.add(Pair(S.max, new SplittableTreap()));
    n = 0;
  }

  // O(1)
  size_t size() {
    return n;
  }

  // average O(log w)
  // @return: min{ y \in this | iy >= ix }
  Maybe!T find(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
    assert(_intValue(x) < S.max);
  } do {
    S ix = _intValue(x);
    return xft.find(Pair(ix)).fmap!(p => p.treap).bind!(t => t.find(ix)).fmap!(iy => _value(iy));
  }

  // average O(log w)
  bool exists(T x) {
    Maybe!T res = find(x);
    return res.isJust && res.get==x;
  }

  // average O(log w)
  // @return:
  //  true  ... if x was added successfully
  //  false ... if x already exists
  bool add(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
    assert(_intValue(x) < S.max);
  } do {
    S ix = _intValue(x);
    auto t1 = xft.find(Pair(ix)).get.treap;
    if (t1.add(ix)) {
      if (uniform(0, w, rnd) == 0) {
        auto t2 = t1.split(ix);
        assert(t2.find(ix+1).isNone);
        assert(t2.find(ix).get == ix);
        xft.add(Pair(ix, t2));
      }
      n++;
      return true;
    } else {
      return false;
    }
  }

  // average O(log w)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) in {
    T y = _value(_intValue(x));
    assert(y == x, format!"value(intValue(%s)) is %s, but should be %s"(x, y, x));
    assert(_intValue(x) < S.max);
  } do {
    S ix = _intValue(x);
    auto node = xft.findNode(Pair(ix));
    auto t1 = node.x.treap;
    S iy = node.x.ix;
    assert(ix <= iy);
    if (t1.remove(ix)) {
      if (ix == iy && ix != S.max) {
        auto t2 = node.next.x.treap;
        t2.absorb(t1);
        xft.remove(node.x);
      }
      n--;
      return true;
    } else {
      return false;
    }
  }

protected:
  struct Pair {
    S ix;
    SplittableTreap treap;
    bool opEquals(Pair that) {
      return this.ix == that.ix;
    }
  }

  class SplittableTreap : Treap!(S, less) {

    SplittableTreap split(S ix) {
      Node u = findLast(ix);
      Node s = createNode(S.init);
      if (u.right is nil) {
        u.right = s;
      } else {
        u = u.right;
        while(u.left !is nil) {
          u = u.left;
        }
        u.left = s;
      }
      s.parent = u;
      s.priority = size_t.min;
      bubbleUp(s);
      root = s.right;
      root.parent = nil;

      auto res = new SplittableTreap();
      res.nil = this.nil;
      res.clear();
      res.root = s.left;
      res.root.parent = nil;
      return res;
    }

    void absorb(SplittableTreap that) in {
      assert(this.nil is that.nil);
    } do {
      Node s = createNode(S.init);
      s.right = this.root;
      s.left = that.root;
      if (this.root !is nil) this.root.parent = s;
      if (that.root !is nil) that.root.parent = s;
      this.root = s;
      that.clear();
      trickleDown(s);
      splice(s);
    }
  }
}
