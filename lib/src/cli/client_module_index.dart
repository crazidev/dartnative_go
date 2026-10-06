/// Client module index — the set of all module URIs shipped with the native app.
///
/// The dev server emits this alongside `guest.ast` so the server-component
/// bundler can subtract shared modules from each component's delta bundle.
///
/// ## Format
/// ```json
/// {
///   "version": 1,
///   "fingerprint": "a1b2c3...",
///   "modules": [
///     "package:myapp/main.dart",
///     "package:myapp/helper.dart",
///     "package:riverpod/riverpod.dart",
///     ...
///   ]
/// }
/// ```
library;

import 'dart:convert';
import 'dart:io';

import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

/// Default file name for the client module index, written alongside guest.ast.
const kClientModuleIndexFile = 'client-module-index.json';

/// Current version of the client module index format.
const kClientModuleIndexVersion = 1;

/// The set of module URIs shipped in the client bundle.
class ClientModuleIndex {
  final int version;
  final String fingerprint;
  final Set<String> modules;

  const ClientModuleIndex({
    this.version = kClientModuleIndexVersion,
    required this.fingerprint,
    required this.modules,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'fingerprint': fingerprint,
    'modules': modules.toList()..sort(),
  };

  factory ClientModuleIndex.fromJson(Map<String, dynamic> json) {
    return ClientModuleIndex(
      version: json['version'] as int? ?? kClientModuleIndexVersion,
      fingerprint: json['fingerprint'] as String? ?? '',
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
    );
  }

  /// Builds the index from a fully-resolved client [AstBundle].
  ///
  /// The index includes every module URI in the bundle EXCEPT dart: scheme
  /// libraries, which are never bundled and always resolved by the runtime.
  ///
  /// Optionally exclude [bridgedUris] — libraries handled by native bridges
  /// (Flutter, DartNative plugins) that are also never bundled.
  factory ClientModuleIndex.fromBundle(
    AstBundle bundle, {
    Set<String>? bridgedUris,
    String fingerprint = '',
  }) {
    final modules = <String>{};
    for (final uri in bundle.modules.keys) {
      if (uri.startsWith('dart:')) continue;
      if (bridgedUris != null && bridgedUris.contains(uri)) continue;
      modules.add(uri);
    }
    return ClientModuleIndex(
      fingerprint: fingerprint,
      modules: Set.unmodifiable(modules),
    );
  }

  /// Whether [moduleUri] is known to be in the client bundle.
  bool contains(String moduleUri) => modules.contains(moduleUri);

  /// Writes this index as pretty-printed JSON to [file].
  void saveToFile(File file) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(toJson()),
    );
  }

  factory ClientModuleIndex.fromFile(File file) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return ClientModuleIndex.fromJson(json);
  }
}
