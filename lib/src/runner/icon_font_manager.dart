import 'dart:async';

import 'bundle_loader.dart';
import 'icon_registry.dart';
import 'logger.dart';

/// On-device tracker for on-demand icon fonts.
///
/// The dev server advertises only the families the guest touches
/// (`ProjectBundle.iconFonts` + `iconFontsHash`); this manager fetches each
/// non-built-in family's bytes **once** via [BundleLoader.fetchFontBytes]
/// and caches them in memory. Built-ins (Cupertino/Material — see
/// [kBuiltInIconFamilies]) short-circuit: they ship inside the host shell,
/// so no HTTP request is ever made for them.
///
/// Pure Dart (no `dart:ui`/`flutter`): when the dartnative SDK gains a
/// runtime font-registration API, call [fontBytes] there. Until then the
/// manager still delivers the core win — unrequested fonts are never
/// downloaded, and repeat reloads with an unchanged [iconFontsHash] fetch
/// nothing at all.
///
/// The [fetcher] seam keeps this unit-testable without HTTP.
class IconFontManager {
  final Future<List<int>?> Function(String family) fetcher;

  /// family → downloaded font bytes (non-built-ins only).
  final Map<String, List<int>> _loaded = {};

  /// Families currently being fetched (dedupes concurrent requests).
  final Map<String, Future<List<int>?>> _inFlight = {};

  /// Last applied [ProjectBundle.iconFontsHash]; [syncBundle] no-ops when
  /// the hash matches, so steady-state reloads cost zero font traffic.
  String _lastHash = '';

  IconFontManager({required this.fetcher});

  /// Creates a manager backed by [loader] against [serverUrl].
  factory IconFontManager.fromLoader(
    BundleLoader loader,
    String serverUrl,
  ) {
    final base = BundleLoader.normalizeUrl(serverUrl);
    return IconFontManager(
      fetcher: (family) => loader.fetchFontBytes(base, family),
    );
  }

  /// Families with cached bytes (fetch-complete, non-built-in).
  Set<String> get loadedFamilies => Set<String>.of(_loaded.keys);

  /// Last synced manifest hash (empty before the first [syncBundle]).
  String get lastHash => _lastHash;

  /// Cached bytes for [family], or null when not (yet) fetched.
  List<int>? fontBytes(String family) => _loaded[family.trim()];

  /// True when [family] needs no work: built-in, or already cached.
  bool isReady(String family) {
    final fam = family.trim();
    if (fam.isEmpty) return true;
    if (isBuiltInIconFamily(fam)) return true;
    return _loaded.containsKey(fam);
  }

  /// Families in [bundle] that require a download: non-built-in, advertised
  /// with a font `url`, and not already cached.
  List<Map<String, dynamic>> neededFonts(ProjectBundle bundle) {
    return bundle.iconFonts.where((entry) {
      final family = '${entry['family'] ?? ''}'.trim();
      if (family.isEmpty || isBuiltInIconFamily(family)) return false;
      if (_loaded.containsKey(family)) return false;
      final url = '${entry['url'] ?? ''}';
      final hasFile = entry['hasFontFile'] == true;
      return url.isNotEmpty || hasFile;
    }).toList();
  }

  /// Ensures [family] is fetched (built-ins resolve immediately).
  /// Concurrent callers share one fetch. Never throws — returns null when
  /// the server has no such font (404) or the fetch fails.
  Future<List<int>?> ensureLoaded(String family) {
    final fam = family.trim();
    if (fam.isEmpty || isBuiltInIconFamily(fam)) return Future.value(const []);
    final cached = _loaded[fam];
    if (cached != null) return Future.value(cached);
    final flight = _inFlight[fam];
    if (flight != null) return flight;
    final future = fetcher(fam).then((bytes) {
      _inFlight.remove(fam);
      if (bytes != null && bytes.isNotEmpty) _loaded[fam] = bytes;
      return bytes;
    }).catchError((_) => null);
    _inFlight[fam] = future;
    return future;
  }

  /// Brings cached fonts up to date with [bundle]:
  /// - same [iconFontsHash] as last sync → no-op (returns empty);
  /// - otherwise fetches every [neededFonts] entry concurrently.
  ///
  /// Returns the families successfully loaded by this call. Never throws.
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
      if (_loaded.containsKey(family)) return false;
      final url = '${entry['url'] ?? ''}';
      final hasFile = entry['hasFontFile'] == true;
      return url.isNotEmpty || hasFile;
    }).toList();
    if (needed.isEmpty) return const [];
    final sw = Stopwatch()..start();
    final results = await Future.wait(
      needed.map((e) => ensureLoaded('${e['family']}')),
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

  /// Drops cached bytes (e.g. on server switch). In-flight fetches still
  /// complete but their results are discarded by key mismatch — callers
  /// should re-[syncBundle] afterwards.
  void reset() {
    _loaded.clear();
    _inFlight.clear();
    _lastHash = '';
  }
}
