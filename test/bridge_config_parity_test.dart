import 'dart:io';

import 'package:yaml/yaml.dart';

/// Guards buildkit.yaml <-> buildkit_ast.yaml drift: same modules, same
/// barrels. Only runtime imports / output paths / registration class differ.
Future<void> run() async {
  Map load(String path) {
    final candidates = [
      path,
      '${Directory.current.path}/$path',
      '${Directory.current.path}/../$path',
      '/Users/mac/Dev/projects/dartnative_go/$path',
    ];
    File? foundFile;
    for (final cand in candidates) {
      final f = File(cand);
      if (f.existsSync()) {
        foundFile = f;
        break;
      }
    }
    foundFile ??= File(path);
    final text = foundFile.readAsStringSync();
    return (loadYaml(text) as Map)['d4rtgen'] as Map;
  }

  final src = load('buildkit.yaml');
  final ast = load('buildkit_ast.yaml');

  assert(
    ast['d4rtImport'] == 'package:tom_d4rt_ast/d4rt.dart',
    'AST set must target the analyzer-free runtime',
  );
  assert(
    (ast['helpersImport'] as String).startsWith('package:tom_d4rt_ast/'),
    'AST helpers must come from tom_d4rt_ast',
  );
  assert(
    ast['registrationClass'] != src['registrationClass'],
    'registration classes must differ to avoid symbol clashes',
  );
  assert(
    (ast['dartscriptPath'] as String).contains('/ast/'),
    'AST dartscript must live under lib/src/interpreter/ast/',
  );

  final srcModules = src['modules'] as List;
  final astModules = ast['modules'] as List;
  assert(
    srcModules.length == astModules.length,
    'module count drift: source=${srcModules.length} ast=${astModules.length}',
  );
  for (var i = 0; i < srcModules.length; i++) {
    final s = srcModules[i] as Map;
    final a = astModules[i] as Map;
    assert(s['name'] == a['name'], 'module name drift at index $i');
    assert(
      (s['barrelFiles'] as List).join(',') ==
          (a['barrelFiles'] as List).join(','),
      'barrel drift for ${s['name']}',
    );
    assert(
      (a['outputPath'] as String).contains('/ast/'),
      'AST output must live under ast/ for ${a['name']}',
    );
  }

  print('✅ bridge_config_parity_test passed (${srcModules.length} modules in sync)');
}

void main() async => run();
