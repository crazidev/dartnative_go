// Logic-level source vs AST parity (host-side).
//
// Compares `tom_d4rt` (source default) against `tom_d4rt_ast` (opt-in)
// on the same pure-Dart bundle. Widget/bridge parity is phase 2.
import 'package:tom_ast_generator/tom_ast_generator.dart';
import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:tom_d4rt_ast/runtime.dart' as ast;

import 'package:dartnative_go/src/runner/ast_bundle_codec.dart';

const _src = '''
int add(int a, int b) => a + b;
String greeting(String name) => 'Hello, \$name!';
int main() => add(20, 22);
''';

Future<void> run() async {
  // 1. Source (default path)
  final sourceRunner = D4rt();
  final sourceResult = await sourceRunner.execute(source: _src);
  assert(
    sourceResult == 42,
    'source main() should return 42, got $sourceResult',
  );

  // 2. AST (opt-in path): bundle -> bytes -> execute, like /guest.ast
  final bundler = AstBundler();
  final bundle = await bundler.createFromSource(_src, sourcePath: 'parity.dart');
  final bytes = bundle.toBytes();
  assert(bytes.isNotEmpty, 'bundle bytes must not be empty');

  final astRunner = ast.D4rtRunner();
  final astResult = astRunner.executeBundleAs<int>(bundle, name: 'main');
  assert(astResult == 42, 'AST main() should return 42, got $astResult');

  // 3. Same bytes round-trip via AstBundle.fromBytes (what the device does)
  final reloaded = ast.AstBundle.fromBytes(bytes);
  final astRunner2 = ast.D4rtRunner();
  final roundTripped = astRunner2.executeBundleAs<int>(reloaded, name: 'main');
  assert(roundTripped == 42, 'round-tripped AST should return 42');

  // 4. Named function with args on AST
  final astRunner3 = ast.D4rtRunner();
  final sum = astRunner3.executeBundleAs<int>(
    bundle,
    name: 'add',
    positionalArgs: [7, 8],
  );
  assert(sum == 15, 'AST add(7,8) should be 15, got $sum');

  // 5. ZIP bytes (what `saveToFile`/`/guest.ast` serves) decode + execute.
  // Regression: client used fromBytes (gzip-only) → "Invalid GZip Signature".
  final zipBytes = bundle.toZip();
  assert(
    zipBytes.length >= 4 &&
        zipBytes[0] == 0x50 &&
        zipBytes[1] == 0x4B,
    'toZip must emit ZIP magic',
  );
  final fromZip = decodeAstBundleBytes(zipBytes);
  final astRunner4 = ast.D4rtRunner();
  final zipResult = astRunner4.executeBundleAs<int>(fromZip, name: 'main');
  assert(zipResult == 42, 'ZIP-decoded AST main() should return 42');

  // 6. Gzip bytes (toBytes) still decode via the same helper.
  final fromGzip = decodeAstBundleBytes(bytes);
  final astRunner5 = ast.D4rtRunner();
  assert(
    astRunner5.executeBundleAs<int>(fromGzip, name: 'main') == 42,
    'gzip-decoded AST main() should return 42',
  );

  // 7. Entry-point resolution: function names ("main") are never module
  // keys — fall back to the bundle's own entry URI instead of throwing
  // `Entry point "main" not found in bundle`.
  assert(
    resolveBundleEntry(bundle, 'main') == bundle.entryPointUri,
    'function name must fall back to bundle entry',
  );
  assert(
    resolveBundleEntry(bundle, bundle.entryPointUri) == bundle.entryPointUri,
  );
  assert(resolveBundleEntry(bundle, null) == bundle.entryPointUri);

  print('✅ ast_parity_test passed (source=42, ast=42, roundtrip=42, add=15)');
  print('✅ zip/gzip auto-detect passed (no more Invalid GZip Signature)');
}

void main() async => run();
