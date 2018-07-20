module util.testFunctions;

public {
  import std.datetime : msecs;
}

import std.format;
import std.datetime;
import std.datetime.stopwatch : benchmark;

void testTimeComplexity(string name, alias fun)(uint iter, Duration timeLimit) {
  auto time = benchmark!fun(iter)[0];

  assert(
    time < timeLimit,
    format!"Time `%s` took to run %s times is %s ms, but it should be less %s ms."(
      name, iter, time.total!"msecs", timeLimit.total!"msecs"
    )
  );
}
