import 'package:dartnative/dartnative.dart';
import '../runner/dep_cache.dart';
import 'shake_detector.dart';

/// Overlay widget wrapped around the mounted guest app.
///
/// Provides:
/// 1. A floating, draggable/hideable DevTool button.
/// 2. Physical device shake detection to open the DevTool bottomsheet.
/// 3. In-stack DevTool bottomsheet showing app details, server connection,
///    dependency cache size & clearing, manual reload, and launcher exit.
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

  /// Whether verbose benchmark & diagnostic logs are enabled.
  final bool verboseLogs;
  final void Function(bool enabled)? onToggleVerbose;

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
    this.verboseLogs = false,
    this.onToggleVerbose,
  });

  @override
  State<DevToolOverlay> createState() => _DevToolOverlayState();
}

class _DevToolOverlayState extends State<DevToolOverlay> {
  late ShakeDetector _shakeDetector;
  bool _isFloatingButtonVisible = true;
  bool _isBottomSheetOpen = false;
  bool _isCacheCleared = false;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(
      onShake: () {
        if (mounted) {
          setState(() {
            _isBottomSheetOpen = true;
          });
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

  void _openBottomSheet() {
    setState(() {
      _isBottomSheetOpen = true;
    });
  }

  void _closeBottomSheet() {
    setState(() {
      _isBottomSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Guest App root
        widget.child,

        // 2. Floating DevTool Pill (when enabled and sheet is closed)
        if (_isFloatingButtonVisible && !_isBottomSheetOpen)
          Positioned(
            right: 16,
            bottom: 34,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xEE1C1C1E),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _openBottomSheet,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/dn-logo.png', width: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'DevTool',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.isConnected
                                ? const Color(0xFF34C759)
                                : const Color(0xFFFF9500),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Close button to hide the floating pill
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFloatingButtonVisible = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Text(
                        '✕',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 3. Minimized edge indicator when floating pill is hidden
        if (!_isFloatingButtonVisible && !_isBottomSheetOpen)
          Positioned(
            right: 0,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFloatingButtonVisible = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xCC1C1C1E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  '⚡️',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

        // 4. In-stack BottomSheet Dim Barrier
        if (_isBottomSheetOpen)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeBottomSheet,
              child: Container(
                color: const Color(0x88000000),
              ),
            ),
          ),

        // 5. In-stack BottomSheet Panel
        if (_isBottomSheetOpen)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x88000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grab Handle
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Header with App Name & Icon
                  Row(
                    children: [
                      Image.asset('assets/dn-logo.png', width: 44),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.appName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.appVersion != null
                                  ? 'Version ${widget.appVersion}'
                                  : 'DartNative Project',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isConnected
                              ? const Color(0x2234C759)
                              : const Color(0x22FF9500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: widget.isConnected
                                    ? const Color(0xFF34C759)
                                    : const Color(0xFFFF9500),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.isConnected ? 'Connected' : 'Offline',
                              style: TextStyle(
                                color: widget.isConnected
                                    ? const Color(0xFF34C759)
                                    : const Color(0xFFFF9500),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Server URL details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEV SERVER',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.serverUrl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Runtime mode (Source, AST, Bytecode)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.onCycleMode != null) {
                        widget.onCycleMode!();
                      } else {
                        widget.onToggleAst?.call(!widget.useAst);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RUNTIME MODE',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.runtimeModeLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                const Text(
                                  'Tap to cycle (Source ➔ AST ➔ Bytecode)',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            widget.useBytecode
                                ? 'Bytecode'
                                : (widget.useAst ? 'AST' : 'Source'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dependency Cache (Expo Go-style caching inspection & clear)
                  if (widget.depCache != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DEPENDENCY CACHE',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isCacheCleared
                                      ? '0 B (0 packages)'
                                      : '${widget.depCache!.getFormattedCacheSize()} (${widget.depCache!.getCachedPackageCount()} packages)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Button(
                            title: _isCacheCleared ? '✅ Cleared' : '🗑️ Clear',
                            variant: ButtonVariant.bordered,
                            foregroundColor: _isCacheCleared
                                ? const Color(0xFF34C759)
                                : const Color(0xFFFF9500),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            onPressed: _isCacheCleared
                                ? null
                                : () async {
                                    await widget.depCache!.clearCache();
                                    widget.onClearCache?.call();
                                    if (mounted) {
                                      setState(() {
                                        _isCacheCleared = true;
                                      });
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onToggleVerbose?.call(!widget.verboseLogs);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'VERBOSE LOGS',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.verboseLogs
                                      ? 'Enabled (Full telemetry & benchmarks)'
                                      : 'Disabled (Clean output)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                const Text(
                                  'Tap to toggle step-by-step benchmark traces',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.verboseLogs
                                  ? const Color(0x2234C759)
                                  : const Color(0x228E8E93),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.verboseLogs ? 'ON' : 'OFF',
                              style: TextStyle(
                                color: widget.verboseLogs
                                    ? const Color(0xFF34C759)
                                    : const Color(0xFF8E8E93),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      // Go Home button
                      Expanded(
                        child: Button(
                          title: '🏠 Go Home',
                          variant: ButtonVariant.filled,
                          color: const Color(0xFFFF3B30),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: () {
                            _closeBottomSheet();
                            widget.onGoHome();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Hot Reload button
                      Expanded(
                        child: Button(
                          title: '🔄 Reload',
                          variant: ButtonVariant.bordered,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: () {
                            _closeBottomSheet();
                            widget.onReload();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Hint on how to reopen
                  const Center(
                    child: Text(
                      'Tip: Shake your device anytime to open this menu',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
