// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

void main(List<String> args) async {
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

  _applyBridgePostFixes();
}

void _applyBridgePostFixes() {
  final dnBridgesFile = File('lib/src/interpreter/dartnative_bridges.b.dart');
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

  final sqliteFile = File('lib/src/interpreter/dartnative_sqlite_bridges.b.dart');
  if (sqliteFile.existsSync()) {
    var content = sqliteFile.readAsStringSync();
    content = content.replaceAll('??>', '?>');
    sqliteFile.writeAsStringSync(content);
  }

  final supabaseFile = File('lib/src/interpreter/dartnative_supabase_bridges.b.dart');
  if (supabaseFile.existsSync()) {
    var content = supabaseFile.readAsStringSync();
    content = content.replaceAll(
      "        name: 'ToSnakeCase',\n        onTypeName: 'Enum',\n        getters: {\n          'snakeCase': (visitor, target) => (target as Enum).snakeCase,",
      "        name: 'ToSnakeCase',\n        onTypeName: 'Enum',\n        getters: {\n          'snakeCase': (visitor, target) => \$gotrue_10.ToSnakeCase(target as Enum).snakeCase,",
    );
    content = content.replaceAll(
      "'snakeCase': (visitor, target) => (target as Enum).snakeCase,",
      "'snakeCase': (visitor, target) => \$storage_client_4.ToSnakeCase(target as Enum).snakeCase,",
    );
    content = content.replaceAll(
      r'<$postgrest_2._HttpMethod?>',
      '<dynamic>',
    );
    content = content.replaceAll(
      '(dynamic p0, dynamic p1) { D4.callInterpreterCallback(visitor!, callbackRaw, [p0, p1]); }',
      '(dynamic p0, [dynamic p1]) { D4.callInterpreterCallback(visitor!, callbackRaw, p1 != null ? [p0, p1] : [p0]); }',
    );
    supabaseFile.writeAsStringSync(content);
  }
}

