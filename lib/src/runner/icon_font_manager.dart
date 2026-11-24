import 'dart:async';
import 'dart:io';

import 'app_cache.dart';
import 'bundle_loader.dart';
import 'icon_registry.dart';
import 'logger.dart';
import 'native_font_registrar.dart';

/// On-device tracker + disk cache + native registrar for on-demand fonts.
///
/// The dev server advertises only the families the guest touches
/// (`ProjectBundle.iconFonts` + `iconFontsHash`); this manager:
/// 1. Short-circuits built-ins (Cupertino/Material — [kBuiltInIconFamilies]).
/// 2. Checks the persistent [AppCache] on disk first (matching ETag when known).
/// 3. Fetches missing or stale fonts from `/fonts/<family>.ttf` with
///    `If-None-Match` conditional requests (`304 Not Modified` reuses disk).
/// 4. Persists the downloaded font to [AppCache] and registers it with the
///    OS font manager via [NativeFontRegistrar] so `TextStyle(fontFamily: ...)`
///    and `IconData(..., fontFamily: ...)` render immediately.
class IconFontManager {
  final Future<List<int>?> Function(String family) fetcher;
  final Future<({List<int>? bytes, String? etag, bool notModified})> Function(
    String family, {
    String? ifNoneMatch,
  })?
  conditionalFetcher;
  final AppCache? cache;
  final String? serverUrl;
  final NativeFontRegistrar? registrar;

  /// family → downloaded font bytes (non-built-ins only).
  final Map<String, List<int>> _loaded = {};

  /// family → ETag of the currently loaded font.
  final Map<String, String> _loadedEtags = {};

  /// family → registered on-disk [File] (for unregistration on reinvalidation).
  final Map<String, File> _registeredFiles = {};

  /// Families currently being fetched (dedupes concurrent requests).
  final Map<String, Future<List<int>?>> _inFlight = {};

  /// Last applied [ProjectBundle.iconFontsHash]; [syncBundle] no-ops when
  /// the hash matches, so steady-state reloads cost zero font traffic.
  String _lastHash = '';

  IconFontManager({
    required this.fetcher,
    this.conditionalFetcher,
    this.cache,
    this.serverUrl,
    this.registrar,
  });

  /// Creates a manager backed by [loader] against [serverUrl], optionally
  /// persisting fonts in [cache] and registering them via [registrar].
  factory IconFontManager.fromLoader(
    BundleLoader loader,
    String serverUrl, {
    AppCache? cache,
    NativeFontRegistrar? registrar,
  }) {
    final base = BundleLoader.normalizeUrl(serverUrl);
    return IconFontManager(
      fetcher: (family) => loader.fetchFontBytes(base, family),
      conditionalFetcher: (family, {ifNoneMatch}) =>
          loader.fetchFont(base, family, ifNoneMatch: ifNoneMatch),
      cache: cache,
      serverUrl: base,
      registrar: registrar ?? NativeFontRegistrar(),
    );
  }

  /// Families with cached bytes (fetch-complete, non-built-in).
  Set<String> get loadedFamilies => Set<String>.of(_loaded.keys);

  /// Last synced manifest hash (empty before the first [syncBundle]).
  String get lastHash => _lastHash;

  /// Cached bytes for [family], or null when not (yet) fetched.
  List<int>? fontBytes(String family) => _loaded[family.trim()];

  /// Registered on-disk font file for [family], if any.
  File? registeredFile(String family) => _registeredFiles[family.trim()];

  /// True when [family] needs no work: built-in, or already cached.
  bool isReady(String family) {
    final fam = family.trim();
    if (fam.isEmpty) return true;
    if (isBuiltInIconFamily(fam)) return true;
    return _loaded.containsKey(fam);
  }

  /// Families in [bundle] that require a download or revalidation:
  /// non-built-in, advertised with a font `url`/`hasFontFile`, and either not
  /// loaded or with a changed ETag.
  List<Map<String, dynamic>> neededFonts(ProjectBundle bundle) {
    return bundle.iconFonts.where((entry) {
      final family = '${entry['family'] ?? ''}'.trim();
      if (family.isEmpty || isBuiltInIconFamily(family)) return false;
      final etag = entry['etag']?.toString();
      if (_loaded.containsKey(family)) {
        if (etag == null || etag.isEmpty || _loadedEtags[family] == etag) {
          return false;
        }
      }
      final url = '${entry['url'] ?? ''}';
      final hasFile = entry['hasFontFile'] == true;
      return url.isNotEmpty || hasFile;
    }).toList();
  }

  /// Ensures [family] is fetched, cached on disk, and registered natively
  /// (built-ins resolve immediately). Concurrent callers share one fetch.
  /// Never throws — returns null when the server has no such font or fails.
  Future<List<int>?> ensureLoaded(
    String family, {
    String? expectedEtag,
  }) {
    final fam = family.trim();
    if (fam.isEmpty || isBuiltInIconFamily(fam)) return Future.value(const []);

    final cached = _loaded[fam];
    if (cached != null) {
      final etagMatches =
          expectedEtag == null ||
          expectedEtag.isEmpty ||
          _loadedEtags[fam] == expectedEtag ||
          _loadedEtags[fam] == '"$expectedEtag"';
      if (etagMatches) return Future.value(cached);
    }

    final flight = _inFlight[fam];
    if (flight != null) return flight;

    final future = _loadAndRegister(fam, expectedEtag: expectedEtag)
        .then((bytes) {
          _inFlight.remove(fam);
          return bytes;
        })
        .catchError((_) {
          _inFlight.remove(fam);
          return null;
        });
    _inFlight[fam] = future;
    return future;
  }

