// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

/// Regenerates the AST bridge set (`lib/src/interpreter/ast/`) targeting
/// `tom_d4rt_ast` (analyzer-free runtime).
///
/// The d4rtgen v2 tool only reads `buildkit.yaml`, so this driver swaps in
/// `buildkit_ast.yaml` for the run and restores the source config in a
/// `finally` block. `buildkit_ast.yaml` must mirror `buildkit.yaml` modules —
/// enforced by `test/bridge_config_parity_test.dart`.
Future<void> main(List<String> args) async {
  const primary = 'buildkit.yaml';
  const astConfig = 'buildkit_ast.yaml';
  const backup = '.buildkit.src.yaml.bak';

  final primaryFile = File(primary);
  if (!primaryFile.existsSync()) {
    stderr.writeln('Missing $primary');
    exitCode = 1;
    return;
  }
  if (!File(astConfig).existsSync()) {
    stderr.writeln('Missing $astConfig');
    exitCode = 1;
    return;
  }

  final original = primaryFile.readAsStringSync();
  try {
    File(astConfig).copySync(primary);
    final runner = ToolRunner(
      tool: d4rtgenTool,
      executors: createD4rtgenExecutors(),
    );
    final runArgs = args.isEmpty ? ['--project=.'] : args;
    final result = await runner.run(runArgs);
    if (!result.success) {
      exitCode = 1;
      return;
    }
    _applyAstBridgePostFixes();
  } finally {
    primaryFile.writeAsStringSync(original);
    try {
      File(backup).deleteSync();
    } catch (_) {}
  }
}

/// Same generator-bug workarounds as `tool/d4rtgen.dart`, applied to the
/// AST output dir. Kept in sync manually until the generator is fixed.
void _applyAstBridgePostFixes() {
  final dnBridgesFile = File('lib/src/interpreter/ast/dartnative_bridges.b.dart');
  if (dnBridgesFile.existsSync()) {
    var content = dnBridgesFile.readAsStringSync();
    content = content.replaceAll(
      ': const [];\n        return \$dartnative_42.showActionSheet',
      ': const <int>[];\n        return \$dartnative_42.showActionSheet',
    );
    content = content.replaceAll(
      'required \$dartnative_3.Curve curve, int durationMs = 0',
      '\$dartnative_3.Curve curve = \$dartnative_3.Curves.linear, int durationMs = 0',
    );
    dnBridgesFile.writeAsStringSync(content);
  }
}
