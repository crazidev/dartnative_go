import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'asset_detector.dart';
import 'broadcaster.dart';
import 'dart_go_version.dart';
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

  const DartGoServerOptions({
    required this.projectDir,
    this.startPort = 8088,
    this.endPort = 8098,
    this.enableBroadcast = true,
    this.enableQrCode = true,
    this.customHost,
  });
}

/// The core DartNative Go Dev Server runner.
class DartGoServer {
  final DartGoServerOptions options;
  HttpServer? _server;
  DartGoBroadcaster? _broadcaster;
  StreamSubscription? _fileWatchSub;
  StreamSubscription? _assetsWatchSub;
  StreamSubscription? _stdinSub;
  final List<WebSocket> _sockets = [];
  final List<Map<String, dynamic>> _activeBreakpoints = [];

  DartGoServer(this.options);

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
    print('⚡️ WebSocket:  \x1B[36m$wsUrl\x1B[0m\n');
    print('\x1B[90mPress h for help\x1B[0m\n');

    // 7. Setup Stdin debugger commands
    _setupStdinListener(serverUrl);

    // 8. Setup File Watchers for Dart code and Assets
    Timer? debounceTimer;
    if (codeDir.existsSync()) {
      _fileWatchSub = codeDir.watch(recursive: true).listen((event) {
        if (event.path.endsWith('.dart')) {
          debounceTimer?.cancel();
          debounceTimer = Timer(const Duration(milliseconds: 150), () {
            print('[DevServer] 🔄 File change detected: ${event.path}. Broadcasting reload...');
            _broadcastReload(event.path, codeDir.path);
          });
        }
      });
    }

    final assetsDir = Directory('${projectDir.path}/assets');
    if (assetsDir.existsSync()) {
      _assetsWatchSub = assetsDir.watch(recursive: true).listen((event) {
        debounceTimer?.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 150), () {
          print('[DevServer] 🔄 Asset change detected: ${event.path}. Broadcasting reload...');
          _broadcastReload(event.path, projectDir.path);
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

  void _broadcastReload([String? changedFilePath, String? baseDir]) {
    String? relPath = changedFilePath;
    if (changedFilePath != null && baseDir != null) {
      relPath = changedFilePath
          .replaceFirst('$baseDir/', '')
          .replaceAll(r'\', '/');
    }
    _broadcast({
      'type': 'reload',
      'changedFile': relPath,
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
          print('  q  Show QR code');
          print('  c  Clear screen\n');
        } else if (char == 'r') {
          print('\n🔄 Triggering manual reload...');
          _broadcastReload();
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
      final manifest = {
        'protocol': 'dart_go',
        'appName': validation.appName,
        'packageName': validation.appName,
        'appVersion': validation.appVersion,
        'dartGoVersion': kDartGoVersion,
        'runtimeVersion': kDartGoRuntimeVersion,
        'serverUrl': serverUrl,
        'hasIcon': assets.hasIcon,
        'iconUrl': assets.hasIcon ? '$serverUrl/assets/icon.png' : null,
        'hasSplash': assets.hasSplash,
        'splashUrl': assets.hasSplash ? '$serverUrl/assets/splash.png' : null,
        'splashBackgroundColor': assets.splashBackgroundColor,
        'assets': _collectProjectAssets(projectDir),
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
        final projectAssets = _collectProjectAssets(projectDir);
        final jsonStr = jsonEncode({
          'manifest': {
            'appName': validation.appName,
            'packageName': validation.appName,
            'appVersion': validation.appVersion,
            'dartGoVersion': kDartGoVersion,
            'splashBackgroundColor': assets.splashBackgroundColor,
            'iconUrl': assets.hasIcon ? '$serverUrl/assets/icon.png' : null,
            'splashUrl':
                assets.hasSplash ? '$serverUrl/assets/splash.png' : null,
            'assets': projectAssets,
          },
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
        print('[DevServer] 📦 Served bundle.json (${bundle.length} files, ${projectAssets.length} assets)');
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Error reading bundle: $e')
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
  static Future<void> _serveAssetFile(HttpRequest request, File file) async {
    try {
      final bytes = await file.readAsBytes();
      final contentType = _getContentTypeForFile(file.path);
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = contentType
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
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
    _fileWatchSub?.cancel();
    _assetsWatchSub?.cancel();
    _stdinSub?.cancel();
    for (final ws in _sockets) {
      try {
        ws.close();
      } catch (_) {}
    }
    _server?.close(force: true);
  }
}
