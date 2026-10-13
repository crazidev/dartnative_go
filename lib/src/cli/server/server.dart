import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../runner/logger.dart';
import '../diagnostics/asset_detector.dart';
import '../packaging/ast_builder.dart';
import 'broadcaster.dart';
import 'dev_socket_hub.dart';
import 'terminal_ui.dart';
import '../diagnostics/dart_go_version.dart';
import '../packaging/dep_packager.dart';
import '../diagnostics/pubspec_validator.dart';

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
  StdinCommands? _stdinCommands;
  late final DevSocketHub _socketHub = DevSocketHub(options.projectDir);
  List<Map<String, dynamic>> get _activeBreakpoints => _socketHub.breakpoints;
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
      print(
        '\x1B[31mError: No entrypoint found at lib/main.dart in ${projectDir.path}.\x1B[0m',
      );
      exit(1);
    }

    // 3. Bind HTTP Server across port range
    final (server, port) = await NetworkHelper.bindInRange(
      startPort: options.startPort,
      endPort: options.endPort,
    );
    _server = server;

    final hostStr = options.customHost ?? await NetworkHelper.getLocalIp();

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

    // 5. Print startup diagnostics and terminal controls.
    printBanner();
    print(validation.formatReport());
    print(assets.formatReport());

    final serverUrl = 'http://$hostStr:$port';

    // 6. Display scannable QR code and connection details.
    if (options.enableQrCode) printQr(serverUrl);
    printConnectionInfo(serverUrl);
    print(
      options.rebuildAst
          ? '[AST] AST auto-build: \x1B[36mon\x1B[0m (guest.ast rebuilt on save; --no-rebuild-ast to disable)\n'
          : '[AST] AST auto-build: \x1B[90moff (--no-rebuild-ast)\x1B[0m\n',
    );
    printHelpHint();

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
          print(
            '[DevServer] [RELOAD] Asset change detected: ${event.path}. Broadcasting reload...',
          );
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

  /// Builds `guest.ast` in the background at startup so `/guest.ast` exists
  /// before the first client connects. Failures only log; source mode is
  /// unaffected.
  Future<void> _initialAstBuild(Directory projectDir) async {
    try {
      final result = await AstBuildWorker.instance.build(projectDir);
      if (result.success) {
        print(
          '[DevServer] [AST] guest.ast ready '
          '(${result.moduleCount} modules, ${result.byteSize} bytes)',
        );
      } else {
        print(
          '[DevServer] ! Initial bundle build skipped (${result.error}). '
          'Source hot reload unaffected.',
        );
      }
    } catch (e) {
      print('[DevServer] ! Initial bundle build error: $e');
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
    DartGoLogger.info(
      '[DevServer] [RELOAD] File changes (${changedPaths.length}): $fileNames',
    );
    DartGoLogger.debug(
      'Full paths: ${changedPaths.join(', ')}',
      tag: 'DevServer',
    );

    if (!options.rebuildAst) {
      _broadcastReload(changedPaths, codeDir.path);
      DartGoLogger.bench(
        'DevServer',
        'Reload broadcast sent',
        sw.elapsedMilliseconds,
      );
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
          final compCount = result.serverComponents?.components.length ?? 0;
          DartGoLogger.bench(
            'DevServer',
            compCount > 0
                ? '$artifacts rebuilt (+$compCount server components)'
                : '$artifacts rebuilt',
            astSw.elapsedMilliseconds,
            {
              'modules': result.moduleCount,
              'bytes': result.byteSize,
              'server_components': compCount,
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

  void _broadcast(Map<String, dynamic> data) => _socketHub.broadcast(data);

  void _broadcastBreakpoints() => _socketHub.broadcastBreakpoints();

  void _broadcastReload([
    Object? changedFilesInput,
    String? baseDir,
    bool isAssetChange = false,
  ]) => _socketHub.broadcastReload(changedFilesInput, baseDir, isAssetChange);

  void _setupStdinListener(String serverUrl) {
    _stdinCommands = StdinCommands(
      serverUrl: serverUrl,
      hub: _socketHub,
      onStop: stop,
    )..start();
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
      await _socketHub.accept(request);
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
        // Server components (Phase 5): advertised when the last AST build
        // emitted server_components/manifest.json.
        ..._serverComponentsManifest(projectDir, serverUrl),
        'supportedPlugins': validation.validSupportedPlugins,
        'unsupportedPlugins': validation.unsupportedNativePlugins,
        'versionMismatches': validation.versionMismatches
            .map(
              (m) => {
                'plugin': m.pluginName,
                'declared': m.declaredConstraint,
                'required': m.requiredConstraint,
              },
            )
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
        ..write(
          jsonEncode({
            'depsHash': depResult.depsHash,
            'deps': depResult.deps.map((e) => e.toJson()).toList(),
          }),
        )
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
      final assetPath = path == '/asset'
          ? (request.uri.queryParameters['path'] ?? '')
          : path;
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
            'splashUrl': assets.hasSplash
                ? '$serverUrl/assets/splash.png'
                : null,
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
        print(
          '[DevServer] [BUNDLE] Served bundle.json (${bundle.length} user files, ${depResult.deps.length} deps)',
        );
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
        final clientEtag = request.headers
            .value(HttpHeaders.ifNoneMatchHeader)
            ?.trim();
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
          '[DevServer] [AST] Served guest.ast (${await astFile.length()} bytes, etag=$etag)',
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
        final clientEtag = request.headers
            .value(HttpHeaders.ifNoneMatchHeader)
            ?.trim();
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
          '[DevServer] [PATCH] Served guest.ast.patch (${patchBytes.length} bytes, etag=$etag)',
        );
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('No active AST patch available; fetch full /guest.ast.')
          ..close();
      }
    } else if (path == '/client-module-index.json') {
      // Module URIs shipped in the client bundle (Phase 1). Component
      // builders subtract these from each delta. 404 until the first
      // successful AST build writes it alongside guest.ast.
      final astFile = _resolveAstBundleFile(projectDir);
      final indexFile = astFile != null
          ? File('${astFile.parent.path}/client-module-index.json')
          : null;
      if (indexFile != null && indexFile.existsSync()) {
        await _serveAssetFile(request, indexFile);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('No client module index. Build the AST bundle first.')
          ..close();
      }
    } else if (path == '/server-components/manifest.json') {
      // Component ID → bundle URL + fingerprint (Phase 5). 404 when the
      // app has no @ServerComponent annotations (nothing to serve).
      final astFile = _resolveAstBundleFile(projectDir);
      final manifestFile = astFile != null
          ? File('${astFile.parent.path}/server_components/manifest.json')
          : null;
      if (manifestFile != null && manifestFile.existsSync()) {
        await _serveAssetFile(request, manifestFile);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.contentType = ContentType.json
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(jsonEncode({'version': 1, 'components': {}}))
          ..close();
      }
    } else if (path.startsWith('/server-components/') &&
        path.endsWith('.ast')) {
      // One pre-built delta bundle per @ServerComponent (Phase 5).
      // The id is strictly validated — no traversal, no sub-paths.
      final astFile = _resolveAstBundleFile(projectDir);
      final id = path.substring(
        '/server-components/'.length,
        path.length - '.ast'.length,
      );
      final validId = RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(id);
      final compFile = (astFile != null && validId)
          ? File('${astFile.parent.path}/server_components/$id.ast')
          : null;
      if (compFile != null && compFile.existsSync()) {
        await _serveAssetFile(request, compFile);
        print(
          '[DevServer] [COMPONENT] Served server component $id '
          '(${await compFile.length()} bytes)',
        );
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Server component not found: $id')
          ..close();
      }
    } else if (path == '/app.dart') {
      try {
        final content = await mainFile.readAsString();
        request.response
          ..headers.contentType = ContentType(
            'application',
            'dart',
            charset: 'utf-8',
          )
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
      print('[DevServer] [RESUME] Resumed execution via HTTP /resume');
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(jsonEncode({'status': 'resumed'}))
        ..close();
    } else if (path == '/health' || path == '/dart_go/discover') {
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(
          jsonEncode({
            'status': 'ok',
            'protocol': 'dart_go',
            'appName': validation.appName,
            'version': kDartGoVersion,
            'clients': _socketHub.clientCount,
            'hasIcon': assets.hasIcon,
            'hasSplash': assets.hasSplash,
          }),
        )
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

  /// Server-component advertisement for `/manifest.json` (Phase 5).
  ///
  /// Reads the `server_components/manifest.json` emitted by the last AST
  /// build (next to `guest.ast`) and re-bases its relative bundle URLs to
  /// absolute dev-server URLs. Returns `hasServerComponents: false` plus an
  /// empty component map when the app has no annotated components — never
  /// throws, so manifest serving stays up even with a half-written build.
  static Map<String, Object?> _serverComponentsManifest(
    Directory projectDir,
    String serverUrl,
  ) {
    try {
      final astFile = _resolveAstBundleFile(projectDir);
      final manifestFile = astFile != null
          ? File('${astFile.parent.path}/server_components/manifest.json')
          : null;
      if (manifestFile == null || !manifestFile.existsSync()) {
        return {
          'hasServerComponents': false,
          'serverComponentsUrl': null,
          'serverComponents': const <String, Object?>{},
        };
      }
      final raw =
          jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
      final entries = (raw['components'] as Map<String, dynamic>?) ?? const {};
      return {
        'hasServerComponents': true,
        'serverComponentsUrl': '$serverUrl/server-components/manifest.json',
        'serverComponents': {
          for (final e in entries.entries)
            e.key: {
              'url': '$serverUrl/${(e.value as Map)['url']}',
              'fingerprint': (e.value as Map)['fingerprint'],
            },
        },
      };
    } catch (_) {
      return {
        'hasServerComponents': false,
        'serverComponentsUrl': null,
        'serverComponents': const <String, Object?>{},
      };
    }
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
    _stdinCommands?.stop();
    _socketHub.closeAll();
    AstBuildWorker.instance.stop();
    _server?.close(force: true);
  }
}
