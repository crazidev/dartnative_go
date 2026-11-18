/// UI scenario runner: drives a YAML scenario against the real mobile app
/// or a headless canned device — no `package:test`, no `dart:ui`.
///
/// Runs under vanilla `dart run` (imports are `dart:` + `package:yaml` +
/// the pure `UiAutomator` driver only):
///
/// ```sh
/// # Headless: validate the scenario flow without hardware.
/// dart run tool/ui_test_run.dart --scenario tool/scenarios/counter.yaml --against fake
///
/// # Real device: app connected to the dev server, guest mounted.
/// dngo start                                    # in example/ (or your project)
/// dart run tool/ui_test_run.dart --scenario tool/scenarios/example_login.yaml \
///   --server http://192.168.3.159:8088
/// ```
///
/// Exit codes: 0 = all steps passed, 1 = step failure, 2 = usage/config error.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:dartnative_go/src/runner/icon_registry.dart';
import '../test/test_lab/fake_server.dart';
import '../test/test_lab/ui_automator.dart';

void _usage([String? error]) {
  if (error != null) stderr.writeln('Error: $error\n');
  stderr.writeln(
    '''Usage: dart run tool/ui_test_run.dart --scenario <path> [options]

Options:
  --scenario <path>     YAML scenario file (required).
  --server <url>        Dev-server URL the app is connected to
                        (required unless --against fake).
  --against <mode>      fake | device (default: device).
  --project-dir <dir>   Overrides the scenario's project_dir (reload edits).
  --step-timeout <s>    Default per-step timeout in seconds (default 10).
  --list-trees          Dump every probed tree as JSON.
  -h, --help            Show this help.''',
  );
}

Future<void> main(List<String> args) async {
  if (args.contains('-h') || args.contains('--help')) {
    _usage();
    return;
  }
  String? scenarioPath;
  String? serverUrl;
  String against = 'device';
  String? projectDirOverride;
  var stepTimeout = 10;
  var listTrees = false;

  for (var i = 0; i < args.length; i++) {
    String value(String flag) {
      if (i + 1 >= args.length) {
        _usage('missing value for $flag');
        exit(2);
      }
      return args[++i];
    }

    switch (args[i]) {
      case '--scenario':
        scenarioPath = value('--scenario');
      case '--server':
        serverUrl = value('--server');
      case '--against':
        against = value('--against');
      case '--project-dir':
        projectDirOverride = value('--project-dir');
      case '--step-timeout':
        stepTimeout = int.tryParse(value('--step-timeout')) ?? 10;
      case '--list-trees':
        listTrees = true;
      default:
        _usage('unknown argument: ${args[i]}');
        exit(2);
    }
  }

  if (scenarioPath == null) {
    _usage('missing required --scenario');
    exit(2);
  }
  if (against != 'fake' && against != 'device') {
    _usage('--against must be fake or device, got "$against"');
    exit(2);
  }
  if (against == 'device' && serverUrl == null) {
    _usage('--server is required unless --against fake');
    exit(2);
  }

  final scenario = _loadScenario(scenarioPath);
  serverUrl ??= scenario.server;
  if (against == 'device' && serverUrl == null) {
    _usage('scenario has no server: and --server was not given');
    exit(2);
  }

  final runner = _ScenarioRunner(
    scenario: scenario,
    serverUrl: serverUrl ?? '',
    fakeMode: against == 'fake',
    projectDirOverride: projectDirOverride,
    defaultStepTimeout: Duration(seconds: stepTimeout),
    listTrees: listTrees,
  );
  final ok = await runner.run();
  exit(ok ? 0 : 1);
}

// ---------------------------------------------------------------------------
// Scenario model (parsed YAML).
// ---------------------------------------------------------------------------

class _Scenario {
  final String name;
  final String? server;
  final String? projectDir;
  final Duration stepTimeout;
  final Duration probeInterval;
  final Map<String, dynamic>? fake;
  final List<Map<String, dynamic>> steps;

