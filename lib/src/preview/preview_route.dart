import 'package:dartnative/dartnative.dart';

import '../client/error_display_storage.dart';
import '../widgets/guest_error_banner.dart';
import '../widgets/interpreter_error_view.dart';
import '../widgets/project_splash_screen.dart';

/// Immutable snapshot of the launch/preview surface.
///
/// The preview is a pushed route, so it is **not** rebuilt when the host root
/// rebuilds (pushed routes are independent native screens). The host publishes
/// this snapshot through a [ValueNotifier] after every state change; the route
/// listens to it, so splash progress, the mounted guest and error surfaces all
/// stay in sync without the root re-deciding its child.
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
  final String? errorMessage;
  final String? errorStackTrace;
  final ErrorDisplayMode errorDisplayMode;

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
    this.errorStackTrace,
    this.errorDisplayMode = ErrorDisplayMode.overlay,
  });
}

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

  final VoidCallback onGoHome;
  final VoidCallback onRetry;
  final void Function(String error)? onLogToTerminal;
  final VoidCallback onDismissError;

  const PreviewScreen({
    super.key,
    required this.state,
    required this.probeKey,
    required this.onGoHome,
    required this.onRetry,
    this.onLogToTerminal,
    required this.onDismissError,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PreviewState>(
      valueListenable: state,
      builder: (context, s, _) {
        // A guest failure fully takes over the route when there is no tree to
        // keep behind it, or when the persisted mode asks for it.
        final fullScreenError =
            s.errorMessage != null &&
            (s.widget == null ||
                s.errorDisplayMode == ErrorDisplayMode.fullscreen);
        if (fullScreenError) {
          return InterpreterErrorView(
            errorMessage: s.errorMessage!,
            stackTrace: s.errorStackTrace,
            onGoHome: onGoHome,
            onRetry: onRetry,
            onLogToTerminal: onLogToTerminal,
          );
        }

        if (s.isAppMounted) {
          final guest = KeyedSubtree(
            key: probeKey,
            child: KeyedSubtree(
              key: const ValueKey('guest_root'),
              child:
                  s.widget ??
                  const Scaffold(
                    body: Center(child: Text('Evaluating widget...')),
                  ),
            ),
          );
          if (s.errorMessage != null && s.widget != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                guest,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: GuestErrorBanner(
                    errorMessage: s.errorMessage!,
                    stackTrace: s.errorStackTrace,
                    onDismiss: onDismissError,
                    onRestart: onRetry,
                  ),
                ),
              ],
            );
          }
          return guest;
        }

        // Launch in progress (or failed before mounting): show the splash.
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
