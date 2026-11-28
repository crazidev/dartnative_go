import 'package:dartnative/dartnative.dart';

class BenchController {
  static const batch = 50;

  final hudExpanded = ValueNotifier(true);
  final resetCount = ValueNotifier(0);
  int ballCount = 0;
  int _pending = 0;

  void addBatch() => _pending += batch;

  int takePending() {
    final n = _pending;
    _pending = 0;
    return n;
  }

  void reset() {
    _pending = 0;
    resetCount.value++;
  }

  void dispose() {
    hudExpanded.dispose();
    resetCount.dispose();
  }
}