  _Scenario({
    required this.name,
    required this.server,
    required this.projectDir,
    required this.stepTimeout,
    required this.probeInterval,
    required this.fake,
    required this.steps,
  });
}

dynamic _yamlToJson(dynamic node) {
  if (node is YamlMap) {
    return {
      for (final e in node.entries) e.key.toString(): _yamlToJson(e.value),
    };
  }
  if (node is YamlList) return [for (final v in node) _yamlToJson(v)];
  return node;
}

_Scenario _loadScenario(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Error: scenario file not found: $path');
    exit(2);
  }
  final doc = _yamlToJson(loadYaml(file.readAsStringSync()));
  if (doc is! Map<String, dynamic>) {
    stderr.writeln('Error: scenario must be a YAML map: $path');
    exit(2);
  }
  final defaults = doc['defaults'] as Map<String, dynamic>? ?? {};
  final rawSteps = doc['steps'];
  if (rawSteps is! List || rawSteps.isEmpty) {
    stderr.writeln('Error: scenario needs a non-empty steps: list');
    exit(2);
  }
  return _Scenario(
    name: doc['name']?.toString() ?? path,
    server: doc['server']?.toString(),
    projectDir: doc['project_dir']?.toString(),
    stepTimeout: Duration(
      seconds: (defaults['step_timeout_s'] as num? ?? 10).toInt(),
    ),
    probeInterval: Duration(
      milliseconds: (defaults['probe_interval_ms'] as num? ?? 300).toInt(),
    ),
    fake: doc['fake'] as Map<String, dynamic>?,
    steps: [
      for (final s in rawSteps)
        if (s is Map<String, dynamic>)
          s
        else
          throw _configError('each step must be a single-key map, got: $s'),
    ],
  );
}

Never _configError(String message) {
  stderr.writeln('Error: invalid scenario: $message');
  exit(2);
}

// ---------------------------------------------------------------------------
// Runner.
// ---------------------------------------------------------------------------

class _ScenarioRunner {
  final _Scenario scenario;
  final String serverUrl;
  final bool fakeMode;
  final String? projectDirOverride;
  final Duration defaultStepTimeout;
  final bool listTrees;

  UiAutomator? _auto;
  FakeDevServer? _fakeServer;
  _CannedDevice? _canned;
  Directory? _fakeSandbox;
  Map<String, dynamic>? _lastTree;
  final Map<String, dynamic> _variables = {};

  _ScenarioRunner({
    required this.scenario,
    required this.serverUrl,
    required this.fakeMode,
    required this.projectDirOverride,
    required this.defaultStepTimeout,
    required this.listTrees,
  });

  String get _projectDir =>
      projectDirOverride ??
      scenario.projectDir ??
      _configErrorExit(
        'reload steps need project_dir: (scenario or --project-dir)',
      );

  Never _configErrorExit(String message) {
    stderr.writeln('Error: $message');
    exit(2);
  }

  Future<bool> run() async {
    print('▶️  Scenario: ${scenario.name} (${fakeMode ? 'fake' : serverUrl})');
    try {
      await _connect();
      var index = 0;
      for (final step in scenario.steps) {
        index++;
        if (step.length != 1) {
          throw UiAutomationFailure(
            'step $index must have exactly one key, got: ${step.keys}',
          );
        }
        final kind = step.keys.single;
        final arg = step[kind];
        final sw = Stopwatch()..start();
        await _runStep(kind, arg);
        sw.stop();
        print(
          '  ✓ [$index] ${_describe(kind, arg)} '
          '(${(sw.elapsedMilliseconds / 1000).toStringAsFixed(1)}s)',
        );
      }
      print('✅ Scenario passed (${scenario.steps.length} steps)');
      return true;
    } on UiAutomationFailure catch (e) {
      print('❌ FAILED: $e');
      // probeUntil failures already embed the last tree; don't print a
      // (possibly staler) second copy.
      if (_lastTree != null && !'$e'.contains('Last tree:')) {
        final dump = jsonEncode(_lastTree);
        print('   last tree: ${dump.substring(0, dump.length.clamp(0, 2000))}');
      }
      return false;
    } finally {
      await _auto?.disconnect();
      await _canned?.disconnect();
      await _fakeServer?.stop();
      if (_fakeSandbox != null) {
        try {
          _fakeSandbox!.deleteSync(recursive: true);
        } catch (_) {}
      }
    }
  }

