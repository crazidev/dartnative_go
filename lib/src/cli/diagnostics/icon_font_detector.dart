import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:yaml/yaml.dart';

import '../../runner/icon_registry.dart';
import '../packaging/ast_builder.dart'
    show
        cachedBundleForProject,
        detectGuestPackageName,
        findPackageConfigFile,
        resolvePackageSources;
import 'icon_annotation_scanner.dart';

/// Known icon-font families DartNative guests can request.
///
/// Built-ins ship inside the host app (no download needed); third-party and
/// custom families resolve to a `.ttf`/`.otf` served on demand by the dev
/// server (`GET /fonts/<family>.ttf`).
class IconFontFamilies {
  static const cupertino = 'CupertinoIcons';
  static const material = 'MaterialIcons';
  static const materialOutlined = 'Material Symbols Outlined';
  static const materialRounded = 'Material Symbols Rounded';
  static const materialSharp = 'Material Symbols Sharp';
  static const fontAwesome5 = 'FontAwesome5';
  static const fontAwesome6 = 'FontAwesome6';

  /// Families bundled with the host — never fetched over HTTP.
  static const builtIn = {
    cupertino,
    material,
    materialOutlined,
    materialRounded,
    materialSharp,
  };

  /// Icon-only packages whose Dart sources must NOT be bundled/parsed at
  /// runtime: their glyphs resolve via bridges + [kCupertinoIcons] etc., and
  /// their font bytes are served on demand instead.
  static const iconOnlyPackages = {
    'cupertino_icons',
    'font_awesome_flutter',
    'material_symbols_icons',
  };
}

/// One custom (non-built-in) font declared in `pubspec.yaml`.
class CustomFontDecl {
  final String family;
  final String asset;
  final int weight;

  const CustomFontDecl({
    required this.family,
    required this.asset,
    this.weight = 400,
  });

  Map<String, dynamic> toJson() => {
    'family': family,
    'asset': asset,
    if (weight != 400) 'weight': weight,
  };
}

/// Usage + font-file report for a guest project.
///
/// Produced by [IconFontDetector] on the dev server; advertised in
/// `/manifest.json` (`iconFonts`, `iconFontsHash`, `fonts`) so the device
/// fetches only the font families the guest actually touches.
class IconFontReport {
  /// family → used glyph names (as written, e.g. `plus`, `home`).
  final Map<String, Set<String>> glyphsByFamily;

  /// family → resolved code points for the used glyphs.
  final Map<String, Set<int>> codePointsByFamily;

  /// Custom fonts declared via `flutter: fonts:` in pubspec.yaml.
  final List<CustomFontDecl> customFonts;

  /// Resolved on-disk font files: family → absolute file path.
  final Map<String, String> fontFiles;

  /// Owning package per family (e.g. `cupertino_icons`), if known.
  final Map<String, String> fontPackages;

  /// Families discovered via class annotation (`@staticIconProvider`,
  /// `@IconFont`) rather than usage regex — typically external packages.
  final Set<String> annotatedFamilies;

  const IconFontReport({
    this.glyphsByFamily = const {},
    this.codePointsByFamily = const {},
    this.customFonts = const [],
    this.fontFiles = const {},
    this.fontPackages = const {},
    this.annotatedFamilies = const {},
  });

  bool get isEmpty =>
      glyphsByFamily.isEmpty &&
      customFonts.isEmpty &&
      codePointsByFamily.isEmpty;

  /// Families the guest actually uses (built-in + custom).
  Set<String> get families => {
    ...glyphsByFamily.keys,
    ...codePointsByFamily.keys,
    for (final f in customFonts) f.family,
  };

