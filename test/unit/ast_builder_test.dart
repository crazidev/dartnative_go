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
  });
}
