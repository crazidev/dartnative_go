import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
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
      File(
        '${tmp.path}/guest_app/main.dart',
      ).writeAsStringSync('void main() {}\n');
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
      expect(
        result.moduleFingerprints.keys.any((k) => k.contains('main.dart')),
        isTrue,
      );
      expect(
        result.moduleFingerprints.keys.any((k) => k.contains('helper.dart')),
        isTrue,
      );
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

    test(
      'incremental build discovers a new file imported by an edited file',
      () async {
        // Regression: creating lib/extra.dart and editing helper.dart to
        // import it must land the new module in both the full bundle and the
        // hot-reload patch. Previously the seed DFS skipped changed modules'
        // new imports, so the device failed with
        // `Package module ... not found in bundle` until a full restart.
        final guest = _makeGuestProject(tmp, 'new_file_guest');
        final outPath = '${tmp.path}/new_file_guest.ast';
        final first = await buildGuestAstBundle(
          guest,
          outputArg: outPath,
          force: true,
        );
        expect(first.success, isTrue, reason: first.error);

        final extra = File('${guest.path}/lib/extra.dart')
          ..writeAsStringSync('int tripleIt(int x) => x * 3;\n');
        final helper = File('${guest.path}/lib/helper.dart');
        helper.writeAsStringSync(
          'import \'package:new_file_guest/extra.dart\';\n'
          'int doubleIt(int x) => tripleIt(x) - x;\n',
        );
        final second = await buildGuestAstBundle(
          guest,
          outputArg: outPath,
          changedFiles: {extra.path, helper.path},
        );
        expect(second.success, isTrue, reason: second.error);

        const newUri = 'package:new_file_guest/extra.dart';
        final bundle = cachedBundleForProject(guest);
        expect(bundle, isNotNull);
        expect(
          bundle!.modules.keys,
          contains(newUri),
          reason: 'full bundle must include the new file',
        );
        final patch = patchBundleForProject(guest);
        expect(patch, isNotNull);
        expect(
          patch!.modules.keys,
          contains(newUri),
          reason: 'hot-reload patch must ship the new file',
        );
      },
    );

    test('unchanged sources hit the incremental cache', () async {
      final guest = _makeGuestProject(tmp, 'cache_hit_guest');
      final out = File('${tmp.path}/cache_hit.ast');
      final first = await buildGuestAstBundle(
        guest,
        outputArg: out.path,
        force: true,
      );
      expect(first.success, isTrue, reason: first.error);
      expect(first.cached, isFalse);

      final cached = await buildGuestAstBundle(
        guest,
        outputArg: out.path,
      );
      expect(cached.success, isTrue);
      expect(
        cached.cached,
        isTrue,
        reason: 'unchanged sources must not force a re-parse',
      );
      expect(out.existsSync(), isTrue);
    });

    test('hot-reload patches chain base fingerprints across builds', () async {
      // Regression: devices apply patch deltas onto their last-evaluated
      // bundle. Without base lineage a skipped intermediate reload yields a
      // franken-bundle (stale modules, no error). Each hot build must record
      // which generation its patch applies to.
      final guest = _makeGuestProject(tmp, 'lineage_guest');
      final outPath = '${tmp.path}/lineage_guest.ast';
      final first = await buildGuestAstBundle(
        guest,
        outputArg: outPath,
        force: true,
      );
      expect(first.success, isTrue, reason: first.error);
      expect(
        patchBytesForProject(guest),
        isNull,
        reason: 'cold build emits no patch (nothing to delta against)',
      );
      final fp1 = bundleFingerprintForProject(guest);
      expect(fp1, isNotEmpty);
      expect(fileSourceFingerprintForPath(outPath), equals(fp1));

      final helper = File('${guest.path}/lib/helper.dart');
      helper.writeAsStringSync(
        '${helper.readAsStringSync()}int tripleIt(int x) => x * 3;\n',
      );
      final second = await buildGuestAstBundle(
        guest,
        outputArg: outPath,
        changedFiles: {helper.path},
      );
      expect(second.success, isTrue, reason: second.error);
      expect(patchBytesForProject(guest), isNotNull);
      expect(
        patchBaseFingerprintForProject(guest),
        equals(fp1),
        reason: 'patch N applies to the bundle the device last evaluated',
      );
      final fp2 = bundleFingerprintForProject(guest);
      expect(fp2, isNot(equals(fp1)));

      helper.writeAsStringSync(
        '${helper.readAsStringSync()}int quadIt(int x) => x * 4;\n',
      );
      final third = await buildGuestAstBundle(
        guest,
        outputArg: outPath,
        changedFiles: {helper.path},
      );
      expect(third.success, isTrue, reason: third.error);
      expect(
        patchBaseFingerprintForProject(guest),
        equals(fp2),
        reason: 'consecutive patches chain: base advances every build',
      );
    });

    test('incremental rebuild preserves bundle sources', () async {
      // Regression: createFromFile only records sources for modules it
      // (re)parses, so rebuilt bundles carried just the entry source
      // (devices reported `source=n/a`). Sources must carry forward.
      final guest = _makeGuestProject(tmp, 'sources_guest');
      final outPath = '${tmp.path}/sources_guest.ast';
      final first = await buildGuestAstBundle(
        guest,
        outputArg: outPath,
        force: true,
      );
      expect(first.success, isTrue, reason: first.error);

      const mainUri = 'package:sources_guest/main.dart';
      const helperUri = 'package:sources_guest/helper.dart';
      final firstSources = cachedBundleForProject(guest)!.sources;
      expect(firstSources, isNotNull);
      expect(firstSources!.keys, containsAll([mainUri, helperUri]));

      final helper = File('${guest.path}/lib/helper.dart');
      helper.writeAsStringSync(
        '${helper.readAsStringSync()}int tripleIt(int x) => x * 3;\n',
      );
      final second = await buildGuestAstBundle(
        guest,
        outputArg: outPath,
        changedFiles: {helper.path},
      );
      expect(second.success, isTrue, reason: second.error);

      final secondSources = cachedBundleForProject(guest)!.sources;
      expect(secondSources, isNotNull);
      expect(
        secondSources!.keys,
        containsAll([mainUri, helperUri]),
        reason: 'untouched modules keep their sources across rebuilds',
      );
      expect(
        secondSources[helperUri],
        contains('tripleIt'),
        reason: 'edited module source must be fresh, not stale',
      );
    });
  });
}
