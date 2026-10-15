# Interpreter and bridges

Makes interpreted guest classes behave as real DartNative widgets.

## Files

| Path | Role |
| :--- | :--- |
| `lib/src/interpreter/*.b.dart`, `ast/*.b.dart` | Generated bridges (source / AST engines). |
| `relaxers.b.dart` | Generated `$Relaxed*` wrappers for loose guest types. |
| `dn_bridge.dart` | Registers all bridges; unwraps bridged/interpreted instances. |
| `widget_proxies.dart`, `ast/ast_widget_proxies.dart` | Native proxies for interpreted Stateless/Stateful/Consumer widgets and Riverpod notifiers. |
| `widget_generation_tracker.dart` | Per-class generation keys driving targeted remounts. |
| `auto_import_parser.dart` | Import/export parsing and framework-import injection (source mode). |
| `asset_bridge.dart`, `ast/ast_asset_bridge.dart` | `Image.asset` over HTTP from the dev server. |
| `ast/isolate_compute_bridge.dart` | `compute()` on a real isolate. |
| `d4rt_flutter_application.dart` | Long-lived app root with teardown across reloads. |

## Generation

```text
buildkit.yaml / buildkit_ast.yaml --tool/d4rtgen*.dart--> *.b.dart
```

Local fixes to generated output are applied by the generator
(`tool/d4rtgen.dart`) and marked `DN-PATCH`; change them there, not in the
`.b.dart` files.

## Invariants

- Source and AST proxy classes keep the same names and lifecycle semantics;
  fix bugs in both.
- A host widget handed back to guest code implements `D4InterpretedProxy` so
  covariant parameters and field reads resolve to the interpreted class.
- A guest `build` that starts throwing renders its last good child.
- Bridge registration order matters: the last registration wins (tests rely
  on this for fakes).
- A re-registration of the *same* native class under one name (e.g. UI +
  compat barrels bridging `Widget`) swaps the thunk lazily — never an eager
  build, never a spurious ambiguity.
- A re-merge of the *same* bridge/enum across generations (reload) is the
  same declaration, not a conflict — compared by native type / value set,
  not object identity.
- `==` / `!=` never invoke function values; callbacks compare by identity.
