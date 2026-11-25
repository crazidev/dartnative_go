import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dngo_api/dngo_api.dart';
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

  /// Label for the secondary (left) action. Defaults to `Go Home`.
  final String secondaryActionTitle;

  /// Label for the primary (right) action. Defaults to `Reload`.
  final String primaryActionTitle;

  /// When true, the secondary action is a destructive trash icon instead of
  /// [secondaryActionTitle] (used by the project long-press sheet).
  final bool secondaryActionIsRemove;

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
    this.secondaryActionTitle = 'Go Home',
    this.primaryActionTitle = 'Reload',
    this.secondaryActionIsRemove = false,
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

  /// Live Connected/Offline badge. Kept in state so an open sheet (its own
  /// native DNTree) can flip when the host socket drops or reconnects without
  /// waiting for the parent builder to run again.
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _verbose = widget.verbose;
    _selectedModeIndex = widget.selectedRuntimeModeIndex;
    _selectedThemeIndex = widget.selectedThemeIndex;
    _isConnected = widget.isConnected;
    try {
      DartGoHost.addListener(_syncConnectionFromHost);
      _isConnected = DartGoHost.isConnected;
    } catch (_) {}
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
    if (oldWidget.isConnected != widget.isConnected) {
      _isConnected = widget.isConnected;
    }
  }

  @override
  void dispose() {
    try {
      DartGoHost.removeListener(_syncConnectionFromHost);
    } catch (_) {}
    super.dispose();
  }

  void _syncConnectionFromHost() {
    if (!mounted) return;
    try {
      final next = DartGoHost.isConnected;
      if (next == _isConnected) return;
      setState(() => _isConnected = next);
    } catch (_) {}
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
          padding: const EdgeInsets.fromLTRB(12, 15, 12, 20),
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
                                color: _isConnected
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
                                      color: _isConnected
                                          ? const Color(0xFF34C759)
                                          : const Color(0xFFFF9500),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isConnected ? 'Connected' : 'Offline',
                                    style: TextStyle(
                                      color: _isConnected
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

              // Action buttons (Go Home / Reload, or Remove / Open Project)
              Row(
                children: [
                  if (widget.secondaryActionIsRemove)
                    Button(
                      variant: ButtonVariant.tinted,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: theme.destructive,
                      onPressed: () {
                        widget.controller.dismiss();
                        widget.onGoHome();
                      },
                      child: Icon(
                        CupertinoIcons.trash_1,
                        size: 20,
                        color: theme.destructive,
                      ),
                    )
                  else
                    Expanded(
                      child: Button(
                        title: widget.secondaryActionTitle,
                        variant: ButtonVariant.bordered,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
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
                      title: widget.primaryActionTitle,
                      variant: ButtonVariant.prominentGlass,
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

              DevToolContainers(
                children: [
                  // Server URL details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DEV SERVER',
                        style: TextStyle(
                          // color: theme.mutedForeground,
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

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'SHELL VERSIONS',
                  //       style: TextStyle(
                  //         color: theme.mutedForeground,
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.bold,
                  //         letterSpacing: 0.5,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 4),
                  //     Text(
                  //       'dngo v${DartGoHost.dngoVersion}  ·  '
                  //       'DartNative v${DartGoHost.dartNativeVersion}  ·  '
                  //       'runtime v${DartGoHost.runtimeVersion}',
                  //       style: TextStyle(
                  //         color: theme.foreground,
                  //         fontSize: 12,
                  //         fontFamily: 'Courier',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  if (widget.runtimeModes.length > 1) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'RUNTIME MODE',
                              style: TextStyle(
                                // color: theme.mutedForeground,
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
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'THEME',
                        style: TextStyle(
                          // color: theme.mutedForeground,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: SegmentedControl(
                          segments: widget.themeModes,
                          selectedIndex: _selectedThemeIndex,
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

                  // Dependency Cache
                  // if (widget.cacheLabel != null) ...[
                  //   Row(
                  //     children: [
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               'DEPENDENCY CACHE',
                  //               style: TextStyle(
                  //                 color: theme.mutedForeground,
                  //                 fontSize: 10,
                  //                 fontWeight: FontWeight.bold,
                  //                 letterSpacing: 0.5,
                  //               ),
                  //             ),
                  //             const SizedBox(height: 4),
                  //             Text(
                  //               _isCacheCleared
                  //                   ? '0 B (0 packages)'
                  //                   : widget.cacheLabel!,
                  //               style: TextStyle(
                  //                 color: theme.foreground,
                  //                 fontSize: 13,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       if (!_isCacheCleared)
                  //         Button(
                  //           child: const Icon(
                  //             CupertinoIcons.trash_fill,
                  //             size: 20,
                  //           ),
                  //           variant: ButtonVariant.plain,
                  //           padding: EdgeInsets.zero,
                  //           foregroundColor: theme.destructive,
                  //           onPressed: () async {
                  //             widget.onClearCache?.call();
                  //             if (mounted) {
                  //               setState(() {
                  //                 _isCacheCleared = true;
                  //               });
                  //             }
                  //           },
                  //         ),
                  //     ],
                  //   ),
                  // ],
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VERBOSE LOGS',
                              style: TextStyle(
                                // color: theme.mutedForeground,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: Switch(
                          value: _verbose,
                          android: AndroidSwitchStyle(checkIcon: true),
                          onChanged: (v) {
                            setState(() {
                              _verbose = v;
                            });
                            widget.onToggleVerbose?.call(v);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 50),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        // Text(
                        //   "SDK",
                        //   style: TextStyle(
                        //     color: theme.mutedForeground,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //     letterSpacing: 0.5,
                        //   ),
                        // ),
                        // Text(DartGoHost.dngoVersion),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 16),
              // DevToolContainers(
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'DARTNATIVE',
              //                 style: TextStyle(
              //                   color: theme.mutedForeground,
              //                   fontSize: 10,
              //                   fontWeight: FontWeight.bold,
              //                   letterSpacing: 0.5,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),

              //         Text(
              //           DartGoHost.dartNativeVersion,
              //           style: TextStyle(
              //             color: theme.foreground,
              //             fontSize: 13,
              //             fontFamily: 'Courier',
              //           ),
              //         ),
              //       ],
              //     ),

              //     Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'GO CLIENT',
              //                 style: TextStyle(
              //                   color: theme.mutedForeground,
              //                   fontSize: 10,
              //                   fontWeight: FontWeight.bold,
              //                   letterSpacing: 0.5,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),

              //         Text(
              //           'SDK ${DartGoHost.runtimeVersion}',
              //           style: TextStyle(
              //             color: theme.foreground,
              //             fontSize: 13,
              //             fontFamily: 'Courier',
              //           ),
              //         ),
              //       ],
              //     ),

              //     // if (widget.extraSection != null) ...[
              //     //   widget.extraSection!,
              //     //   const SizedBox(height: 16),
              //     // ],
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevToolContainers extends StatelessWidget {
  const DevToolContainers({super.key, required this.children});

  final List<Widget> children;

  Widget buildChild(BuildContext context, Widget child) {
    var isFirst = children.indexOf(child) == 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isFirst) ...[
          Divider(color: context.theme.border, thickness: 2),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            bottom: 7,
            top: 7,
            left: 14,
            right: 14,
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.theme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: children.map((child) => buildChild(context, child)).toList(),
      ),
    );
  }
}
