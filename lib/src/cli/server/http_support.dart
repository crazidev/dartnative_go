/// Shared HTTP helpers for the dev server: responses, content types, and
/// traversal-safe project file lookup.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../packaging/ast_artifact_paths.dart';

const _corsHeader = 'Access-Control-Allow-Origin';

/// Writes [body] as plain text with [status] and CORS headers.
void sendText(HttpRequest request, int status, String body) {
  request.response
    ..statusCode = status
    ..headers.add(_corsHeader, '*')
    ..write(body)
    ..close();
}

/// Writes a 404 with [message].
void sendNotFound(HttpRequest request, String message) =>
    sendText(request, HttpStatus.notFound, message);

/// Writes [body] as JSON, uncached unless [cacheControl] is given.
void sendJson(
  HttpRequest request,
  Object? body, {
  String cacheControl = 'no-cache',
}) {
  request.response
    ..headers.contentType = ContentType.json
    ..headers.add(_corsHeader, '*')
    ..headers.add('Cache-Control', cacheControl)
    ..write(jsonEncode(body))
    ..close();
}

/// Writes [bytes] with [contentType] and [cacheControl].
void sendBytes(
  HttpRequest request,
  List<int> bytes,
  ContentType contentType, {
  String cacheControl = 'no-cache',
}) {
  request.response
    ..headers.contentType = contentType
    ..headers.add(_corsHeader, '*')
    ..headers.add('Cache-Control', cacheControl)
    ..add(bytes)
    ..close();
}

/// True when the request's `If-None-Match` matches [tag] (strong or weak).
bool etagMatches(HttpRequest request, String tag) {
  final client = request.headers.value(HttpHeaders.ifNoneMatchHeader)?.trim();
  if (client == null) return false;
  final etag = '"$tag"';
  return client == etag || client == tag || client == 'W/$etag';
}

/// Answers 304 for [tag].
Future<void> sendNotModified(HttpRequest request, String tag) async {
  request.response
    ..statusCode = HttpStatus.notModified
    ..headers.set(HttpHeaders.etagHeader, '"$tag"')
    ..headers.set(_corsHeader, '*')
    ..headers.set('Access-Control-Expose-Headers', 'ETag');
  await request.response.close();
}

/// Strong ETag for [file] based on mtime and byte size.
String computeFileEtag(File file) {
  final stat = file.statSync();
  return '"${stat.modified.millisecondsSinceEpoch}-${stat.size}"';
}

/// Unquoted version token (`mtime-size`) for [file].
String computeFileVersionToken(File file) {
  final stat = file.statSync();
  return '${stat.modified.millisecondsSinceEpoch}-${stat.size}';
}

/// Serves [file] with CORS, no-cache, ETag, and 304 Not Modified support.
Future<void> serveFile(HttpRequest request, File file, {String? etag}) async {
  try {
    final resolvedEtag = etag ?? computeFileEtag(file);
    final rawTag = resolvedEtag.replaceAll('"', '');
    if (etagMatches(request, rawTag)) {
      await sendNotModified(request, rawTag);
      return;
    }
    final bytes = await file.readAsBytes();
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = contentTypeForFile(file.path)
      ..headers.add(_corsHeader, '*')
      ..headers.add('Cache-Control', 'no-cache')
      ..headers.set(HttpHeaders.etagHeader, resolvedEtag)
      ..headers.set('Access-Control-Expose-Headers', 'ETag')
      ..headers.contentLength = bytes.length
      ..add(bytes)
      ..close();
  } catch (e) {
    sendText(
      request,
      HttpStatus.internalServerError,
      'Error reading asset: $e',
    );
  }
}

/// Content type for [path] by extension (octet-stream when unknown).
ContentType contentTypeForFile(String path) {
  final dot = path.lastIndexOf('.');
  final ext = dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
  return switch (ext) {
    'png' => ContentType('image', 'png'),
    'jpg' || 'jpeg' => ContentType('image', 'jpeg'),
    'gif' => ContentType('image', 'gif'),
    'webp' => ContentType('image', 'webp'),
    'svg' => ContentType('image', 'svg+xml'),
    'ico' => ContentType('image', 'x-icon'),
    'bmp' => ContentType('image', 'bmp'),
    'json' => ContentType.json,
    'ttf' => ContentType('font', 'ttf'),
    'otf' => ContentType('font', 'otf'),
    'woff' => ContentType('font', 'woff'),
    'woff2' => ContentType('font', 'woff2'),
    'mp3' => ContentType('audio', 'mpeg'),
    'wav' => ContentType('audio', 'wav'),
    'ogg' => ContentType('audio', 'ogg'),
    'mp4' => ContentType('video', 'mp4'),
    'webm' => ContentType('video', 'webm'),
    'txt' => ContentType('text', 'plain', charset: 'utf-8'),
    'html' || 'htm' => ContentType('text', 'html', charset: 'utf-8'),
    'css' => ContentType('text', 'css', charset: 'utf-8'),
    'js' => ContentType('application', 'javascript', charset: 'utf-8'),
    'pdf' => ContentType('application', 'pdf'),
    _ => ContentType('application', 'octet-stream'),
  };
}

/// Returns true if any segment in [relativePath] is empty, `.`, `..`, or
/// hidden (starts with `.`).
bool _hasUnsafeOrHiddenSegment(String relativePath) {
  if (relativePath.isEmpty) return true;
  for (final seg in relativePath.split('/')) {
    if (seg.isEmpty || seg == '.' || seg == '..' || seg.startsWith('.')) {
      return true;
    }
  }
  return false;
}

