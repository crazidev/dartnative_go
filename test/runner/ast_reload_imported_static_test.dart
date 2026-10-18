/// Regression: class `static` state declared in an **imported library** (not
/// the entry point) must survive a hot reload, exactly like statics declared in
/// `main.dart` (`ast_reload_static_state_test.dart`).
///
/// This is the shape used by service locators such as `get_it`, whose singleton
/// lives in a dependency library:
///
/// ```dart
/// abstract class GetIt {
///   static final GetIt _instance = _GetItImplementation();
/// }
/// ```
///
/// If that cell is rebuilt on reload, every registration made before the reload
/// vanishes and `getIt<Foo>()` throws "not registered" while the guest's own
/// `main()`-side guard still believes it already configured the container.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:test/test.dart';

/// Lives in `lib/store.dart`, imported by `lib/main.dart`.
const _storeLib = r'''
class Store {
  Store._();

  /// Static singleton: mirrors `GetIt._instance`.
  static final Store instance = Store._();

  /// Plain mutable class static: mirrors `GetIt`'s registration map.
  static int boots = 0;
  static final List<String> log = <String>[];

  final Map<String, String> items = <String, String>{};
}

/// Closer to the real `get_it` surface: a static-final singleton holding a
/// **`Type`-keyed** registration map, with a `get` that throws the same way
/// when a lookup was never registered. Registration by `Type` is what makes
/// this sensitive to class identity across a hot reload.
class ApiClient {
  ApiClient();
}

class UserRepository {
  final ApiClient apiClient;
  UserRepository(this.apiClient);
}

class Locator {
  Locator._();

  static final Locator instance = Locator._();

  final Map<Type, Object> registry = <Type, Object>{};

  void register<T extends Object>(Object value) => registry[T] = value;

  T get<T>() {
    if (!registry.containsKey(T)) {
      throw StateError('Locator: $T is not registered');
    }
    return registry[T] as T;
  }
}
''';

/// Mirrors `example/lib/dependencies.dart`: a captured singleton plus a
/// top-level "configured" guard, where `configure()` is re-invoked from
/// `main()` on every generation.
const _depsLib = r'''
import 'package:static_guest/store.dart';

final locator = Locator.instance;

bool _configured = false;

void configure() {
  if (_configured) return;
  locator.register<ApiClient>(ApiClient());
  locator.register<UserRepository>(UserRepository(locator.get<ApiClient>()));
  _configured = true;
}

String describeRepo() => 'repo=${locator.get<UserRepository>()}';
''';

String _main2(String tag) => '''
import 'package:dartnative/dartnative.dart';
import 'package:static_guest/deps.dart';

void main() {
  configure();
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Use'),
              onPressed: () => print('$tag \${describeRepo()}'),
            ),
          ],
        ),
      ),
    ),
  );
}
''';

String _main(String tag) => '''
import 'package:dartnative/dartnative.dart';
import 'package:static_guest/store.dart';

void main() {
  Store.boots += 1;
  Store.log.add('$tag');
  if (Store.instance.items.isEmpty) {
    Store.instance.items['api'] = 'v1';
  }
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Gen: $tag'),
            Button(
              child: Text('Show'),
              onPressed: () => print(
                '$tag boots=\${Store.boots} len=\${Store.log.length} '
                'api=\${Store.instance.items['api']}',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
''';

Column _columnOf(Widget root) {
  final scaffold = root as Scaffold;
  return (scaffold.body as Center).child as Column;
}

void main() {
  group('AST imported-library static state across hot reload', () {
    late Directory tmp;
    late Directory projectDir;
    late List<String> logs;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_imported_static_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    setUp(() {
      logs = <String>[];
      projectDir = Directory('${tmp.path}/imported_guest')
        ..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml')
          .writeAsStringSync('name: static_guest\n');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/store.dart').writeAsStringSync(_storeLib);
    });

    Future<List<int>> build(String source, String tag) async {
      File('${projectDir.path}/lib/main.dart').writeAsStringSync(source);
      final out = File('${projectDir.path}/$tag.ast');
      final result = await buildGuestAstBundle(
        projectDir,
        outputArg: out.path,
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      return out.readAsBytes();
    }

    void tap(Widget root, int index) {
      (_columnOf(root).children[index] as Button).onPressed!();
    }

    test('imported class statics survive a reload', () async {
      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_main('v1'), 'i1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, 'v1 boots=1 len=1 api=v1');

      final v2Bytes = await build(_main('v2'), 'i2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');

      tap(rootV2, 1);
      expect(
        logs.last,
        'v2 boots=2 len=2 api=v1',
        reason: 'statics declared in an imported library must survive '
            '(logs: $logs)',
      );
    });

    test('get_it-shaped singleton + guard survive a reload', () async {
      File('${projectDir.path}/lib/deps.dart').writeAsStringSync(_depsLib);

      final runner = AstInterpreterRunner(onLog: logs.add);
      addTearDown(runner.dispose);

      final v1Bytes = await build(_main2('v1'), 'g1');
      final rootV1 = await runner.evaluateAstBundleAs<Widget>(v1Bytes);
      tap(rootV1, 1);
      expect(logs.last, startsWith("v1 repo=<instance of UserRepository"));

      final v2Bytes = await build(_main2('v2'), 'g2');
      final rootV2 = await runner.evaluateAstBundleAs<Widget>(
        v2Bytes,
        isHotReload: true,
      );
      expect((_columnOf(rootV2).children[0] as Text).data, 'Gen: v2');

      tap(rootV2, 1);
      expect(
        logs.last,
        startsWith("v2 repo=<instance of UserRepository"),
        reason: 'a Type-keyed registration must survive the reload '
            '(logs: $logs)',
      );
    });
  });
}
