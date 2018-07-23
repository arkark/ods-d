module odsD.util.Maybe;

Maybe!T Just(T)(T value) in {
  static if (is(typeof(value is null))) {
    assert(value !is null);
  }
} do {
  return Maybe!T(value);
}

Maybe!T None(T)() {
  return Maybe!T();
}

struct Maybe(T) {

private:
  T value = T.init;
  bool _isJust = false;

package:
  this(T value) {
    this.value = value;
    this._isJust = true;
  }

public:
  @property bool isJust() {
    return _isJust;
  }

  @property bool isNone() {
    return !_isJust;
  }

  @property T get() in {
    assert(isJust);
  } do {
    return value;
  }

}
