/// AST-engine counterpart of `registerDartNativeSubBarrels`.
///
/// Registers the UI bridge surface under the `package:dartnative` libraries
/// that `dartnative.dart` does not re-export — see
/// [kDartNativeSubBarrelUris]. The AST bundler skips these URIs, so the guest
/// resolves them from the bridge instead of the bundle.
library;

import 'package:tom_d4rt_ast/d4rt.dart' as ast;

import '../dartnative_sub_barrels.dart';
import 'dartnative_bridges.b.dart' as ast_ui_bridges;
import 'dartnative_skia_bridges.b.dart' as ast_skia_bridges;

void registerAstDartNativeSubBarrels(ast.D4rtRunner runner) {
  for (final uri in kDartNativeSubBarrelUris) {
    ast_ui_bridges.DartnativeUiBridge.registerBridges(runner, uri);
    // `package:dartnative/canvas.dart` exposes `custom_paint.dart`'s
    // `Gradient` (`Gradient.linear` / `Gradient.radial`), not `painting.dart`'s
    // `Gradient`. Overlay `DartnativeSkiaBridge` which carries the generated
    // `custom_paint.dart` bridges.
    if (uri == 'package:dartnative/canvas.dart') {
      ast_skia_bridges.DartnativeSkiaBridge.registerBridges(runner, uri);
    }
  }
}