  Future<List<int>?> _loadAndRegister(
    String fam, {
    String? expectedEtag,
  }) async {
    final url = serverUrl;
    final diskCache = cache;

    // 1. Check disk cache if expectedEtag matches (or no expectedEtag given).
    if (diskCache != null && url != null && url.isNotEmpty) {
      final quotedExpected = expectedEtag != null && expectedEtag.isNotEmpty
          ? (expectedEtag.startsWith('"') ? expectedEtag : '"$expectedEtag"')
          : null;
      final cachedFile =
          diskCache.getCachedFontFile(url, fam, expectedEtag: quotedExpected) ??
          (expectedEtag != null
              ? diskCache.getCachedFontFile(
                  url,
                  fam,
                  expectedEtag: expectedEtag,
                )
              : null);
      if (cachedFile != null) {
        final bytes = await cachedFile.readAsBytes();
        if (bytes.isNotEmpty) {
          _registerDiskFile(fam, cachedFile);
          _loaded[fam] = bytes;
          final storedEtag = diskCache.getCachedFontEtag(url, fam);
          if (storedEtag != null) _loadedEtags[fam] = storedEtag;
          return bytes;
        }
      }
    }

    // 2. Fetch from server (with If-None-Match if we have a cached ETag).
    final storedEtag = (diskCache != null && url != null && url.isNotEmpty)
        ? diskCache.getCachedFontEtag(url, fam)
        : _loadedEtags[fam];

    List<int>? bytes;
    String? newEtag;
    if (conditionalFetcher != null) {
      final res = await conditionalFetcher!(fam, ifNoneMatch: storedEtag);
      if (res.notModified && diskCache != null && url != null) {
        final existing = diskCache.getCachedFontFile(url, fam);
        if (existing != null) {
          final diskBytes = await existing.readAsBytes();
          if (diskBytes.isNotEmpty) {
            _registerDiskFile(fam, existing);
            _loaded[fam] = diskBytes;
            if (res.etag != null) _loadedEtags[fam] = res.etag!;
            return diskBytes;
          }
        }
      }
      bytes = res.bytes;
      newEtag = res.etag;
    } else {
      bytes = await fetcher(fam);
    }

    if (bytes == null || bytes.isEmpty) return null;

    // 3. Reinvalidate previous native registration if updating an existing font.
    final prevFile = _registeredFiles[fam];
    if (prevFile != null) {
      registrar?.unregisterFile(prevFile);
      _registeredFiles.remove(fam);
    }

    // 4. Persist to disk cache and register natively.
    if (diskCache != null && url != null && url.isNotEmpty) {
      final saved = await diskCache.saveFont(
        url,
        fam,
        bytes,
        etag: newEtag ?? expectedEtag,
      );
      if (saved != null) {
        _registerDiskFile(fam, saved);
      }
    }

    _loaded[fam] = bytes;
    final effectiveEtag = newEtag ?? expectedEtag;
    if (effectiveEtag != null && effectiveEtag.isNotEmpty) {
      _loadedEtags[fam] = effectiveEtag;
    }
    return bytes;
  }

  void _registerDiskFile(String fam, File file) {
    final prev = _registeredFiles[fam];
    if (prev != null && prev.path == file.path) return;
    if (prev != null) {
      registrar?.unregisterFile(prev);
    }
    if (registrar?.registerFile(file, declaredFamily: fam) ?? false) {
      _registeredFiles[fam] = file;
    }
  }

  /// Brings cached fonts up to date with [bundle]:
  /// - same [iconFontsHash] as last sync → no-op (returns empty);
  /// - otherwise fetches every needed/changed entry concurrently and
  ///   registers them natively.
  Future<List<String>> syncBundle(ProjectBundle bundle) {
    return syncEntries(bundle.iconFontsHash, bundle.iconFonts);
  }

  /// Entry-level sync backing [syncBundle], also used for patch-only
  /// reloads where `/manifest.json` is skipped and the entries come from
  /// `GET /icon-fonts.json` instead.
  Future<List<String>> syncEntries(
    String hash,
    List<Map<String, dynamic>> entries,
  ) async {
    if (hash.isNotEmpty && hash == _lastHash) return const [];
    _lastHash = hash;
    final needed = entries.where((entry) {
      final family = '${entry['family'] ?? ''}'.trim();
      if (family.isEmpty || isBuiltInIconFamily(family)) return false;
      final etag = entry['etag']?.toString();
      if (_loaded.containsKey(family)) {
        if (etag == null ||
            etag.isEmpty ||
            _loadedEtags[family] == etag ||
            _loadedEtags[family] == '"$etag"') {
          return false;
        }
      }
      final url = '${entry['url'] ?? ''}';
      final hasFile = entry['hasFontFile'] == true;
      return url.isNotEmpty || hasFile;
    }).toList();
    if (needed.isEmpty) return const [];
    final sw = Stopwatch()..start();
    final results = await Future.wait(
      needed.map(
        (e) => ensureLoaded(
          '${e['family']}',
          expectedEtag: e['etag']?.toString(),
        ),
      ),
    );
    final loaded = <String>[];
    for (var i = 0; i < needed.length; i++) {
      final bytes = results[i];
      if (bytes != null && bytes.isNotEmpty) {
        loaded.add('${needed[i]['family']}');
      }
    }
    DartGoLogger.bench(
      'IconFonts',
      'syncBundle',
      sw.elapsedMilliseconds,
      {
        'needed': needed.length,
        'loaded': loaded.length,
        'hash': hash.isEmpty ? 'none' : hash,
      },
    );
    return loaded;
  }

  /// Drops in-memory cached bytes (e.g. on server switch).
  void reset() {
    _loaded.clear();
    _loadedEtags.clear();
    _registeredFiles.clear();
    _inFlight.clear();
    _lastHash = '';
  }
}
