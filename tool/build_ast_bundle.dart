// Builds `<project>/assets/bundles/guest.ast` for AST-mode testing.
//
// Thin CLI over `lib/src/cli/ast_builder.dart` (shared with the dev server's
// `--rebuild-ast` watcher so both produce identical bundles).
//
// Usage:
//   dart run tool/build_ast_bundle.dart [--project=/path/to/app]
//     [--entry=lib/main.dart] [--output=assets/bundles/guest.ast]
//     [--package=my_app]
import 'dart:io';

import 'package:dartnative_go/src/cli/ast_builder.dart';

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
  final projectDir = Directory(_flag(args, 'project') ?? Directory.current.path);
  if (!projectDir.existsSync()) {
    stderr.writeln('Project directory not found: ${projectDir.path}');
    exitCode = 1;
    return;
  }

  final result = await buildGuestAstBundle(
    projectDir,
    entryArg: _flag(args, 'entry'),
    outputArg: _flag(args, 'output'),
    packageArg: _flag(args, 'package'),
  );

  if (!result.success) {
    stderr.writeln('AST bundle build failed: ${result.error}');
    exitCode = 1;
    return;
  }
  print(
    'Wrote ${result.outputPath} (${result.moduleCount} modules, '
    '${result.byteSize} bytes, entry: ${result.entryPointUri})',
  );
}
