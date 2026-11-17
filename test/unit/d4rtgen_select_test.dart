import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../../tool/d4rtgen_select.dart';

void main() {
  test('package selector keeps only that package and skips the rest', () {
    final modules = readBridgeModules('buildkit.yaml');
    final plan = planSelection(
      modules: modules,
      options: parseBridgeSelectArgs(const ['--package', 'dartnative']),
      isChanged: (_) => true,
    );

    expect(
      plan.selected.map((module) => module.name),
      ['dartnative_ui', 'dartnative_flutter_compat'],
    );
    expect(plan.partial, isTrue);
    expect(plan.skipped, isNot(contains('dartnative_ui')));
    expect(plan.skipped, contains('dio'));
  });

  test('--changed drops packages whose sources are not newer', () {
    final modules = readBridgeModules('buildkit.yaml');
    final plan = planSelection(
      modules: modules,
      options: parseBridgeSelectArgs(const ['--package=dio', '--changed']),
      isChanged: (module) => module.name == 'riverpod_kit',
    );

    expect(plan.selected, isEmpty);
    expect(plan.skipped, contains('dio'));
    expect(plan.skipped, contains('riverpod_kit'));
  });

  test('unknown package fails instead of generating nothing', () {
    final modules = readBridgeModules('buildkit.yaml');
    expect(
      () => planSelection(
        modules: modules,
        options: parseBridgeSelectArgs(const ['--package', 'not_a_package']),
        isChanged: (_) => true,
      ),
      throwsStateError,
    );
  });

  test('partial buildkit round-trips only the selected modules', () {
    final dir = Directory.systemTemp.createTempSync('d4rtgen_select');
    addTearDown(() => dir.deleteSync(recursive: true));
    final source = File('buildkit.yaml').readAsStringSync();
    final copy = File('${dir.path}/buildkit.yaml')..writeAsStringSync(source);
    final modules = readBridgeModules(copy.path);
    final plan = planSelection(
      modules: modules,
      options: parseBridgeSelectArgs(const ['--module', 'crypto']),
      isChanged: (_) => true,
    );

    writePartialBuildkit(buildkitPath: copy.path, plan: plan);

    final yaml = loadYaml(copy.readAsStringSync()) as YamlMap;
    final d4rtgen = yaml['d4rtgen'] as YamlMap;
    final names = [
      for (final module in d4rtgen['modules'] as YamlList)
        (module as YamlMap)['name'],
    ];
    expect(names, ['crypto']);
    expect(d4rtgen['generateBarrel'], isFalse);
    expect(d4rtgen['generateDartscript'], isFalse);
    expect(d4rtgen['relaxerOutputPath'], partialRelaxerPath);
    expect(File('buildkit.yaml').readAsStringSync(), source);
  });
}
