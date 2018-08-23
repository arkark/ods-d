module odsD.dataStructure.graph.Graph;

interface Graph {
  size_t size();
  void addEdge(size_t i, size_t j);
  void removeEdge(size_t i, size_t j);
  bool hasEdge(size_t i, size_t j);
  size_t[] outEdges(size_t i);
  size_t[] inEdges(size_t i);
}
