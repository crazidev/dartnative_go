# Hot Reload

Hot reload is the feature DartNative Go is built around: save a file, and the
app on your phone updates in milliseconds **without losing its state** —
Riverpod providers, `State` objects, scroll positions, and in-flight timers
all survive. This page explains how that actually works.

The mechanism is different in the two engines:

- **AST mode** (the default) has the real engine: a *declaration-cell registry*
  that keeps function bodies, variable storage, and class identities stable
  across reloads. This is what the rest of the page describes.
- **Source mode** (legacy) uses a snapshot/restore pass that copies state out
  before re-evaluating and puts it back after. It's covered briefly at the end.

The AST machinery lives in
[`pkgs/tom_d4rt_ast/lib/src/runtime/declaration_registry.dart`](../pkgs/tom_d4rt_ast/lib/src/runtime/declaration_registry.dart)
and is driven by
[`lib/src/runner/ast_interpreter_runner.dart`](../lib/src/runner/ast_interpreter_runner.dart).
For the server side of the pipeline, see
[Dev Server & Protocol](dev_server.md#file-watching--the-reload-trigger).

## One reload, as a pipeline

```text
save in IDE
   │
   ▼
dev server rebuilds guest.ast & guest.ast.patch  (incremental DFS ~15ms)
   │
   ▼
broadcast {type: reload, only_ast: true} over WS
   │
   ▼
device fast-paths /guest.ast.patch (skips /manifest.json, ~20KB payload)
   │
   ▼
in-memory AstBundle.applyPatch() (merges compilation units in ~5ms)
   │
   ▼
evaluate as a new GENERATION
   │   ├─ beginGeneration()  — open the rollback journal
   │   ├─ reuse unchanged modules (fingerprint match)
   │   ├─ re-declare changed modules:
   │   │     · function bodies swapped into existing cells
   │   │     · variable cells keep their value if the initializer is unchanged
   │   │     · class cells re-published so old instances see the new class
   │   └─ commitGeneration() — or rollbackGeneration() on error
   ▼
remount only the widgets whose class changed (generational keys)
   │
   ▼
report timing + any errors to the CLI
```

The sub-100 ms full roundtrip comes from doing as little as possible at each stage:
unchanged sources skip the analyzer, full manifests are bypassed for code-only edits,
network transfer is reduced by 99% using delta patches, unchanged modules skip re-declaration,
unchanged initializers skip re-evaluation, and unchanged widgets skip the rebuild.

## The declaration-cell registry

The heart of it is the `DeclarationRegistry`, owned by the host app for the
lifetime of a session. Its job: make every declaration resolve to a **stable
object whose contents a reload replaces**, so live references never dangle and
never go stale.

There are three kinds of cell.

### FunctionCell — bodies swap, the shell stays

An `InterpretedFunction` is a thin, stable **shell**. Everything it needs to
execute — parameter list, body AST, async/generator flags, return type — lives
in an immutable `FunctionCode` payload held by a `FunctionCell`. On every call
the shell reads the *current* payload from its cell.

When a reload brings a new body for an existing function, the registry
*publishes* the new `FunctionCode` into the existing cell. Every reference
that already points at the cell — class member tables, tear-offs, timers,
stream listeners, bound-method caches — sees the new code immediately, because
`bind()` shares the cell rather than copying it. Nothing re-wires.

```text
gen 1                          gen 2 (you edited a body)
┌──────────────┐               ┌──────────────┐
│ shell (fn)   │               │ same shell   │
│     │        │   publish     │     │        │
│     ▼        │  ───────────► │     ▼        │
│ ┌─────────┐  │               │ ┌─────────┐  │
│ │ Cell    │  │               │ │ Cell    │  │   same object,
│ │ code v1 │  │               │ │ code v2 │  │   new contents
│ └─────────┘  │               │ └─────────┘  │
└──────────────┘               └──────────────┘
       ▲ every live reference now runs v2
```

### VariableCell — values keep, unless the initializer changed

Top-level variables, class statics, and enum constants live in a
`VariableCell` instead of a raw map slot. This buys three things:

- **Reload keeps the value.** The cell is reused across generations and the
  initializer is only re-run when it *actually changed* — the Dart VM hot
  reload rule. Unchanged initializers keep whatever the running program stored.
- **Cross-generation aliasing.** Every environment that imports the
  declaration (module env, exported env, prefixed import) shares the one cell,
  so a reload can't leave one frame looking at a stale copy.
- **Real declaration flags.** `late` (lazy, `LateInitializationError` if read
  early), `final` (second write throws), and `const` are enforced for
  top-levels — the old raw-value path ignored them entirely.

The keep-vs-reinitialize decision compares an **offset-free canonical key** of
the initializer expression, not the AST node's `offset`/`length`. Those
positions shift whenever you edit anything earlier in the file, so a naive
comparison would reset the state of every declaration after your cursor. By
stripping positions, only the expression's *shape* matters — editing line 5
doesn't reset a counter initialized on line 40.

### ClassCell — old instances dispatch to the new class

Each generation builds a fresh `InterpretedClass` (member tables are frozen
after wiring, so a class object can't be re-wired in place) and publishes it
into a `ClassCell`. `InterpretedInstance.klass` reads through the cell, so an
object created *before* the reload dispatches to the *reloaded* class: new
methods appear, edited bodies run, and `is` / `as` against the reloaded type
keep working.

### Additive vs. breaking edits

The registry decides whether a class's cells survive by comparing member
*shapes* (names, kinds, static/abstract flags, call signatures — bodies
excluded):

- **Body edit** → new declarations are a superset → cells kept, bodies swapped.
- **Member added** → superset → cells kept; new members become visible to
  instances that already exist.
- **Signature changed or member removed** → not a superset → the class cell and
  that class's function cells are **retired**, so in-flight callers keep the
  old call shape instead of crashing on a mismatch. (Removing a static field
  retires only that field's variable cell — adding one must not reset the
  statics that survived.)

You can watch this happen: the AST runner exposes
`declarationRegistry.stats` (`hits`, `misses`, `swaps`, `retirements`, cell
counts) and the verbose log line for a reload includes `decl_cells`,
`var_cells`, and `decl_swaps`.

## Generations are transactional

Every reload runs inside a generation with a rollback journal:

1. `beginGeneration()` — bump the generation counter, open the journal.
2. As declarations wire up, each publication (function body, variable storage,
   class version, cached module) records an **undo action**.
3. `commitGeneration()` — success; the publications become the new baseline.
4. `rollbackGeneration()` — evaluation threw; replay the journal in reverse to
   restore the previous generation exactly.

This is why a bad save never leaves the mounted widget running a half-applied
mix of old and new code. The journal replays defensively: one failing undo
action is logged and skipped so the rest of the rollback still completes.

Async code gets the same guarantee. The parent map that resumes suspended
`await`s is kept alive while older-generation activations are still running,
so a coroutine that was mid-flight when you saved finishes on the code it
started in.

## Module reuse

Re-declaring every module on every save would be wasteful, so the registry
caches loaded modules by content fingerprint:

- The dev server ships per-module fingerprints in `/manifest.json`
  (`astModuleFingerprints`, an FNV-1a hash of each module's serialized AST).
- A module whose fingerprint is unchanged **since the previous generation** is
  not re-declared — its `LoadedModule` (environment, classes, functions) is
  reused and re-parented. That's safe precisely because every mutable piece of
  a module's state lives in a registry cell the new generation shares.
- For a library with `part` files, the effective cache fingerprint includes
  each part URI and its fingerprint. Editing only a generated part therefore
  invalidates and re-declares its owning library without forcing unrelated
  modules to reload. See [Runtime Modes](runtime_modes.md#library-part-files)
  for the shared-library semantics.
- Only the **latest** fingerprint is cached per module, never a history. If
  you edit a file and then revert it to a fingerprint seen two reloads ago, it
  is still re-declared — matching against an old fingerprint would resurrect a
  stale module while the cells hold newer code.

Three rules keep reuse sound: a reused module re-runs its import/export merges
(so a dependency adding a name later becomes visible); the declaration pass
runs before the import merge (so a cyclic import can't plant the previous
generation's frozen class as this generation's placeholder); and
unprefixed-import records are replaced, not accumulated.

There's also a **decoded-bundle cache** (`AstInterpreterRunner._decodeBundle`):
decoding the `.ast` archive is the single most expensive host-side step, and
the server re-sends the same bytes whenever the edited module isn't the entry.
Keyed by the bundle's FNV-1a hash, a cache hit skips the decode entirely — you
see `decode_cache: hit` in the verbose log.

## Patch lineage: deltas apply only to their base

Reloads are fast because the device fetches a delta (`/guest.ast.patch`) and
merges it over its live bundle — but a delta is only valid on the exact
generation it was computed against. Rapid saves break that invariant: each
broadcast starts a device reload, a newer reload aborts the older one
mid-flight, and the server keeps only the *latest* patch. A device that missed
an intermediate generation and applies the newest delta anyway builds a
**franken-bundle** — some modules new, some permanently stale — with no
error, and every later patch applies cleanly on top of the wreckage, so it
never heals short of a full restart.

Patches therefore carry lineage:

- Every hot build records `patchBaseFingerprint`: the source fingerprint of
  the bundle the delta applies to.
- The device tracks its own base (`X-Ast-Bundle`, learned from full and patch
  responses) and sends it as `?base=` on every patch request.
- On mismatch the server answers 404 (`Patch base mismatch …`), and the
  device falls back to a full `/guest.ast` fetch — a slower reload, but a
  correct one. The next save then heals everything with no restart.
- Clients that predate lineage send no `base` and keep the legacy behavior.

You can watch it happen: the server prints `[PATCH] base mismatch …` and the
device logs `[BundleLoader] no usable patch … falling back to full fetch.`

## The widget side: rebuild only what changed

Preserving interpreter state is only half the story — the framework still has
to redraw the right widgets. The app rebuilds surgically rather than from the
root:

1. **Generational keys.** A `WidgetGenerationTracker` maps changed files to
   the widget classes that must remount, bumping a `Stateful_<Class>_gen_$gen`
   key so exactly those subtrees rebuild. Because an AST bundle carries no
   source text, the class→file map is derived from the decoded compilation
   units (`AstInterpreterRunner.classFileMap`) on every load — without it a
   widget defined outside the entry module would never get a new generation.
2. **A stable root.** The app root keeps a `guest_root` key so providers and
   state survive; overlapping reloads/restarts are ordered by monotonic
   sequence tokens. The root sits inside a `guest_epoch_<n>` wrapper that only
   changes on a **hot restart**: the epoch bump discards the mounted
   elements/`State` (which belong to the interpreter that was just disposed)
   instead of reconciling the restarted widgets onto them — otherwise a restart
   would preserve state exactly like a reload.
3. **Bottom sheets** live in their own reconciler outside the app root, so
   `NativeBottomSheetManager.notifyHotReload` rebinds them explicitly: the
   visitor advances, state fields carry over, and the unchanged child is
   marked dirty.
4. **Pushed routes** are not rebuilt when the root widget is replaced, so
   each mounted state proxy also gets a direct reload notification
   (`WidgetGenerationTracker.notifyMountedWidgets`). The proxy looks its
   widget and state classes up in the *new* generation
   (`findUserClassInVisitor`) and rebinds + rebuilds in place. The lookup
   searches the loader's live module cache — the only place that holds every
   module's current environment (entry-merged names miss transitively
   imported screens, and bundle sources are usually absent on device). A
   `[HotReload] could not find <Class> in the updated interpreter` device
   log means the lookup missed and that screen will go stale until it
   remounts: pop and re-push, or fix the lookup, never ignore it.
4. **Proxies unwrap.** A host widget handed back to guest code (say, in
   `didUpdateWidget`) implements `D4InterpretedProxy`, so argument checks and
   field reads resolve through the interpreted class behind it.

## When things go wrong

The design principle is that **a bad save never takes down the working app**.
There are three gates, from the inside out:

1. **Server gate.** A bundle build that fails leaves the previous `guest.ast`
   in place and broadcasts nothing. Devices keep running untouched; the CLI
   warning is the whole signal.
2. **Host gate.** A reload whose evaluation throws keeps the mounted tree —
   the registry already rolled the generation back. Only an *initial* load
   with nothing to show gets the error screen.
3. **Proxy gate.** A guest `build` that starts throwing renders its last good
   child (`_lastGoodChild`) instead of failing the whole tree, and builds
   fresh on the next successful reload. Before the first good child, a
   monitored failure renders a neutral placeholder: the host is about to show
   its error view, and rethrowing would flash the framework's own error screen
   first. (`createState` still throws — there's no widget to fall back to.)

Failures are surfaced, not swallowed. A guest build/lifecycle/callback error
travels `onGuestError` → `DartGoLogger.error` → WebSocket → the CLI prints a
red `[Device Error]` with a short stack (full stack under `-v`). On device,
the DevTool's **Error Display** setting controls whether failures float as a
dismissible banner (default) over the still-running app or take over as a full
screen with a copyable stack trace.

## One persistent core runner

Across hot reloads the `tom_d4rt_ast` runner, its bridge registrations, and
its warm stdlib/bridge parent are built **once** and reused — a reload never
pays for re-registration. Only a hot restart, a runtime-mode switch, or an
unmount tears it down (via `AstInterpreterRunner.dispose`, which clears the
declaration registry). You can observe this: `coreRunnerGeneration` stays at 1
across reloads and increments only on restart, while `evaluationCount` climbs.

## Source mode (legacy)

Source mode doesn't have the cell registry. Instead, `InterpreterRunner` does
a **snapshot/restore** around each reload:

- `_snapshotState` walks the interpreter environments (global, the current
  chain, and per-module envs for user modules only) and copies out the
  stateful objects. It deliberately keeps only "state-preserving" values —
  Riverpod `Provider`/`Notifier`/`Controller`/`Container` instances and their
  bridged equivalents — and skips plain data and functions. It also records
  every interpreted class's static fields.
- The interpreter is disposed and re-run on the new source.
- `_restoreState` writes the snapshots back into the new environments:
  existing top-levels are replaced by their saved values and static fields are
  merged back, skipping anything that's now a class or function.

Restricting the snapshot to user modules (not the 90+ dependency modules) is
what keeps it under ~2 ms. The trade-offs versus the AST engine: it's a
type-name heuristic rather than a structural guarantee, it's more fragile
around class identity, and it re-parses on-device. That's why AST is the
default and where hot-reload investment goes.

## Reading the verbose telemetry

Run `dngo start -v` (or press `v` live) and a reload prints benchmark lines
from both halves. The AST reload line looks like:

```text
AstInterpreter: AST evaluate (reload) 18ms
   {init: 0, decode: 2, exec: 14, core_runner: reused, decode_cache: hit,
    decl_cells: 412 cells, var_cells: 58 cells, decl_swaps: 3 swaps}
```

- `decode: 2` with `decode_cache: hit` — bundle bytes unchanged, decode skipped.
- `core_runner: reused` — the persistent runner (not a restart).
- `decl_swaps: 3 swaps` — three function bodies were swapped into live cells.
- `decl_cells` / `var_cells` — total declaration and variable cells alive.

Code-only patch reloads preserve unchanged module fingerprints from the base
generation (invalidating only URIs present in `/guest.ast.patch`) so
`DeclarationRegistry.cachedModule` skips re-declaring untouched modules, and
run icon-font manifest sync off the reload critical path.

On the server, the matching line is `guest.ast rebuilt {modules: N, bytes: B}`
or `guest.ast up to date {cache: hit}`.

## Related reading

- The pipeline that produces `guest.ast` and triggers the reload:
  [Dev Server & Protocol](dev_server.md).
- AST vs. Source trade-offs: [Runtime Modes](runtime_modes.md).
- The exhaustive internals (generation tracker, bottom-sheet reconciler,
  proxy error boundary): [ARCHITECTURE.md](../ARCHITECTURE.md#42-sub-100ms-hot-reload--state-preservation).
