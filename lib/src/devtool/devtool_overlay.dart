import 'package:dartnative/dartnative.dart';
import 'package:dngo_ui/dngo_ui.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import '../theme/theme_providers.dart';
import 'shake_detector.dart';

/// Opens the DevTools sheet from the host API without a widget callback.
class DevToolsHost {
  static void Function()? _open;

  static void register(void Function() open) => _open = open;

  static void unregister(void Function() open) {
    if (identical(_open, open)) _open = null;
  }

  static void open() => _open?.call();
}

/// Overlay widget wrapped around the mounted guest app.
///
/// Provides:
/// 1. A floating, draggable DevTools button that can be moved anywhere on screen.
/// 2. Physical device shake detection to open the native DevTools bottomsheet.
/// 3. Native bottomsheet powered by `native_bottomsheet` (`showBottomSheet`).
///
/// The pill and sheet live in `dngo_ui` so `dngo start` can preview
/// and hot-reload them. When the previewed UI claims DevTools for itself
/// (`DartGoHost.claimDevTools`), the shell disables this overlay.
class DevToolOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final String appName;
  final String? appVersion;
  final String serverUrl;
  final bool isConnected;
  final Function onGoHome;
  final Function onReload;
  final String? cacheLabel;
  final Function? onClearCache;

  /// Runtime mode labels in selector order.
  final List<String> runtimeModes;

  /// Index into [runtimeModes] of the active mode.
  final int selectedRuntimeModeIndex;
  final Function? onSelectRuntimeMode;

  /// Whether verbose benchmark & diagnostic logs are enabled.
  final bool verboseLogs;
  final Function? onToggleVerbose;

  /// Shell-only section (the AST bundle explorer) rendered after the runtime
  /// selector. Null for non-profile sessions.
  final Widget? extraSection;

  /// Whether the floating controls are active (gated until guest app mounts).
  final bool isEnabled;

  /// Guest failure surface (banner or error view) drawn above the routes but
  /// below the floating button, so DevTools stays reachable while an error is
  /// on screen. Positioned children are fine: this is a `Stack`.
  final Widget? errorSurface;

  const DevToolOverlay({
    super.key,
    required this.child,
    required this.appName,
    this.appVersion,
    required this.serverUrl,
    required this.isConnected,
    required this.onGoHome,
    required this.onReload,
    this.isEnabled = true,
    this.cacheLabel,
    this.onClearCache,
    this.runtimeModes = const ['AST'],
    this.selectedRuntimeModeIndex = 0,
    this.onSelectRuntimeMode,
    this.verboseLogs = false,
    this.onToggleVerbose,
    this.extraSection,
    this.errorSurface,
  });

  @override
  ConsumerState<DevToolOverlay> createState() => _DevToolOverlayState();
}

class _DevToolOverlayState extends ConsumerState<DevToolOverlay> {
  late ShakeDetector _shakeDetector;
  DNSheetController? _sheet;

  @override
  void initState() {
    super.initState();
    DevToolsHost.register(_openFromHost);
    _shakeDetector = ShakeDetector(
      onShake: () {
        if (mounted) {
          showDevtools(context);
        }
      },
    );
    if (widget.isEnabled) _shakeDetector.start();
  }

  @override
  void didUpdateWidget(covariant DevToolOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled == widget.isEnabled) return;
    if (widget.isEnabled) {
      _shakeDetector.start();
    } else {
      _shakeDetector.stop();
      // Leaving the guest (Go Home, teardown, or a previewed UI that owns
      // DevTools): close any open sheet so it cannot outlive the surface it
      // belongs to.
      _sheet?.dismiss();
      _sheet = null;
    }
  }

  @override
  void dispose() {
    DevToolsHost.unregister(_openFromHost);
    _shakeDetector.dispose();
    super.dispose();
  }

  void _openFromHost() {
    if (!mounted) return;
    showDevtools(context, force: true);
  }

  /// Opens the native bottom sheet with DevTools controls.
  ///
  /// [force] skips the "guest is mounted" gate so the host API can open the
  /// sheet from the launcher as well as from a previewed UI.
  void showDevtools(BuildContext context, {bool force = false}) {
    if (_sheet != null) return;
    if (!force && !widget.isEnabled) return;

    _sheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      builder: (ctx, controller) => Consumer(
        builder: (ctx, ref, _) {
          final preference = ref.watch(themePreferenceProvider);
          return HostDevToolSheet(
            controller: controller,
            appName: widget.appName,
            appVersion: widget.appVersion,
            serverUrl: widget.serverUrl,
            isConnected: widget.isConnected,
            runtimeModes: widget.runtimeModes,
            selectedRuntimeModeIndex: widget.selectedRuntimeModeIndex,
            onSelectRuntimeMode: widget.onSelectRuntimeMode,
            themeModes: const ['System', 'Light', 'Dark'],
            selectedThemeIndex: ThemePreference.values.indexOf(preference),
            onSelectTheme: (index) => ref
                .read(themePreferenceProvider.notifier)
                .setPreference(ThemePreference.values[index]),
            verbose: widget.verboseLogs,
            onToggleVerbose: widget.onToggleVerbose,
            cacheLabel: widget.cacheLabel,
            onClearCache: widget.onClearCache,
            onGoHome: widget.onGoHome,
            onReload: widget.onReload,
            extraSection: widget.extraSection,
          );
        },
      ),
      onDetentChanged: (detent) => print('settled at ${detent.label}'),
      onDismissed: () {
        print('sheet closed');
        if (mounted) {
          setState(() {
            _sheet = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final preference = ref.watch(themePreferenceProvider);
    final theme = resolveHostUiTheme(preference.name, context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Guest App root
        widget.child,

        // 2. Guest failure surface: above the routes (so a failure on a screen
        //    the guest pushed is visible), below the button.
        ?widget.errorSurface,

        // 3. Floating, draggable DevTools button (only once a guest is up)
        if (widget.isEnabled)
          HostDevToolButton(
            theme: theme,
            isConnected: widget.isConnected,
            onTap: () => showDevtools(context),
          ),
      ],
    );
  }
}
