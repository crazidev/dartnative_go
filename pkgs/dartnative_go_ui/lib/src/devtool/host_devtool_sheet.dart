import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

import '../theme/host_ui_theme.dart';

/// Major component of an Apple version string such as
/// `Version 26.4.1 (Build 23E254a)`. Returns `0` when none is present.
int _majorVersion(String version) {
  final match = RegExp(r'(\d+)').firstMatch(version);
  if (match == null) return 0;
  return int.tryParse(match.group(1)!) ?? 0;
}

/// Content panel rendered inside the native bottom sheet for DartNative
/// DevTools.
///
/// Lives in this package (not the shell) so `dart_go start` can preview and
/// hot-reload the DevTools UI. Every action is supplied by the caller: the
/// shell wires its controllers, and a previewed UI wires `DartGoHost`.
///
/// Callbacks are `Function`, not typed typedefs: interpreted guest closures
/// are `dynamic Function(...)` and the interpreter rejects them against a
/// nominal function annotation.
class HostDevToolSheet extends StatefulWidget {
  final DNSheetController controller;

  final String appName;
  final String? appVersion;
  final String serverUrl;
  final bool isConnected;

  /// Runtime mode labels in selector order.
  final List<String> runtimeModes;
  final int selectedRuntimeModeIndex;
  final Function? onSelectRuntimeMode;

  /// Theme labels in selector order (`System`, `Light`, `Dark`).
  final List<String> themeModes;
  final int selectedThemeIndex;
  final Function? onSelectTheme;

  final bool verbose;
  final Function? onToggleVerbose;

  /// Formatted dependency cache summary, or null to hide the section.
  final String? cacheLabel;
  final Function? onClearCache;

  /// Rescans the local network for dev servers. Null hides the action.
  final Function? onRescan;

  final Function onGoHome;
  final Function onReload;

  /// Shell-only section (the AST bundle explorer) rendered after the runtime
  /// selector. Null in a previewed UI.
  final Widget? extraSection;

  const HostDevToolSheet({
    super.key,
    required this.controller,
    required this.appName,
    this.appVersion,
    required this.serverUrl,
    required this.isConnected,
    this.runtimeModes = const ['AST'],
    this.selectedRuntimeModeIndex = 0,
    this.onSelectRuntimeMode,
    this.themeModes = const ['System', 'Light', 'Dark'],
    this.selectedThemeIndex = 0,
    this.onSelectTheme,
    this.verbose = false,
    this.onToggleVerbose,
    this.cacheLabel,
    this.onClearCache,
    this.onRescan,
    required this.onGoHome,
    required this.onReload,
    this.extraSection,
  });

  @override
  State<HostDevToolSheet> createState() => _HostDevToolSheetState();
}

class _HostDevToolSheetState extends State<HostDevToolSheet> {
  // ignore: unused_field, prefer_final_fields
  bool _isCacheCleared = false;
  late bool _verbose;
  late int _selectedModeIndex;
  late int _selectedThemeIndex;

  @override
  void initState() {
    super.initState();
    _verbose = widget.verbose;
    _selectedModeIndex = widget.selectedRuntimeModeIndex;
    _selectedThemeIndex = widget.selectedThemeIndex;
  }

