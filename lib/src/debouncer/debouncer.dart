import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _debounce;

  Debouncer({this.delay = const Duration(milliseconds: 800)});

  void run(Function action) {
    // 如果之前的操作还没有完成，取消它
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(delay, () => action());
  }
}
