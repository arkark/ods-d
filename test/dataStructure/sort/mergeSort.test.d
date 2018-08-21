module odsD.test.dataStructure.sort.mergeSort;

import odsD.dataStructure.sort.mergeSort;
import odsD.test;

unittest {
  writeln(__FILE__, ": Some operations");

  long[] xs = [5, 1, 3];
  xs.mergeSort();
  assert(xs.equal([1, 3, 5]));

  xs.mergeSort!"a>b"();
  assert(xs.equal([5, 3, 1]));
}

unittest {
  writeln(__FILE__, ": Use of a defined struct");

  struct Vec {
    long x, y;
    @property long lengthSq() {
      return x*x + y*y;
    }
  }

  Vec[] vs = [
    Vec(10, 20),
    Vec(0, 0),
    Vec(3, 4),
    Vec(-3, 4)
  ];

  vs.mergeSort!"a.lengthSq < b.lengthSq"();
  assert(vs[0] == Vec(0, 0));
  assert(vs[1].lengthSq == 5*5);
  assert(vs[2].lengthSq == 5*5);
  assert(vs[3] == Vec(10, 20));
}

unittest {
  writeln(__FILE__, ": Random array");

  long n = 1000;
  long[] xs = randomArray!long(n);

  long[] ys = xs.dup;
  long[] zs = xs.dup;
  ys.mergeSort();
  zs.sort();
  assert(ys.equal(zs));
}
