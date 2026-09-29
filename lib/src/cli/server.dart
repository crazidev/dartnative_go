import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../runner/logger.dart';
import 'asset_detector.dart';
import 'ast_builder.dart';
import 'broadcaster.dart';
import 'dart_go_version.dart';
import 'dep_packager.dart';
import 'pubspec_validator.dart';
import 'qr_code.dart';

/// Configuration options for launching the DartNative Go server.
class DartGoServerOptions {
  final Directory projectDir;
  final int startPort;
  final int endPort;
  final bool enableBroadcast;
  final bool enableQrCode;
  final String? customHost;

  /// When true (default), Dart file changes trigger an `AstBundle` rebuild
  /// (`assets/bundles/guest.ast`) before the reload broadcast, so AST-mode
  /// clients hot-reload fresh bytes. Unchanged sources skip the analyzer
  /// parse via content fingerprint (millisecond fast path). Disable with
  /// `--no-rebuild-ast` if you only test source mode.
  final bool rebuildAst;
  final bool verbose;

  const DartGoServerOptions({
    required this.projectDir,
    this.startPort = 8088,
    this.endPort = 8098,
    this.enableBroadcast = true,
    this.enableQrCode = true,
    this.customHost,
    this.rebuildAst = true,
    this.verbose = false,
  });
}

/// The core DartNative Go Dev Server runner.
class DartGoServer {
  final DartGoServerOptions options;
  HttpServer? _server;

  /// The port the HTTP/WebSocket server actually bound (null before [start]).
  int? get boundPort => _server?.port;
  DartGoBroadcaster? _broadcaster;
  StreamSubscription? _fileWatchSub;
  StreamSubscription? _assetsWatchSub;
  StreamSubscription? _stdinSub;
  final List<WebSocket> _sockets = [];
  final List<Map<String, dynamic>> _activeBreakpoints = [];
  bool _astRebuildInFlight = false;
  bool _astRebuildQueued = false;
  final Set<String> _pendingDartChanges = {};
  Timer? _codeDebounceTimer;

  DartGoServer(this.options) {
    DartGoLogger.verbose = options.verbose;
  }