/// Relative paths of every regular file under `<project>/assets`, sorted.
/// Excludes generated `assets/bundles/` artifacts, hidden dotfiles/directories,
/// and symlinks escaping `<project>/assets/`.
List<String> collectProjectAssets(Directory projectDir) {
  final assetsDir = Directory(p.join(projectDir.path, 'assets'));
  if (!assetsDir.existsSync()) return const [];
  final results = <String>[];
  try {
    final canonicalAssets = assetsDir.resolveSymbolicLinksSync();
    for (final entity in assetsDir.listSync(recursive: true)) {
      if (entity is File) {
        final canonicalFile = entity.resolveSymbolicLinksSync();
        if (!p.isWithin(canonicalAssets, canonicalFile)) continue;
        final relUnderAssets = p
            .relative(entity.path, from: assetsDir.path)
            .replaceAll(r'\', '/');
        if (_hasUnsafeOrHiddenSegment(relUnderAssets)) continue;
        if (relUnderAssets == 'bundles' ||
            relUnderAssets.startsWith('bundles/')) {
          continue;
        }
        final canonicalRel = p
            .relative(canonicalFile, from: canonicalAssets)
            .replaceAll(r'\', '/');
        if (_hasUnsafeOrHiddenSegment(canonicalRel)) continue;
        if (canonicalRel == 'bundles' || canonicalRel.startsWith('bundles/')) {
          continue;
        }
        results.add('assets/$relUnderAssets');
      }
    }
  } catch (_) {}
  results.sort();
  return results;
}

/// Map of `<project>/assets` relative path → `mtime-size` version token.
Map<String, String> collectProjectAssetEtags(Directory projectDir) {
  final out = <String, String>{};
  for (final rel in collectProjectAssets(projectDir)) {
    final f = File('${projectDir.path}/$rel');
    if (f.existsSync()) {
      try {
        out[rel] = computeFileVersionToken(f);
      } catch (_) {}
    }
  }
  return out;
}

/// Finds `.dart_tool/bundles/guest.ast` (then the legacy `assets/bundles/` and
/// `build/` locations) inside the project, rejecting symlinks that escape it.
File? resolveAstBundleFile(Directory projectDir) {
  return _firstInsideProject(
    projectDir,
    kAstBundleCandidates.map((rel) => '${projectDir.path}/$rel'),
  );
}

/// Maps an asset request path strictly to a regular file inside
/// `<projectDir>/assets/`.
///
/// Rejects paths outside `assets/`, hidden dotfiles/directories, `..`
/// traversal, `assets/bundles/`, malformed URI encodings, null bytes, and
/// symlinks whose target escapes `<projectDir>/assets/`.
File? resolveAssetFile(Directory projectDir, String path) {
  if (path.contains('\x00')) return null;
  String decoded;
  try {
    decoded = Uri.decodeComponent(path);
  } catch (_) {
    return null;
  }
  if (decoded.contains('\x00')) return null;

  var clean = decoded.replaceAll(r'\', '/');
  while (clean.startsWith('/')) {
    clean = clean.substring(1);
  }
  if (clean.startsWith('assets/')) {
    clean = clean.substring('assets/'.length);
  }
  if (_hasUnsafeOrHiddenSegment(clean)) return null;
  if (clean == 'bundles' || clean.startsWith('bundles/')) return null;

  final assetsDir = Directory(p.join(projectDir.path, 'assets'));
  if (!assetsDir.existsSync()) return null;

  try {
    final canonicalAssets = assetsDir.resolveSymbolicLinksSync();
    final candidate = File(p.join(assetsDir.path, clean));
    if (!candidate.existsSync()) return null;
    if (!FileSystemEntity.isFileSync(candidate.path)) return null;
    final canonicalFile = candidate.resolveSymbolicLinksSync();
    if (!p.isWithin(canonicalAssets, canonicalFile)) return null;

    final canonicalRel = p
        .relative(canonicalFile, from: canonicalAssets)
        .replaceAll(r'\', '/');
    if (_hasUnsafeOrHiddenSegment(canonicalRel)) return null;
    if (canonicalRel == 'bundles' || canonicalRel.startsWith('bundles/')) {
      return null;
    }
    return candidate;
  } catch (_) {
    return null;
  }
}

File? _firstInsideProject(Directory projectDir, Iterable<String> candidates) {
  try {
    final canonicalProject = projectDir.resolveSymbolicLinksSync();
    for (final candidate in candidates) {
      final file = File(candidate);
      if (file.existsSync() &&
          p.isWithin(canonicalProject, file.resolveSymbolicLinksSync())) {
        return file;
      }
    }
  } catch (_) {}
  return null;
}

/// Server-component advertisement merged into `/manifest.json`.
///
/// Reads `server_components/manifest.json` next to `guest.ast` and rebases
/// bundle URLs onto [serverUrl]. Never throws: a missing or half-written
/// build yields `hasServerComponents: false`.
Map<String, Object?> serverComponentsManifest(
  Directory projectDir,
  String serverUrl,
) {
  const none = <String, Object?>{
    'hasServerComponents': false,
    'serverComponentsUrl': null,
    'serverComponents': <String, Object?>{},
  };
  try {
    final astFile = resolveAstBundleFile(projectDir);
    final manifestFile = astFile == null
        ? null
        : File('${astFile.parent.path}/server_components/manifest.json');
    if (manifestFile == null || !manifestFile.existsSync()) return none;
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
    return none;
  }
}
