// Exports @ServerComponent bundles for CDN deployment (Phase 6).
//
// Runs the client build (which also emits per-component delta bundles +
// manifest.json under server_components/), then copies the component
// artifacts into [outDir] and rewrites the manifest with absolute [baseUrl]
// URLs ready to upload alongside the files.
//
// Usage:
//   dart run tool/export_server_components.dart --base-url=https://cdn.example.com/app/v3
//     [--project=/path/to/app] [--out=build/server_components]
//     [--entry=lib/main.dart] [--package=my_app]
//
// Upload the contents of [outDir] to `<baseUrl>/` preserving file names,
// then point the native app at `<baseUrl>/manifest.json`.
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/cli/server_component_bundler.dart'
    show serverManifestToJson;

String? _flag(List<String> args, String name) {
  final prefix = '--$name=';
  for (final a in args) {
    if (a.startsWith(prefix)) return a.substring(prefix.length);
  }
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == '--$name') return args[i + 1];
  }
  return null;
}

Future<void> main(List<String> args) async {
  final baseUrl = _flag(args, 'base-url');
  if (baseUrl == null || baseUrl.isEmpty) {
    stderr.writeln('Missing required --base-url=https://cdn.example.com/app/vN');
    exitCode = 2;
    return;
  }
  final projectDir = Directory(_flag(args, 'project') ?? Directory.current.path);
  if (!projectDir.existsSync()) {
    stderr.writeln('Project directory not found: ${projectDir.path}');
    exitCode = 1;
    return;
  }
  final outDir = Directory(
    _flag(args, 'out') ?? '${projectDir.path}/build/server_components',
  );

  final result = await buildGuestAstBundle(
    projectDir,
    entryArg: _flag(args, 'entry'),
    packageArg: _flag(args, 'package'),
    force: true,
  );
  if (!result.success) {
    stderr.writeln('AST bundle build failed: ${result.error}');
    exitCode = 1;
    return;
  }
  final components = result.serverComponents;
  if (components == null || components.components.isEmpty) {
    print('No @ServerComponent annotations found — nothing to export.');
    return;
  }

  outDir.createSync(recursive: true);
  final trimmedBase = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  for (final entry in components.components.entries) {
    File('${outDir.path}/${entry.key}.ast')
        .writeAsBytesSync(entry.value.astBytes);
  }
  final manifest = serverManifestToJson({
    for (final entry in components.manifest.entries)
      entry.key: (
        url: '$trimmedBase/${entry.key}.ast',
        fingerprint: entry.value.fingerprint,
      ),
  });
  File('${outDir.path}/manifest.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(manifest),
  );
  print(
    'Exported ${components.components.length} server components to '
    '${outDir.path} (client: ${result.moduleCount} modules, '
    '${result.byteSize} bytes)',
  );
  for (final entry in components.components.entries) {
    print('  ${entry.key}: ${entry.value.byteSize} bytes, '
        'fp=${entry.value.fingerprint}');
  }
}