  /// Stable hash over families + glyphs + custom fonts + resolved font file
  /// timestamps/sizes. Devices compare this against the last loaded set to
  /// skip redundant font fetches on reload, and reinvalidate when a font file
  /// on disk changes.
  String get hash {
    final parts = <String>[];
    final fams = families.toList()..sort();
    for (final fam in fams) {
      final glyphs = (glyphsByFamily[fam] ?? const {}).toList()..sort();
      final cps = (codePointsByFamily[fam] ?? const {}).toList()..sort();
      var fileTag = '';
      final filePath = fontFiles[fam];
      if (filePath != null) {
        try {
          final st = File(filePath).statSync();
          fileTag = '@${st.modified.millisecondsSinceEpoch}-${st.size}';
        } catch (_) {}
      }
      parts.add('$fam$fileTag:${glyphs.join(",")}:${cps.join(",")}');
    }
    final customs = customFonts.map((f) => '${f.family}@${f.asset}').toList()
      ..sort();
    parts.addAll(customs);
    return sha256
        .convert(utf8.encode(parts.join('|')))
        .toString()
        .substring(
          0,
          16,
        );
  }

  /// Manifest payload: one entry per used family with subset + font URL + etag.
  List<Map<String, dynamic>> toManifestJson(String serverUrl) {
    final out = <Map<String, dynamic>>[];
    final fams = families.toList()..sort();
    for (final family in fams) {
      final names = ((glyphsByFamily[family] ?? const <String>{}).toList()
        ..sort());
      final cps = ((codePointsByFamily[family] ?? const <int>{}).toList()
        ..sort());
      final filePath = fontFiles[family];
      String? etag;
      if (filePath != null) {
        try {
          final st = File(filePath).statSync();
          etag = '${st.modified.millisecondsSinceEpoch}-${st.size}';
        } catch (_) {}
      }
      out.add({
        'family': family,
        'package': fontPackages[family],
        'builtIn': IconFontFamilies.builtIn.contains(family),
        'hasFontFile': filePath != null,
        'url': filePath != null
            ? '$serverUrl/fonts/${Uri.encodeComponent(family)}.ttf'
            : null,
        if (etag != null) 'etag': etag,
        'glyphCount': names.length + cps.length,
        'names': names,
        'codePoints': cps,
      });
    }
    return out;
  }

  String formatReport() {
    final buffer = StringBuffer();
    if (isEmpty) {
      buffer.writeln(
        '[FONTS] No icon-font usage detected (no Cupertino/Material/FA glyphs).',
      );
      return buffer.toString();
    }
    buffer.writeln('[FONTS] Icon-font usage:');
    final fams = families.toList()..sort();
    for (final family in fams) {
      final count =
          (glyphsByFamily[family]?.length ?? 0) +
          (codePointsByFamily[family]?.length ?? 0);
      final builtIn = IconFontFamilies.builtIn.contains(family);
      final file = fontFiles[family];
      final tag = builtIn
          ? 'built-in'
          : (file != null ? 'served on demand' : 'no .ttf found');
      final via = annotatedFamilies.contains(family) ? ' [annotated]' : '';
      buffer.writeln('   • $family: $count glyph(s) ($tag)$via');
    }
    if (customFonts.isNotEmpty) {
      buffer.writeln('   Custom fonts (${customFonts.length}):');
      for (final f in customFonts) {
        buffer.writeln('   • ${f.family} ← ${f.asset}');
      }
    }
    return buffer.toString();
  }
}

/// Detects icon-font usage and font declarations for a guest project.
///
/// Two complementary paths:
///
/// 1. **Annotation (primary for families)** — icon registries annotated
///    with the SDK's `@staticIconProvider` or the dependency-free
///    `@IconFont` are discovered from the already-parsed in-memory AST
///    bundle ([IconAnnotationScanner.scanBundle], zero re-parse cost),
///    falling back to a regex pre-scan of guest + package sources on
///    cold start. The annotation travels with the declaring class, so
///    external packages are found even when guest code never names a
///    glyph — the case pure usage regex cannot catch.
/// 2. **Usage scan** — regex over guest *and* package `.dart` sources
///    (comments/strings stripped, no analyzer parse) for
///    `CupertinoIcons.xxx`, `Icons.xxx`, `MaterialSymbols*.xxx`,
///    `FontAwesome*.xxx` and raw `IconData(... fontFamily: ...)` hits.
///    Cheap (<50 ms typical); never pays the cost of parsing the
///    1 236-entry `CupertinoIcons` class itself.
///
/// Plus **font resolution** — `flutter: fonts:` in pubspec.yaml plus
/// icon-package `.ttf` files in `.dart_tool/package_config.json` → the
/// on-disk files served via `GET /fonts/<family>.ttf`.
class IconFontDetector {
  final Directory projectDir;

