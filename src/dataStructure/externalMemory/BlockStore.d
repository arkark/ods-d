module odsD.dataStructure.externalMemory.BlockStore;

import std.format;
import odsD.util.Maybe;
import odsD.dataStructure.arrayBasedList.ArrayStack;

class BlockStore(T) {

protected:
  ArrayStack!(Maybe!T) blocks;
  ArrayStack!size_t freeList;

public:
  this() {
    blocks = new ArrayStack!(Maybe!T)();
    freeList = new ArrayStack!size_t();
    clear();
  }

  void clear() {
    blocks.clear();
    freeList.clear();
  }

  T readBlock(size_t i) in {
    assert(i < blocks.size, format!"Attempting to fetch the %sth block of a BlockStore with size == %s"(i, blocks.size));
  } do {
    return blocks.get(i).get;
  }

  void writeBlock(size_t i, T block) in {
    assert(i < blocks.size, format!"Attempting to fetch the %sth block of a BlockStore with size == %s"(i, blocks.size));
  } do {
    blocks.set(i, Just(block));
  }

  size_t placeBlock(T block) {
    if (freeList.size > 0) {
      size_t i = freeList.removeBack();
      assert(blocks.get(i).isNone);
      blocks.set(i, Just(block));
      return i;
    } else {
      blocks.insertBack(Just(block));
      return blocks.size - 1;
    }
  }

  void freeBlock(size_t i) {
    blocks.set(i, None!T);
    freeList.insertBack(i);
  }
}
