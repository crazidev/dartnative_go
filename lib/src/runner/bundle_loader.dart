import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../interpreter/auto_import_parser.dart';

/// Encapsulates the loaded project metadata and virtual multi-file source map.
///
/// Dual-mode: [sources]/[entrypointCode] always populated (source default).
/// [astBytes] best-effort populated from `GET /guest.ast` when the dev server
/// has a pre-compiled bundle (see `tool/build_ast_bundle.dart` + `server.dart`).
class ProjectBundle {
  final String appName;
  final String? appVersion;
  final String? splashUrl;
  final String? iconUrl;
  final String? splashBackgroundColor;
  final String serverUrl;
  final Map<String, String> sources;
  final String entrypointCode;
  final String entrypointLibrary;
  final List<Map<String, dynamic>> breakpoints;
  final List<String> assets;

  /// Raw pre-compiled `AstBundle` bytes (ZIP/gzip/JSON auto-detected by
  /// `tom_d4rt_ast` on the device). Null when server has no `/guest.ast`.
  final List<int>? astBytes;

  /// Entry function inside [astBytes] (defaults to `main`).
  final String? astEntryPoint;

  /// Whether an AST bundle is available for opt-in testing.
  bool get hasAst => astBytes != null && astBytes!.isNotEmpty;

  const ProjectBundle({
    required this.appName,
    this.appVersion,
    this.splashUrl,
    this.iconUrl,
    this.splashBackgroundColor,
    required this.serverUrl,
    required this.sources,
    required this.entrypointCode,
    required this.entrypointLibrary,
    this.breakpoints = const [],
    this.assets = const [],
    this.astBytes,
    this.astEntryPoint,
  });
}

/// Service to fetch and parse project manifests and bundles from the dev server.
class BundleLoader {
  final HttpClient _client;

  BundleLoader({HttpClient? client})
      : _client = client ?? HttpClient()
          ..connectionTimeout = const Duration(seconds: 10);

