import 'dart:async';
import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart';

import '../interpreter/asset_bridge.dart';
import '../interpreter/auto_import_parser.dart';
import '../interpreter/d4rt_flutter_application.dart';
import '../interpreter/dartnative_share_bridges.b.dart';
import '../interpreter/dartnative_webview_bridges.b.dart';
import '../interpreter/debug_controller.dart';
import '../interpreter/dn_bridge.dart';

/// Manages dynamic execution of DartNative guest apps using tom_d4rt.
class InterpreterRunner {
  late D4rt _interpreter;
  final DebugController _debugController = DebugController();

  Widget? _capturedApp;
  D4rtFlutterApplication? _activeApplication;
  String? currentServerUrl;
  void Function(String message)? onLog;
  VoidCallback? onExit;

  DebugController get debugController => _debugController;
  D4rt get interpreter => _interpreter;

  InterpreterRunner({this.onLog, this.onExit, this.currentServerUrl}) {
    initInterpreter();
  }

  /// Initializes a fresh interpreter session with all registered bridges and runtime hooks.
  void initInterpreter() {
    _capturedApp = null;
    _interpreter = D4rt();
    _debugController.activeInterpreter = _interpreter;
    _debugController.onLog = onLog;

    // Grant permissions so guest apps can load dart:io and network resources
    _interpreter.grant(FilesystemPermission.any);
    _interpreter.grant(NetworkPermission.any);
    _interpreter.grant(ProcessRunPermission.any);
    _interpreter.grant(IsolatePermission.any);
    _interpreter.grant(DangerousPermission.any);

    // 1. Core DartNative framework bridges + proxies
    registerDartNativeBridges(_interpreter, onLog: onLog);
    registerAssetAwareBridges(_interpreter, serverUrlProvider: () => currentServerUrl);
    AssetResolver.activeServerUrl = currentServerUrl;

    // 2. Plugins bridges
    try {
      DartnativeShareBridge.registerBridges(
        _interpreter,
        'package:dartnative_share/dartnative_share.dart',
      );
    } catch (_) {}

    try {
      DartnativeWebviewBridge.registerBridges(
        _interpreter,
        'package:dartnative_webview/dartnative_webview.dart',
      );
    } catch (_) {}

    // 3. Intercept runApp(...) so standard entrypoints (void main() { runApp(App()); }) work
    void captureRunApp(visitor, positional, named, typeArgs) {
      if (positional.isNotEmpty) {
        _capturedApp = unwrap<Widget>(positional[0], visitor: visitor);
      }
    }

    for (final lib in [
      'package:dartnative/dartnative.dart',
      'package:dartnative/src/framework.dart',
      'package:flutter/widgets.dart',
      'package:flutter/material.dart',
    ]) {
      _interpreter.registertopLevelFunction(
        'runApp',
        captureRunApp,
        lib,
        signature: 'void runApp(Widget app)',
      );
    }

    // 4. Intercept registerNativeBindings so guest app calling DartNativePluginRegistrant.registerAll()
    // does not fail or attempt to re-register native host bindings
    _interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );
    _interpreter.registertopLevelFunction(
      'registerNativeBindings',
      (visitor, positional, named, typeArgs) {
        return null;
      },
      'package:dartnative/src/framework.dart',
      signature: 'void registerNativeBindings(dynamic bindings)',
    );

