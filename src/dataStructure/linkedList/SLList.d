module odsD.dataStructure.linkedList.SLList;

import std.format;

// Singly-Linked List
class SLList(T) {

protected:
  Node head;
  Node tail;
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
    head = null;
    tail = null;
    n = 0;
  }

  // O(1)
  void push(T x) {
    Node node = new Node(x);
    node.next = head;
    head = node;
    if (n == 0) {
      tail = node;
    }
    n++;
  }
  alias insertFront = push;

  // O(1)
  // @return: removed value
  T pop() in {
    assert(n > 0, "Attempting to fetch the head of an empty SLList");
  } do {
    T x = head.x;
    head = head.next;
    if (--n == 0) {
      tail = null;
    }
    return x;
  }
  alias remove = pop;
  alias removeFront = pop;

  // O(1)
  void add(T x) {
    Node node = new Node(x);
    if (n == 0) {
      head = node;
    } else {
      tail.next = node;
    }
    tail = node;
    n++;
  }
  alias insertBack = add;

protected:
  class Node {
    T x;
    Node next;
    this(T x) {
      this.x = x;
      this.next = null;
    }
  }

  invariant {
    assert((n > 0) == (head !is null));
    assert((n > 0) == (tail !is null));
  }
}
