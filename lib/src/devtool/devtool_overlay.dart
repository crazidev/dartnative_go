import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

import '../client/error_display_storage.dart';
import '../runner/dep_cache.dart';
import '../runner/runtime_mode.dart';
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

  /// True when testing Bytecode stack VM.
  final bool useBytecode;
  final void Function()? onCycleMode;
  final void Function(RuntimeMode mode)? onSelectMode;

  /// Whether verbose benchmark & diagnostic logs are enabled.
  final bool verboseLogs;
  final void Function(bool enabled)? onToggleVerbose;

  /// How guest failures surface on the device (overlay banner vs fullscreen).
  final ErrorDisplayMode errorDisplayMode;
  final void Function(ErrorDisplayMode mode)? onSelectErrorMode;

  const DevToolOverlay({
    super.key,
    required this.child,
    required this.appName,
    this.appVersion,
    required this.serverUrl,
    required this.isConnected,
    required this.onGoHome,
    required this.onReload,
    this.depCache,
    this.onClearCache,
    this.runtimeModeLabel = 'Source (tom_d4rt)',
    this.useAst = false,
    this.onToggleAst,
    this.useBytecode = false,
    this.onCycleMode,
    this.onSelectMode,
    this.verboseLogs = false,
    this.onToggleVerbose,
    this.errorDisplayMode = ErrorDisplayMode.overlay,
    this.onSelectErrorMode,
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
    _shakeDetector.start();
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    super.dispose();
  }

  /// Opens the native bottom sheet with DevTools controls.
  void showDevtools(BuildContext context) {
    if (_sheet != null) return;

    _sheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium, DNSheetDetent.large],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      builder: (ctx, controller) => DevToolSheet(
        controller: controller,
        appName: widget.appName,
        appVersion: widget.appVersion,
        serverUrl: widget.serverUrl,
        isConnected: widget.isConnected,
        runtimeModeLabel: widget.runtimeModeLabel,
        useAst: widget.useAst,
        useBytecode: widget.useBytecode,
        onSelectMode: widget.onSelectMode,
        onCycleMode: widget.onCycleMode,
        onToggleAst: widget.onToggleAst,
        depCache: widget.depCache,
        onClearCache: widget.onClearCache,
        verboseLogs: widget.verboseLogs,
        onToggleVerbose: widget.onToggleVerbose,
        errorDisplayMode: widget.errorDisplayMode,
        onSelectErrorMode: widget.onSelectErrorMode,
        onGoHome: widget.onGoHome,
        onReload: widget.onReload,
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

        // 2. Floating, draggable DevTool button
        FloatingDevToolButton(
          isConnected: widget.isConnected,
          onTap: () => showDevtools(context),
        ),
      ],
    );
  }
}
