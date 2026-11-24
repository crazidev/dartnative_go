/// Library URIs exported by `package:dartnative` that are **not** re-exported
/// by `package:dartnative/dartnative.dart`, so the generated bridge sets
/// (`buildkit{,_ast}.yaml`) never register them.
///
/// Guest code imports them directly — `import 'package:dartnative/canvas.dart'
/// as ui;` gives the dart:ui-aligned `Canvas`/`Paint`/`Paragraph` surface. The
/// AST bundler skips them (`kAstBridgedLibraries`), so without an explicit
/// registration the guest fails at import time with
/// `Package module "package:dartnative/canvas.dart" not found in bundle`.
///
/// Both engines register the *same* UI bridge surface under each extra URI
/// (`registerDartNativeSubBarrels` / `registerAstDartNativeSubBarrels`).
/// Registrations are keyed per library and the class thunks are shared, so the
/// cost is one map entry per bridged name.
library;

const kDartNativeSubBarrelUris = <String>{'package:dartnative/canvas.dart'};
