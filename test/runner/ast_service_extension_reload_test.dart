import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;
import 'package:tom_ast_generator/tom_ast_generator.dart';

/// A hot reload re-runs the guest top level, so any package that registers a
/// `dart:developer` service extension (e.g. get_it's
/// `ext.get_it.getRegistrations`) calls `registerExtension` again with the same
/// method name. The host `dart:developer.registerExtension` throws
/// `ArgumentError('Extension already registered: $method')` on a duplicate and
/// exposes no unregister, which surfaced as
/// `Interpreter Error: Invalid argument(s): Extension already registered` on
/// every reload.
///
/// The interpreter stdlib now registers with the host only once per method and
/// rebinds its stored handler on repeat registrations.
void main() {
  const source = r'''
import 'dart:developer';

Future<String> main() async {
  ServiceExtensionResponse handler(String method, Map<String, String> params) {
    return ServiceExtensionResponse.result('{}');
  }

  registerExtension('ext.test.reload_dup', handler);
  // Simulates the second (post-reload) evaluation of the guest top level.
  registerExtension('ext.test.reload_dup', handler);

  return 'ok';
}
''';

  test(
    're-registering a service extension after reload does not throw',
    () async {
      final bundle = await AstBundler().createFromSource(
        source,
        sourcePath: 'service_extension_reload_test.dart',
      );
      final result = await ast.D4rtRunner().executeBundleAsAsync<String>(
        bundle,
        name: 'main',
      );
      expect(result, 'ok');
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
}
