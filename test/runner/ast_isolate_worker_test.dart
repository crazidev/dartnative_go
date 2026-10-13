import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' show D4rtIsolateWorker;

Directory _makeGuest(Directory parent, String name) {
  final dir = Directory('${parent.path}/$name')..createSync(recursive: true);
  File('${dir.path}/pubspec.yaml').writeAsStringSync('''
name: $name
environment:
  sdk: '>=3.0.0 <4.0.0'
''');
  Directory('${dir.path}/lib').createSync(recursive: true);
  return dir;
}

const _guestCode = r'''
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

int heavyTask(int n) {
  int sum = 0;
  for (int i = 1; i <= n; i++) {
    sum += i;
  }
  return sum;
}

String greet(String name) {
  return 'Hello, ' + name + '!';
}

Future<int> runCompute(int n) async {
  return await compute(heavyTask, n);
}

Future<String> runIsolate() async {
  return await Isolate.run(workerJob);
}

String workerJob() {
  return 'Isolate.run completed';
}

Future<String> runClosureFallback() async {
  return await Isolate.run(() {
    return 'closure fallback ok';
  });
}

void main() {}
''';

void main() {
  group('Guest Dart Isolate Worker & compute()', () {
    late Directory tmp;
    late Directory projectDir;
    late List<int> astBytes;

    setUpAll(() async {
      tmp = Directory.systemTemp.createTempSync('dn_isolate_test_');
      projectDir = _makeGuest(tmp, 'isolate_guest');
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(_guestCode);
      final out = File('${projectDir.path}/guest.ast');
      final result = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      astBytes = out.readAsBytesSync();
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('D4rtIsolateWorker.run executes top-level function in background isolate',
        () async {
      final result = await D4rtIsolateWorker.run(
        entryFunction: 'heavyTask',
        positionalArgs: [100],
        bundleBytes: astBytes,
      );
      // 1 + 2 + ... + 100 = 5050
      expect(result, equals(5050));
    });

    test('D4rtIsolateWorker.run handles string arguments and returns string',
        () async {
      final result = await D4rtIsolateWorker.run(
        entryFunction: 'greet',
        positionalArgs: ['World'],
        bundleBytes: astBytes,
      );
      expect(result, equals('Hello, World!'));
    });

    test('guest code compute() runs in worker isolate', () async {
      final runner = AstInterpreterRunner();
      final resFuture = await runner.evaluateAstBundleAs<dynamic>(
        astBytes,
        name: 'runCompute',
        positionalArgs: [10],
      );
      final res = await resFuture;
      // 1 + ... + 10 = 55
      expect(res, equals(55));
    });

    test('guest code Isolate.run() executes named top-level function in worker isolate',
        () async {
      final runner = AstInterpreterRunner();
      final resFuture = await runner.evaluateAstBundleAs<dynamic>(
        astBytes,
        name: 'runIsolate',
      );
      final res = await resFuture;
      expect(res, equals('Isolate.run completed'));
    });

    test('guest code Isolate.run() falls back smoothly on closures', () async {
      final runner = AstInterpreterRunner();
      final resFuture = await runner.evaluateAstBundleAs<dynamic>(
        astBytes,
        name: 'runClosureFallback',
      );
      final res = await resFuture;
      expect(res, equals('closure fallback ok'));
    });
  });
}
