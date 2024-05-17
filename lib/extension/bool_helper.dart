extension BoolMatch on bool {
  T? match<T>({
    T Function()? whenTrue,
    T Function()? whenFalse,
  }) {
    if (this) {
      return whenTrue?.call();
    } else {
      return whenFalse?.call();
    }
  }

  T? whenTrue<T>(
    T Function() action, {
    T Function()? orElse,
  }) =>
      match<T>(
        whenTrue: action,
        whenFalse: orElse,
      );

  T? whenFalse<T>(
    T Function() action, {
    T Function()? orElse,
  }) =>
      match<T>(
        whenTrue: orElse,
        whenFalse: action,
      );
}
