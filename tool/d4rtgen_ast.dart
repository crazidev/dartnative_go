// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:tom_build_base/tom_build_base_v2.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_executor.dart';
import 'package:tom_d4rt_generator/src/v2/d4rtgen_tool.dart';

import 'd4rtgen_select.dart';

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
  final select = parseBridgeSelectArgs(args);
  if (select.runnerArgs.contains('--help') ||
      select.runnerArgs.contains('-h')) {
    stdout.writeln(bridgeSelectHelp);
  }
  final projectDir = Directory.current.path;
  try {
    File(astConfig).copySync(primary);
    final plan = _prepareAstSelection(
      buildkitPath: primary,
      projectDir: projectDir,
      options: select,
    );
    if (plan != null && plan.selected.isEmpty) {
      stdout.writeln('No AST bridge modules need generation.');
      _recordAstStamps(
        projectDir: projectDir,
        buildkitPath: primary,
        plan: SelectionPlan(
          selected: [
            for (final module in readBridgeModules(primary))
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
    _applyAstBridgePostFixes(only: only);
    await _formatGeneratedBridges(isAst: true, only: only);
    _recordAstStamps(
      projectDir: projectDir,
      buildkitPath: primary,
      plan: plan,
    );
  } finally {
    primaryFile.writeAsStringSync(original);
    deletePartialRelaxer(projectDir);
    try {
      File(backup).deleteSync();
    } catch (_) {}
  }
}

SelectionPlan? _prepareAstSelection({
  required String buildkitPath,
  required String projectDir,
  required BridgeSelectOptions options,
}) {
  if (!options.restricts) return null;
  final modules = readBridgeModules(buildkitPath);
  final plan = planSelection(
    modules: modules,
    options: options,
    isChanged: (module) => moduleSourcesChanged(
      module: module,
      projectDir: projectDir,
      stampKey: 'ast:${module.name}',
    ),
  );
  if (plan.selected.isEmpty) {
    stdout.writeln(
      'Skipping ${plan.skipped.length} unchanged AST module(s): '
      '${plan.skipped.join(', ')}',
    );
    return plan;
  }
  stdout.writeln(
    'Generating ${plan.selected.length} AST module(s): '
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

void _recordAstStamps({
  required String projectDir,
  required String buildkitPath,
  required SelectionPlan? plan,
}) {
  final modules = plan?.selected ?? readBridgeModules(buildkitPath);
  final roots = loadPackageRoots(projectDir);
  final edition = readFrameworkEdition();
  writeStamps(projectDir, {
    for (final module in modules)
      'ast:${module.name}': moduleFingerprint(
        module: module,
        packageRoots: roots,
        frameworkEdition: edition,
      ),
  });
}

/// Formats the generated AST bridge set as the final generation step.
///
/// Mirrors `_formatGeneratedBridges` in `tool/d4rtgen.dart`: the generator's
/// raw layout plus the `DN-PATCH` splices are not canonical, so formatting here
/// keeps `dart run tool/d4rtgen_ast.dart` a no-op on unchanged sources instead
/// of producing a whole-file whitespace diff.
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
    stderr.writeln('dart format failed on generated AST bridges:');
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    exitCode = 1;
  }
}

/// Same generator-bug workarounds as `tool/d4rtgen.dart`, applied to the
/// AST output dir. Kept in sync manually until the generator is fixed.
/// Modules whose bridged API surface uses `@experimental` members (Hive's
/// `HiveList`, …). The generator emits calls to them, so without the ignore
/// every regeneration reintroduces warnings into `dart analyze`. Keeping the
/// list explicit means a regeneration only rewrites the files that need it
/// instead of touching every bridge with a cosmetic ignore line. DN-PATCH.
const _experimentalMemberModules = {'dartnative_hive_bridges.b.dart'};

/// Silences `experimental_member_use` in one generated bridge.
void _addExperimentalMemberUseIgnore(String path) {
  if (!_experimentalMemberModules.any(path.endsWith)) return;
  final file = File(path);
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();
  const marker = '// ignore_for_file: ';
  final idx = content.indexOf(marker);
  if (idx < 0) return;
  if (content.substring(idx, content.indexOf('\n', idx)).contains(
    'experimental_member_use',
  )) {
    return;
  }
  content = content.replaceFirst(
    marker,
    '${marker}experimental_member_use, ',
  );
  file.writeAsStringSync(content);
}

void _applyAstBridgePostFixes({Set<String>? only}) {
  bool want(String path) => only == null || only.contains(path);

  final dnBridgesFile = File(
    'lib/src/interpreter/ast/dartnative_bridges.b.dart',
  );
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
    // ValueNotifier<T> is mutable (has `set value(T)`): narrowing
    // `ValueNotifier(0)` to `ValueNotifier<int>(0)` via GEN-075 breaks
    // `ValueNotifier<double> x = ValueNotifier(0); x.value = 1.5;` and
    // nullable `ValueNotifier<T?>` assigned `null`.
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
    // ListenableWatch.watch on interpreted ChangeNotifier subclasses:
    // `target` is an InterpretedInstance whose `bridgedSuperObject` is the
    // native ChangeNotifier (a Listenable). Unwrap via D4.validateTarget and
    // return `target` so `final hist = _history.watch<_ClickHistory>(context)`
    // preserves the guest instance.
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
    dnBridgesFile.writeAsStringSync(content);
  }

  if (want('lib/src/interpreter/ast/riverpod_kit_bridges.b.dart')) {
    _patchRiverpodBridges(
      File('lib/src/interpreter/ast/riverpod_kit_bridges.b.dart'),
    );
  }
  if (want('lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart')) {
    _patchNativeBottomsheetBridges(
      File('lib/src/interpreter/ast/native_bottomsheet_bridges.b.dart'),
    );
  }
  if (want(
    'lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart',
  )) {
    _patchDartNativeCompatBridges(
      File('lib/src/interpreter/ast/dartnative_flutter_compat_bridges.b.dart'),
    );
  }
  if (want('lib/src/interpreter/ast/dio_bridges.b.dart')) {
    _patchDioBridges(File('lib/src/interpreter/ast/dio_bridges.b.dart'));
  }
  if (want('lib/src/interpreter/ast/dartnative_sqlite_bridges.b.dart')) {
    _patchSqliteBridges(
      File('lib/src/interpreter/ast/dartnative_sqlite_bridges.b.dart'),
    );
  }

  final dir = Directory('lib/src/interpreter/ast');
  if (dir.existsSync()) {
    for (final entity in dir.listSync()) {
      if (entity is File &&
          entity.path.endsWith('.b.dart') &&
          want(entity.path)) {
        _addExperimentalMemberUseIgnore(entity.path);
      }
    }
  }
}

/// sqflite's `Database.query` family declares nullable named parameters with
/// the legacy `Type??` spelling, which the generator emits verbatim and which
/// does not parse under null safety. Collapse `??>` to `?>`. DN-PATCH.
void _patchSqliteBridges(File file) {
  if (!file.existsSync()) return;
  var content = file.readAsStringSync();
  content = content.replaceAll('??>', '?>');
  file.writeAsStringSync(content);
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
  // Same Widget-return coercion as tool/d4rtgen.dart (see above). DN-PATCH.
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

void _patchRiverpodBridges(File file) {
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

  // 4b. Same patch for single-line emission (see tool/d4rtgen.dart). DN-PATCH.
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

  // 5. Proxy import for Notifier bridging (mirrors tool/d4rtgen.dart).
  const proxyImport = "import 'ast_widget_proxies.dart';";
  if (!content.contains(proxyImport)) {
    content = content.replaceFirst(
      "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;",
      "import 'package:dartnative/dartnative.dart' as \$flutter_widgets;\n$proxyImport",
    );
  }

  // 6. Define _unwrapInterpretedProxy helper if absent.
  if (!content.contains('Object? _unwrapInterpretedProxy(')) {
    content = content.replaceFirst(
      'class RiverpodKitBridge {',
      'Object? _unwrapInterpretedProxy(Object? val) {\n  if (val is InterpretedNotifierProxy) {\n    return val.instance;\n  }\n  if (val is InterpretedAsyncNotifierProxy) {\n    return val.instance;\n  }\n  if (val is InterpretedStreamNotifierProxy) {\n    return val.instance;\n  }\n  return val;\n}\n\nclass RiverpodKitBridge {',
    );
  }

  // 7d. Notifier factory wraps for single-line emission (see tool/d4rtgen.dart).
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

  // 8. Unwrap InterpretedNotifierProxy on watch, read, and refresh.
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

  // 9b. AsyncValue getters for single-line emission (see tool/d4rtgen.dart).
  // Do not alias `valueOrNull`; riverpod 3 removed it.
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

/// Same generator skew as `tool/d4rtgen.dart`. Kept in sync manually. DN-PATCH.
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
