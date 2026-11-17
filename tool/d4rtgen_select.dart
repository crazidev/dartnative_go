// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:yaml/yaml.dart';

/// Selects which `buildkit.yaml` modules `tool/d4rtgen.dart` and
/// `tool/d4rtgen_ast.dart` regenerate.
///
/// ```sh
/// dart run tool/d4rtgen.dart --package dartnative
/// dart run tool/d4rtgen.dart --module riverpod_kit --module dio
/// dart run tool/d4rtgen.dart --changed
/// dart run tool/d4rtgen_ast.dart --package dartnative --changed
/// ```
///
/// `--package` matches the package in a module's `package:` barrel.
/// `--module` matches the buildkit module name or the output file name.
/// Repeat either flag, or pass a comma-separated list. `--changed` keeps only
/// modules whose package sources differ from the last generation (or, before
/// a stamp exists, whose sources are newer than the bridge file). A partial
/// run does not rewrite the barrel, dartscript, or shared relaxers.
const bridgeSelectHelp = '''
Module selection (dartnative_go):
  --package=<name>   Generate modules that barrel this package. Repeatable.
  --module=<name>    Generate one buildkit module (name or output file). Repeatable.
  --changed          Skip modules whose sources have not changed.
''';

class BridgeSelectOptions {
  const BridgeSelectOptions({
    required this.selectors,
    required this.changedOnly,
    required this.runnerArgs,
  });

  final Set<String> selectors;
  final bool changedOnly;
  final List<String> runnerArgs;

  bool get restricts => selectors.isNotEmpty || changedOnly;
}

class BridgeModule {
  const BridgeModule({
    required this.name,
    required this.packages,
    required this.outputPath,
    required this.raw,
  });

  final String name;
  final List<String> packages;
  final String outputPath;
  final Map<String, Object?> raw;

  bool matches(String selector) {
    final want = _normalize(selector);
    if (want == _normalize(name)) return true;
    if (want == _normalize(_stem(outputPath))) return true;
    return packages.any((package) => _normalize(package) == want);
  }
}

class SelectionPlan {
  const SelectionPlan({
    required this.selected,
    required this.skipped,
    required this.partial,
  });

  final List<BridgeModule> selected;
  final List<String> skipped;
  final bool partial;
}

const partialRelaxerPath = '.dart_tool/d4rtgen_partial_relaxers.b.dart';

BridgeSelectOptions parseBridgeSelectArgs(List<String> args) {
  final selectors = <String>{};
  final runnerArgs = <String>[];
  var changedOnly = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--changed') {
      changedOnly = true;
      continue;
    }
    final value = _flagValue(args, i, arg);
    if (value == null) {
      runnerArgs.add(arg);
      continue;
    }
    i = value.nextIndex;
    for (final part in value.text.split(',')) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty) selectors.add(trimmed);
    }
  }

  return BridgeSelectOptions(
    selectors: selectors,
    changedOnly: changedOnly,
    runnerArgs: runnerArgs,
  );
}

List<BridgeModule> readBridgeModules(String buildkitPath) {
  final yaml = loadYaml(File(buildkitPath).readAsStringSync());
  if (yaml is! YamlMap) {
    throw StateError('$buildkitPath has no document');
  }
  final d4rtgen = yaml['d4rtgen'];
  if (d4rtgen is! YamlMap) {
    throw StateError('$buildkitPath has no d4rtgen section');
  }
  final modules = d4rtgen['modules'];
  if (modules is! YamlList) {
    throw StateError('$buildkitPath d4rtgen.modules is not a list');
  }
  return [
    for (final raw in modules)
      if (raw is YamlMap)
        BridgeModule(
          name: raw['name'].toString(),
          packages: _packagesOf(raw),
          outputPath: raw['outputPath'].toString(),
          raw: _plainMap(raw),
        ),
  ];
}

SelectionPlan planSelection({
  required List<BridgeModule> modules,
  required BridgeSelectOptions options,
  required bool Function(BridgeModule module) isChanged,
}) {
  final unknown = [
    for (final selector in options.selectors)
      if (!modules.any((module) => module.matches(selector))) selector,
  ];
  if (unknown.isNotEmpty) {
    throw StateError(
      'Unknown bridge module or package: ${unknown.join(', ')}. '
      'Known modules: ${modules.map((module) => module.name).join(', ')}',
    );
  }

  final named = options.selectors.isEmpty
      ? modules
      : [
          for (final module in modules)
            if (options.selectors.any(module.matches)) module,
        ];
  final selected = options.changedOnly
      ? [
          for (final module in named)
            if (isChanged(module)) module,
        ]
      : named;
  final selectedNames = selected.map((module) => module.name).toSet();
  return SelectionPlan(
    selected: selected,
    skipped: [
      for (final module in modules)
        if (!selectedNames.contains(module.name)) module.name,
    ],
    partial: selected.length != modules.length,
  );
}

