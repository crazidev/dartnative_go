// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

import 'd4rtgen_select.dart';

/// Regenerates the source bridge set.
///
/// Pass `--package` or `--module` to regenerate one package instead of every
/// module, and `--changed` to skip packages whose sources have not moved.
/// See [bridgeSelectHelp].
void main(List<String> args) async {
  final select = parseBridgeSelectArgs(args);
  if (select.runnerArgs.contains('--help') ||
      select.runnerArgs.contains('-h')) {
    stdout.writeln(bridgeSelectHelp);
  }

  const buildkit = 'buildkit.yaml';
  final projectDir = Directory.current.path;
  final original = File(buildkit).readAsStringSync();
  SelectionPlan? plan;
  try {
    plan = _prepareSelection(
      buildkitPath: buildkit,
      projectDir: projectDir,
      options: select,
      stampPrefix: 'source',
    );
    if (plan != null && plan.selected.isEmpty) {
      stdout.writeln('No bridge modules need generation.');
      _recordSelectionStamps(
        projectDir: projectDir,
        buildkitPath: buildkit,
        stampPrefix: 'source',
        plan: SelectionPlan(
          selected: [
            for (final module in readBridgeModules(buildkit))
              if (select.selectors.isEmpty ||
                  select.selectors.any(module.matches))
                module,
          ],
          skipped: plan.skipped,
          partial: true,
        ),
      );
      return;
    }

    final runner = ToolRunner(
      tool: d4rtgenTool,
      executors: createD4rtgenExecutors(),
    );
    final runArgs = select.runnerArgs.isEmpty
        ? ['--project=.']
        : select.runnerArgs;
    final result = await runner.run(runArgs);
    if (!result.success) {
      exitCode = 1;
      return;
    }

    final only = plan == null
        ? null
        : plan.selected.map((module) => module.outputPath).toSet();
    _applyBridgePostFixes(only: only);
    await _formatGeneratedBridges(isAst: false, only: only);
    _recordSelectionStamps(
      projectDir: projectDir,
      buildkitPath: buildkit,
      stampPrefix: 'source',
      plan: plan,
    );
  } finally {
    File(buildkit).writeAsStringSync(original);
    deletePartialRelaxer(projectDir);
  }
}

SelectionPlan? _prepareSelection({
  required String buildkitPath,
  required String projectDir,
  required BridgeSelectOptions options,
  required String stampPrefix,
}) {
  if (!options.restricts) return null;
  final modules = readBridgeModules(buildkitPath);
  final plan = planSelection(
    modules: modules,
    options: options,
    isChanged: (module) => moduleSourcesChanged(
      module: module,
      projectDir: projectDir,
      stampKey: '$stampPrefix:${module.name}',
    ),
  );
  if (plan.selected.isEmpty) {
    stdout.writeln(
      'Skipping ${plan.skipped.length} unchanged module(s): '
      '${plan.skipped.join(', ')}',
    );
    return plan;
  }
  stdout.writeln(
    'Generating ${plan.selected.length} module(s): '
    '${plan.selected.map((module) => module.name).join(', ')}',
  );
  if (plan.skipped.isNotEmpty) {
    stdout.writeln(
      'Skipping unchanged or unselected: ${plan.skipped.join(', ')}',
    );
  }
  if (plan.partial)
    writePartialBuildkit(buildkitPath: buildkitPath, plan: plan);
  return plan;
}

void _recordSelectionStamps({
  required String projectDir,
  required String buildkitPath,
  required String stampPrefix,
  required SelectionPlan? plan,
}) {
  final modules = plan?.selected ?? readBridgeModules(buildkitPath);
  final roots = loadPackageRoots(projectDir);
  final edition = readFrameworkEdition();
  writeStamps(projectDir, {
    for (final module in modules)
      '$stampPrefix:${module.name}': moduleFingerprint(
        module: module,
        packageRoots: roots,
        frameworkEdition: edition,
      ),
  });
}

