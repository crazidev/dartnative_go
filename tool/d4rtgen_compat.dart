// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

const srcConfig = '''
d4rtgen:
  name: dartnative_flutter_compat
  helpersImport: package:tom_d4rt/tom_d4rt.dart
  generateBarrel: false
  generateDartscript: false
  generateProxies: false
  yieldVoidCallbacks: true
  modules:
    - name: dartnative_flutter_compat
      barrelFiles:
        - package:dartnative/flutter_compat.dart
      barrelImport: package:dartnative/flutter_compat.dart
      outputPath: lib/src/interpreter/dartnative_flutter_compat_bridges.b.dart
''';

const astConfig = '''
d4rtgen:
  name: dartnative_flutter_compat_ast
  d4rtImport: package:tom_d4rt_ast/d4rt.dart
  helpersImport: package:tom_d4rt_ast/runtime.dart
  generateBarrel: false
  generateDartscript: false
  generateProxies: false
  yieldVoidCallbacks: true
  modules:
    - name: dartnative_flutter_compat
      barrelFiles:
        - package:dartnative/flutter_compat.dart
      barrelImport: package:dartnative/flutter_compat.dart
      outputPath: lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart
''';

Future<void> main() async {
  final primaryFile = File('buildkit.yaml');
  final original = primaryFile.readAsStringSync();
  try {
    // 1. Source bridge
    print('Generating source bridge for DartNative compatibility...');
    primaryFile.writeAsStringSync(srcConfig);
    var runner = ToolRunner(
      tool: d4rtgenTool,
      executors: createD4rtgenExecutors(),
    );
    var result = await runner.run(['--project=.']);
    if (!result.success) {
      print('Source generation failed!');
      return;
    }

    // 2. AST bridge
    print('Generating AST bridge for DartNative compatibility...');
    primaryFile.writeAsStringSync(astConfig);
    runner = ToolRunner(
      tool: d4rtgenTool,
      executors: createD4rtgenExecutors(),
    );
    result = await runner.run(['--project=.']);
    if (!result.success) {
      print('AST generation failed!');
      return;
    }

    print('Applying post fixes to DartNative compatibility bridges...');
    _applyPostFixes(
      File('lib/src/interpreter/dartnative_flutter_compat_bridges.b.dart'),
    );
    _applyPostFixes(
      File('lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart'),
    );

    print('Done generating DartNative compatibility bridges!');
  } finally {
    primaryFile.writeAsStringSync(original);
  }
}

void _applyPostFixes(File file) {
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();
  content = content.replaceAllMapped(
    RegExp(r':\s*const\s*\[\];\s*return\s+(\$dartnative_\d+\.showActionSheet)'),
    (m) => ': const <int>[];\n        return ${m[1]}',
  );
  content = content.replaceAllMapped(
    RegExp(
      r'required\s+(\$dartnative_\d+\.Curve)\s+curve,\s*int\s+durationMs\s*=\s*0',
    ),
    (m) {
      final prefix = m[1]!.split('.')[0];
      return '${m[1]} curve = $prefix.Curves.linear, int durationMs = 0';
    },
  );
  content = content.replaceAllMapped(
    RegExp(
      r"(BridgedClass _createValueNotifierBridge\(\) \{[\s\S]*?'value',\n\s*'ValueNotifier',\n\s*\);\n\s*)"
      r'// GEN-075: Preserve generic type parameter from runtime value\n'
      r'\s*switch \(value\) \{[\s\S]*?default:\n'
      r'\s*return (\$dartnative_\d+\.ValueNotifier)\(value\);\n'
      r'\s*\}',
    ),
    (m) => '${m[1]}return ${m[2]}<dynamic>(value);',
  );
  content = content.replaceAllMapped(
    RegExp(
      r"final t = target as (\$dartnative_\d+)\.Listenable;\n"
      r"\s*return Function\.apply\(\n"
      r"\s*t\.watch,\n"
      r"\s*positional,\n"
      r"\s*named\.map\(\(k, v\) => MapEntry\(Symbol\(k\), v\)\),\n"
      r"\s*\);",
    ),
    (m) {
      final p = m[1];
      return 'final raw = target is InterpretedInstance\n'
          '                ? (target.bridgedSuperObject ?? target.nativeProxy ?? target)\n'
          '                : target;\n'
          '            final t = D4.validateTarget<$p.Listenable>(raw, \'Listenable\');\n'
          '            final ctx = positional.isNotEmpty ? positional[0] : null;\n'
          '            if (ctx is $p.BuildContext) {\n'
          '              try {\n'
          '                t.watch(ctx);\n'
          '              } catch (_) {}\n'
          '            }\n'
          '            return target;';
    },
  );
  file.writeAsStringSync(content);
}
