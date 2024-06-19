import 'package:flutter_lazy_j_tools/src/debouncer/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('debouncer ...', (tester) async {
    var debouncer = Debouncer(delay: Duration(milliseconds: 900));

    // 模拟快速连续触发事件
    debouncer.run(() => print('Action 1'));
    debouncer.run(() => print('Action 2'));
    await Future.delayed(Duration(milliseconds: 600), () {
      debouncer.run(() => print(' delay Action 2'));
    });
    await Future.delayed(Duration(milliseconds: 1000), () {
      debouncer.run(() => print(' delay Action 3'));
    });
    debouncer.run(() => print('Action 3'));
    debouncer.run(() => print('Action 4'));

    // 等待一秒后执行
    await Future.delayed(Duration(seconds: 2), () {
      debouncer.run(() => print('Action after delay'));
    });
  });
}
