module odsD.dataStructure.linkedList.SEList;

import odsD.dataStructure.arrayBasedList.ArrayDeque;
import std.format;

// Space-Efficient List (Unrolled Linked List)
class SEList(T) {

protected:
  Node dummy;
  size_t n;
  immutable size_t blockSize;

public:
  // O(1)
  this(size_t blockSize) in {
    assert(blockSize > 0);
  } do {
    this.blockSize = blockSize;
    clear();
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(1)
  void clear() {
    dummy = new Node;
    dummy.next = dummy.prev = dummy;
    n = 0;
  }

  // O(1 + min(i, n - i)/blockSize)
  T get(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SEList with size == %s"(i, n));
  } do {
    Location loc = getLocation(i);
    return loc.node.deque.get(loc.index);
  }

  // O(1 + min(i, n - i)/blockSize)
  // @return: previous ith value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SEList with size == %s"(i, n));
  } do {
    Location loc = getLocation(i);
    T y = loc.node.deque.get(loc.index);
    loc.node.deque.set(loc.index, x);
    return y;
  }

  // amortized O(min(blockSize, n - i) + min(i, n - i)/blockSize)
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of a SEList with size == %s"(x, i, n));
  } do {
    if (i == n) {
      insertBack(x);
      return;
    }

    Location loc = getLocation(i);
    Node node = loc.node;
    size_t r = 0;
    while(r < blockSize && node !is dummy && node.deque.size == blockSize+1) {
      node = node.next;
      r++;
    }

    if (r == blockSize) {
      spread(loc.node);
      node = loc.node;
    } else if (node is dummy) {
      node = addBefore(node);
    }
    while(node !is loc.node) {
      node.deque.insertFront(node.prev.deque.removeBack());
      node = node.prev;
    }
    node.deque.add(loc.index, x);

    n++;
  }

  // amortized O(min(blockSize, n - i) + min(i, n - i)/b)
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a SEList with size == %s"(i, n));
  } do {
    Location loc = getLocation(i);
    T y = loc.node.deque.get(loc.index);
    Node node = loc.node;
    size_t r = 0;
    while(r < blockSize && node !is dummy && node.deque.size == blockSize-1) {
      node = node.next;
      r++;
    }

    if (r == blockSize) {
      gather(loc.node);
    }
    node = loc.node;
    node.deque.remove(loc.index);
    while(node.deque.size < blockSize-1 && node.next !is dummy) {
      node.deque.insertBack(node.next.deque.removeFront());
      node = node.next;
    }
    if (node.deque.size == 0) {
      remove(node);
    }

    n--;
    return y;
  }

  // amortized O(blockSize)
  void insertFront(T x) {
    add(0, x);
  }

  // amortized O(1)
  void insertBack(T x) {
    Node last = dummy.prev;
    if (last is dummy || last.deque.size == blockSize+1) {
      last = addBefore(dummy);
    }
    last.deque.insertBack(x);
    n++;
  }

  // amortized O(blockSize)
  T removeFront() in {
    assert(n > 0, "Attempting to fetch the front of an empty SEList");
  } do {
    return remove(0);
  }

  // amortized O(1)
  T removeBack() in {
    assert(n > 0, "Attempting to fetch the back of an empty SEList");
  } do {
    return remove(n-1);
  }

protected:
  // O(1 + min(i, n-i)/blockSize)
  Location getLocation(size_t i) {
    if (i < n/2) {
      Node node = dummy.next;
      while(i >= node.deque.size) {
        i -= node.deque.size;
        node = node.next;
      }
      return Location(node, i);
    } else {
      Node node = dummy;
      size_t offset = n;
      while(i < offset) {
        node = node.prev;
        offset -= node.deque.size;
      }
      return Location(node, i - offset);
    }
  }

  // O(blockSize)
  Node addBefore(Node node) {
    Node prev = new Node(blockSize);
    prev.prev = node.prev;
    prev.next = node;
    prev.next.prev = prev;
    prev.prev.next = prev;
    return prev;
  }

  void remove(Node node) {
    node.prev.next = node.next;
    node.next.prev = node.prev;
  }

  // O(blockSize^2)
  void spread(Node first) {
    Node node = first;
    foreach(_; 0..blockSize) {
      node = node.next;
    }
    node = addBefore(node);
    while(node != first) {
      while(node.deque.size < blockSize) {
        node.deque.insertFront(node.prev.deque.removeBack());
      }
      node = node.prev;
    }
  }

  // O(blockSize^^2)
  void gather(Node node) {
    foreach(_; 0..blockSize-1) {
      while(node.deque.size < blockSize) {
        node.deque.insertBack(node.next.deque.removeFront());
      }
      node = node.next;
    }
    remove(node);
  }

  class BDeque(T) : ArrayDeque!T {
    this(size_t blockSize) {
      n = 0;
      offset = 0;
      xs = new T[blockSize + 1];
    }
    override void resize() {
      // do nothing
    }
  }

  class Node {
    BDeque!T deque;
    Node prev = null;
    Node next = null;
    this() {
    }
    this(size_t blockSize) {
      deque = new BDeque!T(blockSize);
    }
  }

  struct Location {
    Node node;
    size_t index;
    this(Node node, size_t index) in {
      assert(index < node.deque.size);
    } do {
      this.node = node;
      this.index = index;
    }
  }
}
