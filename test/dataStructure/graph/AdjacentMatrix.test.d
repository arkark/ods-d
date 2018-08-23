module odsD.test.dataStructure.graph.AdjacentMatrix;

import odsD.dataStructure.graph.AdjacentMatrix;
import odsD.dataStructure.graph.traversal;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

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

unittest {
  writeln(__FILE__, ": Test bfs");

  auto graph = new AdjacentMatrix(3);
  assert(graph.size == 3);

  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(2, 1);
  assert(graph.bfs(0).equal([true, true, true]));
  assert(graph.bfs(1).equal([false, true, false]));
  assert(graph.bfs(2).equal([false, true, true]));
}


unittest {
  writeln(__FILE__, ": Test dfs");

  auto graph = new AdjacentMatrix(3);
  assert(graph.size == 3);

  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(2, 1);
  assert(graph.dfs(0).equal([true, true, true]));
  assert(graph.dfs(1).equal([false, true, false]));
  assert(graph.dfs(2).equal([false, true, true]));
}


unittest {
  writeln(__FILE__, ": Test dfs2");

  auto graph = new AdjacentMatrix(3);
  assert(graph.size == 3);

  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(2, 1);
  assert(graph.dfs2(0).equal([true, true, true]));
  assert(graph.dfs2(1).equal([false, true, false]));
  assert(graph.dfs2(2).equal([false, true, true]));
}
