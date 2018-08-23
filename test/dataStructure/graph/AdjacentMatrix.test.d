module odsD.test.dataStructure.graph.AdjacentMatrix;

import odsD.dataStructure.graph.AdjacentMatrix;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  size_t n = 4;

  auto graph = new AdjacentMatrix(3);
  assert(graph.size == 3);

  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(2, 1);
  assert(graph.hasEdge(0, 1) && graph.hasEdge(0, 2) && graph.hasEdge(2, 1));
  assert(!graph.hasEdge(0, 0) && !graph.hasEdge(2, 0) && !graph.hasEdge(2, 2));
  assert(graph.outEdges(0).equal([1, 2]));
  assert(graph.inEdges(1).equal([0, 2]));

  graph.removeEdge(0, 2);
  graph.removeEdge(0, 0);
  assert(graph.hasEdge(0, 1) && graph.hasEdge(2, 1));
  assert(!graph.hasEdge(0, 0) && !graph.hasEdge(0, 2) && !graph.hasEdge(2, 0) && !graph.hasEdge(2, 2));
  assert(graph.outEdges(0).equal([1]));
  assert(graph.inEdges(1).equal([0, 2]));
}
