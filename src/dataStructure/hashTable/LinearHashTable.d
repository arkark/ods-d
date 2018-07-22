module odsD.dataStructure.hashTable.LinearHashTable;

import odsD.util.Maybe;
import std.random;

class LinearHashTable(T)
if(is(typeof(T.init.hashOf()))) {

protected:
  Random rnd;
  size_t randomZ;
  Node del;

  Node[] table;
  size_t n; // number of values
  size_t q; // number of non-null entries
  size_t d; // 1<<d == table.length

public:
  this() {
    rnd = Random(unpredictableSeed);
    del = new Node;
    clear();
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(1)
  void clear() out {
    assert((1<<d) == table.length);
    assert(n <= table.length);
    assert(2*q <= table.length);
  } do {
    n = 0;
    q = 0;
    d = 1;
    table = new Node[1<<d];
    randomZ = rnd.uniform!size_t|1; // random odd number
  }

  // amortized and average O(1)
  // @return:
  //   true  ... if x was added successfully
  //   false ... if x already exists
  bool add(T x) {
    if (exists(x)) return false;

    if (2*(q + 1) > table.length) {
      resize();
    }
    size_t i = hash(x);
    while(table[i] !is null && table[i] !is del) {
      i = (i + 1)%table.length;
    }
    if (table[i] is null) q++;
    n++;

    table[i] = new Node(x);
    return true;
  }

  // amortized and average O(1)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    size_t i = hash(x);
    while(table[i] !is null) {
      if (table[i] !is del && table[i].x == x) {
        table[i] = del;
        n--;
        if (8*n < table.length) {
          resize();
        }
        return true;
      }
      i = (i + 1)%table.length;
    }
    return false;
  }

  // average O(1)
  Maybe!T find(T x) {
    size_t i = hash(x);
    while(table[i] !is null) {
      if (table[i] !is del && table[i].x == x) {
        return Just(table[i].x);
      }
      i = (i + 1)%table.length;
    }
    return None!T();
  }

  // average O(1)
  bool exists(T x) {
    return find(x).isJust;
  }

protected:
  size_t hash(T x) {
    return (randomZ * x.hashOf()) >> (size_t.sizeof*8 - d);
  }

  void resize() out {
    assert((1<<d) == table.length);
    assert(n <= table.length);
    assert(2*q <= table.length);
  } do {
    d = 1;
    while((1<<d) <= 3*n) d++;

    Node[] newTable = new Node[1<<d];
    q = n;
    foreach(node; table) {
      if (node !is null && node !is del) {
        size_t i = hash(node.x);
        while(newTable[i] !is null) {
          i = (i + 1)%newTable.length;
        }
        newTable[i] = new Node(node.x);
      }
    }

    table = newTable;
  }

  class Node {
    T x;
    this() {}
    this(T x) {
      this.x = x;
    }
  }
}
