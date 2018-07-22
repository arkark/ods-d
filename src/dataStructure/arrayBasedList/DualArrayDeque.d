module odsD.dataStructure.arrayBasedList.DualArrayDeque;

import odsD.dataStructure.arrayBasedList.ArrayStack;
import std.format;
import std.algorithm;

class DualArrayDeque(T) {

protected:
  ArrayStack!T frontStack = new ArrayStack!T();
  ArrayStack!T backStack = new ArrayStack!T();

public:
  // O(1)
  this() {
    clear();
  }

  // O(1)
  size_t size() {
    return frontStack.size + backStack.size;
  }

  // O(1)
  T get(size_t i) in {
    assert(i < size, format!"Attempting to fetch the %sth element of a DualArrayDeque with size == %s"(i, size));
  } do {
    if (i < frontStack.size) {
      return frontStack.get(frontStack.size - i - 1);
    } else {
      return backStack.get(i - frontStack.size);
    }
  }

  // O(1)
  // @return: previous `xs[i]` value
  T set(size_t i, T x) in {
    assert(i < size, format!"Attempting to fetch the %sth element of a DualArrayDeque with size == %s"(i, size));
  } do {
    if (i < frontStack.size) {
      return frontStack.set(frontStack.size - i - 1, x);
    } else {
      return backStack.set(i - frontStack.size, x);
    }
  }

  // O(1)
  void clear() {
    frontStack.clear;
    backStack.clear;
  }

  // amortized O(1 + min(i, n-i))
  void add(size_t i, T x) in {
    assert(i <= size, format!"Attempting to add %s to the %sth index of a DualArrayDeque with size == %s"(x, i, size));
  } do {
    if (i < frontStack.size) {
      frontStack.add(frontStack.size - i, x);
    } else {
      backStack.add(i - frontStack.size, x);
    }
    balance();
  }

  // amortized O(1)
  void insertFront(T x) {
    add(0, x);
  }

  // amortized O(1)
  void insertBack(T x) {
    add(size, x);
  }

  // amortized O(1 + min(i, n-i))
  // @return: removed value
  T remove(size_t i) in {
    assert(i < size, format!"Attempting to fetch the %sth element of a DualArrayDeque with size == %s"(i, size));
  } do {
    T x;
    if (i < frontStack.size) {
      x = frontStack.remove(frontStack.size - i - 1);
    } else {
      x = backStack.remove(i - frontStack.size);
    }
    balance();
    return x;
  }

  // amortized O(1)
  T removeFront() in {
    assert(size > 0, "Attempting to fetch the front of an empty DualArrayDeque");
  } do {
    return remove(0);
  }

  // amortized O(1)
  T removeBack() in {
    assert(size > 0, "Attempting to fetch the back of an empty DualArrayDeque");
  } do {
    return remove(size - 1);
  }

protected:
  // O(n)
  void balance() {
    if (isUnbalance) {
      size_t frontN = size/2;
      size_t backN = size - frontN;
      T[] frontXs = new T[max(2*frontN, 1)];
      T[] backXs = new T[max(2*backN, 1)];
      foreach(i; 0..frontN) {
        frontXs[frontN-i-1] = get(i);
      }
      foreach(i; 0..backN) {
        backXs[i] = get(frontN + i);
      }
      frontStack.setArray(frontXs, frontN);
      backStack.setArray(backXs, backN);
    }
  }

  bool isUnbalance() {
    return 3*frontStack.size < backStack.size || 3*backStack.size < frontStack.size;
  }
}
