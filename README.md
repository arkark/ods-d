# ods-d

[![Build Status](https://travis-ci.com/ArkArk/ods-d.svg?branch=master)](https://travis-ci.com/ArkArk/ods-d)
[![codecov.io](https://codecov.io/gh/ArkArk/ods-d/coverage.svg?branch=master)](https://codecov.io/gh/ArkArk/ods-d)

D implementation of data structures in Open Data Structures (ODS).

## Data Structures

- [Array-Based Lists](src/dataStructure/arrayBasedList)
  - ArrayStack.d: An array-based stack
  - FastArrayStack.d: An optimized ArrayStack
  - ArrayQueue.d: An array-based queue
  - ArrayDeque.d: An array-based deque
  - DualArrayDeque.d: An array-based deque which consists of two stacks
  - RootishArrayStack.d: A space-efficient array-based stack
- [Linked Lists](src/dataStructure/linkedList)
  - SLList.d: A singly-linked list
  - DLList.d: A doubly-linked list
  - SEList.d: A space-efficient linked list (a.k.a. unrolled linked list)
- [Skiplists](src/dataStructure/skiplist)
  - SkiplistSSet.d: A set using a skiplist
  - SkiplistList.d: A random-access list using a skiplist
- [Hash Tables](src/dataStructure/hashTable)
  - ChainedHashTable.d: A hash table using chaining
  - LinearHashTable.d: A hash table using open addressing with linear probing
- [Binary Trees](src/dataStructure/binaryTree)
  - BinaryTree.d: A basic binary tree
  - BinarySearchTree.d: An unbalanced binary search tree
- [Random Binary Search Trees](src/dataStructure/randomBinarySearchTree)
  - Treap.d: A treap
- [Scapegoat Trees](src/dataStructure/scapegoatTree)
  - ScapegoatTree.d: A scapegoat tree
- [Red-Black Trees](src/dataStructure/redBlackTree)
  - RedBlackTree.d: A red-black tree
- [Heaps](src/dataStructure/heap)
  - BinaryHeap.d: A binary heap
  - MeldableHeap.d: A randomized meldable heap
- [Sorting Algorithms](src/dataStructure/sort)
  - mergeSort.d
  - quickSort.d
  - heapSort.d
  - countingSort.d
  - radixSort.d
- [Graphs](src/dataStructure/graph)
  - AdjacencyMatrix.d
  - AdjacencyList.d
  - traversal.d: bfs and dfs
- [Data Structures for Integers](src/dataStructure/trie)
  - BinaryTrie.d: A binary trie
  - XFastTrie.d: A x-fast trie
  - YFastTrie.d: A y-fast trie
- [External Memory Searching](src/dataStructure/externalMemory)
  - BTree.d: A B-tree

## Tests

requirements: [dmd](https://dlang.org/), [dub](http://code.dlang.org/)

```
$ dub test
```

## Links

### What's ODS?

- [Open Data Structures](http://opendatastructures.org/)
- [OpenDataStructures.jp](https://sites.google.com/view/open-data-structures-ja)
- [みんなのデータ構造 | Lambda Note](https://www.lambdanote.com/products/opendatastructures)

### Implementations in other languages

- [https://github.com/patmorin/ods](https://github.com/patmorin/ods)
  - C, C++, Java, Python
- [https://github.com/spinute/ods-go](https://github.com/spinute/ods-go)
  - Go
