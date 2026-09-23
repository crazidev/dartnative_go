// Builds `<project>/assets/bundles/guest.bc` for Bytecode-mode execution.
//
// Usage:
//   dart run tool/build_bytecode_bundle.dart [--project=/path/to/app]
//     [--entry=lib/main.dart] [--output=assets/bundles/guest.bc]
//     [--package=my_app]
import 'dart:io';

import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:dartnative_go/src/cli/bytecode_emitter.dart';
import 'package:dartnative_go/src/runner/bytecode/bundle_codec.dart';
import 'package:path/path.dart' as p;
import 'package:tom_ast_generator/tom_ast_generator.dart';

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
  if (args.contains('--help') || args.contains('-h')) {
    print('Usage: dart run tool/build_bytecode_bundle.dart [options]');
    print('Options:');
    print('  --project=<path>   Root of guest project (default: current directory or example/)');
    print('  --entry=<file>     Entrypoint file (default: lib/main.dart)');
    print('  --output=<path>    Output .bc file (default: assets/bundles/guest.bc)');
    print('  --package=<name>   Guest package name (default: from pubspec.yaml)');
    return;
  }

  var targetPath = _flag(args, 'project') ?? Directory.current.path;
  var projectDir = Directory(targetPath);
  if (!projectDir.existsSync()) {
    stderr.writeln('Project directory not found: ${projectDir.path}');
    exitCode = 1;
    return;
  }

  // If run at root of dartnative_go without flags, check if example/ exists
  if (!File(p.join(projectDir.path, 'pubspec.yaml')).existsSync()) {
    final exampleDir = Directory(p.join(projectDir.path, 'example'));
    if (exampleDir.existsSync()) {
      projectDir = exampleDir;
    }
  }

  final entryFile = resolveGuestEntry(projectDir, _flag(args, 'entry'));
  if (entryFile == null) {
    stderr.writeln('Entrypoint not found in ${projectDir.path}');
    exitCode = 1;
    return;
  }

  final packageName =
      _flag(args, 'package') ?? detectGuestPackageName(projectDir) ?? 'guest_app';
  final rawPath = _flag(args, 'output') ?? 'assets/bundles/guest.bc';
  final outPath = rawPath.startsWith('${projectDir.path}/')
      ? rawPath
      : p.isAbsolute(rawPath)
          ? rawPath
          : p.join(projectDir.path, rawPath);

  try {
    final explicitSources = <String, String>{
      ...resolvePackageSources(projectDir, packageName: packageName),
      ...registrantStubs(projectDir, packageName),
    };

    final bundler = AstBundler(
      bridgedLibraries: kAstBridgedLibraries,
      explicitSources: explicitSources,
      packageName: packageName,
      projectRoot: projectDir.path,
      converter: SafeAstConverter(),
    );

    final astBundle = await bundler.createFromFile(entryFile.path);

    final emitter = BytecodeEmitter();
    final bcBundle = emitter.compileBundle(astBundle);

    final encodedBytes = BytecodeBundleCodec.encodeBundle(bcBundle);

    final outFile = File(outPath);
    await outFile.parent.create(recursive: true);
    await outFile.writeAsBytes(encodedBytes, flush: true);

    print(
      'Wrote Bytecode bundle $outPath '
      '(${bcBundle.functions.length} functions, ${bcBundle.classes.length} classes, '
      '${encodedBytes.length} bytes, entry: ${bcBundle.entryPointUri})',
    );
  } catch (e, st) {
    stderr.writeln('Bytecode build failed: $e\n$st');
    exitCode = 1;
  }
}
