import 'package:tom_d4rt_ast/runtime.dart' as ast;

/// Decodes bundle bytes served as `/guest.ast`, mirroring the
/// auto-detection in `AstBundle.fromFile` (which we can't use — the bytes
/// arrive over HTTP, not disk).
///
/// - ZIP magic `PK\x03\x04` → [AstBundle.fromZip] (what
///   `AstBundler` + `saveToFile`/`toZip` produce for `.ast` files).
/// - Otherwise → [AstBundle.fromBytes] (gzip JSON from `toBytes()`).
///
/// Kept dependency-free (no `dartnative` import) so host-side tests can
/// run under plain `dart`, where `dart:ui` is unavailable.
ast.AstBundle decodeAstBundleBytes(List<int> bytes) {
  if (bytes.length >= 4 &&
      bytes[0] == 0x50 &&
      bytes[1] == 0x4B &&
      bytes[2] == 0x03 &&
      bytes[3] == 0x04) {
    return ast.AstBundle.fromZip(bytes);
  }
  return ast.AstBundle.fromBytes(bytes);
}

/// Resolves the module URI to execute.
///
/// [requested] is an explicit override (module URI, e.g. `lib/main.dart`).
/// Falls back to the bundle's own [AstBundle.entryPointUri] when absent or
/// unknown — the manifest once sent the *function* name `"main"` here, which
/// is never a module key. Returns the effective entry URI.
String resolveBundleEntry(ast.AstBundle bundle, String? requested) {
  if (requested != null && bundle.modules.containsKey(requested)) {
    return requested;
  }
  return bundle.entryPointUri;
}