  Future<void> _connect() async {
    if (fakeMode) {
      final fake = scenario.fake;
      if (fake == null) {
        throw UiAutomationFailure(
          'fake mode needs a top-level fake: block '
          '(trees:, taps:, files:) in the scenario',
        );
      }
      _fakeServer = FakeDevServer(appName: 'UI CLI fake');
      await _fakeServer!.start();
      _canned = _CannedDevice(
        serverUrl: _fakeServer!.baseUrl,
        trees: (fake['trees'] as List? ?? [])
            .map((t) => Map<String, dynamic>.from(t as Map))
            .toList(),
        taps: Map<String, String>.from(
          (fake['taps'] as Map? ?? {}).map((k, v) => MapEntry('$k', '$v')),
        ),
      );
      await _canned!.connect();
      _auto = UiAutomator(
        serverUrl: _fakeServer!.baseUrl,
        stepTimeout: defaultStepTimeout,
      );
      await _auto!.connect();
      final files = fake['files'];
      if (files is Map && files.isNotEmpty) {
        _fakeSandbox = Directory.systemTemp.createTempSync('ui_cli_sandbox_');
        for (final e in files.entries) {
          final f = File('${_fakeSandbox!.path}/${e.key}');
          f.parent.createSync(recursive: true);
          f.writeAsStringSync('${e.value}');
        }
      }
    } else {
      _auto = UiAutomator(
        serverUrl: serverUrl,
        stepTimeout: defaultStepTimeout,
      );
      await _auto!.connect();
    }
  }

  String _describe(String kind, dynamic arg) {
    if (arg is Map) {
      if (arg.isEmpty) return kind;
      if (kind == 'type') {
        final text = arg['text'];
        final target =
            arg['into'] ??
            arg['placeholder'] ??
            arg['hint'] ??
            arg['key'] ??
            arg['title'];
        if (target != null && text != null) return 'type "$text" into $target';
        if (text != null) return 'type "$text"';
      }
      final first = arg.entries.first;
      return '$kind ${first.key}=${first.value}';
    }
    return arg == null ? kind : '$kind $arg';
  }

