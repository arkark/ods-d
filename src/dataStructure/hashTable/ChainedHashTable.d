module odsD.dataStructure.hashTable.ChainedHashTable;

import std.algorithm;
import std.range;
import std.random;
import std.traits;
import std.container : DList;

class ChainedHashTable(T)
if(is(typeof(T.init.hashOf()))) {

protected:
  Random rnd;
  size_t randomZ;

  DList!T[] table;
  size_t n;
  size_t d; // 1<<d == table.length

public:
  this() {
    rnd = Random(unpredictableSeed);
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
  } do {
    n = 0;
    d = 1;
    table = new DList!T[1<<d];
    randomZ = rnd.uniform!size_t|1; // random odd number
  }

  // amortized and average O(1)
  // @return:
  //   true  ... if x was added successfully
  //   false ... if x already exists
  bool add(T x) {
    if (exists(x)) return false;

    if (n >= table.length) {
      resize();
    }
    table[hash(x)].insertBack(x);
    n++;
    return true;
  }

  // amortized and average O(1)
  // @return:
  //   true  ... if x was removed successfully
  //   false ... if x didn't exist
  bool remove(T x) {
    size_t j = hash(x);
    bool removed = table[j].linearRemoveElement(x);
    if (removed) {
      n--;
    }
    return removed;
  }

  // average O(1)
  // @return:
  //   InputRange(x)  ... if x exists
  //   InputRange() ... if x doesn't exist
  auto find(T x) {
    size_t j = hash(x);
    return table[j][].find(x).take(1);
  }
  static assert(isInputRange!(ReturnType!find));

  // average O(1)
  bool exists(T x) {
    return !find(x).empty;
  }

protected:
  size_t hash(T x) {
    return (randomZ * x.hashOf()) >> (size_t.sizeof*8 - d);
  }

  void resize() out {
    assert((1<<d) == table.length);
    assert(n <= table.length);
  } do {
    d = 1;
    while((1<<d) <= n) d++;

    n = 0;
    DList!T[] oldTable = table;
    table = new DList!T[1<<d];
    foreach(i, list; oldTable) {
      foreach(x; list) {
        add(x);
      }
    }
  }
}
