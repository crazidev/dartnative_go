import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

import '../client/error_display_storage.dart';
import '../client/theme_storage.dart';
import '../runner/ast_profile.dart';
import '../runner/dep_cache.dart';
import '../runner/runtime_mode.dart';
import 'ast_profile_panel.dart';

/// Content panel rendered inside the native bottom sheet for DartNative DevTools.
class DevToolSheet extends StatefulWidget {
  final DNSheetController controller;
  final String appName;
  final String? appVersion;
  final String serverUrl;
  final bool isConnected;
  final String runtimeModeLabel;
  final bool useAst;
  final void Function(RuntimeMode mode)? onSelectMode;
  final VoidCallback? onCycleMode;
  final void Function(bool)? onToggleAst;
  final DepCache? depCache;
  final VoidCallback? onClearCache;
  final bool verboseLogs;
  final void Function(bool)? onToggleVerbose;
  final ErrorDisplayMode errorDisplayMode;
  final void Function(ErrorDisplayMode mode)? onSelectErrorMode;
  final ThemePreference themePreference;
  final void Function(ThemePreference preference)? onSelectTheme;
  final VoidCallback onGoHome;
  final VoidCallback onReload;

  /// Structured snapshot of the last AST bundle evaluation, or null before
  /// the first evaluation. Rendered in the AST BUNDLE explorer section.
  final AstProfileSnapshot? astProfile;

  const DevToolSheet({
    super.key,
    required this.controller,
    required this.appName,
    this.appVersion,
    required this.serverUrl,
    required this.isConnected,
    required this.runtimeModeLabel,
    this.useAst = false,
    this.onSelectMode,
    this.onCycleMode,
    this.onToggleAst,
    this.depCache,
    this.onClearCache,
    this.verboseLogs = false,
    this.onToggleVerbose,
    this.errorDisplayMode = ErrorDisplayMode.overlay,
    this.onSelectErrorMode,
    this.themePreference = ThemePreference.system,
    this.onSelectTheme,
    required this.onGoHome,
    required this.onReload,
    this.astProfile,
  });

  @override
  State<DevToolSheet> createState() => _DevToolSheetState();
}

class _DevToolSheetState extends State<DevToolSheet> {
  bool _isCacheCleared = false;
  late bool _verbose;
  late int _selectedModeIndex;
  late int _selectedErrorModeIndex;
  late int _selectedThemeIndex;

  static int _modeToIndex(bool useAst) {
    final mode = runtimeModeFromBool(useAst);
    final index = selectableRuntimeModes.indexOf(mode);
    return index < 0 ? 0 : index;
  }

  static RuntimeMode _indexToMode(int index) {
    final modes = selectableRuntimeModes;
    if (index < 0 || index >= modes.length) return kDefaultRuntimeMode;
    return modes[index];
  }

  static int _errorModeToIndex(ErrorDisplayMode mode) =>
      mode == ErrorDisplayMode.fullscreen ? 1 : 0;

  static ErrorDisplayMode _indexToErrorMode(int index) =>
      index == 1 ? ErrorDisplayMode.fullscreen : ErrorDisplayMode.overlay;

  static int _themeToIndex(ThemePreference preference) =>
      ThemePreference.values.indexOf(preference);

  static ThemePreference _indexToTheme(int index) {
    final values = ThemePreference.values;
    if (index < 0 || index >= values.length) return ThemePreference.system;
    return values[index];
  }

  @override
  void initState() {
    super.initState();
    _verbose = widget.verboseLogs;
    _selectedModeIndex = _modeToIndex(widget.useAst);
    _selectedErrorModeIndex = _errorModeToIndex(widget.errorDisplayMode);
    _selectedThemeIndex = _themeToIndex(widget.themePreference);
  }