  Future<void> _runStep(String kind, dynamic arg) async {
    final auto = _auto!;
    switch (kind) {
      case 'probe':
        _lastTree = await auto.probe();
        _maybeDump();
      case 'expect_text':
        UiAutomator.expectText(_requireTree(), '$arg');
      case 'expect_no_text':
        UiAutomator.expectNoText(_requireTree(), '$arg');
      case 'expect_button':
        UiAutomator.expectButton(_requireTree(), '$arg');
      case 'tap':
        final target = _resolveTargetArg(arg);
        await auto.tap(target);
        _lastTree = null; // stale after a tap; next probe refreshes
      case 'set':
        final vars = _mapArg(arg);
        for (final e in vars.entries) {
          _variables[e.key] = _resolveTargetArg(e.value);
        }
      case 'hover':
      case 'focus':
      case 'blur':
      case 'submit':
      case 'type':
        await _runTrigger(kind, arg);
        _lastTree = null;
      case 'scroll':
        final spec = _mapArg(arg);
        final dy = (spec['delta_y'] as num?)?.toDouble() ?? 100.0;
        final dx = (spec['delta_x'] as num?)?.toDouble() ?? 0.0;
        final targetArg = spec['target'];
        final target = targetArg != null ? _resolveTargetArg(targetArg) : null;
        await auto.scroll(
          target: target is Map<String, dynamic> ? target : null,
          deltaX: dx,
          deltaY: dy,
        );
        _lastTree = null;
      case 'expect_key':
        UiAutomator.expectKey(_requireTree(), '$arg');
      case 'expect_icon':
        int? cp;
        String? ff;
        dynamic iconRef;
        if (arg is String) {
          var iconExpr = arg.trim();
          String? asVar;
          if (iconExpr.contains(' as ')) {
            final parts = iconExpr.split(' as ');
            iconExpr = parts[0].trim();
            asVar = parts[1].trim();
          }
          final resolvedTarget = _resolveTargetArg(iconExpr);
          if (asVar != null) {
            _variables[asVar] = resolvedTarget;
          }
          if (resolvedTarget is Map) {
            cp = resolvedTarget['icon_code_point'] is int
                ? resolvedTarget['icon_code_point'] as int
                : int.tryParse('${resolvedTarget['icon_code_point']}');
            ff = resolvedTarget['icon_font_family']?.toString();
            iconRef = resolvedTarget['icon_name'] ?? iconExpr;
          } else {
            cp = int.tryParse(iconExpr);
            iconRef = iconExpr;
          }
        } else {
          final iconCond = _mapArg(arg);
          final asVar = iconCond['as']?.toString();
          final resolvedTarget = _resolveTargetArg(iconCond);
          if (asVar != null) {
            _variables[asVar] = resolvedTarget;
          }
          if (resolvedTarget is Map) {
            cp = resolvedTarget['icon_code_point'] is int
                ? resolvedTarget['icon_code_point'] as int
                : int.tryParse('${resolvedTarget['icon_code_point']}');
            ff = resolvedTarget['icon_font_family']?.toString();
            iconRef = resolvedTarget['icon_name'] ?? iconCond['icon'];
          }
        }
        UiAutomator.expectIcon(
          _requireTree(),
          icon: iconRef,
          codePoint: cp,
          fontFamily: ff,
        );
      case 'probe_until':
        final cond = _mapArg(arg);
        final iconTarget = cond['icon'] != null
            ? _resolveTargetArg(cond['icon'])
            : null;
        int? iconCp;
        String? iconFf = cond['icon_font_family']?.toString();
        dynamic iconRef = cond['icon'];
        if (iconTarget is Map) {
          iconCp = iconTarget['icon_code_point'] is int
              ? iconTarget['icon_code_point'] as int
              : int.tryParse('${iconTarget['icon_code_point']}');
          iconFf ??= iconTarget['icon_font_family']?.toString();
          iconRef = iconTarget['icon_name'] ?? iconRef;
        } else if (iconTarget is int) {
          iconCp = iconTarget;
        } else if (cond['icon'] != null) {
          iconCp = int.tryParse('${cond['icon']}');
        }
        _lastTree = await auto.probeUntil(
          text: cond['text']?.toString(),
          absentText: cond['absent_text']?.toString(),
          button: cond['button']?.toString(),
          key: cond['key']?.toString(),
          icon: iconRef,
          iconCodePoint: iconCp,
          iconFontFamily: iconFf,
          timeout: _seconds(cond['timeout_s']) ?? defaultStepTimeout,
          interval: scenario.probeInterval,
        );
        _maybeDump();
      case 'reload':
        await _runReload(_mapArg(arg));
        _lastTree = null;
      case 'restart':
        // Hot restart before/during a scenario: fresh interpreter state and
        // (re)mount. Doubles as "load the app" when the project is dispatched
        // but the guest isn't mounted yet. `arg` may be null/{} or a settle
        // map {text, absent_text, button, timeout_s}.
        _auto!.triggerRestart();
        _lastTree = null;
        if (arg != null) {
          final cond = _mapArg(arg);
          final hasCond =
              cond['text'] != null ||
              cond['absent_text'] != null ||
              cond['button'] != null;
          if (hasCond) {
            _lastTree = await _auto!.probeUntil(
              text: cond['text']?.toString(),
              absentText: cond['absent_text']?.toString(),
              button: cond['button']?.toString(),
              timeout: _seconds(cond['timeout_s']) ?? defaultStepTimeout,
              interval: scenario.probeInterval,
            );
            _maybeDump();
          } else {
            await Future<void>.delayed(const Duration(seconds: 2));
          }
        } else {
          await Future<void>.delayed(const Duration(seconds: 2));
        }
      case 'sleep':
        await Future<void>.delayed(
          Duration(milliseconds: (arg as num?)?.toInt() ?? 500),
        );
      case 'require_clean':
        // Fail fast when reload-target files carry leftover edits from an
        // aborted run (e.g. a previous reload that never reverted). Takes
        // {files: [rel, paths...]} resolved against project_dir (device) or
        // the temp sandbox (fake mode, pristine by construction).
        await _runRequireClean(_mapArg(arg));
      case 'log':
        print('  … ${_stringArg(arg, 'msg')}');
      default:
        throw UiAutomationFailure('unknown step: $kind');
    }
  }