  Future<void> start() async {
    final projectDir = options.projectDir;

    // 1. Validate Pubspec & Plugin Compatibility
    final validator = PubspecValidator(projectDir);
    final validation = validator.validate();

    // 2. Detect Project Assets (Icon & Splash)
    final assetDetector = AssetDetector(projectDir);
    final assets = assetDetector.detect();

    // Follow the project in the directory (default to lib/ and lib/main.dart)
    Directory codeDir = Directory('${projectDir.path}/lib');
    File mainFile = File('${projectDir.path}/lib/main.dart');
    if (!codeDir.existsSync() || !mainFile.existsSync()) {
      final guestDir = Directory('${projectDir.path}/guest_app');
      final guestMain = File('${projectDir.path}/guest_app/main.dart');
      if (guestDir.existsSync() && guestMain.existsSync()) {
        codeDir = guestDir;
        mainFile = guestMain;
      }
    }

    if (!mainFile.existsSync()) {
      print('\x1B[31mError: No entrypoint found at lib/main.dart in ${projectDir.path}.\x1B[0m');
      exit(1);
    }

    // 3. Bind HTTP Server across port range
    final (server, port) = await NetworkHelper.bindInRange(
      startPort: options.startPort,
      endPort: options.endPort,
    );
    _server = server;

    final hostStr =
        options.customHost ?? await NetworkHelper.getLocalIp();

    // 4. Start UDP Discovery Broadcaster across port range
    if (options.enableBroadcast) {
      _broadcaster = DartGoBroadcaster(
        appName: validation.appName,
        host: hostStr,
        port: port,
        startPort: options.startPort,
        endPort: options.endPort,
        dartGoVersion: kDartGoVersion,
        hasIcon: assets.hasIcon,
        hasSplash: assets.hasSplash,
      );
      await _broadcaster!.start();
    }

    // 5. Print Startup Diagnostics & Banner
    print('\x1B[2J\x1B[0;0H'); // Clear terminal screen
    print('╔══════════════════════════════════════════════════════════╗');
    print('║            ⚡️ DartNative Go Dev Server ⚡️               ║');
    print('║                 CLI & Runtime v$kDartGoVersion                   ║');
    print('╚══════════════════════════════════════════════════════════╝\n');

    print(validation.formatReport());
    print(assets.formatReport());

    final serverUrl = 'http://$hostStr:$port';
    final wsUrl = 'ws://$hostStr:$port/ws';

    // 6. Display Scannable QR Code
    if (options.enableQrCode) {
      print('📱 \x1B[1mScan with DartNative Go mobile app:\x1B[0m');
      final qr = QrCode(serverUrl);
      print(qr.renderToTerminal());
    }

    print('🌐 Server URL: \x1B[36m$serverUrl\x1B[0m');
    print('⚡️ WebSocket:  \x1B[36m$wsUrl\x1B[0m');
    print(
      options.rebuildAst
          ? '📦 AST auto-build: \x1B[36mon\x1B[0m (guest.ast rebuilt on save; --no-rebuild-ast to disable)\n'
          : '📦 AST auto-build: \x1B[90moff (--no-rebuild-ast)\x1B[0m\n',
    );
    print('\x1B[90mPress h for help\x1B[0m\n');

    // 6b. Initial AST bundle build (background) so `/guest.ast` exists
    // before the first client connects — later saves reuse the watcher.
    if (options.rebuildAst) {
      _initialAstBuild(projectDir);
    }

    // 7. Setup Stdin debugger commands
    _setupStdinListener(serverUrl);

    // 8. Setup File Watchers for Dart code and Assets
    Timer? assetsDebounceTimer;
    if (codeDir.existsSync()) {
      _fileWatchSub = codeDir.watch(recursive: true).listen((event) {
        if (event.path.endsWith('.dart')) {
          _scheduleRebuild(event.path, codeDir, projectDir);
        }
      });
    }

    final assetsDir = Directory('${projectDir.path}/assets');
    if (assetsDir.existsSync()) {
      _assetsWatchSub = assetsDir.watch(recursive: true).listen((event) {
        // guest.ast writes and bundle directory changes are covered by code-change
        // broadcast that triggered the rebuild — ignore to avoid double reloads.
        final p = event.path.replaceAll(r'\', '/');
        if (p.contains('/assets/bundles') || p.endsWith('guest.ast')) return;
        assetsDebounceTimer?.cancel();
        assetsDebounceTimer = Timer(const Duration(milliseconds: 150), () {
          print('[DevServer] 🔄 Asset change detected: ${event.path}. Broadcasting reload...');
          _broadcastReload(event.path, projectDir.path, true);
        });
      });
    }

    // 9. Handle HTTP & WebSocket Requests
    await for (final request in server) {
      _handleHttpRequest(
        request: request,
        projectDir: projectDir,
        codeDir: codeDir,
        mainFile: mainFile,
        assets: assets,
        validation: validation,
        serverUrl: serverUrl,
      );
    }
  }

  /// Initial background build at startup (fire-and-forget).
  ///
  /// Ensures `/guest.ast` is served from the first connection; failures
  /// (e.g. FFI registrants in full native shells) only log — source mode
  /// Initial background build at startup (fire-and-forget).
  ///
  /// Ensures `/guest.ast` is served from the first connection; failures
  /// (e.g. FFI registrants in full native shells) only log — source mode
  /// is unaffected.
  Future<void> _initialAstBuild(Directory projectDir) async {
    try {
      final result = await AstBuildWorker.instance.build(projectDir);
      if (result.success) {
        print(
          '[DevServer] 📦 guest.ast ready '
          '(${result.moduleCount} modules, ${result.byteSize} bytes)',
        );
      } else {
        print(
          '[DevServer] ⚠️ Initial bundle build skipped (${result.error}). '
          'Source hot reload unaffected.',
        );
      }
    } catch (e) {
      print('[DevServer] ⚠️ Initial bundle build error: $e');
    }
  }

  void _scheduleRebuild(
    String changedPath,
    Directory codeDir,
    Directory projectDir,
  ) {
    _pendingDartChanges.add(changedPath);
    _codeDebounceTimer?.cancel();
    _codeDebounceTimer = Timer(const Duration(milliseconds: 120), () {
      if (_astRebuildInFlight) {
        _astRebuildQueued = true;
        return;
      }
      final batch = Set<String>.of(_pendingDartChanges);
      _pendingDartChanges.clear();
      _onCodeChangedBatch(batch, codeDir, projectDir);
    });
  }

  /// Handles a batch of Dart file changes: optionally rebuilds the AST bundle
  /// first (`--rebuild-ast`), then broadcasts a single reload with all changed
  /// files so clients fetch fresh source AND fresh bytes together.
  Future<void> _onCodeChangedBatch(
    Set<String> changedPaths,
    Directory codeDir,
    Directory projectDir,
  ) async {
    if (changedPaths.isEmpty) return;
    final sw = Stopwatch()..start();
    final fileNames = changedPaths.map(p.basename).join(', ');
    DartGoLogger.info('[DevServer] 🔄 File changes (${changedPaths.length}): $fileNames');
    DartGoLogger.debug('Full paths: ${changedPaths.join(', ')}', tag: 'DevServer');

    if (!options.rebuildAst) {
      _broadcastReload(changedPaths, codeDir.path);
      DartGoLogger.bench('DevServer', 'Reload broadcast sent', sw.elapsedMilliseconds);
      return;
    }
    if (_astRebuildInFlight) {
      _pendingDartChanges.addAll(changedPaths);
      _astRebuildQueued = true;
      return;
    }
    _astRebuildInFlight = true;
    var buildOk = false;
    try {
      final astSw = Stopwatch()..start();
      final result = await AstBuildWorker.instance.build(
        projectDir,
        changedFiles: changedPaths,
      );
      astSw.stop();
      buildOk = result.success;
      if (result.success) {
        const artifacts = 'guest.ast';
        if (result.cached) {
          DartGoLogger.bench(
            'DevServer',
            '$artifacts up to date',
            astSw.elapsedMilliseconds,
            {'bytes': result.byteSize, 'cache': 'hit'},
          );
        } else {
          DartGoLogger.bench(
            'DevServer',
            '$artifacts rebuilt',
            astSw.elapsedMilliseconds,
            {
              'modules': result.moduleCount,
              'bytes': result.byteSize,
            },
          );
        }
      } else {
        DartGoLogger.warn(
          'AST rebuild failed in ${astSw.elapsedMilliseconds}ms (${result.error})',
          tag: 'DevServer',
        );
      }
    } finally {
      _astRebuildInFlight = false;
    }
    // A failed build leaves the previous bundle in place, so there is nothing
    // new to fetch: skip the broadcast and let every device keep running its
    // current generation. The warning above (plus the next successful save)
    // is the whole signal.
    if (!buildOk) return;
    _broadcastReload(changedPaths, codeDir.path);
    DartGoLogger.bench(
      'DevServer',
      'Total server reload prep',
      sw.elapsedMilliseconds,
    );
    if (_astRebuildQueued || _pendingDartChanges.isNotEmpty) {
      _astRebuildQueued = false;
      final nextBatch = Set<String>.of(_pendingDartChanges);
      _pendingDartChanges.clear();
      if (nextBatch.isNotEmpty) {
        _onCodeChangedBatch(nextBatch, codeDir, projectDir);
      }
    }
  }

  void _broadcast(Map<String, dynamic> data) {
    final payload = jsonEncode(data);
    for (final ws in _sockets) {
      try {
        ws.add(payload);
      } catch (_) {}
    }
  }

  void _broadcastBreakpoints() {
    _broadcast({
      'type': 'breakpoints',
      'breakpoints': _activeBreakpoints,
    });
  }

  void _broadcastReload([
    Object? changedFilesInput,
    String? baseDir,
    bool isAssetChange = false,
  ]) {
    final relPaths = <String>[];
    if (changedFilesInput is String && changedFilesInput.isNotEmpty) {
      var rel = changedFilesInput;
      if (baseDir != null) {
        rel = rel.replaceFirst('$baseDir/', '').replaceAll(r'\', '/');
      } else {
        rel = rel.replaceAll(r'\', '/');
      }
      relPaths.add(rel);
    } else if (changedFilesInput is Iterable) {
      for (final item in changedFilesInput) {
        if (item is String && item.isNotEmpty) {
          var rel = item;
          if (baseDir != null) {
            rel = rel.replaceFirst('$baseDir/', '').replaceAll(r'\', '/');
          } else {
            rel = rel.replaceAll(r'\', '/');
          }
          relPaths.add(rel);
        }
      }
    }
    final patchBytes = patchBytesForProject(options.projectDir);
    final hasPatch = patchBytes != null && patchBytes.isNotEmpty;
    _broadcast({
      'type': 'reload',
      'changedFile': relPaths.firstOrNull,
      'changedFiles': relPaths,
      'isPatch': hasPatch && !isAssetChange,
      'isAssetChange': isAssetChange,
      'patchUrl': (hasPatch && !isAssetChange) ? '/guest.ast.patch' : null,
      'patchSize': (hasPatch && !isAssetChange) ? patchBytes.length : null,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void _setupStdinListener(String serverUrl) {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = false;
        stdin.echoMode = false;
      }
    } catch (_) {}

    _stdinSub = stdin.listen((bytes) {
      for (final byte in bytes) {
        if (byte == 3) {
          // Ctrl+C
          stop();
          exit(0);
        }

        final char = String.fromCharCode(byte).toLowerCase();
        if (char == 'h') {
          print('\nCommands:');
          print('  h  Help');
          print('  r  Hot reload');
          print('  v  Toggle verbose logging (currently: ${DartGoLogger.verbose ? "on" : "off"})');
          print('  q  Show QR code');
          print('  c  Clear screen\n');
        } else if (char == 'r') {
          print('\n🔄 Triggering manual reload...');
          _broadcastReload();
        } else if (char == 'v') {
          final enabled = DartGoLogger.toggleVerbose();
          _broadcast({'type': 'set_verbose', 'enabled': enabled});
          print('\n📢 Verbose mode: ${enabled ? "\x1B[32mON\x1B[0m (detailed telemetry)" : "\x1B[33mOFF\x1B[0m (clean output)"}\n');
        } else if (char == 'q') {
          print('\n📱 Scan with DartNative Go mobile app:');
          print(QrCode(serverUrl).renderToTerminal());
          print('\x1B[90mPress h for help\x1B[0m\n');
        } else if (char == 'c') {
          print('\x1B[2J\x1B[0;0H');
          print('🌐 Server URL: \x1B[36m$serverUrl\x1B[0m');
          print('⚡️ WebSocket:  \x1B[36m${serverUrl.replaceFirst('http', 'ws')}/ws\x1B[0m\n');
          print('\x1B[90mPress h for help\x1B[0m\n');
        }
      }
    });
  }

  Future<void> _handleHttpRequest({
    required HttpRequest request,
    required Directory projectDir,
    required Directory codeDir,
    required File mainFile,
    required ProjectAssets assets,
    required PubspecValidationResult validation,
    required String serverUrl,
  }) async {
    final path = request.uri.path;

    if (path == '/ws') {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final socket = await WebSocketTransformer.upgrade(request);
        _sockets.add(socket);
        print('[DevServer] 📱 Client connected via WebSocket (${_sockets.length} active)');

        // Send current verbose state and active breakpoints to newly connected client
        socket.add(jsonEncode({
          'type': 'set_verbose',
          'enabled': DartGoLogger.verbose,
        }));

        if (_activeBreakpoints.isNotEmpty) {
          socket.add(jsonEncode({
            'type': 'breakpoints',
            'breakpoints': _activeBreakpoints,
          }));
        }

        socket.listen(
          (message) {
            try {
              final data = jsonDecode(message as String);
              if (data is Map) {
                if (data['type'] == 'log') {
                  final time =
                      DateTime.now().toIso8601String().substring(11, 19);
                  final msg = data['message'] ?? '';
                  final level = data['level'] ?? 'INFO';
                  if (level == 'ERROR') {
                    print('\x1B[31m[$time][Device Error]\x1B[0m $msg');
                  } else {
                    print('\x1B[36m[$time][Device Log]\x1B[0m $msg');
                  }
                  return;
                } else if (data['type'] == 'set_verbose') {
                  final enabled = data['enabled'] == true;
                  DartGoLogger.verbose = enabled;
                  print('\n📢 Verbose mode toggled from app: ${enabled ? "\x1B[32mON\x1B[0m (detailed telemetry)" : "\x1B[33mOFF\x1B[0m (clean output)"}\n');
                  _broadcast({'type': 'set_verbose', 'enabled': enabled});
                  return;
                } else if (data['type'] == 'breakpoint_hit') {
                  final file = data['file'] ?? '<guest>';
                  final line = data['line'] ?? '?';
                  final note = data['message'];
                  final vars = data['variables'] as Map?;

                  print('\n\x1B[31m🛑 BREAKPOINT HIT: $file:$line\x1B[0m');
                  if (note != null) print('   Note: $note');
                  if (vars != null && vars.isNotEmpty) {
                    print('   Variables:');
                    vars.forEach((k, v) => print('     $k = $v'));
                  }
                  print('   👉 Type c to resume execution.\n');
                  return;
                } else if (data['type'] == 'reload' &&
                    data['origin'] == 'test') {
                  // UI automation: a test script without filesystem access
                  // asks for a reload. Only `origin: test` messages are
                  // relayed — device reloads originate server-side, so this
                  // cannot loop back.
                  print('[DevServer] 📲 Test-triggered reload requested');
                  _broadcastReload(
                    data['changedFile']?.toString(),
                    options.projectDir.path,
                  );
                  return;
                } else if (data['type'] == 'restart' &&
                    data['origin'] == 'test') {
                  // UI automation: a test script asks for a full restart
                  // (fresh interpreter, e.g. before a scenario). Same
                  // loop-safety as the test reload above.
                  print('[DevServer] 📲 Test-triggered restart requested');
                  _broadcast({
                    'type': 'restart',
                    'origin': 'test',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  });
                  return;
                } else if (data['type'] == 'ui_probe_request' ||
                    data['type'] == 'ui_tap' ||
                    data['type'] == 'ui_hover' ||
                    data['type'] == 'ui_focus' ||
                    data['type'] == 'ui_blur' ||
                    data['type'] == 'ui_submit' ||
                    data['type'] == 'ui_type' ||
                    data['type'] == 'ui_scroll') {
                  // UI automation: a test script drives the connected
                  // device(s) — probe, tap, hover, focus, blur, submit, type, scroll.
                  // Relay to everyone; the device answers with `ui_tree` /
                  // `*_result` messages handled below.
                  _broadcast(Map<String, dynamic>.from(data));
                  return;
                } else if (data['type'] == 'ui_tree') {
                  final req = data['requestId'] ?? '?';
                  print('[DevServer] 📲 UI tree received (request $req)');
                  _broadcast(Map<String, dynamic>.from(data));
                  return;
                } else if (data['type'] == 'ui_tap_result' ||
                    data['type'] == 'ui_hover_result' ||
                    data['type'] == 'ui_focus_result' ||
                    data['type'] == 'ui_blur_result' ||
                    data['type'] == 'ui_submit_result' ||
                    data['type'] == 'ui_type_result' ||
                    data['type'] == 'ui_scroll_result') {
                  final req = data['requestId'] ?? '?';
                  final action = (data['type'] as String)
                      .replaceFirst('ui_', '')
                      .replaceFirst('_result', '');
                  final ok = data['ok'] == true;
                  final err = data['error'];
                  final view = data['viewId'];
                  if (ok) {
                    print('[DevServer] 📲 UI $action ok (request $req'
                        '${view != null ? ', view $view' : ''})');
                  } else {
                    print('[DevServer] 📲 UI $action FAILED (request $req): $err');
                  }
                  _broadcast(Map<String, dynamic>.from(data));
                  return;
                }
              }
            } catch (_) {}
          },
          onDone: () {
            _sockets.remove(socket);
            print('[DevServer] 📱 Client disconnected (${_sockets.length} active)');
          },
          onError: (_) {
            _sockets.remove(socket);
          },
        );
      } else {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Expected WebSocket upgrade')
          ..close();
      }
    } else if (path == '/manifest.json') {
      final depResult = DepPackager.resolveAndPack(
        projectDir,
        serverUrl,
        packageName: validation.appName,
      );
      final userCode = DepPackager.packUserCode(
        codeDir,
        packageName: validation.appName,
      );
      final astFile = _resolveAstBundleFile(projectDir);
      final manifest = {
        'protocol': 'dart_go',
        'appName': validation.appName,
        'packageName': validation.appName,
        'appVersion': validation.appVersion,
        'dartGoVersion': kDartGoVersion,
        'runtimeVersion': kDartGoRuntimeVersion,
        'serverUrl': serverUrl,
        'depMode': true,
        'depsHash': depResult.depsHash,
        'depsCount': depResult.deps.length,
        'depsUrl': '$serverUrl/deps.json',
        'userCodeUrl': '$serverUrl/user-code.zip',
        'userCodeHash': userCode.hash,
        'hasIcon': assets.hasIcon,
        'iconUrl': assets.hasIcon ? '$serverUrl/assets/icon.png' : null,
        'hasSplash': assets.hasSplash,
        'splashUrl': assets.hasSplash ? '$serverUrl/assets/splash.png' : null,
        'splashBackgroundColor': assets.splashBackgroundColor,
        'assets': _collectProjectAssets(projectDir),
        'hasAstBundle': astFile != null,
        'astUrl': astFile != null ? '$serverUrl/guest.ast' : null,
        'astModuleFingerprints': astFile != null
            ? moduleFingerprintsForProject(projectDir)
            : const <String, String>{},
        'supportedPlugins': validation.validSupportedPlugins,
        'unsupportedPlugins': validation.unsupportedNativePlugins,
        'versionMismatches': validation.versionMismatches
            .map((m) => {
                  'plugin': m.pluginName,
                  'declared': m.declaredConstraint,
                  'required': m.requiredConstraint,
                })
            .toList(),
      };
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(jsonEncode(manifest))
        ..close();
    } else if (path == '/deps.json') {
      final depResult = DepPackager.resolveAndPack(
        projectDir,
        serverUrl,
        packageName: validation.appName,
      );
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(jsonEncode({
          'depsHash': depResult.depsHash,
          'deps': depResult.deps.map((e) => e.toJson()).toList(),
        }))
        ..close();
    } else if (path.startsWith('/pkg/') && path.endsWith('.zip')) {
      final pkgKey = path.substring(5, path.length - 4); // <name>@<version>
      final depResult = DepPackager.resolveAndPack(
        projectDir,
        serverUrl,
        packageName: validation.appName,
      );
      final zipBytes = depResult.packageZips[pkgKey];
      if (zipBytes != null) {
        request.response
          ..headers.contentType = ContentType('application', 'zip')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Cache-Control', 'public, max-age=31536000')
          ..add(zipBytes)
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Package zip not found: $pkgKey')
          ..close();
      }
    } else if (path == '/user-code.zip') {
      final userCode = DepPackager.packUserCode(
        codeDir,
        packageName: validation.appName,
      );
      request.response
        ..headers.contentType = ContentType('application', 'zip')
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..add(userCode.bytes)
        ..close();
    } else if (path == '/user-code-hash') {
      final userCode = DepPackager.packUserCode(
        codeDir,
        packageName: validation.appName,
      );
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(jsonEncode({'hash': userCode.hash}))
        ..close();
    } else if (path == '/assets.json') {
      final projectAssets = _collectProjectAssets(projectDir);
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(jsonEncode({'assets': projectAssets}))
        ..close();
    } else if (path == '/assets/icon.png' || path == '/icon.png') {
      if (assets.hasIcon) {
        await _serveAssetFile(request, assets.iconFile!);
      } else {
        final resolved = _resolveAssetFile(projectDir, path);
        if (resolved != null) {
          await _serveAssetFile(request, resolved);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..headers.add('Access-Control-Allow-Origin', '*')
            ..write('No custom app icon found')
            ..close();
        }
      }
    } else if (path == '/assets/splash.png' || path == '/splash.png') {
      if (assets.hasSplash) {
        await _serveAssetFile(request, assets.splashFile!);
      } else {
        final resolved = _resolveAssetFile(projectDir, path);
        if (resolved != null) {
          await _serveAssetFile(request, resolved);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..headers.add('Access-Control-Allow-Origin', '*')
            ..write('No custom splash image found')
            ..close();
        }
      }
    } else if (path.startsWith('/assets/') || path == '/asset') {
      final assetPath =
          path == '/asset' ? (request.uri.queryParameters['path'] ?? '') : path;
      final file = _resolveAssetFile(projectDir, assetPath);
      if (file != null) {
        await _serveAssetFile(request, file);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Asset not found: $assetPath')
          ..close();
      }
    } else if (path == '/bundle.json') {
      try {
        final bundle = <String, String>{};
        if (codeDir.existsSync()) {
          await for (final entity in codeDir.list(recursive: true)) {
            if (entity is File && entity.path.endsWith('.dart')) {
              final relPath = entity.path
                  .replaceFirst('${codeDir.path}/', '')
                  .replaceAll(r'\', '/');
              bundle[relPath] = await entity.readAsString();
            }
          }
        }
        final depResult = DepPackager.resolveAndPack(
          projectDir,
          serverUrl,
          packageName: validation.appName,
        );
        final userCode = DepPackager.packUserCode(
          codeDir,
          packageName: validation.appName,
        );
        final projectAssets = _collectProjectAssets(projectDir);
        final jsonStr = jsonEncode({
          'manifest': {
            'appName': validation.appName,
            'packageName': validation.appName,
            'appVersion': validation.appVersion,
            'dartGoVersion': kDartGoVersion,
            'depMode': true,
            'depsHash': depResult.depsHash,
            'depsCount': depResult.deps.length,
            'userCodeHash': userCode.hash,
            'splashBackgroundColor': assets.splashBackgroundColor,
            'iconUrl': assets.hasIcon ? '$serverUrl/assets/icon.png' : null,
            'splashUrl':
                assets.hasSplash ? '$serverUrl/assets/splash.png' : null,
            'assets': projectAssets,
          },
          'deps': depResult.deps.map((e) => e.toJson()).toList(),
          'assets': projectAssets,
          'files': bundle,
          'breakpoints': _activeBreakpoints,
        });
        request.response
          ..headers.contentType = ContentType.json
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Cache-Control', 'no-cache')
          ..write(jsonStr)
          ..close();
        print('[DevServer] 📦 Served bundle.json (${bundle.length} user files, ${depResult.deps.length} deps)');
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Error reading bundle: $e')
          ..close();
      }
    } else if (path == '/guest.ast') {
      // Pre-compiled AST bundle (tom_ast_generator output).
      // Built via `dart run tool/build_ast_bundle.dart`.
      // 404 when absent — client stays on source mode.
      final astFile = _resolveAstBundleFile(projectDir);
      if (astFile != null) {
        final fp = astBundleFingerprintForProject(projectDir, astFile);
        final etag = '"$fp"';
        final clientEtag =
            request.headers.value(HttpHeaders.ifNoneMatchHeader)?.trim();
        if (clientEtag != null &&
            (clientEtag == etag ||
                clientEtag == fp ||
                clientEtag == 'W/$etag' ||
                clientEtag == 'W/"$fp"')) {
          request.response.statusCode = HttpStatus.notModified;
          request.response.headers.set(HttpHeaders.etagHeader, etag);
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          request.response.headers.set('Access-Control-Expose-Headers', 'ETag');
          await request.response.close();
          return;
        }
        await _serveAssetFile(request, astFile, etag: etag);
        print(
          '[DevServer] 📦 Served guest.ast (${await astFile.length()} bytes, etag=$etag)',
        );
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(
            'No AST bundle. Run `dart run tool/build_ast_bundle.dart` '
            'once tom_ast_generator is available.',
          )
          ..close();
      }
    } else if (path == '/guest.ast.patch') {
      final patchBytes = patchBytesForProject(projectDir);
      if (patchBytes != null && patchBytes.isNotEmpty) {
        final astFile = _resolveAstBundleFile(projectDir);
        final fp = astFile != null
            ? astBundleFingerprintForProject(projectDir, astFile)
            : '${DateTime.now().millisecondsSinceEpoch}';
        final etag = '"$fp-patch"';
        final clientEtag =
            request.headers.value(HttpHeaders.ifNoneMatchHeader)?.trim();
        if (clientEtag != null &&
            (clientEtag == etag ||
                clientEtag == '$fp-patch' ||
                clientEtag == 'W/$etag' ||
                clientEtag == 'W/"$fp-patch"')) {
          request.response.statusCode = HttpStatus.notModified;
          request.response.headers.set(HttpHeaders.etagHeader, etag);
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          request.response.headers.set('Access-Control-Expose-Headers', 'ETag');
          await request.response.close();
          return;
        }
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType('application', 'octet-stream')
          ..headers.set(HttpHeaders.contentLengthHeader, patchBytes.length)
          ..headers.set(HttpHeaders.etagHeader, etag)
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Access-Control-Expose-Headers', 'ETag')
          ..add(patchBytes);
        await request.response.close();
        print(
          '[DevServer] ⚡️ Served guest.ast.patch (${patchBytes.length} bytes, etag=$etag)',
        );
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('No active AST patch available; fetch full /guest.ast.')
          ..close();
      }
    } else if (path == '/app.dart') {
      try {
        final content = await mainFile.readAsString();
        request.response
          ..headers.contentType =
              ContentType('application', 'dart', charset: 'utf-8')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(content)
          ..close();
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Error reading entrypoint: $e')
          ..close();
      }
    } else if (path == '/breakpoints') {
      if (request.method == 'GET') {
        request.response
          ..headers.contentType = ContentType.json
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(jsonEncode(_activeBreakpoints))
          ..close();
      } else if (request.method == 'POST') {
        final body = await utf8.decodeStream(request);
        try {
          final data = jsonDecode(body);
          if (data is Map && data['file'] != null && data['line'] != null) {
            _activeBreakpoints.add({
              'file': data['file'].toString(),
              'line': data['line'] is int
                  ? data['line']
                  : int.parse(data['line'].toString()),
            });
            _broadcastBreakpoints();
            _broadcastReload();
            request.response
              ..headers.contentType = ContentType.json
              ..write(jsonEncode({'status': 'ok'}))
              ..close();
          } else {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..write('Invalid payload')
              ..close();
          }
        } catch (e) {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('Error parsing JSON: $e')
            ..close();
        }
      }
    } else if (path == '/resume' && request.method == 'POST') {
      _broadcast({'type': 'resume'});
      print('[DevServer] ▶️ Resumed execution via HTTP /resume');
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(jsonEncode({'status': 'resumed'}))
        ..close();
    } else if (path == '/health' || path == '/dart_go/discover') {
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(jsonEncode({
          'status': 'ok',
          'protocol': 'dart_go',
          'appName': validation.appName,
          'version': kDartGoVersion,
          'clients': _sockets.length,
          'hasIcon': assets.hasIcon,
          'hasSplash': assets.hasSplash,
        }))
        ..close();
    } else {
      // Fallback: check if requested path points to any project asset
      final maybeAsset = _resolveAssetFile(projectDir, path);
      if (maybeAsset != null) {
        await _serveAssetFile(request, maybeAsset);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('404 Not Found')
          ..close();
      }
    }
  }

  /// Collects relative paths for all assets in [projectDir]/assets.
  static List<String> _collectProjectAssets(Directory projectDir) {
    final assetsDir = Directory('${projectDir.path}/assets');
    if (!assetsDir.existsSync()) return const [];
    final results = <String>[];
    try {
      for (final entity in assetsDir.listSync(recursive: true)) {
        if (entity is File) {
          final rel = entity.path
              .replaceFirst('${projectDir.path}/', '')
              .replaceAll(r'\', '/');
          results.add(rel);
        }
      }
    } catch (_) {}
    results.sort();
    return results;
  }

  /// Locates a pre-compiled AST bundle if `tool/build_ast_bundle.dart` ran.
  ///
  /// Checks `assets/bundles/guest.ast` then `build/guest.ast` (traversal-safe).
  static File? _resolveAstBundleFile(Directory projectDir) {
    const candidates = [
      'assets/bundles/guest.ast',
      'build/guest.ast',
    ];
    try {
      final canonicalProject = projectDir.resolveSymbolicLinksSync();
      for (final rel in candidates) {
        final file = File('${projectDir.path}/$rel');
        if (file.existsSync()) {
          final canonicalFile = file.resolveSymbolicLinksSync();
          if (canonicalFile.startsWith(canonicalProject)) return file;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Resolves an asset request path to a concrete [File] inside [projectDir].
  static File? _resolveAssetFile(
    Directory projectDir,
    String path, {
    String? queryPath,
  }) {
    String cleanPath = queryPath ?? path;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    cleanPath = Uri.decodeComponent(cleanPath).replaceAll(r'\', '/');

    // Prevent directory traversal attacks
    if (cleanPath.contains('..') || cleanPath.isEmpty) return null;

    final candidates = <String>[];

    // 1. Direct path from projectDir (e.g. assets/dn-logo.png)
    candidates.add('${projectDir.path}/$cleanPath');

    // 2. Under assets/ folder if path doesn't already start with assets/
    if (!cleanPath.startsWith('assets/')) {
      candidates.add('${projectDir.path}/assets/$cleanPath');
    }

    // 3. If path starts with assets/, also check without 'assets/' prefix
    if (cleanPath.startsWith('assets/')) {
      final stripped = cleanPath.substring('assets/'.length);
      candidates.add('${projectDir.path}/$stripped');
      candidates.add('${projectDir.path}/assets/$stripped');
    }

    try {
      final canonicalProject = projectDir.resolveSymbolicLinksSync();
      for (final candidate in candidates) {
        final file = File(candidate);
        if (file.existsSync()) {
          final canonicalFile = file.resolveSymbolicLinksSync();
          if (canonicalFile.startsWith(canonicalProject)) {
            return file;
          }
        }
      }
    } catch (_) {}

    return null;
  }

  /// Returns appropriate ContentType based on file extension.
  static ContentType _getContentTypeForFile(String path) {
    final lastDot = path.lastIndexOf('.');
    final ext = lastDot != -1 ? path.substring(lastDot + 1).toLowerCase() : '';
    switch (ext) {
      case 'png':
        return ContentType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return ContentType('image', 'jpeg');
      case 'gif':
        return ContentType('image', 'gif');
      case 'webp':
        return ContentType('image', 'webp');
      case 'svg':
        return ContentType('image', 'svg+xml');
      case 'ico':
        return ContentType('image', 'x-icon');
      case 'bmp':
        return ContentType('image', 'bmp');
      case 'json':
        return ContentType.json;
      case 'ttf':
        return ContentType('font', 'ttf');
      case 'otf':
        return ContentType('font', 'otf');
      case 'woff':
        return ContentType('font', 'woff');
      case 'woff2':
        return ContentType('font', 'woff2');
      case 'mp3':
        return ContentType('audio', 'mpeg');
      case 'wav':
        return ContentType('audio', 'wav');
      case 'ogg':
        return ContentType('audio', 'ogg');
      case 'mp4':
        return ContentType('video', 'mp4');
      case 'webm':
        return ContentType('video', 'webm');
      case 'txt':
        return ContentType('text', 'plain', charset: 'utf-8');
      case 'html':
      case 'htm':
        return ContentType('text', 'html', charset: 'utf-8');
      case 'css':
        return ContentType('text', 'css', charset: 'utf-8');
      case 'js':
        return ContentType('application', 'javascript', charset: 'utf-8');
      case 'pdf':
        return ContentType('application', 'pdf');
      default:
        return ContentType('application', 'octet-stream');
    }
  }

  /// Streams the asset file to the HTTP response with CORS and cache headers.
  static Future<void> _serveAssetFile(
    HttpRequest request,
    File file, {
    String? etag,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final contentType = _getContentTypeForFile(file.path);
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = contentType
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache');
      if (etag != null) {
        request.response.headers.set(HttpHeaders.etagHeader, etag);
        request.response.headers.set('Access-Control-Expose-Headers', 'ETag');
      }
      request.response
        ..headers.contentLength = bytes.length
        ..add(bytes)
        ..close();
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write('Error reading asset: $e')
        ..close();
    }
  }

  void stop() {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = true;
        stdin.echoMode = true;
      }
    } catch (_) {}
    _broadcaster?.stop();
    _codeDebounceTimer?.cancel();
    _codeDebounceTimer = null;
    _pendingDartChanges.clear();
    _fileWatchSub?.cancel();
    _assetsWatchSub?.cancel();
    _stdinSub?.cancel();
    for (final ws in _sockets) {
      try {
        ws.close();
      } catch (_) {}
    }
    AstBuildWorker.instance.stop();
    _server?.close(force: true);
  }
}
