module odsD.dataStructure.graph.AdjacentMatrix;

import std.format;
import std.array;
import std.range;
import std.algorithm;

class AdjacentMatrix {

protected:
  size_t n;
  bool[][] xss;

public:
  // O(n^2)
  this(size_t n) {
    this.n = n;
    this.xss = new bool[][](n, n);
  }

  // O(1)
  size_t size() {
    return n;
  }

  // O(1)
  void addEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    xss[i][j] = true;
  }

  // O(1)
  void removeEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    xss[i][j] = false;
  }

  // O(1)
  bool hasEdge(size_t i, size_t j) in {
    assert(i<n && j<n, format!"Attempting to fetch the %sth and %sth vertices of a graph with %s vertices"(i, j, n));
  } do {
    return xss[i][j];
  }

  // O(n)
  size_t[] outEdges(size_t i) in {
    assert(i<n, format!"Attempting to fetch the %sth vertex of a graph with %s vertices"(i, n));
  } do {
    return n.iota.filter!(j => xss[i][j]).array;
  }

  // O(n)
  size_t[] inEdges(size_t i) in {
    assert(i<n, format!"Attempting to fetch the %sth vertex of a graph with %s vertices"(i, n));
  } do {
    return n.iota.filter!(j => xss[j][i]).array;
  }

}