  Map<String, dynamic> _requireTree() {
    final tree = _lastTree;
    if (tree == null) {
      throw UiAutomationFailure(
        'no probed tree yet — add a probe: or probe_until: step first',
      );
    }
    return tree;
  }

  void _maybeDump() {
    if (listTrees && _lastTree != null) print(jsonEncode(_lastTree));
  }

  dynamic _resolveTargetArg(dynamic arg) {
    if (arg is String) {
      final varName = arg.startsWith(r'$') ? arg.substring(1) : arg;
      if (_variables.containsKey(varName)) {
        return _variables[varName];
      }
      final resolved = resolveIcon(arg);
      if (resolved != null) {
        return {
          'icon_code_point': resolved.codePoint,
          'icon_font_family': resolved.fontFamily,
          'icon_name': arg,
        };
      }
      return arg;
    }
    if (arg is Map) {
      final map = Map<String, dynamic>.from(arg);
      final resolved = resolveIcon(map);
      final out = <String, dynamic>{};
      for (final e in map.entries) {
        final k = e.key.toString();
        final v = e.value;
        if (k == 'icon' || k == 'code_point') {
          if (v is int) {
            out['icon_code_point'] = v;
          } else if (v is Map) {
            out['icon_code_point'] = v['code_point'] ?? v['icon'];
            out['icon_font_family'] = v['font_family'];
          } else if (v is String) {
            final named = resolveIcon(v);
            if (named != null) {
              out['icon_code_point'] = named.codePoint;
              out['icon_font_family'] = named.fontFamily;
              out['icon_name'] = v;
            } else {
              out['icon_code_point'] = int.tryParse(v);
            }
          } else {
            out['icon_code_point'] = int.tryParse('$v');
          }
        } else if (k == 'font_family') {
          out['icon_font_family'] = '$v';
        } else {
          out[k] = v;
        }
      }
      if (resolved != null) {
        out['icon_code_point'] ??= resolved.codePoint;
        out['icon_font_family'] ??= resolved.fontFamily;
      }
      return out;
    }
    return arg;
  }

  String _stringArg(dynamic arg, String key) {
    if (arg is Map<String, dynamic>) return '${arg[key]}';
    return '$arg';
  }

  Map<String, dynamic> _mapArg(dynamic arg) {
    if (arg is Map<String, dynamic>) return arg;
    throw UiAutomationFailure('step needs a map argument, got: $arg');
  }

  Duration? _seconds(dynamic v) =>
      v == null ? null : Duration(seconds: (v as num).toInt());

  // -- reload (edit or signal) --

