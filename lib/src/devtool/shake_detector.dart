import 'package:dartnative/dartnative.dart';

/// Detects physical device shaking by observing discrete transitions in
/// [DeviceOrientationListener.currentNotifier].
class ShakeDetector {
  final VoidCallback onShake;
  final Duration window;
  final int requiredTransitions;

  final List<DateTime> _recentTransitions = [];
  bool _isListening = false;
  VoidCallback? _listener;

  ShakeDetector({
    required this.onShake,
    this.window = const Duration(milliseconds: 1400),
    this.requiredTransitions = 2,
  });

  /// Starts listening to device orientation transitions.
  void start() {
    if (_isListening) return;
    _isListening = true;

    _listener = () {
      final now = DateTime.now();
      _recentTransitions.add(now);

      // Keep only transitions within the detection window
      _recentTransitions.removeWhere((t) => now.difference(t) > window);

      if (_recentTransitions.length >= requiredTransitions) {
        _recentTransitions.clear();
        onShake();
      }
    };

    try {
      DeviceOrientationListener.currentNotifier.addListener(_listener!);
    } catch (_) {
      // Non-fatal if platform orientation listener is unsupported
    }
  }

  /// Stops listening and clears history.
  void stop() {
    _isListening = false;
    if (_listener != null) {
      try {
        DeviceOrientationListener.currentNotifier.removeListener(_listener!);
      } catch (_) {}
      _listener = null;
    }
    _recentTransitions.clear();
  }

  void dispose() => stop();
}
