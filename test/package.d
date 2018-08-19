module odsD.test;

import std.format;
import std.datetime;

public {
  import std.stdio : writeln;
  import std.format : format;
  import std.datetime : msecs;
  import std.algorithm : equal, sort;
}

Duration benchmark(alias fun)(uint iter) {
  import std.datetime.stopwatch : benchmark;
  return benchmark!fun(iter)[0];
}

void testTimeComplexity(string name, alias fun)(uint iter, Duration timeLimit) {
  auto time = benchmark!fun(iter);

  assert(
    time < timeLimit,
    format!"Time `%s` took to run %s times is %s ms, but it should be less %s ms."(
      name, iter, time.total!"msecs", timeLimit.total!"msecs"
    )
  );
}

T[] randomArray(T)(size_t n) {
  import std.random;
  auto rnd = Random(unpredictableSeed);
  T[] xs = new T[n];
  foreach(ref x; xs) {
    x = rnd.uniform!T;
  }
  return xs;
}
