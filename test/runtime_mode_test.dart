import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:dartnative_go/src/runner/runtime_mode.dart';

Future<void> run() async {
  assert(kUseAst == false, 'default must stay source');
  assert(kDefaultRuntimeMode == RuntimeMode.source);
  assert(runtimeModeFromBool(false) == RuntimeMode.source);
  assert(runtimeModeFromBool(true) == RuntimeMode.ast);
  assert(RuntimeMode.source.label.contains('Source'));
  assert(RuntimeMode.ast.label.contains('AST'));

  const without = ProjectBundle(
    appName: 'x',
    serverUrl: 'http://localhost:8088',
    sources: {},
    entrypointCode: '',
    entrypointLibrary: 'main.dart',
  );
  assert(!without.hasAst);

  const withAst = ProjectBundle(
    appName: 'x',
    serverUrl: 'http://localhost:8088',
    sources: {},
    entrypointCode: '',
    entrypointLibrary: 'main.dart',
    astBytes: [1, 2, 3],
    astEntryPoint: 'main',
  );
  assert(withAst.hasAst);

  print('✅ runtime_mode_test passed (default=source, AST opt-in)');
}

void main() async => run();