/// True when [module]'s package sources differ from the last stamp, or when
/// no stamp exists and a source file is newer than the generated bridge.
bool moduleSourcesChanged({
  required BridgeModule module,
  required String projectDir,
  required String stampKey,
  Map<String, String>? packageRoots,
  Map<String, String>? stamps,
  String? frameworkEdition,
}) {
  final output = File(_join(projectDir, module.outputPath));
  if (!output.existsSync()) return true;

  final roots = packageRoots ?? loadPackageRoots(projectDir);
  final recorded = (stamps ?? loadStamps(projectDir))[stampKey];
  final current = moduleFingerprint(
    module: module,
    packageRoots: roots,
    frameworkEdition: frameworkEdition ?? readFrameworkEdition(),
  );
  if (recorded != null) return recorded != current;

  final outputTime = output.lastModifiedSync();
  for (final package in module.packages) {
    final root = roots[package];
    if (root == null) continue;
    if (_newestDart(Directory(_join(root, 'lib')), outputTime)) return true;
  }
  return false;
}

String moduleFingerprint({
  required BridgeModule module,
  required Map<String, String> packageRoots,
  String? frameworkEdition,
}) {
  final chunks = <String>[];
  for (final package in module.packages) {
    final root = packageRoots[package];
    if (root == null) {
      chunks.add('missing:$package');
      continue;
    }
    if (frameworkEdition != null && _isSdkPackage(root)) {
      chunks.add('edition:$frameworkEdition');
    }
    final lib = Directory(_join(root, 'lib'));
    if (!lib.existsSync()) continue;
    final files =
        lib
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.dart') &&
                  // macOS resource-fork twins (._foo.dart) are not Dart text.
                  !file.uri.pathSegments.last.startsWith('._'),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      final relative = file.path.substring(root.length);
      chunks.add(relative);
      chunks.add(file.readAsStringSync());
    }
  }
  return sha256.convert(utf8.encode(chunks.join('\n'))).toString();
}

Map<String, String> loadPackageRoots(String projectDir) {
  final file = File(_join(projectDir, '.dart_tool/package_config.json'));
  if (!file.existsSync()) return const {};
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) return const {};
  final packages = decoded['packages'];
  if (packages is! List) return const {};
  final roots = <String, String>{};
  for (final package in packages) {
    if (package is! Map) continue;
    final name = package['name'];
    final rootUri = package['rootUri'];
    if (name is! String || rootUri is! String) continue;
    roots[name] = _resolveRoot(projectDir, rootUri);
  }
  return roots;
}

Map<String, String> loadStamps(String projectDir) {
  final file = File(_stampPath(projectDir));
  if (!file.existsSync()) return const {};
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) return const {};
  return {
    for (final entry in decoded.entries)
      if (entry.value is String) entry.key.toString(): entry.value as String,
  };
}

void writeStamps(
  String projectDir,
  Map<String, String> updates,
) {
  if (updates.isEmpty) return;
  final stamps = {...loadStamps(projectDir), ...updates};
  final file = File(_stampPath(projectDir));
  file.parent.createSync(recursive: true);
  final keys = stamps.keys.toList()..sort();
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      for (final key in keys) key: stamps[key],
    }),
  );
}

String? readFrameworkEdition() {
  final home = Platform.environment['HOME'];
  if (home == null || home.isEmpty) return null;
  final file = File('$home/zero/bin/cache/dartnative_release.json');
  if (!file.existsSync()) return null;
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) return null;
  final current = decoded['current'];
  if (current is! Map) return null;
  final edition = current['edition'];
  return edition is String ? edition : null;
}

/// Rewrites [buildkitPath] so the generator emits only [plan.selected].
/// Shared barrel, dartscript, and relaxer outputs are left untouched.
void writePartialBuildkit({
  required String buildkitPath,
  required SelectionPlan plan,
}) {
  final yaml = loadYaml(File(buildkitPath).readAsStringSync());
  if (yaml is! YamlMap) {
    throw StateError('$buildkitPath has no document');
  }
  final d4rtgen = _plainMap(yaml['d4rtgen'] as YamlMap);
  d4rtgen['generateBarrel'] = false;
  d4rtgen['generateDartscript'] = false;
  d4rtgen['relaxerOutputPath'] = partialRelaxerPath;
  d4rtgen['modules'] = [
    for (final module in plan.selected) module.raw,
  ];
  File(buildkitPath).writeAsStringSync(_emitDocument({'d4rtgen': d4rtgen}));
}

void deletePartialRelaxer(String projectDir) {
  final file = File(_join(projectDir, partialRelaxerPath));
  if (file.existsSync()) file.deleteSync();
}

String _stampPath(String projectDir) =>
    _join(projectDir, '.dart_tool/bridge_module_stamps.json');

