import 'package:dngo_api/host_api.dart';

/// Guest closures registered by the host API bridge.
///
/// Interpreted `addListener` callbacks are not the shell's Dart closures.
/// Each engine tracks the wrappers it installed and drops them when that
/// engine's runner is disposed, so a hot restart does not call into a
/// dead interpreter.
class HostApiGuestListeners {
  final List<void Function()> _wrappers = [];

  void track(void Function() wrapper) {
    _wrappers.add(wrapper);
    try {
      DartGoHost.addListener(wrapper);
    } catch (_) {
      _wrappers.remove(wrapper);
    }
  }

  void detach(Object callback, Map<Object, void Function()> byCallback) {
    final wrapper = byCallback.remove(callback);
    if (wrapper == null) return;
    _wrappers.remove(wrapper);
    try {
      DartGoHost.removeListener(wrapper);
    } catch (_) {}
  }

  void detachAll(Map<Object, void Function()> byCallback) {
    for (final wrapper in _wrappers) {
      try {
        DartGoHost.removeListener(wrapper);
      } catch (_) {}
    }
    _wrappers.clear();
    byCallback.clear();
  }
}
