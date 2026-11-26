import 'package:tom_d4rt_ast/runtime.dart';

/// `dart:core` [WeakReference].
///
/// A thin handle over the native object — the interpreter keeps the real
/// instance, so GC semantics stay the SDK's own. `WeakReference` is used by
/// packages that hold a non-owning back-pointer; dio's `DioMixin.fetch` keeps
/// a `WeakReference` to the in-flight `CancelableOperation` so a cancelled
/// request can be cancelled without pinning the operation alive.
class WeakReferenceCore {
  static BridgedClass get definition => BridgedClass(
    nativeType: WeakReference,
    name: 'WeakReference',
    isAssignable: (v) => v is WeakReference,
    typeParameterCount: 1, // WeakReference<T>
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        D4.checkArity(positionalArgs, 'WeakReference', exactly: 1);
        return WeakReference<Object>(positionalArgs[0] as Object);
      },
    },
    getters: {
      'target': (visitor, target) => (target as WeakReference).target,
      'hashCode': (visitor, target) => (target as WeakReference).hashCode,
      'runtimeType': (visitor, target) => (target as WeakReference).runtimeType,
    },
    methods: {
      'toString': (visitor, target, positionalArgs, namedArgs, _) =>
          (target as WeakReference).toString(),
    },
  );
}
