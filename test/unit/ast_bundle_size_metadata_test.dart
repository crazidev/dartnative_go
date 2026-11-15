/// Bundle size metadata: recorded at build time, carried through ZIP, and
/// consumed by the device profile.
///
/// The profile used to re-serialize every decoded module with
/// `jsonEncode(unit.toJson())` just to print sizes — a multi-second cost on
/// device at launch. The bundler now records module / class / source sizes in
/// `manifest.json`, so `buildAstProfile` reads them instead of walking the AST.
library;

import 'dart:convert';

import 'package:dartnative_go/src/runner/ast_bundle_codec.dart';
import 'package:dartnative_go/src/runner/ast_profile.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

const _source = '''
class Counter {
  int value = 0;
  void bump() => value++;
}

int answer() => 42;
void main() {}
''';

void main() {
  group('AST bundle size metadata', () {
    test(
      'toZip records module, class and source sizes in the manifest',
      () async {
        final bundler = AstBundler();
        final parsed = await bundler.createFromSource(
          _source,
          sourcePath: 'lib/main.dart',
        );
        final bundle = ast.AstBundle(
          entryPointUri: parsed.entryPointUri,
          modules: parsed.modules,
          sources: {'lib/main.dart': _source},
        );

        final moduleAstBytes = <String, int>{};
        final classAstBytes = <String, Map<String, int>>{};
        final zipBytes = bundle.toZip(
          moduleAstBytes: moduleAstBytes,
          classAstBytes: classAstBytes,
        );

        final expected = utf8
            .encode(jsonEncode(bundle.entryPoint.toJson()))
            .length;
        expect(moduleAstBytes['lib/main.dart'], equals(expected));
        expect(classAstBytes['lib/main.dart'], contains('Counter'));

        final reloaded = decodeAstBundleBytes(zipBytes);
        expect(reloaded.moduleAstBytes?['lib/main.dart'], equals(expected));
        expect(
          reloaded.classAstBytes?['lib/main.dart']?['Counter'],
          equals(classAstBytes['lib/main.dart']!['Counter']),
        );
        expect(
          reloaded.sourceBytes?['lib/main.dart'],
          equals(utf8.encode(_source).length),
        );
      },
    );

    test('recorded sizes match a fresh serialization walk', () async {
      final bundler = AstBundler();
      final bundle = await bundler.createFromSource(
        _source,
        sourcePath: 'lib/main.dart',
      );
      final reloaded = decodeAstBundleBytes(bundle.toZip());

      final profile = buildAstProfile(
        bundle: reloaded,
        moduleLoadMicros: const {},
        moduleLoadCounts: const {},
        moduleCacheHits: const {},
        bridgedSymbols: const {},
        mainMicros: null,
        isHotReload: false,
      );

      var walkedModules = 0;
      var walkedClasses = 0;
      for (final unit in reloaded.modules.values) {
        walkedModules += utf8.encode(jsonEncode(unit.toJson())).length;
        for (final decl in unit.declarations.whereType<SClassDeclaration>()) {
          walkedClasses += utf8.encode(jsonEncode(decl.toJson())).length;
        }
      }

      expect(profile.totalAstBytes, equals(walkedModules));
      expect(
        profile.largestClasses.fold<int>(0, (sum, c) => sum + c.astBytes),
        equals(walkedClasses),
      );
    });

    test('applyPatch carries size metadata from the patch', () async {
      final bundler = AstBundler();
      final base = await bundler.createFromSource(
        _source,
        sourcePath: 'lib/main.dart',
      );
      final baseBytes = base.toZip(
        moduleAstBytes: {},
        classAstBytes: {},
      );

      const patched = '''
class Counter {
  int value = 0;
  int extra = 1;
  void bump() => value++;
}

int answer() => 43;
void main() {}
''';
      final patch = await bundler.createFromSource(
        patched,
        sourcePath: 'lib/main.dart',
      );
      final patchSizes = <String, int>{};
      final patchBytes = patch.toZip(moduleAstBytes: patchSizes);

      final merged = decodeAstBundleBytes(baseBytes).applyPatch(
        decodeAstBundleBytes(patchBytes),
      );
      expect(
        merged.moduleAstBytes?['lib/main.dart'],
        equals(patchSizes['lib/main.dart']),
      );
    });
  });
}