  IconFontDetector(this.projectDir);

  // In-memory cache: project path → (fingerprint, report). Manifest is
  // fetched on every (re)connect; without this each fetch would rescan.
  static final Map<String, ({String fp, IconFontReport report})> _cache = {};

  /// Full detection: scan sources + resolve fonts.
  IconFontReport detect() {
    final fp = _fingerprintProject();
    final cached = _cache[projectDir.path];
    if (cached != null && cached.fp == fp) return cached.report;
    final guestPackage = detectGuestPackageName(projectDir);
    final guestSources = _readGuestSources();
    // Package sources (bounded: dev/dartnative packages skipped by
    // resolvePackageSources) catch icon usage *inside* dependencies —
    // e.g. a widget kit using its own registry internally.
    Map<String, String> packageSources;
    try {
      packageSources = resolvePackageSources(
        projectDir,
        packageName: guestPackage,
      );
    } catch (_) {
      packageSources = const {};
    }
    final usage = scanSources({...guestSources, ...packageSources});
    final customs = _readCustomFonts();
    final annotated = _scanAnnotatedIconFonts(
      guestSources,
      packageSources,
      guestPackage ?? 'guest_app',
    );
    final mergedGlyphs = Map<String, Set<String>>.from(usage.glyphsByFamily);
    final mergedCps = Map<String, Set<int>>.from(usage.codePointsByFamily);
    final mergedPackages = Map<String, String>.from(usage.fontPackages);
    final annotatedFamilies = <String>{};
    for (final a in annotated) {
      mergedGlyphs.putIfAbsent(a.family, () => <String>{});
      mergedCps.putIfAbsent(a.family, () => <int>{});
      mergedPackages.putIfAbsent(a.family, () => a.package);
      annotatedFamilies.add(a.family);
    }
    // Discover fonts declared by external packages imported in guest code
    // (e.g. `lucide_kit` declaring `dartnative: fonts: - family: Lucide`).
    final importedPkgFonts = _readImportedPackageFonts(guestSources);
    for (final entry in importedPkgFonts) {
      mergedGlyphs.putIfAbsent(entry.family, () => <String>{});
      mergedCps.putIfAbsent(entry.family, () => <int>{});
      mergedPackages.putIfAbsent(entry.family, () => entry.package);
    }
    final files = _resolveFontFiles(
      IconFontReport(
        glyphsByFamily: mergedGlyphs,
        codePointsByFamily: mergedCps,
        fontPackages: mergedPackages,
      ),
      customs,
      annotated: annotated,
      importedPackageFonts: importedPkgFonts,
    );
    // Annotation packages win for families the hardcoded map doesn't know.
    for (final a in annotated) {
      mergedPackages.putIfAbsent(a.family, () => a.package);
    }
    final report = IconFontReport(
      glyphsByFamily: mergedGlyphs,
      codePointsByFamily: mergedCps,
      customFonts: customs,
      fontFiles: files.files,
      fontPackages: {...files.packages, ...mergedPackages},
      annotatedFamilies: annotatedFamilies,
    );
    _cache[projectDir.path] = (fp: fp, report: report);
    return report;
  }

  /// Discovers annotated icon registries, preferring the precise bundle
  /// scan (free: reuses the builder's in-memory bundle) over the cold-
  /// start regex pre-scan. Never throws.
  Set<AnnotatedIconFont> _scanAnnotatedIconFonts(
    Map<String, String> guestSources,
    Map<String, String> packageSources,
    String guestPackage,
  ) {
    try {
      final bundle = cachedBundleForProject(projectDir);
      if (bundle != null) {
        return IconAnnotationScanner.scanBundle(
          bundle,
          defaultPackage: guestPackage,
        );
      }
    } catch (_) {}
    // Cold start (no build yet): regex pre-scan over guest sources
    // (re-keyed to module URIs) plus package sources.
    try {
      final searchSources = <String, String>{};
      for (final entry in guestSources.entries) {
        searchSources[_guestModuleUri(entry.key, guestPackage)] = entry.value;
      }
      searchSources.addAll(packageSources);
      final found = IconAnnotationScanner.findAnnotatedClasses(searchSources);
      final out = <AnnotatedIconFont>{};
      for (final e in found.entries) {
        for (final className in e.value) {
          final family = IconAnnotationScanner.familyForClass(
            className,
            explicitFamily: IconAnnotationScanner.findIconFontFamily(
              searchSources[e.key] ?? '',
              className,
            ),
          );
          out.add(
            AnnotatedIconFont(
              className: className,
              moduleUri: e.key,
              package: _packageOfUri(e.key, guestPackage),
              family: family,
              fontAsset: null,
            ),
          );
        }
      }
      return out;
    } catch (_) {
      return const {};
    }
  }

