module odsD.dataStructure.graph.traversal;

import odsD.dataStructure.graph.Graph;
import odsD.dataStructure.linkedList.SLList;

// breadth-first search
bool[] bfs(Graph graph, size_t root) {
  bool[] seen = new bool[graph.size];

  auto list = new SLList!size_t();
  list.insertBack(root);
  seen[root] = true;

  while(list.size > 0) {
    size_t i  = list.removeFront();
    foreach(j; graph.outEdges(i)) {
      if (seen[j]) continue;
      list.insertBack(j);
      seen[j] = true;
    }
  }

  return seen;
}

// depth-first search (recursion version)
bool[] dfs(Graph graph, size_t root) {
  bool[] visited = new bool[graph.size];

  void rec(size_t i) {
    visited[i] = true;
    foreach(j; graph.outEdges(i)) {
      if (visited[j]) continue;
      visited[j] = true;
      rec(j);
    }
  }
  rec(root);

  return visited;
}

// depth-first search (while version)
bool[] dfs2(Graph graph, size_t root) {
  bool[] visited = new bool[graph.size];
  auto list = new SLList!size_t();
  list.insertFront(root);

  while(list.size > 0) {
    size_t i = list.removeFront();
    if (visited[i]) continue;
    visited[i] = true;
    foreach(j; graph.outEdges(i)) {
      list.insertFront(j);
    }
  }

  return visited;
}
