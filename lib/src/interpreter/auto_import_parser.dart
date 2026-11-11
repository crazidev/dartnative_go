/// Represents a parsed import or export directive.
class ImportDirectiveInfo {
  final String uri;
  final String? prefix;
  final List<String> showList;
  final List<String> hideList;

  const ImportDirectiveInfo({
    required this.uri,
    this.prefix,
    this.showList = const [],
    this.hideList = const [],
  });

  @override
  String toString() {
    final buffer = StringBuffer("import '$uri'");
    if (prefix != null) buffer.write(' as $prefix');
    if (showList.isNotEmpty) buffer.write(' show ${showList.join(', ')}');
    if (hideList.isNotEmpty) buffer.write(' hide ${hideList.join(', ')}');
    buffer.write(';');
    return buffer.toString();
  }
}

/// Rewrites [source] to instrument breakpoints on [targetLines].
///
/// Injected by the Source entrypoint so this library stays analyzer-free.
typedef BreakpointInstrumenter =
    String Function(
      String source,
      String fileName,
      Set<int> targetLines,
    );

/// Advanced Auto Import & Dependency Graph Parser for interpreted DartNative apps.
///
/// Handles:
/// 1. Extraction of existing `import` and `export` directives.
/// 2. Automatic injection of missing framework imports (`package:dartnative/dartnative.dart`).
/// 3. Standard library auto-imports (`dart:math`, `dart:async`).
/// 4. Project-wide symbol indexing and cross-file auto-import resolution.
/// 5. Virtual relative path normalization and multi-key URI alias mapping.
class AutoImportParser {
  /// Known core DartNative framework symbols that require `package:dartnative/dartnative.dart`.
  static const Set<String> dartNativeSymbols = {
    'Widget',
    'StatefulWidget',
    'StatelessWidget',
    'State',
    'BuildContext',
    'Key',
    'ValueKey',
    'GlobalKey',
    'Scaffold',
    'AppBar',
    'AppBarIOSConfig',
    'BarButtonItem',
    'CupertinoIcons',
    'Container',
    'Column',
    'Row',
    'Center',
    'SizedBox',
    'Expanded',
    'Padding',
    'Text',
    'TextStyle',
    'FontWeight',
    'FontStyle',
    'TextAlign',
    'Button',
    'ButtonVariant',
    'Color',
    'Brightness',
    'EdgeInsets',
    'Alignment',
    'BorderRadius',
    'BoxDecoration',
    'GestureDetector',
    'InkWell',
    'ListView',
    'SingleChildScrollView',
    'Stack',
    'Positioned',
    'Icon',
    'Icons',
    'Navigator',
    'Theme',
    'ThemeData',
    'MaterialApp',
    'CupertinoApp',
    'debugger',
    'breakpoint',
    '__debugBreakpoint',
  };

  /// Dart Math symbols.
  static const Set<String> dartMathSymbols = {
    'Random',
    'min',
    'max',
    'pi',
    'e',
    'sqrt',
    'sin',
    'cos',
    'tan',
    'atan2',
  };

  /// Dart Async symbols.
  static const Set<String> dartAsyncSymbols = {
    'Timer',
    'Completer',
    'StreamController',
    'StreamSubscription',
    'Future',
    'Stream',
  };

  /// DartNative Media Picker symbols.
  static const Set<String> dartMediaPickerSymbols = {
    'showMediaPicker',
    'MediaPickerType',
    'MediaFile',
  };

  /// DartNative Share symbols.
  static const Set<String> dartShareSymbols = {
    'Share',
    'ShareResult',
    'ShareResultStatus',
  };