  /// Normalizes base server URL without trailing slash.
  static String normalizeUrl(String input) {
    var trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      trimmed = 'http://$trimmed';
    }
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  /// Fetches the project manifest from `$serverUrl/manifest.json`.
  Future<Map<String, dynamic>?> fetchManifest(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/manifest.json'));
      final res = await req.close();
      if (res.statusCode == HttpStatus.ok) {
        final body = await res.transform(utf8.decoder).join();
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) return decoded;
      }
    } catch (_) {}
    return null;
  }

  /// Best-effort fetch of pre-compiled `AstBundle` bytes from `/guest.ast`.
  ///
  /// Returns null (not an error) when the server has no bundle yet — source
  /// mode keeps working. Never throws.
  Future<List<int>?> fetchAstBytes(String serverUrl) async {
    final baseUrl = normalizeUrl(serverUrl);
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/guest.ast'));
      final res = await req.close();
      if (res.statusCode != HttpStatus.ok) return null;
      final bytes = await res.fold<List<int>>(
        <int>[],
        (prev, el) => prev..addAll(el),
      );
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  /// Fetches the complete project bundle and compiles virtual source maps.
  ///
  /// Always fetches source (`/bundle.json` → `/app.dart` fallback). When
  /// [fetchAst] is true, also best-effort fetches `/guest.ast` bytes.
  Future<ProjectBundle> fetchBundle(
    String serverUrl, {
    Map<String, dynamic>? preloadedManifest,
    Map<String, Set<int>>? breakpointsByFile,
    bool fetchAst = true,
  }) async {
    final baseUrl = normalizeUrl(serverUrl);
    final manifest = preloadedManifest ?? await fetchManifest(baseUrl) ?? {};

    final appName = manifest['appName']?.toString() ?? 'DartNative App';
    final appVersion = manifest['appVersion']?.toString();
    final hasSplash = manifest['hasSplash'] == true;
    final hasIcon = manifest['hasIcon'] == true;
    final splashUrl = hasSplash ? (manifest['splashUrl']?.toString() ?? '$baseUrl/assets/splash.png') : null;
    final iconUrl = hasIcon ? (manifest['iconUrl']?.toString() ?? '$baseUrl/assets/icon.png') : null;
    final splashBg = manifest['splashBackgroundColor']?.toString();

    // 1. Attempt to fetch /bundle.json
    try {
      final req = await _client.getUrl(Uri.parse('$baseUrl/bundle.json'));
      final res = await req.close();

      if (res.statusCode == HttpStatus.ok) {
        final body = await res.transform(utf8.decoder).join();
        final rawMap = jsonDecode(body) as Map<String, dynamic>;

        final rawFiles = <String, String>{};
        final breakpoints = <Map<String, dynamic>>[];
        final rawAssets = <String>[];

        if (manifest['assets'] is List) {
          rawAssets.addAll(
            (manifest['assets'] as List).map((e) => e.toString()),
          );
        }

        if (rawMap.containsKey('assets') && rawMap['assets'] is List) {
          for (final a in rawMap['assets'] as List) {
            final str = a.toString();
            if (!rawAssets.contains(str)) rawAssets.add(str);
          }
        }

        if (rawMap.containsKey('files') && rawMap['files'] is Map) {
          (rawMap['files'] as Map).forEach((k, v) {
            rawFiles[k.toString()] = v.toString();
          });
          if (rawMap['breakpoints'] is List) {
            breakpoints.addAll(
              (rawMap['breakpoints'] as List).cast<Map<String, dynamic>>(),
            );
          }
        } else {
          rawMap.forEach((k, v) {
            if (k != 'manifest' && k != 'breakpoints' && k != 'assets') {
              rawFiles[k.toString()] = v.toString();
            }
          });
        }

        final packageName = manifest['packageName']?.toString() ??
            manifest['appName']?.toString() ??
            'guest_app';

        final virtualSources = AutoImportParser.buildVirtualSourceMap(
          rawFiles,
          packageName: packageName,
          breakpointsByFile: breakpointsByFile,
        );

        String entrypointLibrary = 'package:$packageName/main.dart';
        String entrypointCode = '';

        if (virtualSources.containsKey('package:$packageName/main.dart')) {
          entrypointLibrary = 'package:$packageName/main.dart';
          entrypointCode = virtualSources['package:$packageName/main.dart']!;
        } else if (virtualSources.containsKey('package:guest_app/main.dart')) {
          entrypointLibrary = 'package:guest_app/main.dart';
          entrypointCode = virtualSources['package:guest_app/main.dart']!;
        } else if (virtualSources.containsKey('main.dart')) {
          entrypointLibrary = 'main.dart';
          entrypointCode = virtualSources['main.dart']!;
        } else if (virtualSources.isNotEmpty) {
          entrypointLibrary = virtualSources.keys.first;
          entrypointCode = virtualSources.values.first;
        }

        return ProjectBundle(
          appName: appName,
          appVersion: appVersion,
          splashUrl: splashUrl,
          iconUrl: iconUrl,
          splashBackgroundColor: splashBg,
          serverUrl: baseUrl,
          sources: virtualSources,
          entrypointCode: entrypointCode,
          entrypointLibrary: entrypointLibrary,
          breakpoints: breakpoints,
          assets: rawAssets,
          astBytes: fetchAst ? await fetchAstBytes(baseUrl) : null,
          astEntryPoint: manifest['astEntryPoint']?.toString(),
        );
      }
    } catch (_) {}

    // 2. Fallback to /app.dart if bundle.json is not supported
    final req = await _client.getUrl(Uri.parse('$baseUrl/app.dart'));
    final res = await req.close();
    if (res.statusCode != HttpStatus.ok) {
      throw HttpException('Server returned HTTP ${res.statusCode}');
    }

    final code = await res.transform(utf8.decoder).join();
    final rawFiles = {'main.dart': code};
    final virtualSources = AutoImportParser.buildVirtualSourceMap(
      rawFiles,
      breakpointsByFile: breakpointsByFile,
    );

    return ProjectBundle(
      appName: appName,
      appVersion: appVersion,
      splashUrl: splashUrl,
      iconUrl: iconUrl,
      splashBackgroundColor: splashBg,
      serverUrl: baseUrl,
      sources: virtualSources,
      entrypointCode: virtualSources['main.dart'] ?? code,
      entrypointLibrary: 'main.dart',
      astBytes: fetchAst ? await fetchAstBytes(baseUrl) : null,
    );
  }

  void close() {
    _client.close(force: true);
  }
}