    // 4. Intercept exitToLauncher()
    _interpreter.registertopLevelFunction(
      'exitToLauncher',
      (visitor, positional, named, typeArgs) {
        onExit?.call();
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void exitToLauncher()',
    );

    // 4b. Register unawaited() from dart:async — fire-and-forget, discards
    // the future's result. Without this the interpreter falls back to a
    // "default bridged constructor" adapter which always returns null and
    // throws a runtime error.
    void registerUnawaited(String library) {
      _interpreter.registertopLevelFunction(
        'unawaited',
        (visitor, positional, named, typeArgs) {
          final arg = positional.isNotEmpty ? positional[0] : null;
          if (arg is Future) {
            arg.ignore();
          }
          return null;
        },
        library,
        signature: 'void unawaited(Future<void> future)',
      );
    }

    for (final lib in [
      'dart:async',
      'package:dartnative/dartnative.dart',
      'package:dartnative/src/framework.dart',
    ]) {
      registerUnawaited(lib);
    }

    // 5. Debugger and Breakpoint hooks
    _interpreter.registertopLevelFunction(
      'debugger',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty ? positional[0]?.toString() : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> debugger([String? message])',
    );

    _interpreter.registertopLevelFunction(
      'breakpoint',
      (visitor, positional, named, typeArgs) {
        final message = positional.isNotEmpty ? positional[0]?.toString() : null;
        return _debugController.handleDebuggerCall(message);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> breakpoint([String? message])',
    );

    _interpreter.registertopLevelFunction(
      '__debugBreakpoint',
      (visitor, positional, named, typeArgs) {
        final file = positional.isNotEmpty ? positional[0]?.toString() ?? '<unknown>' : '<unknown>';
        final line = positional.length > 1 && positional[1] is int
            ? positional[1] as int
            : int.tryParse(positional.length > 1 ? positional[1].toString() : '') ?? 0;
        return _debugController.handleLineBreakpoint(file, line);
      },
      'package:dartnative/dartnative.dart',
      signature: 'Future<void> __debugBreakpoint(String file, int line)',
    );

    // 6. D4rtFlutterApplication wrapper hook
    _interpreter.registertopLevelFunction(
      'D4rtFlutterApplication',
      (visitor, positional, named, typeArgs) {
        final rootWidget = unwrap<Widget>(named['root'], visitor: visitor);
        return D4rtFlutterApplication(
          root: rootWidget ??
              const Scaffold(
                body: Center(child: Text('Empty D4rtFlutterApplication root')),
              ),
          onMount: named['onMount'] != null
              ? () => D4.callInterpreterCallback(visitor, named['onMount'], [])
              : null,
          onUnmount: named['onUnmount'] != null
              ? () => D4.callInterpreterCallback(visitor, named['onUnmount'], [])
              : null,
        );
      },
      'package:dartnative/dartnative.dart',
      signature:
          'D4rtFlutterApplication({required Widget root, Function? onMount, Function? onUnmount})',
    );
  }

  /// Evaluates guest code from [source] and resolves the root [Widget].
  Future<Widget> evaluate({
    required String source,
    required String library,
    Map<String, String>? sources,
    bool isHotReload = false,
  }) async {
    if (isHotReload) {
      try {
        _interpreter.dispose();
      } catch (_) {}
      initInterpreter();
    }

    _capturedApp = null;
    final processedScript = AutoImportParser.processAndAutoImport(
      source,
      currentFilePath: library,
      projectFiles: sources,
    );

    Object? rawResult = runZoned(
      () => _interpreter.execute(
        source: processedScript,
        name: 'main',
        library: library,
        sources: sources,
      ),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          onLog?.call(line);
        },
      ),
    );

    if (rawResult is Future) {
      rawResult = await rawResult;
    }

    if (rawResult is D4rtFlutterApplication) {
      _activeApplication = rawResult;
      try {
        rawResult.onMount?.call();
      } catch (_) {}
    }

    Widget? resolvedWidget = _capturedApp ??
        unwrap<Widget>(rawResult, visitor: _interpreter.visitor);

    if (resolvedWidget == null) {
      throw StateError(
        'Evaluation succeeded, but could not resolve a Widget from the entrypoint ($rawResult).\n'
        'Ensure your main() calls runApp(Widget) or returns a Widget.',
      );
    }

    return resolvedWidget;
  }

  /// Cleanly unmounts the active guest app.
  void unmount() {
    try {
      _activeApplication?.onUnmount?.call();
    } catch (_) {}
    _activeApplication = null;
    _capturedApp = null;
    try {
      _interpreter.dispose();
    } catch (_) {}
  }
}
