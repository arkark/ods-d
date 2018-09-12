module odsD.dataStructure.graph.AdjacencyList;

import std.format;
import std.array;
import std.range;
import std.algorithm;

import odsD.dataStructure.graph.Graph;
import odsD.dataStructure.arrayBasedList.ArrayStack;

class AdjacencyList : Graph {

protected:
  size_t n;
  ArrayStack!size_t[] adjs;

public:
  // O(n)
  this(size_t n) {
    this.n = n;
    this.adjs.length = n;
    foreach(ref adj; adjs) {
      adj = new ArrayStack!size_t();
    }
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(1)
  void addEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    adjs[i].push(j);
  }

  // O(deg(i))
  void removeEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    foreach(k; 0..adjs[i].size) {
      if (adjs[i].get(k) == j) {
        adjs[i].remove(k);
        return;
      }
    }
  }

  // O(deg(1))
  bool hasEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    return adjs[i].size.iota.any!(k => adjs[i].get(k) == j);
  }

  // O(deg(i))
  size_t[] outEdges(size_t i) in {
    assert(i<n, format!"Attempting to fetch the %sth vertex of a graph with %s vertices"(i, n));
  } do {
    return adjs[i].size.iota.map!(k => adjs[i].get(k)).array;
  }

  // O(n + m)
  size_t[] inEdges(size_t i) in {
    assert(i<n, format!"Attempting to fetch the %sth vertex of a graph with %s vertices"(i, n));
  } do {
    return n.iota.filter!(j => hasEdge(j, i)).array;
  }

}