  static String _packageOfUri(String moduleUri, String guestPackage) {
    try {
      final uri = Uri.parse(moduleUri);
      if (uri.isScheme('package') && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
    } catch (_) {}
    return guestPackage;
  }

  String _guestModuleUri(String absolutePath, String guestPackage) {
    final norm = absolutePath.replaceAll(r'\', '/');
    for (final rootName in ['lib', 'guest_app']) {
      final marker = '${projectDir.path}/$rootName/'.replaceAll(r'\', '/');
      if (norm.startsWith(marker)) {
        final rel = norm.substring(marker.length);
        if (rootName == 'lib') return 'package:$guestPackage/$rel';
        return rel;
      }
    }
    return norm;
  }

  /// Resolves a served `/fonts/<family>.ttf` request to an on-disk file.
  ///
  /// Returns null for built-ins without a resolvable `.ttf` (host already
  /// bundles them) and for unknown families — callers answer 404.
  File? resolveFontFile(String family) {
    final decoded = Uri.decodeComponent(family);
    final report = detect();
    final path = report.fontFiles[decoded];
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) return file;
    }
    // Fallback: direct lookup without a cached scan (e.g. first request
    // raced the manifest). Never throws.
    try {
      final customs = _readCustomFonts();
      for (final c in customs) {
        if (c.family == decoded) {
          final f = File('${projectDir.path}/${c.asset}');
          if (f.existsSync()) return f;
        }
      }
      final fromPkg = _findPackageFont(decoded);
      if (fromPkg != null) return fromPkg;
    } catch (_) {}
    return null;
  }

  /// Scans in-memory sources (path → content) for icon usage.
  ///
  /// Pure/static — also used by tests and (via [detect]) by the server.
  static IconFontReport scanSources(Map<String, String> sources) {
    final glyphs = <String, Set<String>>{};
    final codePoints = <String, Set<int>>{};
    final fontPackages = <String, String>{};

    void addGlyph(String family, String name) {
      final norm = name.trim();
      if (norm.isEmpty) return;
      glyphs.putIfAbsent(family, () => <String>{}).add(norm);
    }

    void addCodePoint(String family, int cp) {
      codePoints.putIfAbsent(family, () => <int>{}).add(cp);
    }

    for (final content in sources.values) {
      final clean = _stripCommentsAndStrings(content);
      final noComments = _stripCommentsOnly(content);
      for (final m in _cupertinoPattern.allMatches(clean)) {
        addGlyph(IconFontFamilies.cupertino, m.group(1)!);
      }
      for (final m in _materialPattern.allMatches(clean)) {
        addGlyph(IconFontFamilies.material, m.group(1)!);
      }
      for (final m in _symbolsOutlinedPattern.allMatches(clean)) {
        addGlyph(IconFontFamilies.materialOutlined, m.group(1)!);
      }
      for (final m in _symbolsRoundedPattern.allMatches(clean)) {
        addGlyph(IconFontFamilies.materialRounded, m.group(1)!);
      }
      for (final m in _symbolsSharpPattern.allMatches(clean)) {
        addGlyph(IconFontFamilies.materialSharp, m.group(1)!);
      }
      for (final m in _faPattern.allMatches(clean)) {
        final raw = m.group(1)!;
        final family = raw.toLowerCase().contains('6')
            ? IconFontFamilies.fontAwesome6
            : IconFontFamilies.fontAwesome5;
        addGlyph(family, m.group(2)!);
      }
      // Raw IconData(0xF489, fontFamily: 'CupertinoIcons', fontPackage: '…')
      // NOTE: runs on comment-stripped (but string-preserving) source —
      // _stripCommentsAndStrings blanks string literals, which would erase
      // the fontFamily value itself.
      for (final m in _iconDataCpFirst.allMatches(noComments)) {
        final cpStr = m.group(1)!;
        final fam = (m.group(2) ?? '').trim();
        final cp = cpStr.startsWith('0x') || cpStr.startsWith('0X')
            ? int.tryParse(cpStr.substring(2), radix: 16)
            : int.tryParse(cpStr);
        if (cp == null) continue;
        final resolvedFam = fam.isEmpty ? IconFontFamilies.cupertino : fam;
        addCodePoint(resolvedFam, cp);
        final fullMatch = m.group(0) ?? '';
        final pkgMatch = _fontPackagePattern.firstMatch(fullMatch);
        if (pkgMatch != null) {
          final pkg = pkgMatch.group(1)!.trim();
          if (pkg.isNotEmpty) fontPackages.putIfAbsent(resolvedFam, () => pkg);
        }
      }
      for (final m in _iconDataFamFirst.allMatches(noComments)) {
        final fam = (m.group(1) ?? '').trim();
        final cpStr = m.group(2)!;
        final cp = cpStr.startsWith('0x') || cpStr.startsWith('0X')
            ? int.tryParse(cpStr.substring(2), radix: 16)
            : int.tryParse(cpStr);
        if (cp == null) continue;
        final resolvedFam = fam.isEmpty ? IconFontFamilies.cupertino : fam;
        addCodePoint(resolvedFam, cp);
      }
      // fontFamily: 'SomeCustomFont' — counted as usage even without a
      // resolvable IconData, so custom text/icon fonts are preloaded.
      // Same string-preservation note as above.
      for (final m in _fontFamilyPattern.allMatches(noComments)) {
        final fam = m.group(1)!.trim();
        if (fam.isEmpty || fam == 'inherit') continue;
        glyphs.putIfAbsent(fam, () => <String>{});
        codePoints.putIfAbsent(fam, () => <int>{});
      }
    }

    // Attach resolved code points for known glyph names so the manifest
    // carries a concrete subset (device can skip parsing the full class).
    final resolved = <String, Set<int>>{};
    glyphs.forEach((family, names) {
      for (final name in names) {
        final cp = _resolveCodePoint(family, name);
        if (cp != null) {
          resolved.putIfAbsent(family, () => <int>{}).add(cp);
        }
      }
    });
    resolved.forEach((family, cps) {
      codePoints.putIfAbsent(family, () => <int>{}).addAll(cps);
    });

    return IconFontReport(
      glyphsByFamily: glyphs,
      codePointsByFamily: codePoints,
      fontPackages: fontPackages,
    );
  }

  // -- patterns -----------------------------------------------------------

  static final _cupertinoPattern = RegExp(r'\bCupertinoIcons\.([A-Za-z0-9_]+)');
  static final _materialPattern = RegExp(r'\bIcons\.([A-Za-z0-9_]+)');
  static final _symbolsOutlinedPattern = RegExp(
    r'\bMaterialSymbolsOutlined\.([A-Za-z0-9_]+)',
  );
  static final _symbolsRoundedPattern = RegExp(
    r'\bMaterialSymbolsRounded\.([A-Za-z0-9_]+)',
  );
  static final _symbolsSharpPattern = RegExp(
    r'\bMaterialSymbolsSharp\.([A-Za-z0-9_]+)',
  );
  static final _faPattern = RegExp(
    r'\b(FontAwesome(?:5|6)?|FaIcon|FontAwesomeIcons)\.([A-Za-z0-9_]+)',
  );
  static final _iconDataCpFirst = RegExp(
    "IconData\\(\\s*(0[xX][0-9a-fA-F]+|\\d+)[^)]*?fontFamily\\s*:\\s*['\"]([^'\"]+)['\"][^)]*\\)",
  );
  static final _fontPackagePattern = RegExp(
    r'''fontPackage\s*:\s*['"]([^'"]+)['"]''',
  );
  static final _packageImportPattern = RegExp(
    r'''(?:import|export)\s+['"]package:([a-zA-Z0-9_]+)/''',
  );
  static final _iconDataFamFirst = RegExp(
    "fontFamily\\s*:\\s*['\"]([^'\"]+)['\"][^)]*?IconData\\(\\s*(0[xX][0-9a-fA-F]+|\\d+)",
  );
  static final _fontFamilyPattern = RegExp(
    r'''fontFamily\s*:\s*['"]([^'"]+)['"]''',
  );

  static String _stripCommentsAndStrings(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ')
        .replaceAll(RegExp(r'//.*'), ' ')
        .replaceAll(RegExp(r"'''[\s\S]*?'''"), "''")
        .replaceAll(RegExp(r'"""[\s\S]*?"""'), '""')
        .replaceAll(RegExp(r"'([^'\\]|\\.)*'"), "''")
        .replaceAll(RegExp(r'"([^"\\]|\\.)*"'), '""');
  }

  static String _stripCommentsOnly(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ')
        .replaceAll(RegExp(r'//.*'), ' ');
  }

  static int? _resolveCodePoint(String family, String name) {
    final norm = name.toLowerCase().replaceAll('-', '_');
    switch (family) {
      case IconFontFamilies.cupertino:
        return kCupertinoIcons[norm];
      case IconFontFamilies.material:
        return kMaterialSymbolsIcons[norm];
      case IconFontFamilies.materialOutlined:
      case IconFontFamilies.materialRounded:
      case IconFontFamilies.materialSharp:
        return kMaterialSymbolsIcons[norm];
      case IconFontFamilies.fontAwesome5:
      case IconFontFamilies.fontAwesome6:
        return kFontAwesome5Icons[norm];
      default:
        return kCupertinoIcons[norm] ??
            kMaterialSymbolsIcons[norm] ??
            kFontAwesome5Icons[norm];
    }
  }

  // -- project I/O --------------------------------------------------------

  Map<String, String> _readGuestSources() {
    final out = <String, String>{};
    for (final rootName in ['lib', 'guest_app']) {
      final root = Directory('${projectDir.path}/$rootName');
      if (!root.existsSync()) continue;
      try {
        for (final entity in root.listSync(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            try {
              out[entity.path] = entity.readAsStringSync();
            } catch (_) {}
          }
        }
      } catch (_) {}
    }
    return out;
  }

  String _fingerprintProject() {
    try {
      final hash = sha256.convert(
        utf8.encode(_collectFingerprintInputs().join('|')),
      );
      return hash.toString().substring(0, 16);
    } catch (_) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  List<String> _collectFingerprintInputs() {
    final inputs = <String>[];
    final pubspec = File('${projectDir.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      try {
        inputs.add(
          'pubspec.yaml:${pubspec.lastModifiedSync().millisecondsSinceEpoch}',
        );
      } catch (_) {}
    }
    final pkgConfig = findPackageConfigFile(projectDir);
    if (pkgConfig != null && pkgConfig.existsSync()) {
      try {
        inputs.add(
          'package_config.json:${pkgConfig.lastModifiedSync().millisecondsSinceEpoch}',
        );
      } catch (_) {}
    }
    for (final rootName in ['lib', 'guest_app']) {
      final root = Directory('${projectDir.path}/$rootName');
      if (!root.existsSync()) continue;
      try {
        final files =
            root
                .listSync(recursive: true)
                .whereType<File>()
                .where((f) => f.path.endsWith('.dart'))
                .toList()
              ..sort((a, b) => a.path.compareTo(b.path));
        for (final f in files) {
          try {
            inputs.add(
              '${f.path}:${f.lastModifiedSync().millisecondsSinceEpoch}',
            );
          } catch (_) {}
        }
      } catch (_) {}
    }
    for (final custom in _readCustomFonts()) {
      if (custom.asset.isEmpty) continue;
      final f = File('${projectDir.path}/${custom.asset}');
      if (f.existsSync()) {
        try {
          final st = f.statSync();
          inputs.add(
            '${custom.asset}:${st.modified.millisecondsSinceEpoch}-${st.size}',
          );
        } catch (_) {}
      }
    }
    return inputs;
  }

  List<CustomFontDecl> _readCustomFonts([Directory? dir]) {
    final targetDir = dir ?? projectDir;
    final pubspec = File('${targetDir.path}/pubspec.yaml');
    if (!pubspec.existsSync()) return const [];
    try {
      final content = pubspec.readAsStringSync();
      final yaml = loadYaml(content);
      if (yaml is! YamlMap) return const [];
      final flutter = yaml['flutter'];
      final dartnative = yaml['dartnative'];
      final fonts =
          (dartnative is YamlMap ? dartnative['fonts'] : null) ??
          (flutter is YamlMap ? flutter['fonts'] : null);
      if (fonts is! YamlList) return const [];
      final out = <CustomFontDecl>[];
      for (final entry in fonts) {
        if (entry is! YamlMap) continue;
        final family = entry['family']?.toString();
        if (family == null || family.isEmpty) continue;
        final fontList = entry['fonts'];
        if (fontList is YamlList) {
          for (final f in fontList) {
            if (f is YamlMap && f['asset'] != null) {
              out.add(
                CustomFontDecl(
                  family: family,
                  asset: f['asset'].toString(),
                  weight: int.tryParse('${f['weight'] ?? 400}') ?? 400,
                ),
              );
            }
          }
        } else {
          out.add(CustomFontDecl(family: family, asset: ''));
        }
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  /// Discovers fonts declared in `pubspec.yaml` (`dartnative.fonts` or
  /// `flutter.fonts`) of external packages imported by [guestSources].
  List<({String package, String family, String filePath})>
  _readImportedPackageFonts(Map<String, String> guestSources) {
    final importedPackages = <String>{};
    for (final source in guestSources.values) {
      final noComments = _stripCommentsOnly(source);
      for (final m in _packageImportPattern.allMatches(noComments)) {
        final pkg = m.group(1);
        if (pkg != null && pkg.isNotEmpty) importedPackages.add(pkg);
      }
    }
    if (importedPackages.isEmpty) return const [];
    final out = <({String package, String family, String filePath})>[];
    for (final pkg in importedPackages) {
      if (pkg == 'dartnative' || pkg == 'flutter' || pkg == 'dartnative_go') {
        continue;
      }
      final root = _packageRootDir(pkg);
      if (root == null) continue;
      final decls = _readCustomFonts(root);
      for (final decl in decls) {
        if (decl.asset.isEmpty) continue;
        final file = File('${root.path}/${decl.asset}');
        if (file.existsSync()) {
          out.add((
            package: pkg,
            family: decl.family,
            filePath: file.path,
          ));
        }
      }
    }
    return out;
  }

  ({Map<String, String> files, Map<String, String> packages}) _resolveFontFiles(
    IconFontReport usage,
    List<CustomFontDecl> customs, {
    Set<AnnotatedIconFont> annotated = const {},
    List<({String package, String family, String filePath})>
        importedPackageFonts =
        const [],
  }) {
    final files = <String, String>{};
    final packages = <String, String>{};

    // 1. Imported external package fonts declared in their pubspec.yaml.
    for (final entry in importedPackageFonts) {
      files.putIfAbsent(entry.family, () => entry.filePath);
      packages.putIfAbsent(entry.family, () => entry.package);
    }

    // 2. Families detected via usage or IconData(fontPackage: ...).
    for (final family in usage.families) {
      if (files.containsKey(family)) continue;
      final declaredPkg = usage.fontPackages[family];
      if (declaredPkg != null && declaredPkg.isNotEmpty) {
        final root = _packageRootDir(declaredPkg);
        if (root != null) {
          for (final decl in _readCustomFonts(root)) {
            if (decl.family == family && decl.asset.isNotEmpty) {
              final f = File('${root.path}/${decl.asset}');
              if (f.existsSync()) {
                files[family] = f.path;
                break;
              }
            }
          }
          if (!files.containsKey(family)) {
            final found = _findFontInDir(root, family);
            if (found != null) files[family] = found.path;
          }
        }
        packages[family] = declaredPkg;
        continue;
      }
      final found = _findPackageFont(family);
      if (found != null) {
        files[family] = found.path;
        final pkg = _packageForFamily(family);
        if (pkg != null) packages[family] = pkg;
      } else {
        final pkg = _packageForFamily(family);
        if (pkg != null) packages[family] = pkg;
      }
    }

    // Annotated registries: explicit fontAsset hints first, then a
    // package-wide search — works for any package, no hardcoded list.
    for (final a in annotated) {
      if (a.fontAsset != null && a.fontAsset!.isNotEmpty) {
        final root = _packageRootDir(a.package);
        if (root != null) {
          final hinted = File('${root.path}/${a.fontAsset}');
          if (hinted.existsSync()) {
            files.putIfAbsent(a.family, () => hinted.path);
          }
        }
      }
      if (!files.containsKey(a.family)) {
        final found = _findFontInPackage(a.package, a.family);
        if (found != null) files[a.family] = found.path;
      }
      packages.putIfAbsent(a.family, () => a.package);
    }

    for (final custom in customs) {
      if (custom.asset.isEmpty) continue;
      final file = File('${projectDir.path}/${custom.asset}');
      if (file.existsSync()) {
        files.putIfAbsent(custom.family, () => file.path);
      }
    }
    return (files: files, packages: packages);
  }

  String? _packageForFamily(String family) {
    switch (family) {
      case IconFontFamilies.cupertino:
        return 'cupertino_icons';
      case IconFontFamilies.fontAwesome5:
      case IconFontFamilies.fontAwesome6:
        return 'font_awesome_flutter';
      case IconFontFamilies.material:
      case IconFontFamilies.materialOutlined:
      case IconFontFamilies.materialRounded:
      case IconFontFamilies.materialSharp:
        return 'flutter';
      default:
        return null;
    }
  }

  File? _findPackageFont(String family) {
    final pkg = _packageForFamily(family);
    if (pkg == null || pkg == 'flutter') return null;
    return _findFontInPackage(pkg, family);
  }

  /// Searches [packageName]'s root (via `.dart_tool/package_config.json`)
  /// for a font file matching [family]. Package-agnostic: no hardcoded
  /// family list, so annotated external registries resolve too.
  File? _findFontInPackage(String packageName, String family) {
    final rootDir = _packageRootDir(packageName);
    if (rootDir == null) return null;
    return _findFontInDir(rootDir, family);
  }

  /// Resolves a package's on-disk root, or null when unknown. Never throws.
  /// Walks up parent directories so Dart workspace members (e.g. `example/`)
  /// find the workspace `.dart_tool/package_config.json`.
  Directory? _packageRootDir(String packageName) {
    try {
      final configFile = findPackageConfigFile(projectDir);
      if (configFile == null || !configFile.existsSync()) return null;
      final json =
          jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
      final packages = json['packages'] as List<dynamic>?;
      if (packages == null) return null;
      final baseUri = configFile.uri;
      for (final entry in packages) {
        if (entry is! Map<String, dynamic>) continue;
        if (entry['name'] != packageName) continue;
        final rawRoot = entry['rootUri'] as String?;
        if (rawRoot == null) continue;
        final rootUri = baseUri.resolve(
          rawRoot.endsWith('/') ? rawRoot : '$rawRoot/',
        );
        final rootDir = Directory.fromUri(rootUri);
        if (rootDir.existsSync()) return rootDir;
      }
    } catch (_) {}
    return null;
  }

  File? _findFontInDir(Directory root, String family) {
    try {
      final want = family.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
      File? fallback;
      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File) continue;
        final fileName = entity.path.split(Platform.pathSeparator).last;
        // Skip hidden files and macOS AppleDouble resource forks (e.g. ._lucide.ttf).
        if (fileName.startsWith('.')) continue;
        final p = fileName.toLowerCase();
        if (!(p.endsWith('.ttf') ||
            p.endsWith('.otf') ||
            p.endsWith('.woff') ||
            p.endsWith('.woff2'))) {
          continue;
        }
        final base = p.replaceAll(RegExp(r'\.(ttf|otf|woff2?)$'), '');
        if (base.contains(want) || want.contains(base)) return entity;
        fallback ??= entity;
      }
      return fallback;
    } catch (_) {
      return null;
    }
  }
}
