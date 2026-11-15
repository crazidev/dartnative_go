import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Guards buildkit.yaml <-> buildkit_ast.yaml drift: same modules, same
/// barrels. Only runtime imports / output paths / registration class differ.
Map _loadKit(String path) {
  final candidates = [
    path,
    '${Directory.current.path}/$path',
    '${Directory.current.path}/../$path',
  ];
  for (final cand in candidates) {
    final f = File(cand);
    if (f.existsSync())
      return (loadYaml(f.readAsStringSync()) as Map)['d4rtgen'] as Map;
  }
  throw StateError('not found: $path (cwd=${Directory.current.path})');
}

void main() {
  group('bridge config parity (buildkit vs buildkit_ast)', () {
    late Map src;
    late Map ast;

    setUpAll(() {
      src = _loadKit('buildkit.yaml');
      ast = _loadKit('buildkit_ast.yaml');
    });

    test('AST set targets the analyzer-free runtime', () {
      expect(ast['d4rtImport'], equals('package:tom_d4rt_ast/d4rt.dart'));
      expect(
        ast['helpersImport'] as String,
        startsWith('package:tom_d4rt_ast/'),
      );
    });

    test('registration classes differ to avoid symbol clashes', () {
      expect(
        ast['registrationClass'],
        isNot(equals(src['registrationClass'])),
      );
    });

    test('AST outputs live under lib/src/interpreter/ast/', () {
      expect(ast['dartscriptPath'] as String, contains('/ast/'));
    });

    test('module list is in sync (names + barrels)', () {
      final srcModules = src['modules'] as List;
      final astModules = ast['modules'] as List;
      expect(
        astModules.length,
        equals(srcModules.length),
        reason: 'module count drift',
      );
      for (var i = 0; i < srcModules.length; i++) {
        final s = srcModules[i] as Map;
        final a = astModules[i] as Map;
        expect(s['name'], equals(a['name']), reason: 'drift at index $i');
        expect(
          (s['barrelFiles'] as List).join(','),
          equals((a['barrelFiles'] as List).join(',')),
          reason: 'barrel drift for ${s['name']}',
        );
        expect(
          a['outputPath'] as String,
          contains('/ast/'),
          reason: 'AST output must live under ast/ for ${a['name']}',
        );
      }
    });
  });
}