  @override
  void didUpdateWidget(covariant DevToolSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.useAst != widget.useAst) {
      _selectedModeIndex = _modeToIndex(widget.useAst);
    }
    if (oldWidget.verboseLogs != widget.verboseLogs) {
      _verbose = widget.verboseLogs;
    }
    if (oldWidget.errorDisplayMode != widget.errorDisplayMode) {
      _selectedErrorModeIndex = _errorModeToIndex(widget.errorDisplayMode);
    }
    if (oldWidget.themePreference != widget.themePreference) {
      _selectedThemeIndex = _themeToIndex(widget.themePreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C1C1E),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with App Name, Icon & Status
              Row(
                children: [
                  Image.asset('assets/dn-logo.png', width: 44, height: 44),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.appName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: EdgeInsets.only(left: 10),
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
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.isConnected
                                        ? 'Connected'
                                        : 'Offline',
                                    style: TextStyle(
                                      color: widget.isConnected
                                          ? const Color(0xFF34C759)
                                          : const Color(0xFFFF9500),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.appVersion != null
                              ? 'Runtime Version: ${widget.appVersion}'
                              : 'DartNative Project',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GlassEffectContainer(
                    borderRadius: BorderRadius.circular(100),
                    child: IconButton(
                      icon: Icon(CupertinoIcons.xmark_1),
                      onPressed: () {
                        widget.controller.dismiss();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Button(
                      title: 'Go Home',
                      variant: ButtonVariant.bordered,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: () {
                        widget.controller.dismiss();
                        widget.onGoHome();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button(
                      title: 'Reload',
                      variant: ButtonVariant.bordered,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: () {
                        widget.controller.dismiss();
                        widget.onReload();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

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
              const SizedBox(height: 16),

              // Runtime mode (Source, AST)
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(width: 10),
                        Expanded(
                          child: SegmentedControl(
                            segments: selectableRuntimeModes
                                .map(
                                  (m) => m == RuntimeMode.source
                                      ? 'Source'
                                      : 'AST',
                                )
                                .toList(),
                            selectedIndex: _selectedModeIndex,
                            onValueChanged: (index) {
                              if (index == _selectedModeIndex) return;
                              setState(() {
                                _selectedModeIndex = index;
                              });
                              final mode = _indexToMode(index);
                              if (widget.onSelectMode != null) {
                                widget.onSelectMode!(mode);
                              } else if (widget.onCycleMode != null) {
                                widget.onCycleMode!();
                              } else if (widget.onToggleAst != null) {
                                widget.onToggleAst!(mode == RuntimeMode.ast);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // AST bundle explorer (packages, modules, classes, loads)
              AstProfilePanel(profile: widget.astProfile),
              const SizedBox(height: 16),

              // Error Display
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF2C2C2E),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             'ERROR DISPLAY',
              //             style: TextStyle(
              //               color: Colors.white38,
              //               fontSize: 10,
              //               fontWeight: FontWeight.bold,
              //               letterSpacing: 0.5,
              //             ),
              //           ),
              //           SizedBox(width: 10),
              //           Expanded(
              //             child: SegmentedControl(
              //               segments: const ['Overlay', 'Full screen'],
              //               selectedIndex: _selectedErrorModeIndex,
              //               onValueChanged: (index) {
              //                 if (index == _selectedErrorModeIndex) return;
              //                 setState(() {
              //                   _selectedErrorModeIndex = index;
              //                 });
              //                 widget.onSelectErrorMode?.call(
              //                   _indexToErrorMode(index),
              //                 );
              //               },
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Theme
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'THEME',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SegmentedControl(
                            segments: const [
                              'System',
                              'Light',
                              'Dark',
                            ],
                            selectedIndex: _selectedThemeIndex,
                            onValueChanged: (index) {
                              if (index == _selectedThemeIndex) return;
                              setState(() {
                                _selectedThemeIndex = index;
                              });
                              widget.onSelectTheme?.call(
                                _indexToTheme(index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dependency Cache
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
                      if (!_isCacheCleared)
                        Button(
                          child: Icon(CupertinoIcons.trash_1, size: 20),
                          variant: ButtonVariant.plain,
                          padding: EdgeInsets.zero,
                          foregroundColor: Colors.red,
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
                const SizedBox(height: 16),
              ],

              // Verbose logs toggle
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final next = !_verbose;
                  setState(() {
                    _verbose = next;
                  });
                  widget.onToggleVerbose?.call(next);
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
                          ],
                        ),
                      ),

                      Switch(
                        value: _verbose,
                        onChanged: (v) {
                          widget.onToggleVerbose?.call(v);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
