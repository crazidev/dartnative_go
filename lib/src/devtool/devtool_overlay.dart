import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import '../client/error_display_storage.dart';
import '../runner/ast_profile.dart';
import '../runner/dep_cache.dart';
import '../runner/runtime_mode.dart';
import '../theme/theme_providers.dart';
import 'devtool_sheet.dart';
import 'floating_devtool_button.dart';
import 'shake_detector.dart';

/// Overlay widget wrapped around the mounted guest app.
///
/// Provides:
/// 1. A floating, draggable DevTool button that can be moved anywhere on screen.
/// 2. Physical device shake detection to open the native DevTools bottomsheet.
/// 3. Native bottomsheet powered by `native_bottomsheet` (`showBottomSheet`).
class DevToolOverlay extends StatefulWidget {
  final Widget child;
  final String appName;
  final String? appVersion;
  final String serverUrl;
  final bool isConnected;
  final VoidCallback onGoHome;
  final VoidCallback onReload;
  final DepCache? depCache;
  final VoidCallback? onClearCache;

  /// Current engine mode label (e.g. "Source (tom_d4rt)").
  final String runtimeModeLabel;

  /// True when testing AST bundles. Defaults to false (source).
  final bool useAst;
  final void Function(bool enabled)? onToggleAst;

  final void Function()? onCycleMode;
  final void Function(RuntimeMode mode)? onSelectMode;

  /// Whether verbose benchmark & diagnostic logs are enabled.
  final bool verboseLogs;
  final void Function(bool enabled)? onToggleVerbose;

  /// How guest failures surface on the device (overlay banner vs fullscreen).
  final ErrorDisplayMode errorDisplayMode;
  final void Function(ErrorDisplayMode mode)? onSelectErrorMode;

  /// Structured snapshot of the last AST bundle evaluation for the viewer.
  final AstProfileSnapshot? astProfile;

  /// Whether the floating controls are active (gated until guest app mounts).
  final bool isEnabled;

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
    this.depCache,
    this.onClearCache,
    this.runtimeModeLabel = 'Source (tom_d4rt)',
    this.useAst = false,
    this.onToggleAst,
    this.onCycleMode,
    this.onSelectMode,
    this.verboseLogs = false,
    this.onToggleVerbose,
    this.errorDisplayMode = ErrorDisplayMode.overlay,
    this.onSelectErrorMode,
    this.astProfile,
  });

  @override
  State<DevToolOverlay> createState() => _DevToolOverlayState();
}

class _DevToolOverlayState extends State<DevToolOverlay> {
  late ShakeDetector _shakeDetector;
  DNSheetController? _sheet;

  @override
  void initState() {
    super.initState();
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
      // Leaving the guest (Go Home, teardown): close any open sheet so it
      // cannot outlive the surface it belongs to.
      _sheet?.dismiss();
      _sheet = null;
    }
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    super.dispose();
  }

  /// Opens the native bottom sheet with DevTools controls.
  void showDevtools(BuildContext context) {
    if (!widget.isEnabled || _sheet != null) return;

    _sheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium, DNSheetDetent.large],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      builder: (ctx, controller) => Consumer(
        builder: (ctx, ref, _) => DevToolSheet(
          controller: controller,
          appName: widget.appName,
          appVersion: widget.appVersion,
          serverUrl: widget.serverUrl,
          isConnected: widget.isConnected,
          runtimeModeLabel: widget.runtimeModeLabel,
          useAst: widget.useAst,
          onSelectMode: widget.onSelectMode,
          onCycleMode: widget.onCycleMode,
          onToggleAst: widget.onToggleAst,
          depCache: widget.depCache,
          onClearCache: widget.onClearCache,
          verboseLogs: widget.verboseLogs,
          onToggleVerbose: widget.onToggleVerbose,
          errorDisplayMode: widget.errorDisplayMode,
          onSelectErrorMode: widget.onSelectErrorMode,
          themePreference: ref.watch(themePreferenceProvider),
          onSelectTheme: (preference) => ref
              .read(themePreferenceProvider.notifier)
              .setPreference(preference),
          onGoHome: widget.onGoHome,
          onReload: widget.onReload,
          astProfile: widget.astProfile,
        ),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Guest App root
        widget.child,

        // 2. Floating, draggable DevTool button (only once a guest is up)
        if (widget.isEnabled)
          FloatingDevToolButton(
            isConnected: widget.isConnected,
            onTap: () => showDevtools(context),
          ),
      ],
    );
  }
}
