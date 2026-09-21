/// Per-plugin test contract: every supported plugin gets its own case.
///
/// A [PluginCase] declares guest sources plus scripted interactions, so the
/// plugin matrix runner can execute it in source mode, AST mode, or both and
/// classify failures as bridge-missing / native-missing / parity-skew.
library;

import 'package:dartnative/dartnative.dart';

/// How a plugin check failed (for matrix reporting).
enum PluginFailureKind {
  /// Expected bridge class/method not registered on the interpreter.
  bridgeMissing,

  /// Bridge exists but the underlying native call failed
  /// (FFI symbol, platform channel, host without native lib).
  nativeMissing,

  /// Source mode and AST mode disagree on the same guest code.
  paritySkew,

  /// Anything else (guest exception, assertion, timeout).
  other,
}

/// Classified plugin failure for matrix reports.
class PluginFailure implements Exception {
  final String plugin;
  final PluginFailureKind kind;
  final String message;

  const PluginFailure(this.plugin, this.kind, this.message);

  @override
  String toString() => 'PluginFailure($plugin, $kind): $message';
}

/// One plugin's headless compatibility case.
abstract class PluginCase {
  /// Plugin name as in `pubspec.yaml` (e.g. `dartnative_shared_preferences`).
  String get pluginName;

  /// Guest sources keyed by relative path. Must contain `main.dart`
  /// calling `runApp(...)` or returning a `Widget`.
  Map<String, String> guestSources();

  /// Drive the UI: find widgets, tap buttons, call callbacks.
  /// Called with the evaluated root widget.
  Future<void> interact(Widget root);

  /// Assert post-interaction state (widget tree contents, prefs values…).
  /// Called with the (possibly rebuilt) root widget.
  Future<void> verify(Widget root);
}
