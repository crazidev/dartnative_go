/// Host-side bridge for the reactive-state extensions in
/// `package:dartnative/src/state.dart`.
///
/// `Signal<T>.watch(context)` and `Computed<T>.watch(context)` are declared by
///
/// ```dart
/// extension SignalWatch<T> on _SignalBase<T> {
///   T watch(BuildContext context) { … }
/// }
/// ```
///
/// `_SignalBase` is library-private, so the bridge generator skips the whole
/// extension: a generated bridge lives in another library, cannot name the
/// `on` type, and could not resolve `onTypeName: '_SignalBase'` at
/// registration time either. Registering it by hand against the two public
/// subclasses is the supported way to expose it.
///
/// The adapters call the framework's own `watch` — the real implementation
/// lives in the platform, not in the SDK source copy under
/// `.dart_tool/dartnative_sdk` (whose bodies are `UnimplementedError` stubs).
library;

import 'package:dartnative/dartnative.dart';
import 'package:tom_d4rt/tom_d4rt.dart' as src;
import 'package:tom_d4rt_ast/d4rt.dart' as ast;

/// Library the extension is declared in. Both engines key bridged extensions
/// per library, so this has to be the URI guest code imports.
const _stateLibrary = 'package:dartnative/dartnative.dart';

/// Canonical source URI, used for cross-bridge deduplication.
const _stateSourceUri = 'package:dartnative/src/state.dart';

/// `Signal.watch(context)` / `Computed.watch(context)`.
///
/// `watch` reads [context] for the element it subscribes and schedules a
/// rebuild when the value changes. A build that runs outside an element tree
/// — the headless playground suite drives `build` on a synthetic context —
/// has no element to subscribe, so the read falls back to the plain value.
/// That keeps `final count = counter.watch(context)` working in both cases
/// instead of turning "no element" into a build failure.
Object? _watch(Object target, List<Object?> positional) {
  final context = positional.isEmpty ? null : positional[0];
  if (target is Signal) {
    if (context is BuildContext) {
      try {
        return target.watch(context);
      } catch (_) {
        // Not in an element tree: fall through to a value read.
      }
    }
    return target.value;
  }
  if (target is Computed) {
    if (context is BuildContext) {
      try {
        return target.watch(context);
      } catch (_) {}
    }
    return target.value;
  }
  return null;
}

/// AST-engine registration (`tom_d4rt_ast`).
///
/// One definition per public `on` type, because extension lookup is nominal
/// on that side: the interpreter matches the receiver's bridged class against
/// `onTypeName`. Both are added to the unnamed-extension walk, so implicit
/// `.watch(context)` resolves for either.
void registerAstStateSignalExtensions(ast.D4rtRunner runner) {
  for (final onType in const ['Signal', 'Computed']) {
    runner.registerBridgedExtension(
      ast.BridgedExtensionDefinition(
        name: 'SignalWatch',
        onTypeName: onType,
        methods: {
          'watch': (visitor, target, positional, named, typeArgs) =>
              _watch(target, positional),
        },
      ),
      _stateLibrary,
      sourceUri: _stateSourceUri,
    );
  }
}

/// Source-engine counterpart of [registerAstStateSignalExtensions].
void registerStateSignalExtensions(src.D4rt interpreter) {
  for (final onType in const ['Signal', 'Computed']) {
    interpreter.registerBridgedExtension(
      src.BridgedExtensionDefinition(
        name: 'SignalWatch',
        onTypeName: onType,
        methods: {
          'watch': (visitor, target, positional, named, typeArgs) =>
              _watch(target, positional),
        },
      ),
      _stateLibrary,
      sourceUri: _stateSourceUri,
    );
  }
}
