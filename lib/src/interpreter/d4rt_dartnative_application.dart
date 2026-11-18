import 'dart:async';

/// A first-class long-lived application root for interpreted DartNative apps.
///
/// Designed after the DartNative AST specification for over-the-air applications.
/// Allows guest scripts to manage non-widget lifecycles (streams, timers, tickers)
/// with guaranteed teardown across hot reloads and unmounts.
class D4rtDartNativeApplication {
  /// The root widget to mount in the native widget tree.
  final dynamic root;

  /// Invoked once when the application root is first mounted.
  final FutureOr<void> Function()? onMount;

  /// Invoked when the application is unmounted or prior to a live hot reload.
  final FutureOr<void> Function()? onUnmount;

  /// Optional sink for late framework and layout errors.
  final void Function(Object error, StackTrace stackTrace)? errorListener;

  const D4rtDartNativeApplication({
    required this.root,
    this.onMount,
    this.onUnmount,
    this.errorListener,
  });
}