/// Formats the generated bridge set as the final generation step.
///
/// The generator emits its own layout and the `DN-PATCH` rewrites above splice
/// text in verbatim, so without this step a regeneration reformats the whole
/// file and every run shows up as an unrelated whitespace diff in review. By
/// formatting here, the committed output is already canonical: re-running
/// `dart run tool/d4rtgen.dart` against unchanged sources produces no diff.
///
/// Kept in sync with `tool/d4rtgen_ast.dart`.
Future<void> _formatGeneratedBridges({
  required bool isAst,
  Set<String>? only,
}) async {
  final dir = Directory(
    isAst ? 'lib/src/interpreter/ast' : 'lib/src/interpreter',
  );
  if (!dir.existsSync()) return;

  final paths = <String>[
    if (only == null) ...[
      for (final entity in dir.listSync())
        if (entity is File && entity.path.endsWith('.b.dart')) entity.path,
      // Source set only: the AST set has `generateBarrel: false`.
      if (!isAst) 'lib/d4rt_bridges.b.dart',
    ] else
      ...only,
  ]..sort();

  if (paths.isEmpty) return;

  final result = await Process.run(
    Platform.resolvedExecutable,
    ['format', '--output=write', ...paths],
  );
  if (result.exitCode != 0) {
    stderr.writeln('dart format failed on generated bridges:');
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    exitCode = 1;
  }
}

