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
        list.add(ImportDirectiveInfo(
          uri: uri,
          prefix: prefix,
          showList: showStr != null
              ? showStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
              : const [],
          hideList: hideStr != null
              ? hideStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
              : const [],
        ));
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
  static Map<String, String> buildSymbolIndex(Map<String, String> projectFiles) {
    final index = <String, String>{};
    projectFiles.forEach((path, code) {
      final declared = extractDeclaredSymbols(code);
      for (final sym in declared) {
        index[sym] = path;
      }
    });
    return index;
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

    final importsToAdd = <String>{};

    // 1. Check for DartNative framework symbols
    final hasDartNativeImport = existingUris.any((uri) =>
        uri == 'package:dartnative/dartnative.dart' ||
        uri == 'package:flutter/material.dart' ||
        uri.endsWith('dartnative.dart'));

    if (!hasDartNativeImport) {
      final usesDartNative = dartNativeSymbols.any((sym) =>
          RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(source));
      if (usesDartNative) {
        importsToAdd.add("import 'package:dartnative/dartnative.dart';");
      }
    }

    // 2. Check for dart:math
    if (!existingUris.contains('dart:math')) {
      final usesMath = dartMathSymbols.any((sym) =>
          RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(source));
      if (usesMath) {
        importsToAdd.add("import 'dart:math';");
      }
    }

    // 3. Check for dart:async
    if (!existingUris.contains('dart:async')) {
      final usesAsync = dartAsyncSymbols.any((sym) =>
          RegExp(r'\b' + RegExp.escape(sym) + r'\b').hasMatch(source));
      if (usesAsync) {
        importsToAdd.add("import 'dart:async';");
      }
    }

    // 4. Check for project-wide symbols from other files
    if (projectFiles != null && currentFilePath != null) {
      final symbolIndex = buildSymbolIndex(projectFiles);
      symbolIndex.forEach((symbol, definingPath) {
        if (definingPath != currentFilePath) {
          // If the symbol is referenced in source
          final isReferenced =
              RegExp(r'\b' + RegExp.escape(symbol) + r'\b').hasMatch(source);
          if (isReferenced) {
            // Check if defining file or symbol is already imported
            final relImportPath =
                computeRelativePath(currentFilePath, definingPath);
            final alreadyImported = existingUris.any((uri) =>
                uri == relImportPath ||
                uri == definingPath ||
                uri.endsWith(definingPath));

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

    // Prepend auto imports at the very top (or right after library directives)
    final buffer = StringBuffer();
    for (final imp in importsToAdd) {
      buffer.writeln(imp);
    }
    buffer.writeln();
    buffer.write(source);
    return buffer.toString();
  }

  /// Normalizes and generates all virtual alias paths for a given file.
  ///
  /// Examples for `components/button.dart`:
  /// - `components/button.dart`
  /// - `package:guest_app/components/button.dart`
  /// - `file:///components/button.dart`
  /// - `file:///guest_app/components/button.dart`
  /// - `./components/button.dart`
  static Map<String, String> buildVirtualSourceMap(Map<String, String> rawFiles) {
    final result = <String, String>{};

    // First pass: auto-import processing on all files
    final processedFiles = <String, String>{};
    rawFiles.forEach((path, content) {
      final normalized = path.startsWith('/') ? path.substring(1) : path;
      processedFiles[normalized] = processAndAutoImport(
        content,
        currentFilePath: normalized,
        projectFiles: rawFiles,
      );
    });

    // Second pass: generate multi-key aliases
    processedFiles.forEach((path, code) {
      result[path] = code;
      result['package:guest_app/$path'] = code;
      result['./$path'] = code;
      result['file:///$path'] = code;
      result['file:///guest_app/$path'] = code;

      // Sibling / bare filename alias (e.g., if path is 'guest_app/main.dart' -> 'main.dart')
      if (path.startsWith('guest_app/')) {
        final sub = path.substring('guest_app/'.length);
        result[sub] = code;
        result['package:guest_app/$sub'] = code;
        result['./$sub'] = code;
        result['file:///$sub'] = code;
      }
    });

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