bool _isSdkPackage(String root) => root.contains(
  '${Platform.pathSeparator}bin${Platform.pathSeparator}cache${Platform.pathSeparator}pkg${Platform.pathSeparator}',
);

bool _newestDart(Directory dir, DateTime outputTime) {
  if (!dir.existsSync()) return false;
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.lastModifiedSync().isAfter(outputTime)) return true;
  }
  return false;
}

List<String> _packagesOf(YamlMap module) {
  final barrels = module['barrelFiles'];
  if (barrels is! YamlList) return const [];
  final packages = <String>[];
  for (final barrel in barrels) {
    final text = barrel.toString();
    if (!text.startsWith('package:')) continue;
    final name = text.substring('package:'.length).split('/').first;
    if (name.isNotEmpty && !packages.contains(name)) packages.add(name);
  }
  return packages;
}

Map<String, Object?> _plainMap(YamlMap map) => {
  for (final entry in map.entries) entry.key.toString(): _plain(entry.value),
};

Object? _plain(Object? value) {
  if (value is YamlMap) return _plainMap(value);
  if (value is YamlList) return [for (final item in value) _plain(item)];
  return value;
}

String _resolveRoot(String projectDir, String rootUri) {
  if (rootUri.startsWith('file://')) {
    return Uri.parse(rootUri).toFilePath();
  }
  return _join(projectDir, rootUri);
}

String _join(String root, String relative) {
  if (relative.startsWith('/')) return relative;
  return '$root/$relative'.replaceAll(RegExp(r'/+'), '/');
}

String _stem(String path) {
  final name = path.split('/').last;
  return name.endsWith('.b.dart')
      ? name.substring(0, name.length - '.b.dart'.length)
      : name;
}

String _normalize(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

class _FlagValue {
  const _FlagValue(this.text, this.nextIndex);
  final String text;
  final int nextIndex;
}

_FlagValue? _flagValue(List<String> args, int index, String arg) {
  const names = ['module', 'package'];
  for (final name in names) {
    if (arg == '--$name') {
      if (index + 1 >= args.length || args[index + 1].startsWith('-')) {
        throw FormatException('--$name needs a value');
      }
      return _FlagValue(args[index + 1], index + 1);
    }
    if (arg.startsWith('--$name=')) {
      return _FlagValue(arg.substring('--$name='.length), index);
    }
  }
  return null;
}

String _emitDocument(Map<String, Object?> document) {
  final buffer = StringBuffer();
  _emitMap(buffer, document, 0, false);
  return buffer.toString();
}

void _emitMap(
  StringBuffer buffer,
  Map<String, Object?> map,
  int indent,
  bool underDash,
) {
  var first = underDash;
  for (final entry in map.entries) {
    final pad = '  ' * indent;
    final prefix = first ? pad.substring(2) : pad;
    first = false;
    final value = entry.value;
    if (value is Map<String, Object?>) {
      buffer.writeln('$prefix${entry.key}:');
      _emitMap(buffer, value, indent + 1, false);
    } else if (value is List) {
      buffer.writeln('$prefix${entry.key}:');
      _emitList(buffer, value, indent + 1);
    } else {
      buffer.writeln('$prefix${entry.key}: ${_scalar(value)}');
    }
  }
}

void _emitList(StringBuffer buffer, List<Object?> list, int indent) {
  final pad = '  ' * indent;
  if (list.isEmpty) {
    buffer.writeln('$pad[]');
    return;
  }
  for (final item in list) {
    if (item is Map<String, Object?>) {
      if (item.isEmpty) {
        buffer.writeln('$pad- {}');
        continue;
      }
      final entries = item.entries.toList();
      final first = entries.first;
      if (first.value is Map<String, Object?> || first.value is List) {
        buffer.writeln('$pad- ${first.key}:');
        if (first.value is Map<String, Object?>) {
          _emitMap(
            buffer,
            first.value as Map<String, Object?>,
            indent + 2,
            false,
          );
        } else {
          _emitList(buffer, first.value as List, indent + 2);
        }
      } else {
        buffer.writeln('$pad- ${first.key}: ${_scalar(first.value)}');
      }
      _emitMap(
        buffer,
        {for (final entry in entries.skip(1)) entry.key: entry.value},
        indent + 1,
        false,
      );
    } else {
      buffer.writeln('$pad- ${_scalar(item)}');
    }
  }
}

String _scalar(Object? value) {
  if (value == null) return 'null';
  if (value is bool || value is num) return '$value';
  final text = value.toString();
  if (text.isEmpty ||
      text.contains(': ') ||
      text.contains('#') ||
      text.contains('\n') ||
      text.startsWith('*') ||
      text.startsWith('&') ||
      text.startsWith('!') ||
      text.startsWith('[') ||
      text.startsWith('{') ||
      text.startsWith("'") ||
      text.startsWith('"')) {
    return jsonEncode(text);
  }
  return text;
}
