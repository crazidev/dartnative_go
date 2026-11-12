import 'package:dartnative/dartnative.dart';

import '../client/error_display_storage.dart';
import '../widgets/project_splash_screen.dart';

/// Immutable snapshot of the launch/preview surface published to pushed routes.
class PreviewState {
  final String appName;
  final String? appVersion;
  final String serverUrl;
  final bool isConnected;
  final bool isLoadingBundle;
  final bool isAppMounted;
  final String statusMessage;
  final double? downloadProgress;
  final int? downloadedCount;
  final int? downloadTotal;
  final Widget? widget;
  final String? splashUrl;
  final String? iconUrl;
  final String? splashBackgroundColor;

  /// The failure's message, already stripped of host/interpreter framing.
  final String? errorMessage;

  /// The exception type (`Argument Error`, `Bad state`, …) shown as the error
  /// view's subtitle; null when the message names none.
  final String? errorType;
  final String? errorStackTrace;
  final ErrorDisplayMode errorDisplayMode;

  /// Epoch counter bumped on hot restart so Flutter discards existing State.
  final int guestEpoch;

  /// True when the error occurred before the initial frame rendered.
  final bool failedToStart;

  /// Failure left no rendered child (blank surface).
  final bool guestBlankBuild;

  const PreviewState({
    this.appName = 'DartNative App',
    this.appVersion,
    this.serverUrl = '',
    this.isConnected = false,
    this.isLoadingBundle = false,
    this.isAppMounted = false,
    this.statusMessage = 'Connecting to project...',
    this.downloadProgress,
    this.downloadedCount,
    this.downloadTotal,
    this.widget,
    this.splashUrl,
    this.iconUrl,
    this.splashBackgroundColor,
    this.errorMessage,
    this.errorType,
    this.errorStackTrace,
    this.errorDisplayMode = ErrorDisplayMode.overlay,
    this.guestEpoch = 0,
    this.failedToStart = false,
    this.guestBlankBuild = false,
  });
}

/// True when the failure should show `InterpreterErrorView` (banner tap,
/// failed-to-start, or persisted full-screen mode) rather than the overlay.
bool previewStateNeedsFullScreenError(
  PreviewState s, {
  bool expanded = false,
}) =>
    s.errorMessage != null &&
    (expanded ||
        s.failedToStart ||
        s.errorDisplayMode == ErrorDisplayMode.fullscreen);

/// `popUntil` stop for `/preview` — match by name; `isFirst` is the backstop.
///
/// DartNative passes synthetic routes (not `PageRoute`), so `route is PageRoute`
/// never matches and a naive pop runs past the preview to the launcher.
bool stopAtHostPreviewRoute(
  Route<dynamic> route, {
  required bool Function(Route<dynamic>) byName,
}) => route.isFirst || byName(route);

/// The pushed route that launches and previews a guest project.
///
/// Started when the launcher opens a project; it shows the project splash
/// while the bundle downloads, then the mounted guest app. The floating
/// DevTools button lives in the host `App`'s builder layer above every route
/// (see `_buildDevToolsOverlay` in `lib/main.dart`), so it stays reachable
/// while the guest pushes its own screens.
class PreviewScreen extends StatelessWidget {
  final ValueListenable<PreviewState> state;

  /// Resolves the guest-root `Element` for UI automation. Owned by the host.
  final GlobalKey probeKey;

  const PreviewScreen({
    super.key,
    required this.state,
    required this.probeKey,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PreviewState>(
      valueListenable: state,
      builder: (context, s, _) {
        if (s.isAppMounted) {
          return KeyedSubtree(
            key: probeKey,
            // `guestEpoch` changes only on a hot restart, so the wrapper is
            // stable across reloads (state/providers stay alive) but is
            // discarded on restart — forcing fresh elements and State instead
            // of reconciling onto the previous, disposed interpreter's tree.
            child: KeyedSubtree(
              key: ValueKey('guest_epoch_${s.guestEpoch}'),
              child: KeyedSubtree(
                key: const ValueKey('guest_root'),
                child:
                    s.widget ??
                    const Scaffold(
                      body: Center(child: Text('Evaluating widget...')),
                    ),
              ),
            ),
          );
        }

        // Launch in progress (or failed before mounting): show the splash.
        // Guest failures are rendered by the host shell's overlay layer, which
        // stays above every route (see `_buildDevToolsOverlay`).
        return ProjectSplashScreen(
          appName: s.appName,
          splashUrl: s.splashUrl,
          iconUrl: s.iconUrl,
          backgroundColor: ProjectSplashScreen.parseHexColor(
            s.splashBackgroundColor,
          ),
          statusMessage: s.statusMessage,
          downloadProgress: s.downloadProgress,
          downloadedCount: s.downloadedCount,
          downloadTotal: s.downloadTotal,
        );
      },
    );
  }
}
