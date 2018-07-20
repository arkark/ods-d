module util.testFunctions;


import std.format;
import std.datetime;

public {
  import std.datetime : msecs;
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