  @override
  void didUpdateWidget(covariant HostDevToolSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRuntimeModeIndex != widget.selectedRuntimeModeIndex) {
      _selectedModeIndex = widget.selectedRuntimeModeIndex;
    }
    if (oldWidget.verbose != widget.verbose) {
      _verbose = widget.verbose;
    }
    if (oldWidget.selectedThemeIndex != widget.selectedThemeIndex) {
      _selectedThemeIndex = widget.selectedThemeIndex;
    }
  }

  /// Palette for the current selection, resolved from [HostDevToolSheet.themeModes].
  ///
  /// Resolving here (instead of taking a fixed palette) means changing the
  /// theme inside the sheet repaints the sheet itself, not just the screen
  /// behind it. The sheet is its own native surface and cannot read the
  /// ambient `HostUiTheme` scope.
  HostUiThemeData _resolveTheme(BuildContext context) {
    if (widget.themeModes.isEmpty) return HostUiThemeData.light;
    var index = _selectedThemeIndex;
    if (index < 0) index = 0;
    if (index >= widget.themeModes.length) {
      index = widget.themeModes.length - 1;
    }
    return resolveHostUiTheme(
      widget.themeModes[index].toLowerCase(),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme(context);
    final isIOS26 =
        Platform.isIOS && _majorVersion(Platform.operatingSystemVersion) >= 26;
    return Container(
      color: !isIOS26 ? theme.background : null,
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
                              style: TextStyle(
                                color: theme.foreground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(left: 10),
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
                          style: TextStyle(
                            color: theme.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GlassEffectContainer(
                    borderRadius: BorderRadius.circular(100),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.xmark_1,
                        color: theme.foreground,
                      ),
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
                      foregroundColor: theme.foreground,
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
                      foregroundColor: theme.foreground,
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
                  color: theme.secondary,
                  borderRadius: theme.radius.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEV SERVER',
                      style: TextStyle(
                        color: theme.mutedForeground,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.serverUrl,
                      style: TextStyle(
                        color: theme.foreground,
                        fontSize: 13,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Runtime mode segment (hidden in single-engine product builds).
              if (widget.runtimeModes.length > 1) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: theme.radius.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RUNTIME MODE',
                            style: TextStyle(
                              color: theme.mutedForeground,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SegmentedControl(
                              segments: widget.runtimeModes,
                              selectedIndex: _selectedModeIndex,
                              onValueChanged: (index) {
                                if (index == _selectedModeIndex) return;
                                setState(() {
                                  _selectedModeIndex = index;
                                });
                                widget.onSelectRuntimeMode?.call(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // AST bundle explorer (shell only).
              if (widget.extraSection != null) ...[
                widget.extraSection!,
                const SizedBox(height: 16),
              ],

              // Theme
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.secondary,
                  borderRadius: theme.radius.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'THEME',
                      style: TextStyle(
                        color: theme.mutedForeground,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SegmentedControl(
                        segments: widget.themeModes,
                        selectedIndex: _selectedThemeIndex,
                        // labelFontStyle: TextStyle(
                        //   color: theme.foreground,
                        // ),
                        // selectedLabelFontStyle: TextStyle(
                        //   color: _selectedThemeIndex == 2 ? theme.background : null,
                        // ),
                        onValueChanged: (index) {
                          if (index == _selectedThemeIndex) return;
                          setState(() {
                            _selectedThemeIndex = index;
                          });
                          widget.onSelectTheme?.call(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dependency Cache
              // if (widget.cacheLabel != null) ...[
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: theme.secondary,
              //       borderRadius: theme.radius.lg,
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'DEPENDENCY CACHE',
              //                 style: TextStyle(
              //                   color: theme.mutedForeground,
              //                   fontSize: 10,
              //                   fontWeight: FontWeight.bold,
              //                   letterSpacing: 0.5,
              //                 ),
              //               ),
              //               const SizedBox(height: 4),
              //               Text(
              //                 _isCacheCleared
              //                     ? '0 B (0 packages)'
              //                     : widget.cacheLabel!,
              //                 style: TextStyle(
              //                   color: theme.foreground,
              //                   fontSize: 13,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         if (!_isCacheCleared)
              //           Button(
              //             child: const Icon(CupertinoIcons.trash_1, size: 20),
              //             variant: ButtonVariant.plain,
              //             padding: EdgeInsets.zero,
              //             foregroundColor: theme.destructive,
              //             onPressed: () async {
              //               widget.onClearCache?.call();
              //               if (mounted) {
              //                 setState(() {
              //                   _isCacheCleared = true;
              //                 });
              //               }
              //             },
              //           ),
              //       ],
              //     ),
              //   ),
              //   const SizedBox(height: 16),
              // ],

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
                    color: theme.secondary,
                    borderRadius: theme.radius.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VERBOSE LOGS',
                              style: TextStyle(
                                color: theme.mutedForeground,
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
                          setState(() {
                            _verbose = v;
                          });
                          widget.onToggleVerbose?.call(v);
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
