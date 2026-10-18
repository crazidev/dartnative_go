import 'package:dartnative_go/src/interpreter/ast/dartscript.b.dart' as bridges;
import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

/// Verifies that packages added to the bridge set (buildkit{,_ast}.yaml) are
/// compiled into the shell and used *instead of* the interpreted copy: a guest
/// `package:<pkg>/...` import must resolve to the real, compiled host classes.
///
/// The bundler is told to treat the bridged packages as external (the same way
/// the dev server does), so a successful run proves the bridge is what supplied
/// the symbols.
Future<Object?> _runGuest(String source, Set<String> bridgedLibraries) async {
  final bundler = AstBundler(bridgedLibraries: bridgedLibraries);
  final bundle = await bundler.createFromSource(
    source,
    sourcePath: 'bin/main.dart',
  );

  final runner = ast.D4rtRunner();
  runner.grant(ast.NetworkPermission.any);
  runner.grant(ast.DangerousPermission.any);
  bridges.DartnativeGoAstBridges.register(runner);

  return runner.executeBundleAsAsync<Object?>(bundle, name: 'main');
}

void main() {
  test(
    'bridged dio: guest gets the compiled host Dio instance',
    () async {
      const source = r'''
import 'package:dio/dio.dart';

Object? main() {
  final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9'));
  dio.options.connectTimeout = const Duration(seconds: 2);
  return dio;
}
''';
      final result = await _runGuest(source, const {'package:dio/dio.dart'});

      expect(
        result,
        isA<Dio>(),
        reason: 'guest must receive the compiled host Dio, not an '
            'interpreted re-implementation',
      );
      expect((result! as Dio).options.baseUrl, 'http://127.0.0.1:9');
      expect((result as Dio).options.connectTimeout, const Duration(seconds: 2));
    },
    timeout: const Timeout(Duration(seconds: 180)),
  );
}