module odsD.test.dataStructure.externalMemory.BlockStore;

import odsD.dataStructure.externalMemory.BlockStore;
import odsD.test.util;

unittest {
  writeln(__FILE__, ": Some operations");

  auto store = new BlockStore!long();

  long[] xs = [2, 3, 5, 7];
  size_t[] ids = xs.map!(
    x => store.placeBlock(x)
  ).array;

  foreach(id, x; zip(ids, xs)) {
    assert(store.readBlock(id) == x);
  }

  store.freeBlock(ids[1]); // free xs[1]
  store.writeBlock(ids[2], -100);
  assert(store.readBlock(ids[0]) == 2);
  assert(store.readBlock(ids[2]) == -100);
  assert(store.readBlock(ids[3]) == 7);

  assert(store.placeBlock(0) == ids[1]);
}