  /// Trigger steps: hover / focus / blur / submit / type.
  ///
  /// Target selects via title/text/key/icon_code_point/icon_font_family;
  /// submit/type take an optional text payload:
  /// `submit: {key: search, text: query}`. Fails with the device-reported
  /// error (e.g. focus on a Button, submit without onSubmitted).
  Future<void> _runTrigger(String kind, dynamic arg) async {
    final resolved = _resolveTargetArg(arg);
    Map<String, dynamic> spec;
    String? text;

    if (resolved is String && (kind == 'type' || kind == 'submit')) {
      spec = const {};
      text = resolved;
    } else if (resolved is Map<String, dynamic>) {
      spec = resolved;
      text = spec['text']?.toString();
    } else if (resolved is Map) {
      spec = Map<String, dynamic>.from(resolved);
      text = spec['text']?.toString();
    } else {
      spec = const {};
    }

    final target = <String, dynamic>{};
    if (spec['title'] != null) target['title'] = '${spec['title']}';
    if (spec['key'] != null) target['key'] = '${spec['key']}';

    final placeholder =
        spec['placeholder'] ??
        spec['hint'] ??
        (spec['into'] is String ? spec['into'] : null) ??
        (spec['target'] is String ? spec['target'] : null);
    if (placeholder != null) target['placeholder'] = '$placeholder';

    if (spec['into'] is Map) {
      target.addAll(Map<String, dynamic>.from(spec['into'] as Map));
    }
    if (spec['target'] is Map) {
      target.addAll(Map<String, dynamic>.from(spec['target'] as Map));
    }

    // `text:` doubles as target Text-data match for find-only actions…
    if (spec['text'] != null && kind != 'submit' && kind != 'type') {
      target['text'] = '${spec['text']}';
    }
    if (spec['icon'] != null) {
      final cp = spec['icon'] is int
          ? spec['icon'] as int
          : int.tryParse('${spec['icon']}');
      if (cp != null) target['icon_code_point'] = cp;
    }
    if (spec['icon_font_family'] != null) {
      target['icon_font_family'] = '${spec['icon_font_family']}';
    }

    if (target.isEmpty &&
        (kind == 'type' || kind == 'focus' || kind == 'submit')) {
      target['any_text_field'] = true;
    }

    switch (kind) {
      case 'hover':
        await _auto!.hover(target: target);
      case 'focus':
        await _auto!.focus(target: target);
      case 'blur':
        await _auto!.blur(target: target);
      case 'submit':
        await _auto!.submit(target: target, text: text);
      case 'type':
        if (text == null) {
          throw UiAutomationFailure(
            'type: needs text: {into/placeholder/key/text, text} or type: "text"',
          );
        }
        await _auto!.type(target: target, text: text);
    }
  }

  Future<void> _runReload(Map<String, dynamic> spec) async {
    if (spec.containsKey('signal') && spec['signal'] == true) {
      _auto!.triggerReload(spec['changed_file']?.toString());
      final settle = spec['settle'];
      if (settle is Map<String, dynamic>) {
        _lastTree = await _auto!.probeUntil(
          text: settle['text']?.toString(),
          absentText: settle['absent_text']?.toString(),
          button: settle['button']?.toString(),
          timeout: _seconds(settle['timeout_s']) ?? defaultStepTimeout,
          interval: scenario.probeInterval,
        );
      }
      return;
    }

    final edit = spec['edit'];
    if (edit is! Map<String, dynamic>) {
      throw UiAutomationFailure(
        'reload: needs edit: {file, search, replace} or edit: {file, append: …} '
        '(no full-file write in v1) or signal: true',
      );
    }
    final relPath = '${edit['file']}';
    if (relPath.isEmpty || relPath.contains('..')) {
      throw UiAutomationFailure('reload edit: unsafe file path: $relPath');
    }
    final base = fakeMode
        ? (_fakeSandbox?.path ??
              _configErrorExit('reload edit in fake mode needs fake: files:'))
        : _projectDir;
    final file = File('$base/$relPath');
    if (!file.existsSync()) {
      throw UiAutomationFailure('reload edit: file not found: ${file.path}');
    }

    final original = file.readAsStringSync();
    final updated = _applyEdit(original, relPath, edit);
    file.writeAsStringSync(updated);
    if (file.readAsStringSync() == original) {
      throw UiAutomationFailure('reload edit: file unchanged: $relPath');
    }
    try {
      await _awaitSettle(spec['settle'], 'settle');
    } catch (e) {
      _restore(file, original);
      rethrow;
    }
    if (spec['revert'] == true) {
      _restore(file, original);
      if (file.existsSync() && file.readAsStringSync() != original) {
        throw UiAutomationFailure('reload edit: revert failed: $relPath');
      }
      await _awaitSettle(
        spec['revert_settle'],
        'revert_settle',
        optional: true,
      );
    } else {
      print('  … edit kept (revert not requested): $relPath');
    }
  }

