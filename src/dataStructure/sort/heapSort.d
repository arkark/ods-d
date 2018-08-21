module odsD.dataStructure.sort.heapSort;

import odsD.dataStructure.heap.BinaryHeap;
import std.functional;

// O(n log n)
// @sideEffect: xs
void heapSort(alias less = "a < b", T)(T[] xs)
if (is(typeof(binaryFun!less(T.init, T.init)))) {

  auto heap = new BinaryHeap!(T, less)(xs);
  foreach(ref x; xs) {
    x = heap.remove();
  }

}
