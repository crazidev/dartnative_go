import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../runner/logger.dart';
import '../../client/deep_link.dart';
import '../diagnostics/asset_detector.dart';
import '../diagnostics/icon_font_detector.dart';
import '../packaging/ast_builder.dart';
import 'broadcaster.dart';
import 'dev_socket_hub.dart';
import 'http_support.dart';
import 'loading_page.dart';
import 'terminal_ui.dart';
import '../diagnostics/version_info.dart';
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
  /// (`.dart_tool/bundles/guest.ast`) before the reload broadcast, so AST-mode
  /// clients hot-reload fresh bytes. Unchanged sources skip the analyzer
  /// parse via content fingerprint (millisecond fast path). Disable with
  /// `--no-rebuild-ast` if you only test source mode.
  final bool rebuildAst;
  final bool verbose;

  /// Enables internal runtime/protocol telemetry (`--dev-logs` or `DNGO_DEV=1`).
  final bool devLogs;

  /// `--profile`: advertised in the manifest as `profile: true` so AST-mode
  /// apps show the AST BUNDLE explorer in their DevTools sheet. Off by
  /// default — the explorer costs an on-demand AST sizing walk per open.
  final bool profile;

  /// Same snapshot `dngo --version` prints (baked into this process).
  final DngoVersionInfo versions;

  const DartGoServerOptions({
    required this.projectDir,
    this.startPort = 8088,
    this.endPort = 8098,
    this.enableBroadcast = true,
    this.enableQrCode = true,
    this.customHost,
    this.rebuildAst = true,
    this.verbose = false,
    this.devLogs = false,
    this.profile = false,
    this.versions = DngoVersionInfo.current,
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
  final DevServerConsole _console = DevServerConsole();
  late final DevSocketHub _socketHub = DevSocketHub(
    options.projectDir,
    console: _console,
  );
  List<Map<String, dynamic>> get _activeBreakpoints => _socketHub.breakpoints;
  bool _astRebuildInFlight = false;
  bool _astRebuildQueued = false;
  final Set<String> _pendingDartChanges = {};
  Timer? _codeDebounceTimer;

  DartGoServer(this.options) {
    DartGoLogger.verbose = options.verbose;
    DartGoLogger.devLogs = options.devLogs;
  }

  Future<void> start() async {
    final projectDir = options.projectDir;

    // 1. Validate Pubspec & Plugin Compatibility
    final validator = PubspecValidator(projectDir);
    final validation = validator.validate();

    // 2. Detect Project Assets (Icon & Splash)
    final assetDetector = AssetDetector(projectDir);
    final assets = assetDetector.detect();

    // 2b. Detect icon-font usage (Cupertino/Material/FA/custom) so the
    // manifest advertises only the families the guest touches and the
    // server serves only requested `.ttf` bytes on demand.
    IconFontReport iconFonts;
    try {
      iconFonts = IconFontDetector(projectDir).detect();
    } catch (_) {
      iconFonts = const IconFontReport();
    }

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

    // 3. Bind HTTP Server across port range (binding to customHost IP if provided)
    final bindAddress = await _resolveBindAddress(options.customHost);
    final (server, port) = await NetworkHelper.bindInRange(
      startPort: options.startPort,
      endPort: options.endPort,
      address: bindAddress,
    );
    _server = server;

    final customHost = options.customHost?.trim();
    final hostStr = (customHost != null && customHost.isNotEmpty)
        ? customHost
        : await NetworkHelper.getLocalIp();

    // 4. Start UDP Discovery Broadcaster across port range
    if (options.enableBroadcast) {
      final beaconIconUrl = assets.hasIcon
          ? 'http://$hostStr:$port/assets/icon.png?v=${computeFileVersionToken(assets.iconFile!)}'
          : null;
      _broadcaster = DartGoBroadcaster(
        appName: validation.appName,
        host: hostStr,
        port: port,
        startPort: options.startPort,
        endPort: options.endPort,
        dartGoVersion: options.versions.dngoVersion,
        appVersion: validation.appVersion,
        hasIcon: assets.hasIcon,
        iconUrl: beaconIconUrl,
        hasSplash: assets.hasSplash,
      );
      await _broadcaster!.start();
    }

    // 5. Print startup screen (project details, QR/URL, shortcuts, and
    // verbose-only diagnostics).
    final versions = options.versions;
    final serverUrl = 'http://$hostStr:$port';
    final deepLink = DartGoDeepLink.build(
      serverUrl,
      appName: validation.appName,
    );
    final startupInfo = StartupScreenInfo(
      projectPath: p.normalize(projectDir.absolute.path),
      serverUrl: serverUrl,
      deepLink: deepLink,
      validation: validation,
      assets: assets,
      iconFonts: iconFonts,
      versions: versions,
      rebuildAst: options.rebuildAst,
      enableQrCode: options.enableQrCode,
      verbose: options.verbose,
      devLogs: options.devLogs,
    );
    _socketHub.startupInfo = startupInfo;
    _console.printStartup(startupInfo);

    // 6b. Initial AST bundle build (background) so `/guest.ast` exists
    // before the first client connects — later saves reuse the watcher.
    if (options.rebuildAst) {
      _initialAstBuild(projectDir);
    }

    // 7. Setup Stdin debugger commands
    _setupStdinListener(serverUrl, startupInfo);

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
        // Bundles now live under `.dart_tool/`, but keep ignoring legacy
        // `assets/bundles/` writes so old projects don't double-reload.
        final norm = event.path.replaceAll(r'\', '/');
        if (norm.contains('/assets/bundles') ||
            norm.contains('/.dart_tool/') ||
            norm.endsWith('guest.ast')) {
          return;
        }
        assetsDebounceTimer?.cancel();
        assetsDebounceTimer = Timer(const Duration(milliseconds: 150), () {
          final rel = _relativeToProject(event.path, projectDir);
          _console.beginAssetReload(
            assetPath: rel,
            connectedClients: _socketHub.clientCount,
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
        assets: assets,
        validation: validation,
        serverUrl: serverUrl,
        iconFonts: iconFonts,
      );
    }
  }

  /// Builds `guest.ast` in the background at startup so `/guest.ast` exists
  /// before the first client connects.
  Future<void> _initialAstBuild(Directory projectDir) async {
    final sw = Stopwatch()..start();
    _console.beginBundling();
    try {
      final result = await AstBuildWorker.instance.build(projectDir);
      sw.stop();
      if (result.success) {
        final astFile = resolveAstBundleFile(projectDir);
        final etag = astFile != null
            ? '"${astBundleFingerprintForProject(projectDir, astFile)}"'
            : null;
        _console.endBundlingSuccess(
          elapsedMs: sw.elapsedMilliseconds,
          moduleCount: result.moduleCount,
          byteSize: result.byteSize,
          etag: etag,
        );
      } else {
        _console.endBundlingWarning(
          'Initial bundle skipped (${sw.elapsedMilliseconds}ms)',
          '${result.error ?? 'unknown error'} · source hot reload unaffected',
        );
      }
    } catch (e) {
      sw.stop();
      _console.endBundlingWarning(
        'Initial bundle error (${sw.elapsedMilliseconds}ms)',
        '$e',
      );
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
    final relFiles =
        changedPaths
            .map((path) => _relativeToProject(path, projectDir))
            .toList()
          ..sort();

    if (!options.rebuildAst) {
      _console.beginCodeReload(
        changedFiles: relFiles,
        rebuildMs: sw.elapsedMilliseconds,
        cached: true,
        connectedClients: _socketHub.clientCount,
      );
      _broadcastReload(changedPaths, codeDir.path);
      return;
    }
    if (_astRebuildInFlight) {
      _pendingDartChanges.addAll(changedPaths);
      _astRebuildQueued = true;
      return;
    }
    _astRebuildInFlight = true;
    var buildOk = false;
    var rebuildMs = 0;
    var cached = false;
    int? totalModules;
    int? bundleBytes;
    try {
      final astSw = Stopwatch()..start();
      final result = await AstBuildWorker.instance.build(
        projectDir,
        changedFiles: changedPaths,
      );
      astSw.stop();
      rebuildMs = astSw.elapsedMilliseconds;
      buildOk = result.success;
      if (result.success) {
        cached = result.cached;
        totalModules = result.moduleCount;
        bundleBytes = result.byteSize;
      } else {
        _console.onRebuildFailed(rebuildMs, result.error ?? 'build failed');
      }
    } finally {
      _astRebuildInFlight = false;
    }
    // A failed build leaves the previous bundle in place, so there is nothing
    // new to fetch: skip the broadcast and let every device keep running its
    // current generation. The warning above (plus the next successful save)
    // is the whole signal.
    if (!buildOk) return;
    final patchBytes = patchBytesForProject(projectDir)?.length;
    _console.beginCodeReload(
      changedFiles: relFiles,
      rebuildMs: rebuildMs,
      cached: cached,
      patchBytes: patchBytes,
      bundleBytes: bundleBytes,
      totalModules: totalModules,
      totalPrepMs: sw.elapsedMilliseconds,
      connectedClients: _socketHub.clientCount,
    );
    _broadcastReload(changedPaths, codeDir.path);
    if (_astRebuildQueued || _pendingDartChanges.isNotEmpty) {
      _astRebuildQueued = false;
      final nextBatch = Set<String>.of(_pendingDartChanges);
      _pendingDartChanges.clear();
      if (nextBatch.isNotEmpty) {
        _onCodeChangedBatch(nextBatch, codeDir, projectDir);
      }
    }
  }

  static String _relativeToProject(String filePath, Directory projectDir) {
    final normPath = filePath.replaceAll(r'\', '/');
    final normRoot = projectDir.path.replaceAll(r'\', '/');
    final prefix = normRoot.endsWith('/') ? normRoot : '$normRoot/';
    if (normPath.startsWith(prefix)) {
      return normPath.substring(prefix.length);
    }
    return p.relative(filePath, from: projectDir.path).replaceAll(r'\', '/');
  }

  void _broadcast(Map<String, dynamic> data) => _socketHub.broadcast(data);

  void _broadcastBreakpoints() => _socketHub.broadcastBreakpoints();

  void _broadcastReload([
    Object? changedFilesInput,
    String? baseDir,
    bool isAssetChange = false,
  ]) => _socketHub.broadcastReload(changedFilesInput, baseDir, isAssetChange);

  void _setupStdinListener(String serverUrl, StartupScreenInfo startupInfo) {
    _stdinCommands = StdinCommands(
      serverUrl: serverUrl,
      hub: _socketHub,
      console: _console,
      startupInfo: startupInfo,
      onStop: stop,
    )..start();
  }

  Future<void> _handleHttpRequest({
    required HttpRequest request,
    required Directory projectDir,
    required ProjectAssets assets,
    required PubspecValidationResult validation,
    required String serverUrl,
    IconFontReport? iconFonts,
  }) async {
    final path = request.uri.path;

    if (path == '/ws') {
      await _socketHub.accept(request);
    } else if (path == '/manifest.json') {
      final astFile = resolveAstBundleFile(projectDir);
      // Icon-font usage is re-detected per manifest fetch (cached by source
      // fingerprint inside IconFontDetector) so newly added
      // `CupertinoIcons.xxx` / `Icons.xxx` glyphs appear without restart.
      IconFontReport fontsReport;
      try {
        fontsReport = IconFontDetector(projectDir).detect();
      } catch (_) {
        fontsReport = iconFonts ?? const IconFontReport();
      }
      final versions = options.versions;
      final manifest = {
        'protocol': 'dart_go',
        'appName': validation.appName,
        'packageName': validation.packageName,
        'appVersion': validation.appVersion,
        ...versions.toJson(),
        'serverUrl': serverUrl,
        'hasIcon': assets.hasIcon,
        'iconUrl': assets.hasIcon
            ? '$serverUrl/assets/icon.png?v=${computeFileVersionToken(assets.iconFile!)}'
            : null,
        'hasSplash': assets.hasSplash,
        'splashUrl': assets.hasSplash
            ? '$serverUrl/assets/splash.png?v=${computeFileVersionToken(assets.splashFile!)}'
            : null,
        'splashBackgroundColor': assets.splashBackgroundColor,
        'splashBackgroundColorDark': assets.splashBackgroundColorDark,
        'assets': collectProjectAssets(projectDir),
        'assetEtags': collectProjectAssetEtags(projectDir),
        // On-demand icon fonts: only the families the guest touches are
        // advertised; devices fetch each `.ttf`/`.otf` via its `url` once.
        'iconFonts': fontsReport.toManifestJson(serverUrl),
        'iconFontsHash': fontsReport.hash,
        'fonts': fontsReport.customFonts
            .map(
              (f) => {
                ...f.toJson(),
                'url': '$serverUrl/fonts/${Uri.encodeComponent(f.family)}.ttf',
              },
            )
            .toList(),
        'hasAstBundle': astFile != null,
        'astUrl': astFile != null ? '$serverUrl/guest.ast' : null,
        // Tells AST-mode clients whether a bundle is still being built: the
        // initial build runs in the background, so a client that connects in
        // the first seconds sees hasAstBundle=false while bytes are moments
        // away.
        'astPending': options.rebuildAst && astFile == null,
        // Only when the server runs with `--profile`: the app may open the
        // AST BUNDLE explorer in its DevTools sheet (costs an AST sizing
        // walk per open, so it stays hidden by default).
        'profile': options.profile,
        'astModuleFingerprints': astFile != null
            ? moduleFingerprintsForProject(projectDir)
            : const <String, String>{},
        // Server components (Phase 5): advertised when the last AST build
        // emitted server_components/manifest.json.
        ...serverComponentsManifest(projectDir, serverUrl),
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
    } else if (path == '/assets.json') {
      final projectAssets = collectProjectAssets(projectDir);
      final assetEtags = collectProjectAssetEtags(projectDir);
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(jsonEncode({'assets': projectAssets, 'assetEtags': assetEtags}))
        ..close();
    } else if (path == '/icon-fonts.json' || path == '/fonts.json') {
      // Subset manifest for on-demand font loading: families + used glyphs.
      IconFontReport fontsReport;
      try {
        fontsReport = IconFontDetector(projectDir).detect();
      } catch (_) {
        fontsReport = iconFonts ?? const IconFontReport();
      }
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(
          jsonEncode({
            'hash': fontsReport.hash,
            'iconFonts': fontsReport.toManifestJson(serverUrl),
            'fonts': fontsReport.customFonts
                .map(
                  (f) => {
                    ...f.toJson(),
                    'url':
                        '$serverUrl/fonts/${Uri.encodeComponent(f.family)}.ttf',
                  },
                )
                .toList(),
          }),
        )
        ..close();
    } else if (path.startsWith('/fonts/')) {
      // On-demand font bytes: only the requested family is read from disk
      // and streamed — unrequested fonts are never touched.
      final family = path.substring('/fonts/'.length);
      final cleanFamily = family.split('/').first.split('?').first;
      if (cleanFamily.isEmpty || cleanFamily.contains('..')) {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Font not found')
          ..close();
      } else {
        File? fontFile;
        try {
          final decoded = Uri.decodeComponent(cleanFamily);
          final stripped = decoded.replaceAll(
            RegExp(r'\.(ttf|otf)$', caseSensitive: false),
            '',
          );
          final detector = IconFontDetector(projectDir);
          fontFile = detector.resolveFontFile(stripped);
          // Accept both `/fonts/CupertinoIcons` and `/fonts/CupertinoIcons.ttf`.
          fontFile ??= detector.resolveFontFile(decoded);
        } catch (_) {
          fontFile = null;
        }
        if (fontFile != null && fontFile.existsSync()) {
          final stat = fontFile.statSync();
          await _serveAssetFile(request, fontFile);
          _console.onArtifactServed(
            name: cleanFamily,
            byteSize: stat.size,
            isFont: true,
          );
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..headers.add('Access-Control-Allow-Origin', '*')
            ..write('Font not found: $cleanFamily')
            ..close();
        }
      }
    } else if (path == '/assets/icon.png' || path == '/icon.png') {
      if (assets.hasIcon) {
        await _serveAssetFile(request, assets.iconFile!);
      } else {
        final resolved = resolveAssetFile(projectDir, 'assets/icon.png');
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
        final resolved = resolveAssetFile(projectDir, 'assets/splash.png');
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
    } else if (path.startsWith('/assets/')) {
      final file = resolveAssetFile(projectDir, path);
      if (file != null) {
        await _serveAssetFile(request, file);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Asset not found: $path')
          ..close();
      }
    } else if (path == '/guest.ast') {
      // Pre-compiled AST bundle (tom_ast_generator output).
      // Built via `dart run tool/build_ast_bundle.dart`.
      final astFile = resolveAstBundleFile(projectDir);
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
        final serveSw = Stopwatch()..start();
        await _serveAssetFile(
          request,
          astFile,
          etag: etag,
          // Patch lineage: the fingerprint of the exact bytes served, so
          // devices know which bundle generation they are based on.
          extraHeaders: {
            if (fileSourceFingerprintForPath(astFile.path).isNotEmpty)
              'X-Ast-Bundle': fileSourceFingerprintForPath(astFile.path),
          },
        );
        serveSw.stop();
        final fingerprints = moduleFingerprintsForProject(projectDir);
        final projectAssets = collectProjectAssets(projectDir);
        _console.onArtifactServed(
          name: 'guest.ast',
          byteSize: await astFile.length(),
          etag: etag,
          moduleCount: fingerprints.isNotEmpty ? fingerprints.length : null,
          assetCount: projectAssets.isNotEmpty ? projectAssets.length : null,
          serveMs: serveSw.elapsedMilliseconds,
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
        // Patch lineage: a delta is only valid on the base it was computed
        // against. A device that missed an intermediate reload (aborted by a
        // newer broadcast) sends a stale `?base=` and must take the full
        // bundle instead — applying the delta would strand stale modules
        // with no error (franken-bundle). Clients that predate lineage send
        // no `base` and keep the legacy behavior.
        final query = request.uri.queryParameters;
        final patchBaseFp = patchBaseFingerprintForProject(projectDir);
        if (query.containsKey('base') &&
            patchBaseFp != null &&
            patchBaseFp.isNotEmpty &&
            query['base'] != patchBaseFp) {
          request.response
            ..statusCode = HttpStatus.notFound
            ..headers.add('Access-Control-Allow-Origin', '*')
            ..write(
              'Patch base mismatch (patch is based on $patchBaseFp); '
              'fetch full /guest.ast.',
            )
            ..close();
          if (DartGoLogger.devLogs) {
            _console.onWarning(
              'Patch base mismatch',
              'device=${query['base']}, patch base=$patchBaseFp — full fetch advised',
            );
          }
          return;
        }
        final bundleFp = bundleFingerprintForProject(projectDir);
        final astFile = resolveAstBundleFile(projectDir);
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
          ..headers.set('X-Ast-Bundle', bundleFp)
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Access-Control-Expose-Headers', 'ETag, X-Ast-Bundle')
          ..add(patchBytes);
        await request.response.close();
        _console.onArtifactServed(
          name: 'guest.ast.patch',
          byteSize: patchBytes.length,
          etag: etag,
          isPatch: true,
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
      final astFile = resolveAstBundleFile(projectDir);
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
      final astFile = resolveAstBundleFile(projectDir);
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
      final astFile = resolveAstBundleFile(projectDir);
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
        _console.onArtifactServed(
          name: 'component/$id.ast',
          byteSize: await compFile.length(),
        );
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write('Server component not found: $id')
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
      final versions = options.versions;
      request.response
        ..headers.contentType = ContentType.json
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write(
          jsonEncode({
            'status': 'ok',
            'protocol': 'dart_go',
            'appName': validation.appName,
            'version': versions.dngoVersion,
            ...versions.toJson(),
            'clients': _socketHub.clientCount,
            'hasIcon': assets.hasIcon,
            'hasSplash': assets.hasSplash,
          }),
        )
        ..close();
    } else if (path == '/' || path.isEmpty) {
      // Browsers opening the printed Server URL get the loading page;
      // API clients (Go app, curl JSON) keep the JSON identity payload.
      final accept = request.headers.value(HttpHeaders.acceptHeader);
      final versions = options.versions;
      if (isBrowserDocumentRequest(accept)) {
        request.response
          ..statusCode = HttpStatus.temporaryRedirect
          ..headers.set(
            HttpHeaders.locationHeader,
            '$kDngoLoadingPath?url=${Uri.encodeQueryComponent(serverUrl)}',
          )
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Cache-Control', 'no-cache')
          ..close();
      } else {
        request.response
          ..headers.contentType = ContentType.json
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Cache-Control', 'no-cache')
          ..write(
            jsonEncode({
              'status': 'ok',
              'protocol': 'dart_go',
              'appName': validation.appName,
              'version': versions.dngoVersion,
              ...versions.toJson(),
              'loadingUrl': '$serverUrl$kDngoLoadingPath',
            }),
          )
          ..close();
      }
    } else if (path == kDngoLoadingPath) {
      final html = buildLoadingPageHtml(
        appName: validation.appName,
        appVersion: validation.appVersion,
        serverUrl: serverUrl,
      );
      request.response
        ..headers.contentType = ContentType('text', 'html', charset: 'utf-8')
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache')
        ..write(html)
        ..close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..write('404 Not Found')
        ..close();
    }
  }

  /// Resolves [customHost] into a bind [InternetAddress], defaulting to
  /// `anyIPv4` when unset.
  static Future<InternetAddress> _resolveBindAddress(String? customHost) async {
    final trimmed = customHost?.trim();
    if (trimmed == null || trimmed.isEmpty) return InternetAddress.anyIPv4;
    if (trimmed.toLowerCase() == 'localhost') {
      return InternetAddress.loopbackIPv4;
    }
    final parsed = InternetAddress.tryParse(trimmed);
    if (parsed != null) return parsed;
    try {
      final results = await InternetAddress.lookup(trimmed);
      if (results.isNotEmpty) return results.first;
    } catch (_) {}
    return InternetAddress.anyIPv4;
  }

  /// Streams the asset file to the HTTP response with CORS, ETag, and 304
  /// Not Modified support.
  static Future<void> _serveAssetFile(
    HttpRequest request,
    File file, {
    String? etag,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final resolvedEtag = etag ?? computeFileEtag(file);
      final rawTag = resolvedEtag.replaceAll('"', '');
      if (etagMatches(request, rawTag)) {
        await sendNotModified(request, rawTag);
        return;
      }
      final bytes = await file.readAsBytes();
      final contentType = contentTypeForFile(file.path);
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = contentType
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add('Cache-Control', 'no-cache');
      final expose = <String>['ETag'];
      request.response.headers.set(HttpHeaders.etagHeader, resolvedEtag);
      if (extraHeaders != null) {
        extraHeaders.forEach((name, value) {
          request.response.headers.set(name, value);
          expose.add(name);
        });
      }
      request.response.headers.set(
        'Access-Control-Expose-Headers',
        expose.join(', '),
      );
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
    _console.dispose();
    _socketHub.closeAll();
    AstBuildWorker.instance.stop();
    _server?.close(force: true);
  }
}