  static final RegExp _importExportRegex = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"](?:\s+as\s+([a-zA-Z0-9_$]+))?(?:\s+show\s+([^;]+))?(?:\s+hide\s+([^;]+))?\s*;''',
    multiLine: true,
  );

  static final RegExp _classDeclarationRegex = RegExp(
    r'''(?:class|enum|mixin|typedef)\s+([A-Za-z0-9_$]+)''',
  );

  /// Parses all import URIs from a Dart source string.
  static List<ImportDirectiveInfo> parseDirectives(String source) {
    final list = <ImportDirectiveInfo>[];
    for (final match in _importExportRegex.allMatches(source)) {
      final uri = match.group(1);
      if (uri != null) {
        final prefix = match.group(2);
        final showStr = match.group(3);
        final hideStr = match.group(4);
        list.add(
          ImportDirectiveInfo(
            uri: uri,
            prefix: prefix,
            showList: showStr != null
                ? showStr
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList()
                : const [],
            hideList: hideStr != null
                ? hideStr
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList()
                : const [],
          ),
        );
      }
    }
    return list;
  }

  /// Extracts top-level declared class/enum/mixin names from Dart source.
  static Set<String> extractDeclaredSymbols(String source) {
    final symbols = <String>{};
    for (final match in _classDeclarationRegex.allMatches(source)) {
      final sym = match.group(1);
      if (sym != null) symbols.add(sym);
    }
    return symbols;
  }

  /// Builds an index mapping symbol name -> defining file path from project sources.
  static Map<String, String> buildSymbolIndex(
    Map<String, String> projectFiles,
  ) {
    final index = <String, String>{};
    projectFiles.forEach((path, code) {
      if (path.startsWith('package:') || path.startsWith('file:///')) return;
      final declared = extractDeclaredSymbols(code);
      for (final sym in declared) {
        index[sym] = path;
      }
    });
    return index;
  }

  /// Strips comments and string literals so identifier matching does not falsely match words in comments/strings.
  static String stripCommentsAndStrings(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ')
        .replaceAll(RegExp(r'//.*'), ' ')
        .replaceAll(RegExp(r"'''[\s\S]*?'''"), "''")
        .replaceAll(RegExp(r'"""[\s\S]*?"""'), '""')
        .replaceAll(RegExp(r"'([^'\\]|\\.)*'"), "''")
        .replaceAll(RegExp(r'"([^"\\]|\\.)*"'), '""');
  }

  /// Checks source code and automatically injects missing framework & project imports.
  ///
  /// Returns the enhanced source code.
  static String processAndAutoImport(
    String source, {
    String? currentFilePath,
    Map<String, String>? projectFiles,
  }) {
    final existingDirectives = parseDirectives(source);
    final existingUris = existingDirectives.map((d) => d.uri).toSet();
    final cleanCode = stripCommentsAndStrings(source);

    final importsToAdd = <String>{};

    // 1. Check for DartNative framework symbols
    final hasDartNativeImport = existingUris.any(
      (uri) =>
          uri == 'package:dartnative/dartnative.dart' ||
          uri == 'package:dartnative/flutter_compat.dart' ||
          uri == 'package:flutter/material.dart' ||
          uri.endsWith('dartnative.dart'),
    );

    if (!hasDartNativeImport) {
      final usesDartNative = dartNativeSymbols.any(
        (sym) => RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(cleanCode),
      );
      if (usesDartNative) {
        importsToAdd.add("import 'package:dartnative/dartnative.dart';");
      }
    }

    // 2. Check for dart:math
    if (!existingUris.contains('dart:math')) {
      final usesMath = dartMathSymbols.any(
        (sym) => RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(cleanCode),
      );
      if (usesMath) {
        importsToAdd.add("import 'dart:math';");
      }
    }

    // 3. Check for dart:async
    if (!existingUris.contains('dart:async')) {
      final usesAsync = dartAsyncSymbols.any(
        (sym) => RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(cleanCode),
      );
      if (usesAsync) {
        importsToAdd.add("import 'dart:async';");
      }
    }

    // 5. Check for dartnative_share
    if (!existingUris.any((u) => u.contains('dartnative_share'))) {
      final usesShare = dartShareSymbols.any(
        (sym) => RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(cleanCode),
      );
      if (usesShare) {
        importsToAdd.add(
          "import 'package:dartnative_share/dartnative_share.dart';",
        );
      }
    }

    // 6. Check for project-wide symbols from other files
    if (projectFiles != null && currentFilePath != null) {
      final symbolIndex = buildSymbolIndex(projectFiles);
      symbolIndex.forEach((symbol, definingPath) {
        if (definingPath != currentFilePath) {
          // If the symbol is referenced in clean source (not comment or string)
          final isReferenced = RegExp(
            r'\b' + RegExp.escape(symbol) + r'\b',
          ).hasMatch(cleanCode);
          if (isReferenced) {
            // Check if defining file or symbol is already imported
            final relImportPath = computeRelativePath(
              currentFilePath,
              definingPath,
            );
            final alreadyImported = existingUris.any(
              (uri) =>
                  uri == relImportPath ||
                  uri == definingPath ||
                  uri.endsWith(definingPath),
            );

            if (!alreadyImported) {
              importsToAdd.add("import '$relImportPath';");
            }
          }
        }
      });
    }

    if (importsToAdd.isEmpty) {
      return source;
    }

    final importsText = importsToAdd.join('\n');

    // 1. Check if there is a library directive (must appear before imports)
    final libraryMatch = RegExp(
      r'^[ \t]*library(?:\s+[a-zA-Z0-9_.]+)?\s*;',
      multiLine: true,
    ).firstMatch(source);

    if (libraryMatch != null) {
      final insertIndex = libraryMatch.end;
      final before = source.substring(0, insertIndex);
      final after = source.substring(insertIndex);
      return '$before\n\n$importsText\n$after';
    }

    // 2. Check if there is a shebang line
    if (source.startsWith('#!')) {
      final firstNewline = source.indexOf('\n');
      if (firstNewline != -1) {
        final shebang = source.substring(0, firstNewline + 1);
        final rest = source.substring(firstNewline + 1);
        return '$shebang\n$importsText\n\n$rest';
      }
    }

    // 3. Otherwise prepend at the top
    return '$importsText\n\n$source';
  }

  /// Normalizes and generates all virtual alias paths for a given file.
  ///
  /// Examples for `components/button.dart`:
  /// - `components/button.dart`
  /// - `package:guest_app/components/button.dart`
  /// - `file:///components/button.dart`
  /// - `file:///guest_app/components/button.dart`
  /// - `./components/button.dart`
  static Map<String, String> buildVirtualSourceMap(
    Map<String, String> rawFiles, {
    String? packageName,
    Map<String, Set<int>>? breakpointsByFile,
    BreakpointInstrumenter? breakpointInstrumenter,
  }) {
    final result = <String, String>{};

    // Collect all valid package name aliases
    final packageNames = <String>{'guest_app'};
    if (packageName != null && packageName.trim().isNotEmpty) {
      packageNames.add(packageName.trim());
    }

    // Auto-discover any imported package name from raw files
    final importRegex = RegExp(
      r'''(?:import|export)\s+['"]package:([a-zA-Z0-9_]+)/''',
    );
    for (final content in rawFiles.values) {
      for (final match in importRegex.allMatches(content)) {
        final pkg = match.group(1);
        if (pkg != null &&
            pkg != 'dartnative' &&
            !pkg.startsWith('dartnative_') &&
            pkg != 'flutter' &&
            pkg != 'analyzer') {
          packageNames.add(pkg);
        }
      }
    }

    // First pass: breakpoint instrumentation & auto-import processing on all files
    final processedFiles = <String, String>{};
    rawFiles.forEach((path, content) {
      if (path.startsWith('package:')) {
        processedFiles[path] = content;
        return;
      }
      final normalized = path.startsWith('/') ? path.substring(1) : path;
      final cleanFile = normalized.replaceAll(r'\', '/');
      final baseFile = cleanFile.contains('/')
          ? cleanFile.split('/').last
          : cleanFile;

      final targetLines =
          (breakpointsByFile?[normalized] ??
          breakpointsByFile?[baseFile] ??
          breakpointsByFile?[cleanFile] ??
          const <int>{});

      final instrumented =
          targetLines.isNotEmpty && breakpointInstrumenter != null
          ? breakpointInstrumenter(content, baseFile, targetLines)
          : content;

      processedFiles[normalized] = processAndAutoImport(
        instrumented,
        currentFilePath: normalized,
        projectFiles: rawFiles,
      );
    });

    // Second pass: generate multi-key aliases for all discovered/configured packages
    processedFiles.forEach((path, code) {
      result[path] = code;
      if (path.startsWith('package:')) {
        return;
      }
      result['./$path'] = code;
      result['file:///$path'] = code;

      final normalizedPath = path.startsWith('lib/') ? path.substring(4) : path;

      for (final pkg in packageNames) {
        result['package:$pkg/$path'] = code;
        result['package:$pkg/$normalizedPath'] = code;
        result['file:///$pkg/$path'] = code;
        result['file:///$pkg/$normalizedPath'] = code;

        // Sibling / bare filename alias
        if (path.startsWith('$pkg/')) {
          final sub = path.substring('$pkg/'.length);
          result[sub] = code;
          result['package:$pkg/$sub'] = code;
          result['./$sub'] = code;
          result['file:///$sub'] = code;
        }
      }
    });

    // Built-in package stubs for platform bindings & plugin registrants
    result['package:dartnative_ios/dartnative_ios.dart'] = '''
library dartnative_ios;

class IOSNativeBindings {
  static final IOSNativeBindings instance = IOSNativeBindings._();
  IOSNativeBindings._();
}
''';

    result['package:dartnative_android/dartnative_android.dart'] = '''
library dartnative_android;

class AndroidNativeBindings {
  static final AndroidNativeBindings instance = AndroidNativeBindings._();
  AndroidNativeBindings._();
}
''';

    result['package:dartnative_shared_preferences/dartnative_shared_preferences.dart'] =
        '''
library dartnative_shared_preferences;

class PrefsBindings {
  static void loadSymbols() {}
}

class SharedPreferences {
  static SharedPreferences? _instance;
  static Future<SharedPreferences> getInstance() async {
    _instance ??= SharedPreferences._();
    return _instance!;
  }
  SharedPreferences._();
  final Map<String, Object> _storage = {};
  String? getString(String key) => _storage[key] as String?;
  bool? getBool(String key) => _storage[key] as bool?;
  int? getInt(String key) => _storage[key] as int?;
  double? getDouble(String key) => _storage[key] as double?;
  List<String>? getStringList(String key) => _storage[key] as List<String>?;
  Future<bool> setString(String key, String value) async { _storage[key] = value; return true; }
  Future<bool> setBool(String key, bool value) async { _storage[key] = value; return true; }
  Future<bool> setInt(String key, int value) async { _storage[key] = value; return true; }
  Future<bool> setDouble(String key, double value) async { _storage[key] = value; return true; }
  Future<bool> setStringList(String key, List<String> value) async { _storage[key] = value; return true; }
  Future<bool> remove(String key) async { _storage.remove(key); return true; }
  Future<bool> clear() async { _storage.clear(); return true; }
  bool containsKey(String key) => _storage.containsKey(key);
  Set<String> getKeys() => _storage.keys.toSet();
}
''';

    // Fallback plugin registrant for each package if not provided in rawFiles
    for (final pkg in packageNames) {
      final key = 'package:$pkg/dartnative_plugin_registrant.dart';
      if (!result.containsKey(key)) {
        result[key] = '''
library dartnative_plugin_registrant;

abstract final class DartNativePluginRegistrant {
  static void registerAll() {}
}
''';
      }
    }

    return result;
  }

  /// Computes the relative path from [fromPath] to [toPath].
  static String computeRelativePath(String fromPath, String toPath) {
    final fromSegments = fromPath.split('/')..removeLast();
    final toSegments = toPath.split('/');

    int common = 0;
    while (common < fromSegments.length &&
        common < toSegments.length &&
        fromSegments[common] == toSegments[common]) {
      common++;
    }

    final upCount = fromSegments.length - common;
    final resultSegments = <String>[];
    for (int i = 0; i < upCount; i++) {
      resultSegments.add('..');
    }
    resultSegments.addAll(toSegments.sublist(common));

    final joined = resultSegments.join('/');
    return joined.isEmpty ? './' : joined;
  }
}