  String _applyEdit(
    String original,
    String relPath,
    Map<String, dynamic> edit,
  ) {
    if (edit.containsKey('append')) {
      return '$original\n${edit['append']}\n';
    }
    final search = '${edit['search']}';
    final replace = '${edit['replace']}';
    if (search.isEmpty) {
      throw UiAutomationFailure('reload edit: search must not be empty');
    }
    final count = search.allMatches(original).length;
    if (count != 1) {
      final alreadyApplied =
          count == 0 && replace.isNotEmpty && original.contains(replace);
      throw UiAutomationFailure(
        alreadyApplied
            ? 'reload edit: "$search" not found but "$replace" already present '
                  'in $relPath — leftover from an aborted run? Restore the file '
                  '(git checkout -- $relPath) and rerun.'
            : 'reload edit: search occurs $count× in $relPath (need exactly 1)',
      );
    }
    return original.replaceFirst(search, replace);
  }

  void _restore(File file, String original) {
    try {
      file.writeAsStringSync(original);
    } catch (e) {
      stderr.writeln('Warning: could not restore ${file.path}: $e');
    }
  }

  Future<void> _runRequireClean(Map<String, dynamic> spec) async {
    final rawFiles = spec['files'];
    if (rawFiles is! List || rawFiles.isEmpty) {
      throw UiAutomationFailure(
        'require_clean: needs files: [rel, paths...]',
      );
    }
    if (fakeMode) {
      // Sandbox files are seeded fresh per run — pristine by construction.
      // Just confirm they exist.
      final sandbox = _fakeSandbox?.path;
      if (sandbox == null) {
        throw UiAutomationFailure(
          'require_clean in fake mode needs fake: files: seeded',
        );
      }
      final missing = <String>[];
      for (final f in rawFiles) {
        if (!File('$sandbox/$f').existsSync()) missing.add('$f');
      }
      if (missing.isNotEmpty) {
        throw UiAutomationFailure(
          'require_clean: missing from sandbox: ${missing.join(', ')}',
        );
      }
      return;
    }
    final base = _projectDir;
    for (final f in rawFiles) {
      if ('$f'.contains('..')) {
        throw UiAutomationFailure('require_clean: unsafe path: $f');
      }
    }
    ProcessResult diff;
    try {
      diff = await Process.run('git', [
        '-C',
        base,
        'diff',
        '--exit-code',
        '--',
        ...rawFiles.map((f) => '$f'),
      ]);
    } on ProcessException catch (e) {
      throw UiAutomationFailure('require_clean: cannot run git: $e');
    }
    if (diff.exitCode != 0) {
      final err = '${diff.stderr}'.trim();
      if (err.contains('not a git repository')) {
        throw UiAutomationFailure(
          'require_clean: $base is not a git repository — omit the step',
        );
      }
      if (spec['restore'] == true) {
        // Whole-state reset: restore leftover edits instead of blocking.
        final restored = await Process.run('git', [
          '-C',
          base,
          'restore',
          '--source=HEAD',
          '--',
          ...rawFiles.map((f) => '$f'),
        ]);
        if (restored.exitCode != 0) {
          throw UiAutomationFailure(
            'require_clean: git restore failed: ${restored.stderr}'.trim(),
          );
        }
        print(
          '  … restored leftover edits: '
          '${rawFiles.map((f) => '$f').join(', ')}',
        );
        return;
      }
      final names = await Process.run('git', [
        '-C',
        base,
        'diff',
        '--name-only',
        '--',
        ...rawFiles.map((f) => '$f'),
      ]);
      final dirty = '${names.stdout}'
          .trim()
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .join(', ');
      throw UiAutomationFailure(
        'require_clean: dirty files from an aborted run? '
        'Restore and rerun (git checkout -- $dirty). Dirty: $dirty',
      );
    }
  }

