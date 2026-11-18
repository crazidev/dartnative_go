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
| `d4rt_dartnative_application.dart` | Long-lived app root with teardown across reloads. |

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
- A guest `build` that starts throwing renders its last good child; before
  there is one, a monitored failure renders a neutral placeholder so the
  framework's error screen never flashes before the host's error view.
- Bridge registration order matters: the last registration wins (tests rely
  on this for fakes).
- A re-registration of the *same* native class under one name (e.g. UI +
  compat barrels bridging `Widget`) swaps the thunk lazily — never an eager
  build, never a spurious ambiguity.
- A re-merge of the *same* bridge/enum across generations (reload) is the
  same declaration, not a conflict — compared by native type / value set,
  not object identity.
- `==` / `!=` never invoke function values; callbacks compare by identity.
- Callable interpreted instances dispatch through their `call` method and
  preserve explicit generic type arguments (`locator<User>()`).
- A declared for-in variable gets a fresh environment binding on every
  iteration, so closures capture their own value; identifier-form loops keep
  assigning the existing binding.
- A non-generic class alias (`typedef Alias = Target;`) resolves to its target
  in expressions as well as type positions, including constructor initializer
  lists. The declaration-pass alias binding is limited to non-generic aliases;
  generic aliases are not covered by this callable-alias behavior.

## Pure-Dart dependencies and SDK bridges

AST mode bundles reachable pure-Dart package source and interprets it on the
device. That source can still extend or mix in SDK types, so those SDK names
must be available in the runtime bridge registry even though the package
itself is bundled rather than bridged. For example, `equatable` depends on
`collection`, which uses `dart:collection` bases such as `IterableBase`,
`ListBase`, and `MapBase`; the runtime registers minimal type bridges for
those SDK helpers.

The module loader also publishes declared type placeholders before resolving
imports, allowing legal cyclic imports to resolve class and mixin names. A
module exports its own declarations, not its imports; this avoids leaking
dependency symbols through barrels and follows Dart library semantics.
`test/unit/collection_dependency_test.dart` covers the `equatable`/`collection`
path end to end in AST mode.

The SDK compatibility surface also covers collection `MapView`/
`UnmodifiableMapView` and `HashMap`/`LinkedHashMap` constructors, typed-data
list views, conversion-sink typedef aliases, `WeakReference`, and a narrow
`Zone` bridge. `Zone.current`, parent/fork, and run/delegation calls use the
host zone; guest `runZoned`/`runZonedGuarded` remain interpreter-owned rather
than being exposed as misleading no-op bridges.

## Async execution and developer extensions

Interpreted async continuations use a cooperative event-loop budget. Within the
default 4 ms turn budget, continuations use microtasks; after the budget is
spent, the next continuation moves to a zero-duration timer turn so the host
event loop can render frames and process other work. Set
`InterpretedFunction.asyncSliceBudgetMicros` to `0` to restore the historical
all-microtask scheduling behavior.

The `dart:developer` `registerExtension` bridge registers each method with the
host once and updates its stored interpreted handler on later registrations.
This allows guest top-level code to re-register service extensions after a hot
reload without triggering the host's duplicate-registration error or leaving
dispatch bound to an obsolete interpreter generation.

Compile-time-gated initialization profiling is documented in
[Runtime Modes](../runtime_modes.md#profiling-ast-initialization).

## Third-party packages compiled into the shell

A pure-Dart dependency is normally bundled and interpreted (see above). Some
are instead *bridged whole*: the package becomes a module in `buildkit.yaml` /
`buildkit_ast.yaml`, which the generator expands into a `*_bridges.b.dart`
registered from `dartscript.b.dart` (and its `ast/` twin) under
`package:<pkg>/<barrel>.dart`. Adding the barrel URI to `kAstBridgedLibraries`
(`lib/src/cli/packaging/ast_builder.dart`) then makes the bundler skip the
package, so a guest `import 'package:dio/dio.dart'` resolves to the compiled
host classes instead of an interpreted copy.

Bridge a package only when its cost is interpretation-dominated and its value
semantics don't matter. `dio` is the reference case: interpreting its async
request pipeline node by node was the bottleneck, and dio's objects are never
compared structurally. `equatable` is the counter-example — an interpreted
subclass of a bridged abstract superclass inherits no concrete member bodies,
so bridging it would regress its `==`/`hashCode`; it stays interpreted and is
covered by `test/unit/collection_dependency_test.dart`.

## AST library parts

`AstModuleLoader.loadLibraryUnits` follows `SPartDirective`s from a library
unit and gathers the referenced part ASTs in directive order. The loader and
the entrypoint execution path then run declaration passes over those units in
one environment, so private declarations are visible across the library just
as they are in Dart. Parts remain separate bundle entries for source mapping
and incremental builds; the parent library's cache fingerprint includes its
parts so a part-only edit triggers re-declaration.

Regression coverage lives in
[`test/runner/ast_part_files_test.dart`](../../test/runner/ast_part_files_test.dart)
and covers both entrypoint parts and parts of an imported library, including
part-only cache invalidation.