void _applyBridgePostFixes({Set<String>? only}) {
  bool want(String path) => only == null || only.contains(path);

  final dnBridgesFile = File('lib/src/interpreter/dartnative_bridges.b.dart');
  if (want(dnBridgesFile.path) && dnBridgesFile.existsSync()) {
    var content = dnBridgesFile.readAsStringSync();
    // Alias-agnostic (regex): import alias numbers shift whenever the
    // framework gains files. DN-PATCH.
    content = content.replaceAllMapped(
      RegExp(
        r':\s*const\s*\[\];\s*return\s+(\$dartnative_\d+\.showActionSheet)',
      ),
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
    dnBridgesFile.writeAsStringSync(content);
  }

  final sqliteFile = File(
    'lib/src/interpreter/dartnative_sqlite_bridges.b.dart',
  );
  if (want(sqliteFile.path) && sqliteFile.existsSync()) {
    var content = sqliteFile.readAsStringSync();
    content = content.replaceAll('??>', '?>');
    sqliteFile.writeAsStringSync(content);
  }

  final supabaseFile = File(
    'lib/src/interpreter/dartnative_supabase_bridges.b.dart',
  );
  if (want(supabaseFile.path) && supabaseFile.existsSync()) {
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

  if (want('lib/src/interpreter/riverpod_kit_bridges.b.dart')) {
    _patchRiverpodBridges(
      File('lib/src/interpreter/riverpod_kit_bridges.b.dart'),
      isAst: false,
    );
  }
  if (want('lib/src/interpreter/ast/riverpod_kit_bridges.b.dart')) {
    _patchRiverpodBridges(
      File('lib/src/interpreter/ast/riverpod_kit_bridges.b.dart'),
      isAst: true,
    );
  }

  if (want('lib/src/interpreter/native_bottomsheet_bridges.b.dart')) {
    _patchNativeBottomsheetBridges(
      File('lib/src/interpreter/native_bottomsheet_bridges.b.dart'),
    );
  }
  if (want('lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart')) {
    _patchNativeBottomsheetBridges(
      File('lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart'),
    );
  }

  if (want('lib/src/interpreter/dartnative_flutter_compat_bridges.b.dart')) {
    _patchDartNativeCompatBridges(
      File('lib/src/interpreter/dartnative_flutter_compat_bridges.b.dart'),
    );
  }
  if (want(
    'lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart',
  )) {
    _patchDartNativeCompatBridges(
      File('lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart'),
    );
  }

  if (want('lib/src/interpreter/dio_bridges.b.dart')) {
    _patchDioBridges(File('lib/src/interpreter/dio_bridges.b.dart'));
  }
  if (want('lib/src/interpreter/ast/dio_bridges.b.dart')) {
    _patchDioBridges(File('lib/src/interpreter/ast/dio_bridges.b.dart'));
  }
}

/// dio's `FormData.fromMap` defaults `boundaryName` to the private top-level
/// const `_boundaryName`, which the generator cannot reference from the bridge
/// library. It therefore emits a mandatory-argument stub that throws whenever
/// the caller omits the parameter. Inline the literal default instead.
/// DN-PATCH.
void _patchDioBridges(File file) {
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();
  content = content.replaceAllMapped(
    RegExp(
      r"// TODO: Non-wrappable default: _boundaryName\n\s*"
      r"final boundaryName = D4\.getRequiredArgTodoDefault<String>"
      r"\(positional, 3, 'boundaryName', 'FormData', '_boundaryName'\);",
    ),
    (m) =>
        "// DN-PATCH: dio's `_boundaryName` is a private top-level const, so the\n"
        '        // generator cannot reference it. Inline its literal value instead of\n'
        '        // forcing every call site to pass `boundaryName` explicitly.\n'
        "        final boundaryName = D4.getOptionalArgWithDefault<String>("
        "positional, 3, 'boundaryName', '--dio-boundary');",
  );
  file.writeAsStringSync(content);
}

void _patchDartNativeCompatBridges(File file) {
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
  file.writeAsStringSync(content);
}

void _patchNativeBottomsheetBridges(File file) {
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'final builder = (dynamic p0,',
    'final dynamic builder = (dynamic p0,',
  );
  // Builder callbacks return interpreted Widgets: castCallbackResult<dynamic>
  // leaves them dynamic and the native `Widget Function(...)` parameter
  // rejects the closure (tap-time TypeError). Coerce via the Widget proxy
  // path instead. Also wrap the child in NativeBottomSheetScope so the
  // bottom sheet's independent DNTree is tracked for hot-reload. DN-PATCH.
  if (!content.contains("as \$flutter_widgets;")) {
    content = content.replaceFirst(
      "import 'package:native_bottomsheet/",
      "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;\nimport 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart' as \$bottomsheet_mgr;\nimport 'package:native_bottomsheet/",
    );
  } else if (!content.contains("as \$bottomsheet_mgr;")) {
    content = content.replaceFirst(
      "import 'package:native_bottomsheet/",
      "import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart' as \$bottomsheet_mgr;\nimport 'package:native_bottomsheet/",
    );
  }
  content = content.replaceAll(
    "D4.castCallbackResult<dynamic>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]))",
    "\$bottomsheet_mgr.NativeBottomSheetScope(controller: p1, child: D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), 'builder', visitor))",
  );
  content = content.replaceAll(
    "return D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), 'builder', visitor);",
    "return \$bottomsheet_mgr.NativeBottomSheetScope(controller: p1, child: D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), 'builder', visitor));",
  );
  // Single-line emission (current generator): the whole builder closure is
  // one line with a trailing `as ... Function(...)` cast, so the patterns
  // above silently no-op. Same coercion + scope wrap. DN-PATCH.
  content = content.replaceAllMapped(
    RegExp(
      r'final builder = \(\(dynamic p0, (\$\w+\.DNSheetController) p1\) \{ return D4\.extractBridgedArg<[^>]+>\(D4\.callInterpreterCallback\(visitor!, builderRaw, \[p0, p1\]\), .callback., visitor\) as [^;]+; \}\) as [^;]+;',
    ),
    (m) =>
        'final dynamic builder = (dynamic p0, ${m[1]} p1) { return \$bottomsheet_mgr.NativeBottomSheetScope(controller: p1, child: D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.callInterpreterCallback(visitor!, builderRaw, [p0, p1]), \'builder\', visitor)); };',
  );
  file.writeAsStringSync(content);
}

void _patchRiverpodBridges(File file, {required bool isAst}) {
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();

  if (!content.contains('experimental_member_use')) {
    content = content.replaceFirst(
      '// ignore_for_file: ',
      '// ignore_for_file: experimental_member_use, ',
    );
  }

  // 1. Remove internal ClassBaseX and $RefArg extension blocks cleanly
  content = content.replaceAll(
    RegExp(
      r'BridgedExtensionDefinition\(\s*name:\s*r?[\x27"]ClassBaseX[\x27"],[\s\S]*?(?=BridgedExtensionDefinition)',
    ),
    '',
  );
  content = content.replaceAll(
    RegExp(
      r'BridgedExtensionDefinition\(\s*name:\s*r?[\x27"]\$RefArg[\x27"],[\s\S]*?(?=BridgedExtensionDefinition)',
    ),
    '',
  );

  // 2. Remove from extension source map
  content = content.replaceAll(
    RegExp(
      r"[\x27\x22]ClassBaseX@AnyNotifier[\x27\x22]:\s*['\x22][^'\x22]+['\x22],\s*\n?",
    ),
    '',
  );
  content = content.replaceAll(
    RegExp(
      r"r?[\x27\x22]\$RefArg@Ref[\x27\x22]:\s*['\x22][^'\x22]+['\x22],\s*\n?",
    ),
    '',
  );

  // 3. Escape unescaped '$...' in string literals to '\$...' (excluding '${')
  content = content.replaceAll(r"'$", r"'\$");
  content = content.replaceAll(r"'\${", r"'${");

  // 4. Ensure ProviderScope & UncontrolledProviderScope extract child as Widget
  if (!content.contains(
    "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;",
  )) {
    content = content.replaceFirst(
      "import 'dart:async';",
      "import 'dart:async';\nimport 'package:dartnative/dartnative.dart' as \$flutter_widgets;",
    );
  }
  content = content.replaceAll(
    "final child = D4.getRequiredNamedArg<dynamic>(\n          named,\n          'child',\n          'ProviderScope',\n        );",
    "final child = D4.extractBridgedArg<\$flutter_widgets.Widget>(\n          D4.getRequiredNamedArg<dynamic>(\n            named,\n            'child',\n            'ProviderScope',\n          ),\n          'child',\n          visitor,\n        );",
  );
  content = content.replaceAll(
    "final child = D4.getRequiredNamedArg<dynamic>(\n          named,\n          'child',\n          'UncontrolledProviderScope',\n        );",
    "final child = D4.extractBridgedArg<\$flutter_widgets.Widget>(\n          D4.getRequiredNamedArg<dynamic>(\n            named,\n            'child',\n            'UncontrolledProviderScope',\n          ),\n          'child',\n          visitor,\n        );",
  );

  // 4b. Same patch for single-line emission. Current generator versions
  // emit the getRequiredNamedArg call on one line, so the multi-line
  // patterns above silently no-op and interpreted Widget children hit the
  // native constructor as `dynamic` -> bare `type 'InterpretedInstance'
  // is not a subtype of type 'Widget'` on hot reload. DN-PATCH.
  content = content.replaceAll(
    "final child = D4.getRequiredNamedArg<dynamic>(named, 'child', 'ProviderScope');",
    "final child = D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.getRequiredNamedArg<dynamic>(named, 'child', 'ProviderScope'), 'child', visitor);",
  );
  content = content.replaceAll(
    "final child = D4.getRequiredNamedArg<dynamic>(named, 'child', 'UncontrolledProviderScope');",
    "final child = D4.extractBridgedArg<\$flutter_widgets.Widget>(D4.getRequiredNamedArg<dynamic>(named, 'child', 'UncontrolledProviderScope'), 'child', visitor);",
  );
  content = content.replaceAll(
    "final child = D4.getRequiredNamedArg<dynamic>(named, 'child', 'Consumer');",
    "final child = D4.extractBridgedArgOrNull<\$flutter_widgets.Widget>(D4.getRequiredNamedArg<dynamic>(named, 'child', 'Consumer'), 'child', visitor);",
  );

  // 5. Proxy import for Notifier bridging
  final proxyImport = isAst
      ? "import 'ast_widget_proxies.dart';"
      : "import 'widget_proxies.dart';";
  if (!content.contains(proxyImport)) {
    content = content.replaceFirst(
      "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;",
      "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;\n$proxyImport",
    );
  }

  // 6. Define _unwrapInterpretedProxy helper if absent
  if (!content.contains('Object? _unwrapInterpretedProxy(')) {
    content = content.replaceFirst(
      'class RiverpodKitBridge {',
      'Object? _unwrapInterpretedProxy(Object? val) {\n  if (val is InterpretedNotifierProxy) {\n    return val.instance;\n  }\n  if (val is InterpretedAsyncNotifierProxy) {\n    return val.instance;\n  }\n  if (val is InterpretedStreamNotifierProxy) {\n    return val.instance;\n  }\n  return val;\n}\n\nclass RiverpodKitBridge {',
    );
  }

  // 7. Patch NotifierProvider to wrap InterpretedInstance in InterpretedNotifierProxy
  content = content.replaceAll(
    "        final retryRaw = named['retry'];\n        return \$riverpod_8.NotifierProvider(\n          (() {\n                return D4.extractBridgedArg<\$riverpod_8.Notifier<dynamic>>(\n                      D4.callInterpreterCallback(\n                        visitor!,\n                        createNotifierRaw,\n                        [],\n                      ),\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_8.Notifier<dynamic>;\n              })",
    "        final retryRaw = named['retry'];\n        return \$riverpod_8.NotifierProvider(\n          (() {\n                final rawNotifier = D4.callInterpreterCallback(\n                  visitor!,\n                  createNotifierRaw,\n                  [],\n                );\n                // DN-PATCH: InterpretedInstance → native Notifier proxy.\n                if (rawNotifier is InterpretedInstance) {\n                  return InterpretedNotifierProxy(visitor!, rawNotifier);\n                }\n                return D4.extractBridgedArg<\$riverpod_8.Notifier<dynamic>>(\n                      rawNotifier,\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_8.Notifier<dynamic>;\n              })",
  );

  // 7b. Patch AsyncNotifierProvider to wrap InterpretedInstance in InterpretedAsyncNotifierProxy
  content = content.replaceAll(
    "        final retryRaw = named['retry'];\n        return \$riverpod_6.AsyncNotifierProvider(\n          (() {\n                return D4.extractBridgedArg<\$riverpod_6.AsyncNotifier<dynamic>>(\n                      D4.callInterpreterCallback(\n                        visitor!,\n                        createNotifierRaw,\n                        [],\n                      ),\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_6.AsyncNotifier<dynamic>;\n              })",
    "        final retryRaw = named['retry'];\n        return \$riverpod_6.AsyncNotifierProvider(\n          (() {\n                final rawNotifier = D4.callInterpreterCallback(\n                  visitor!,\n                  createNotifierRaw,\n                  [],\n                );\n                // DN-PATCH: InterpretedInstance → native AsyncNotifier proxy.\n                if (rawNotifier is InterpretedInstance) {\n                  return InterpretedAsyncNotifierProxy(visitor!, rawNotifier);\n                }\n                return D4.extractBridgedArg<\$riverpod_6.AsyncNotifier<dynamic>>(\n                      rawNotifier,\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_6.AsyncNotifier<dynamic>;\n              })",
  );

  // 7c. Patch StreamNotifierProvider to wrap InterpretedInstance in InterpretedStreamNotifierProxy
  content = content.replaceAll(
    "        final retryRaw = named['retry'];\n        return \$riverpod_10.StreamNotifierProvider(\n          (() {\n                return D4.extractBridgedArg<\n                      \$riverpod_10.StreamNotifier<dynamic>\n                    >(\n                      D4.callInterpreterCallback(\n                        visitor!,\n                        createNotifierRaw,\n                        [],\n                      ),\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_10.StreamNotifier<dynamic>;\n              })",
    "        final retryRaw = named['retry'];\n        return \$riverpod_10.StreamNotifierProvider(\n          (() {\n                final rawNotifier = D4.callInterpreterCallback(\n                  visitor!,\n                  createNotifierRaw,\n                  [],\n                );\n                // DN-PATCH: InterpretedInstance → native StreamNotifier proxy.\n                if (rawNotifier is InterpretedInstance) {\n                  return InterpretedStreamNotifierProxy(visitor!, rawNotifier);\n                }\n                return D4.extractBridgedArg<\n                      \$riverpod_10.StreamNotifier<dynamic>\n                    >(\n                      rawNotifier,\n                      'callback',\n                      visitor,\n                    )\n                    as \$riverpod_10.StreamNotifier<dynamic>;\n              })",
  );

  // 7d. Same factory wraps for single-line emission (see 4b). DN-PATCH.
  content = content.replaceAll(
    "(() { return D4.extractBridgedArg<\$riverpod_8.Notifier<dynamic>>(D4.callInterpreterCallback(visitor!, createNotifierRaw, []), 'callback', visitor) as \$riverpod_8.Notifier<dynamic>; })",
    "(() { final rawNotifier = D4.callInterpreterCallback(visitor!, createNotifierRaw, []); if (rawNotifier is InterpretedInstance) { return InterpretedNotifierProxy(visitor!, rawNotifier); } return D4.extractBridgedArg<\$riverpod_8.Notifier<dynamic>>(rawNotifier, 'callback', visitor) as \$riverpod_8.Notifier<dynamic>; })",
  );
  content = content.replaceAll(
    "(() { return D4.extractBridgedArg<\$riverpod_6.AsyncNotifier<dynamic>>(D4.callInterpreterCallback(visitor!, createNotifierRaw, []), 'callback', visitor) as \$riverpod_6.AsyncNotifier<dynamic>; })",
    "(() { final rawNotifier = D4.callInterpreterCallback(visitor!, createNotifierRaw, []); if (rawNotifier is InterpretedInstance) { return InterpretedAsyncNotifierProxy(visitor!, rawNotifier); } return D4.extractBridgedArg<\$riverpod_6.AsyncNotifier<dynamic>>(rawNotifier, 'callback', visitor) as \$riverpod_6.AsyncNotifier<dynamic>; })",
  );
  content = content.replaceAll(
    "(() { return D4.extractBridgedArg<\$riverpod_10.StreamNotifier<dynamic>>(D4.callInterpreterCallback(visitor!, createNotifierRaw, []), 'callback', visitor) as \$riverpod_10.StreamNotifier<dynamic>; })",
    "(() { final rawNotifier = D4.callInterpreterCallback(visitor!, createNotifierRaw, []); if (rawNotifier is InterpretedInstance) { return InterpretedStreamNotifierProxy(visitor!, rawNotifier); } return D4.extractBridgedArg<\$riverpod_10.StreamNotifier<dynamic>>(rawNotifier, 'callback', visitor) as \$riverpod_10.StreamNotifier<dynamic>; })",
  );
  content = content.replaceAll(
    "        return t.watch(provider);",
    "        return _unwrapInterpretedProxy(t.watch(provider));",
  );
  content = content.replaceAll(
    "        return t.read(provider);",
    "        return _unwrapInterpretedProxy(t.read(provider));",
  );
  content = content.replaceAll(
    "        return t.refresh(provider);",
    "        return _unwrapInterpretedProxy(t.refresh(provider));",
  );
  content = content.replaceAll(
    "        return t.read(listenable);",
    "        return _unwrapInterpretedProxy(t.read(listenable));",
  );
  content = content.replaceAll(
    "        return t.watch(listenable);",
    "        return _unwrapInterpretedProxy(t.watch(listenable));",
  );

  // 9. Riverpod still has these AsyncValue getters; the generator sometimes
  // omits them. Do not reintroduce `valueOrNull` — riverpod 3 removed it.
  if (!content.contains("'isLoading':")) {
    const asyncGetters = """      'isLoading': (visitor, target) =>
          D4.validateTarget<TARGET_TYPE>(target, 'TARGET_NAME').isLoading,
      'isRefreshing': (visitor, target) =>
          D4.validateTarget<TARGET_TYPE>(target, 'TARGET_NAME').isRefreshing,
      'isReloading': (visitor, target) =>
          D4.validateTarget<TARGET_TYPE>(target, 'TARGET_NAME').isReloading,
      'hasValue': (visitor, target) =>
          D4.validateTarget<TARGET_TYPE>(target, 'TARGET_NAME').hasValue,
      'hasError': (visitor, target) =>
          D4.validateTarget<TARGET_TYPE>(target, 'TARGET_NAME').hasError,
      'hashCode':""";

    for (final name in [
      'AsyncValue',
      'AsyncData',
      'AsyncLoading',
      'AsyncError',
    ]) {
      final targetType = '\$riverpod_5.$name';
      final snippet = asyncGetters
          .replaceAll('TARGET_TYPE', targetType)
          .replaceAll('TARGET_NAME', name);
      final search =
          "      'hashCode': (visitor, target) => D4\n          .validateTarget<$targetType>(target, '$name')\n          .hashCode,";
      content = content.replaceFirst(
        search,
        snippet + search.substring(search.indexOf(" (visitor, target)")),
      );
    }
  }

  // 9b. Same AsyncValue getters for single-line emission. Do not alias
  // `valueOrNull`; riverpod 3 removed it. DN-PATCH.
  if (!content.contains("'isLoading':")) {
    for (final name in [
      'AsyncValue',
      'AsyncData',
      'AsyncLoading',
      'AsyncError',
    ]) {
      final targetType = '\$riverpod_5.$name';
      content = content.replaceFirst(
        "      'hashCode': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').hashCode,",
        "      'isLoading': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').isLoading,\n"
            "      'isRefreshing': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').isRefreshing,\n"
            "      'isReloading': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').isReloading,\n"
            "      'hasValue': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').hasValue,\n"
            "      'hasError': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').hasError,\n"
            "      'hashCode': (visitor, target) => D4.validateTarget<$targetType>(target, '$name').hashCode,",
      );
    }
  }

  content = _patchRiverpodGeneratorSkew(content);

  file.writeAsStringSync(content);
}

/// Generator skew that shows up after a riverpod regeneration. DN-PATCH.
///
/// - `$aux_riverpod_N.StateNotifier` is emitted with no import for that prefix.
///   `state_notifier` is already imported as `$state_notifier_N`.
/// - `ProviderScope` overrides/observers are emitted as `List<dynamic>`, but the
///   constructor requires `List<Override>` / `List<ProviderObserver>` from
///   `package:riverpod/src/framework.dart`. Alias numbers shift, so resolve them.
String _patchRiverpodGeneratorSkew(String content) {
  final stateNotifierAlias = RegExp(
    r"import 'package:state_notifier/state_notifier\.dart' as (\$state_notifier_\d+);",
  ).firstMatch(content)?.group(1);
  if (stateNotifierAlias != null) {
    content = content.replaceAll(
      RegExp(r'\$aux_riverpod_\d+\.StateNotifier'),
      '$stateNotifierAlias.StateNotifier',
    );
  }

  final frameworkAlias = RegExp(
    r"import 'package:riverpod/src/framework\.dart' as (\$riverpod_\d+);",
  ).firstMatch(content)?.group(1);
  if (frameworkAlias != null) {
    content = content.replaceAll(
      "D4.coerceList<dynamic>(named['overrides'], 'overrides')",
      "D4.coerceList<$frameworkAlias.Override>(named['overrides'], 'overrides')",
    );
    content = content.replaceAll(
      "? D4.coerceList<$frameworkAlias.Override>(named['overrides'], 'overrides')\n            : const <dynamic>[];",
      "? D4.coerceList<$frameworkAlias.Override>(named['overrides'], 'overrides')\n            : const <$frameworkAlias.Override>[];",
    );
    content = content.replaceAll(
      'D4.coerceListOrNull<dynamic>(\n          named[\'observers\'],\n          \'observers\',\n        )',
      'D4.coerceListOrNull<$frameworkAlias.ProviderObserver>(\n          named[\'observers\'],\n          \'observers\',\n        )',
    );
    content = content.replaceAll(
      "D4.coerceListOrNull<dynamic>(named['observers'], 'observers')",
      "D4.coerceListOrNull<$frameworkAlias.ProviderObserver>(named['observers'], 'observers')",
    );
    // Riverpod 3 removed `valueOrNull`. Strip it if a previous patch or a
    // stale generation left it, even when guest code still calls it.
    content = content.replaceAll(
      RegExp(
        r"\n\s*'valueOrNull': \(visitor, target\) =>[\s\S]*?\.value,",
      ),
      '',
    );
    if (!content.contains("'isLoading':")) {
      const extra = [
        'isLoading',
        'isRefreshing',
        'isReloading',
        'hasValue',
        'hasError',
      ];
      for (final name in [
        'AsyncValue',
        'AsyncData',
        'AsyncLoading',
        'AsyncError',
      ]) {
        final member = {
          'isLoading': 'isLoading',
          'isRefreshing': 'isRefreshing',
          'isReloading': 'isReloading',
          'hasValue': 'hasValue',
          'hasError': 'hasError',
        };
        final multi =
            "      'hashCode': (visitor, target) => D4\n"
            "          .validateTarget<$frameworkAlias.$name>(target, '$name')\n"
            "          .hashCode,";
        final single =
            "      'hashCode': (visitor, target) => D4.validateTarget<$frameworkAlias.$name>(target, '$name').hashCode,";
        final inserted = [
          for (final key in extra)
            "      '$key': (visitor, target) => D4.validateTarget<$frameworkAlias.$name>(target, '$name').${member[key]},",
        ].join('\n');
        if (content.contains(multi)) {
          content = content.replaceFirst(multi, '$inserted\n$multi');
        } else if (content.contains(single)) {
          content = content.replaceFirst(single, '$inserted\n$single');
        }
      }
    }
  }
  return content;
}
