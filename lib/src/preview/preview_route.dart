import 'package:dartnative/dartnative.dart';

import '../client/error_display_storage.dart';
import '../widgets/guest_error_banner.dart';
import '../widgets/interpreter_error_view.dart';
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
  final String? errorMessage;
  final String? errorStackTrace;
  final ErrorDisplayMode errorDisplayMode;

  /// Epoch counter bumped on hot restart so Flutter discards existing State.
  final int guestEpoch;

  /// True when the error occurred before the initial frame rendered.
  final bool failedToStart;

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
    this.guestEpoch = 0,
    this.failedToStart = false,
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
  final VoidCallback onDismissError;

  const PreviewScreen({
    super.key,
    required this.state,
    required this.probeKey,
    required this.onGoHome,
    required this.onRetry,
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
            // One general title for every failure; the subtitle says whether
            // the project never loaded or crashed while running.
            subtitle: s.failedToStart
                ? 'The project did not finish loading'
                : 'Runtime exception during execution',
          );
        }

        if (s.isAppMounted) {
          final guest = KeyedSubtree(
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
