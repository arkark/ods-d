module odsD.dataStructure.linkedList.DLList;

import std.format;

// Doubly-Linked List
class DLList(T) {

protected:
  Node dummy;
  size_t n;

public:
  // O(1)
  this() {
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

  // O(1 + min(i, n - i))
  T get(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a DLList with size == %s"(i, n));
  } do {
    return getNode(i).x;
  }

  // O(1 + min(i, n - i))
  // @return: previous ith value
  T set(size_t i, T x) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a DLList with size == %s"(i, n));
  } do {
    Node u = getNode(i);
    T y = u.x;
    u.x = x;
    return y;
  }

  // O(1 + min(i, n - i))
  void add(size_t i, T x) in {
    assert(i <= n, format!"Attempting to add %s to the %sth index of a DLList with size == %s"(x, i, n));
  } do {
    addBefore(getNode(i), x);
  }

  // O(1 + min(i, n - i))
  // @return: removed value
  T remove(size_t i) in {
    assert(i < n, format!"Attempting to fetch the %sth element of a DLList with size == %s"(i, n));
  } do {
    Node w = getNode(i);
    T x = w.x;
    remove(w);
    return x;
  }

  // O(1)
  void insertFront(T x) {
    add(0, x);
  }

  // O(1)
  void insertBack(T x) {
    add(n, x);
  }

  // O(1)
  T removeFront() in {
    assert(n > 0, "Attempting to fetch the front of an empty DLList");
  } do {
    return remove(0);
  }

  // O(1)
  T removeBack() in {
    assert(n > 0, "Attempting to fetch the back of an empty DLList");
  } do {
    return remove(n-1);
  }

protected:
  // O(1 + min(i, n - i))
  Node getNode(size_t i) {
    Node p;
    if (i < n/2) {
      p = dummy.next;
      foreach(_; 0..i) {
        p = p.next;
      }
    } else {
      p = dummy;
      foreach(_; i..n) {
        p = p.prev;
      }
    }
    return p;
  }

  void addBefore(Node w, T x) {
    Node u = new Node(x);
    u.prev = w.prev;
    u.next = w;
    u.next.prev = u;
    u.prev.next = u;
    n++;
  }

  void remove(Node w) {
    w.prev.next = w.next;
    w.next.prev = w.prev;
    n--;
  }

  class Node {
    T x;
    Node prev = null;
    Node next = null;
    this() {
    }
    this(T x) {
      this.x = x;
    }
  }
}
