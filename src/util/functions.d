module odsD.util.functions;

import std.traits;
import std.range;
import std.algorithm;

private enum bool areCopyCompatibleArrays(T1, T2) =
  isArray!T1 && isArray!T2 && is(typeof(T2.init[] = T1.init[]));

void retroCopy(SourceRange, TargetRange)(SourceRange source, TargetRange target)
if (areCopyCompatibleArrays!(SourceRange, TargetRange)) {
  source.retro.copy(target.retro);
}
