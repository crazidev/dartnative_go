import 'dart:io';

import 'package:dartnative_go/src/cli/ast_builder.dart';

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

Future<void> run() async {
  final tmp = Directory.systemTemp.createTempSync('dart_go_ast_builder_');
  try {
    // 1. Package name detection
    assert(detectGuestPackageName(tmp) == null);
    File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
    assert(detectGuestPackageName(tmp) == 'demo_app');

    // 2. Entry fallback: lib/ then guest_app/, null when absent
    assert(resolveGuestEntry(tmp) == null);
    Directory('${tmp.path}/guest_app').createSync();
    File('${tmp.path}/guest_app/main.dart')
        .writeAsStringSync('void main() {}\n');
    assert(resolveGuestEntry(tmp)!.path.endsWith('guest_app/main.dart'));
    Directory('${tmp.path}/lib').createSync();
    File('${tmp.path}/lib/main.dart').writeAsStringSync('void main() {}\n');
    assert(resolveGuestEntry(tmp)!.path.endsWith('lib/main.dart'));

    // 3. Full multi-module build of a temp guest project
    final guest = _makeGuestProject(tmp, 'temp_guest');
    final out = File('${tmp.path}/guest.ast');
    final sw = Stopwatch()..start();
    final result = await buildGuestAstBundle(guest, outputArg: out.path);
    sw.stop();
    assert(result.success, 'guest build failed: ${result.error}');
    assert(!result.cached, 'first build must parse, not hit cache');
    assert(out.existsSync() && await out.length() > 0);
    assert(result.moduleCount >= 2, 'expected main + helper modules');
    print('  (full parse: ${sw.elapsedMilliseconds}ms)');

    // 4. Incremental fast path: unchanged sources skip the analyzer parse
    final sw2 = Stopwatch()..start();
    final cached = await buildGuestAstBundle(guest, outputArg: out.path);
    sw2.stop();
    assert(cached.success && cached.cached, 'second build should hit cache');
    print('  (cached: ${sw2.elapsedMilliseconds}ms)');

    // 5. Real change invalidates the cache → full rebuild
    final helper = File('${guest.path}/lib/helper.dart');
    final original = helper.readAsStringSync();
    helper.writeAsStringSync('${original}int tripleIt(int x) => x * 3;\n');
    try {
      final rebuilt = await buildGuestAstBundle(guest, outputArg: out.path);
      assert(rebuilt.success && !rebuilt.cached, 'changed file must rebuild');
    } finally {
      helper.writeAsStringSync(original);
    }

    // 6. example/ (full native shell): registrant FFI imports are stubbed,
    // so the bundle builds (main + home_screen + registrant stub).
    final example = Directory('example');
    if (example.existsSync()) {
      final ok = await buildGuestAstBundle(
        example,
        outputArg: '${tmp.path}/example.ast',
      );
      assert(ok.success, 'example build failed: ${ok.error}');
      assert(
        ok.moduleCount >= 3,
        'expected main + home_screen + registrant stub, got ${ok.moduleCount}',
      );
      print('  (example bundles: ${ok.moduleCount} modules)');
    }

    // 7. Missing entry: failure, never throws
    final missing = await buildGuestAstBundle(tmp, entryArg: 'nope.dart');
    assert(!missing.success && missing.error != null);
  } finally {
    try {
      tmp.deleteSync(recursive: true);
    } catch (_) {}
  }

  print('✅ ast_builder_test passed (detect/resolve/build/cache/example)');
}

void main() async => run();