  Future<void> _awaitSettle(
    dynamic settle,
    String label, {
    bool optional = false,
  }) async {
    if (settle == null) {
      if (optional) return;
      throw UiAutomationFailure('reload: missing $label: condition');
    }
    if (settle is! Map<String, dynamic>) {
      throw UiAutomationFailure('reload $label: must be a map, got: $settle');
    }
    _lastTree = await _auto!.probeUntil(
      text: settle['text']?.toString(),
      absentText: settle['absent_text']?.toString(),
      button: settle['button']?.toString(),
      timeout: _seconds(settle['timeout_s']) ?? defaultStepTimeout,
      interval: scenario.probeInterval,
    );
    _maybeDump();
  }
}

// ---------------------------------------------------------------------------
// Canned device (fake mode): scripted trees + tap results, no dart:ui.
// ---------------------------------------------------------------------------

class _CannedDevice {
  final String serverUrl;
  final List<Map<String, dynamic>> trees;
  final Map<String, String> taps;

  WebSocket? _socket;
  var _probeCount = 0;

  _CannedDevice({
    required this.serverUrl,
    required this.trees,
    required this.taps,
  });

  Future<void> connect() async {
    _socket = await WebSocket.connect(
      '${serverUrl.replaceFirst('http', 'ws')}/ws',
    );
    _socket!.listen((message) {
      try {
        final data = jsonDecode(message as String);
        if (data is! Map<String, dynamic>) return;
        final type = data['type']?.toString();
        final requestId = data['requestId']?.toString() ?? '';
        if (type == 'ui_probe_request') {
          final tree = trees.isEmpty
              ? {'type': 'Error', 'error': 'no app mounted'}
              : trees[_probeCount.clamp(0, trees.length - 1)];
          _probeCount++;
          _send({'type': 'ui_tree', 'requestId': requestId, 'tree': tree});
        } else if (type == 'restart') {
          // Fresh start over: subsequent probes replay from the first tree.
          _probeCount = 0;
        } else if (type == 'ui_tap') {
          final title = data['title']?.toString();
          final target = data['target'];
          final String tapKey;
          if (title != null && title.isNotEmpty) {
            tapKey = title;
          } else if (target is Map && target['icon_code_point'] != null) {
            tapKey = '${target['icon_code_point']}';
          } else if (target is Map && target['key'] != null) {
            tapKey = '${target['key']}';
          } else {
            tapKey = target?.toString() ?? '';
          }
          final verdict =
              taps[tapKey] ??
              (title != null ? taps[title] : null) ??
              (target is Map && target['icon_name'] != null
                  ? taps[target['icon_name']]
                  : null);
          if (verdict == null || verdict == 'ok') {
            _send({
              'type': 'ui_tap_result',
              'requestId': requestId,
              'ok': true,
            });
          } else {
            _send({
              'type': 'ui_tap_result',
              'requestId': requestId,
              'ok': false,
              'error': verdict,
            });
          }
        } else if (type == 'ui_hover' ||
            type == 'ui_focus' ||
            type == 'ui_blur' ||
            type == 'ui_submit' ||
            type == 'ui_type' ||
            type == 'ui_scroll') {
          // Canned flow validation: acknowledge triggers; semantic
          // verification (focus nodes, controllers) happens on-device and
          // in `dn test` suites via SimulatedDevice.
          _send({'type': '${type}_result', 'requestId': requestId, 'ok': true});
        }
      } catch (_) {}
    });
  }

  void _send(Map<String, dynamic> data) {
    try {
      _socket?.add(jsonEncode(data));
    } catch (_) {}
  }

  Future<void> disconnect() async {
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }
}
