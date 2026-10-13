/// Server-side `@ServerComponent` annotation library for guest code.
///
/// Guest projects annotate widgets with the REAL host annotation by writing:
///
/// ```dart
/// import 'package:dartnative_go/server.dart';
///
/// @ServerComponent(id: 'profile_card')
/// class ProfileCard extends StatelessWidget { ... }
/// ```
///
/// No guest dependency is needed: the dev server (and `tool/` builds) inject
/// this package's actual `lib/server.dart` + `lib/src/server/server_annotation.dart`
/// sources into the bundler's `explicitSources` (see [serverAnnotationSources]),
/// exactly like the `dartnative_plugin_registrant.dart` stub. The annotation
/// file is dependency-free, so only these two modules ever enter a bundle.
///
/// A `test/unit/server_annotation_source_test.dart` guard asserts the
/// injected sources stay identical to the real files.
library;

import 'dart:io';

/// Package URIs under which guest code imports the annotation.
const kServerAnnotationUris = {
  'package:dartnative_go/server.dart',
  'package:dartnative_go/src/server/server_annotation.dart',
};

/// Host-relative paths backing [kServerAnnotationUris], in the same order.
const _kServerAnnotationPaths = [
  'lib/server.dart',
  'lib/src/server/server_annotation.dart',
];

/// Reads the real annotation sources from the enclosing `dartnative_go`
/// package and keys them by their guest-visible package URIs.
///
/// The package root is discovered by walking up from [Platform.script]
/// to the `pubspec.yaml` declaring `name: dartnative_go` — this works for
/// the dev server (`bin/dart_go.dart`), `tool/` builds, and `dn test`
/// alike. Returns an empty map when the root cannot be located (e.g. an
/// embedder shipping these sources standalone); the bundler then reports
/// the import as unresolvable, as before.
Map<String, String> serverAnnotationSources() {
  final root = _dartnativeGoRoot();
  if (root == null) return const {};
  final sources = <String, String>{};
  for (var i = 0; i < _kServerAnnotationPaths.length; i++) {
    final file = File('${root.path}/${_kServerAnnotationPaths[i]}');
    try {
      if (!file.existsSync()) return const {};
      sources[kServerAnnotationUris.elementAt(i)] = file.readAsStringSync();
    } catch (_) {
      return const {};
    }
  }
  return sources;
}

/// Walks up from the running script to the `dartnative_go` package root.
///
/// Keeps walking past unrelated pubspecs (e.g. a guest project nested
/// inside the checkout, like `example/`) — only an exact name match wins.
Directory? _dartnativeGoRoot() {
  try {
    var dir = Directory.fromUri(Platform.script.resolve('.'));
    while (true) {
      final pubspec = File('${dir.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        try {
          for (final line in pubspec.readAsLinesSync()) {
            if (line.trim() == 'name: dartnative_go') return dir;
          }
        } catch (_) {}
      }
      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  } catch (_) {
    return null;
  }
}
