/// Public DartNative Go host API.
///
/// ```dart
/// import 'package:dartnative_go/host_api.dart';
///
/// await DartGoHost.discover();
/// await DartGoHost.openWithLink('http://127.0.0.1:8088');
/// await DartGoHost.toggleTheme();
/// ```
///
/// The shell installs a [DartGoHostBinding] at startup. Interpreted guests
/// that import this library (or `package:dartnative_go_api/host_api.dart`)
/// are served by the host bridge, so a UI package running under
/// `dart_go start` can drive discover, refresh, open, theme, DevTools,
/// verbose, reload, and go-home without a native rebuild.
///
/// The host UI package imports `package:dartnative_go_api/host_api.dart`
/// directly. That avoids a package cycle: the shell depends on the UI, and
/// the UI must not depend on the shell.
library;

export 'package:dartnative_go_api/host_api.dart';
