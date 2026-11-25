import 'dart:collection';

import 'package:tom_d4rt_ast/runtime.dart';

/// Bridges for `dart:collection` base helpers required by `package:collection`
/// (and therefore `equatable`).
///
/// `package:collection` 1.19.1 has a true import cycle
/// (`unmodifiable_wrappers ↔ wrappers ↔ empty_unmodifiable_set`) whose classes
/// extend SDK bases:
///
/// * `EmptyUnmodifiableSet extends IterableBase` (SDK typedef → `Iterable`)
/// * `IterableZip extends IterableBase`, `CombinedIterableView extends IterableBase`
/// * `ListSlice extends ListBase`, `CombinedListView extends ListBase`
/// * `UnionSet extends SetBase`
/// * `CombinedMapView extends UnmodifiableMapBase`
/// * `QueueList with ListMixin` (SDK typedef → `ListBase`), `BoolList with ListMixin`
///
/// In SDK 3.12 `IterableBase`, `ListMixin`, `SetMixin`, `MapMixin`,
/// `IterableMixin` are typedef aliases (`IterableBase<E> = Iterable<E>`,
/// `ListMixin<E> = ListBase<E>`, …), while `ListBase`/`SetBase`/`MapBase` are
/// `abstract mixin class` and `UnmodifiableMapBase` is
/// `abstract class = MapBase with _UnmodifiableMapMixin`.
///
/// None were bridged, so any bundle importing `package:collection`
/// failed with `Superclass 'IterableBase' not found` (after the cycle fix)
/// or `Mixin 'UnmodifiableSetMixin' not found` (before it).
///
/// These are intentionally minimal stubs: they exist so `extends`/`with`
/// wiring succeeds during module loading. Unused collection classes (empty
/// sets, union sets, combined views) are never instantiated by `equatable`
/// (`sorted`, equality helpers), so full method surfaces are unnecessary.
/// `IterableBase` carries the two static string helpers because
/// `QueueList.toString` references `IterableBase.iterableToFullString`.
class CollectionBasesCollection {
  static BridgedClass get iterableBase => BridgedClass(
    nativeType: Iterable,
    name: 'IterableBase',
    providesContract: 'Iterable',
    typeParameterCount: 1,
    isAbstract: true,
    // No isAssignable: concrete iterables are owned by Iterable/List/Set
    // bridges. This stub exists only so `extends IterableBase` (typedef to
    // Iterable) wires during module loading; claiming assignability would
    // steal dispatch (e.g. `[].sorted` resolving via ListMixin).
    staticMethods: {
      'iterableToShortString': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs.length > 3) {
          throw RuntimeD4rtException(
            'IterableBase.iterableToShortString(iterable, [leftDelimiter, '
            'rightDelimiter]) expects one to three positional arguments.',
          );
        }
        final iterable = positionalArgs[0];
        if (iterable is! Iterable) {
          throw RuntimeD4rtException(
            'The first argument to IterableBase.iterableToShortString must '
            'be an Iterable.',
          );
        }
        return Iterable.iterableToShortString(
          iterable,
          positionalArgs.length > 1 ? positionalArgs[1] as String : '(',
          positionalArgs.length > 2 ? positionalArgs[2] as String : ')',
        );
      },
      'iterableToFullString': (visitor, positionalArgs, namedArgs, _) {
        if (positionalArgs.isEmpty || positionalArgs.length > 3) {
          throw RuntimeD4rtException(
            'IterableBase.iterableToFullString(iterable, [leftDelimiter, '
            'rightDelimiter]) expects one to three positional arguments.',
          );
        }
        final iterable = positionalArgs[0];
        if (iterable is! Iterable) {
          throw RuntimeD4rtException(
            'The first argument to IterableBase.iterableToFullString must '
            'be an Iterable.',
          );
        }
        return Iterable.iterableToFullString(
          iterable,
          positionalArgs.length > 1 ? positionalArgs[1] as String : '(',
          positionalArgs.length > 2 ? positionalArgs[2] as String : ')',
        );
      },
    },
  );

  static BridgedClass get iterableMixin => BridgedClass(
    nativeType: Iterable,
    name: 'IterableMixin',
    providesContract: 'Iterable',
    typeParameterCount: 1,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get listBase => BridgedClass(
    nativeType: ListBase,
    name: 'ListBase',
    providesContract: 'List',
    typeParameterCount: 1,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get listMixin => BridgedClass(
    nativeType: ListBase,
    name: 'ListMixin',
    providesContract: 'List',
    typeParameterCount: 1,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get setBase => BridgedClass(
    nativeType: SetBase,
    name: 'SetBase',
    providesContract: 'Set',
    typeParameterCount: 1,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get setMixin => BridgedClass(
    nativeType: SetBase,
    name: 'SetMixin',
    providesContract: 'Set',
    typeParameterCount: 1,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get mapBase => BridgedClass(
    nativeType: MapBase,
    name: 'MapBase',
    providesContract: 'Map',
    typeParameterCount: 2,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get mapMixin => BridgedClass(
    nativeType: MapBase,
    name: 'MapMixin',
    providesContract: 'Map',
    typeParameterCount: 2,
    isAbstract: true,
    canBeUsedAsMixin: true,
  );

  static BridgedClass get unmodifiableMapBase => BridgedClass(
    nativeType: UnmodifiableMapBase,
    name: 'UnmodifiableMapBase',
    typeParameterCount: 2,
    isAbstract: true,
  );

  static void register(Environment environment) {
    environment.defineBridge(iterableBase);
    environment.defineBridge(iterableMixin);
    environment.defineBridge(listBase);
    environment.defineBridge(listMixin);
    environment.defineBridge(setBase);
    environment.defineBridge(setMixin);
    environment.defineBridge(mapBase);
    environment.defineBridge(mapMixin);
    environment.defineBridge(unmodifiableMapBase);
  }
}
