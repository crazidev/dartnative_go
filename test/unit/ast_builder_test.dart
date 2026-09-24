import 'dart:io';

import 'package:dartnative_go/src/cli/ast_builder.dart';
import 'package:test/test.dart';

/// Creates a minimal guest-style project: pubspec + multi-file lib/
/// importing only the bridged DartNative barrel (no FFI registrants).
Directory _makeGuestProject(Directory parent, String name) {
  final dir = Directory('${parent.path}/$name')..createSync(recursive: true);
  File('${dir.path}/pubspec.yaml').writeAsStringSync('name: $name\n');
  Directory('${dir.path}/lib').createSync();
  File('${dir.path}/lib/helper.dart').writeAsStringSync(
    'int doubleIt(int x) => x * 2;\n',
  );
  File('${dir.path}/lib/main.dart').writeAsStringSync(
    "import 'package:dartnative/dartnative.dart';\n"
    "import 'helper.dart';\n"
    'int answer() => doubleIt(21);\n'
    'void main() {}\n',
  );
  return dir;
}

/// Mirrors the builder's sibling-artifact convention (`x.ast` → `x.bc`).
File _bytecodeFileFor(File astFile) {
  final path = astFile.path;
  return File(
    path.endsWith('.ast')
        ? '${path.substring(0, path.length - 4)}.bc'
        : '$path.bc',
  );
}

void main() {
  group('AstBuilder', () {
    late Directory tmp;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dart_go_ast_builder_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('detects guest package name from pubspec', () {
      expect(detectGuestPackageName(tmp), isNull);
      File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
      expect(detectGuestPackageName(tmp), equals('demo_app'));
    });

    test('resolves entry with lib/ preferred over guest_app/', () {
      expect(resolveGuestEntry(tmp), isNull);
      Directory('${tmp.path}/guest_app').createSync();
      File('${tmp.path}/guest_app/main.dart')
          .writeAsStringSync('void main() {}\n');
      expect(resolveGuestEntry(tmp)!.path, endsWith('guest_app/main.dart'));
      Directory('${tmp.path}/lib').createSync();
      File('${tmp.path}/lib/main.dart').writeAsStringSync('void main() {}\n');
      expect(resolveGuestEntry(tmp)!.path, endsWith('lib/main.dart'));
    });

    test('full multi-module build parses (not cached) on first run', () async {
      final guest = _makeGuestProject(tmp, 'temp_guest');
      final out = File('${tmp.path}/guest.ast');
      final result = await buildGuestAstBundle(guest, outputArg: out.path);
      expect(result.success, isTrue, reason: result.error);
      expect(result.cached, isFalse);
      expect(out.existsSync() && await out.length() > 0, isTrue);
      expect(result.moduleCount, greaterThanOrEqualTo(2));
    });

    test('unchanged sources hit the analyzer cache', () async {
      final guest = Directory('${tmp.path}/temp_guest');
      final out = File('${tmp.path}/guest.ast');
      final cached = await buildGuestAstBundle(guest, outputArg: out.path);
      expect(cached.success, isTrue);
      expect(cached.cached, isTrue);
    });

    test('changed sources invalidate the cache and rebuild', () async {
      final helper = File('${tmp.path}/temp_guest/lib/helper.dart');
      final original = helper.readAsStringSync();
      helper.writeAsStringSync('${original}int tripleIt(int x) => x * 3;\n');
      try {
        final rebuilt = await buildGuestAstBundle(
          Directory('${tmp.path}/temp_guest'),
          outputArg: '${tmp.path}/guest.ast',
        );
        expect(rebuilt.success, isTrue);
        expect(rebuilt.cached, isFalse);
      } finally {
        helper.writeAsStringSync(original);
      }
    });

    test('example/ full shell bundles with registrant stubs', () async {
      final example = Directory('example');
      if (!example.existsSync()) return;
      final ok = await buildGuestAstBundle(
        example,
        outputArg: '${tmp.path}/example.ast',
      );
      expect(ok.success, isTrue, reason: ok.error);
      expect(ok.moduleCount, greaterThanOrEqualTo(3));
    });

    test('missing entry fails without throwing', () async {
      final missing = await buildGuestAstBundle(tmp, entryArg: 'nope.dart');
      expect(missing.success, isFalse);
      expect(missing.error, isNotNull);
    });

    test('reports a fingerprint for every compiled module', () async {
      final guest = _makeGuestProject(tmp, 'fp_guest');
      final result = await buildGuestAstBundle(
        guest,
        outputArg: '${tmp.path}/fp.ast',
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      expect(result.moduleFingerprints.length, result.moduleCount);
      expect(result.moduleFingerprints.keys.any((k) => k.contains('main.dart')),
          isTrue);
      expect(result.moduleFingerprints.keys.any((k) => k.contains('helper.dart')),
          isTrue);
      expect(
        result.moduleFingerprints.values.every((v) => v.isNotEmpty),
        isTrue,
      );
    });

    test('only the edited module changes fingerprint', () async {
      final guest = _makeGuestProject(tmp, 'fp_delta_guest');
      final first = await buildGuestAstBundle(
        guest,
        outputArg: '${tmp.path}/fp_delta.ast',
        force: true,
      );
      expect(first.success, isTrue, reason: first.error);

      final helper = File('${guest.path}/lib/helper.dart');
      final original = helper.readAsStringSync();
      helper.writeAsStringSync('${original}int tripleIt(int x) => x * 3;\n');
      try {
        final second = await buildGuestAstBundle(
          guest,
          outputArg: '${tmp.path}/fp_delta.ast',
          force: true,
        );
        expect(second.success, isTrue, reason: second.error);

        String fpFor(Map<String, String> fps, String needle) =>
            fps.entries.firstWhere((e) => e.key.contains(needle)).value;

        expect(
          fpFor(second.moduleFingerprints, 'helper.dart'),
          isNot(equals(fpFor(first.moduleFingerprints, 'helper.dart'))),
          reason: 'edited module must get a new fingerprint',
        );
        expect(
          fpFor(second.moduleFingerprints, 'main.dart'),
          equals(fpFor(first.moduleFingerprints, 'main.dart')),
          reason: 'untouched module keeps its fingerprint',
        );
      } finally {
        helper.writeAsStringSync(original);
      }
    });

    test('missing guest.bc does not invalidate the AST cache', () async {
      final guest = _makeGuestProject(tmp, 'bc_missing_guest');
      final out = File('${tmp.path}/bc_missing.ast');
      final first = await buildGuestAstBundle(
        guest,
        outputArg: out.path,
        force: true,
      );
      expect(first.success, isTrue, reason: first.error);

      final bcFile = _bytecodeFileFor(out);
      if (bcFile.existsSync()) bcFile.deleteSync();

      final cached = await buildGuestAstBundle(
        guest,
        outputArg: out.path,
      );
      expect(cached.success, isTrue);
      expect(
        cached.cached,
        isTrue,
        reason: 'a missing bytecode artifact must not force a re-parse',
      );
      expect(cached.bytecodeBuilt, isFalse);
      expect(out.existsSync(), isTrue);
    });
  });
}
