import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart';

class _WidgetA {
  const _WidgetA();
}

class _WidgetB {
  const _WidgetB();
}

// Cold-start regression test: the same native class registered under one
// name through two barrels (e.g. `dartnative_ui` + `flutter_compat` both
// bridging `Widget`) must not force eager [BridgedClass] builds. Before
// the fix, every duplicate built both thunks during warm-parent
// construction (~8s of `registerBridgedDefinitions` on device).
void main() {
  test('same native type re-registration builds nothing eagerly', () {
    final env = Environment();
    var buildsA = 0;
    var buildsB = 0;

    env.defineBridgeLazy('Widget', _WidgetA, () {
      buildsA++;
      return BridgedClass(nativeType: _WidgetA, name: 'Widget');
    }, sourceUri: 'package:ui/ui.dart');

    // Second barrel, same class: must swap the thunk without building.
    env.defineBridgeLazy('Widget', _WidgetA, () {
      buildsB++;
      return BridgedClass(nativeType: _WidgetA, name: 'Widget');
    }, sourceUri: 'package:compat/compat.dart');

    expect(buildsA, isZero, reason: 'first thunk must stay deferred');
    expect(buildsB, isZero, reason: 'second thunk must stay deferred');

    // Last registration still wins the name, built once on first lookup.
    final resolved = env.findBridgedClassByName('Widget');
    expect(resolved, isNotNull);
    expect(buildsA, isZero);
    expect(buildsB, equals(1));
  });

  test('different native type under one name keeps collision behaviour', () {
    final env = Environment();
    var buildsA = 0;
    var buildsB = 0;

    env.defineBridgeLazy('Widget', _WidgetA, () {
      buildsA++;
      return BridgedClass(nativeType: _WidgetA, name: 'Widget');
    }, sourceUri: 'package:a/a.dart');

    // Genuine ambiguity: old eager path is preserved.
    env.defineBridgeLazy('Widget', _WidgetB, () {
      buildsB++;
      return BridgedClass(nativeType: _WidgetB, name: 'Widget');
    }, sourceUri: 'package:b/b.dart');

    expect(buildsA, equals(1), reason: 'prior bridge built for shadowing');
    expect(buildsB, equals(1), reason: 'new bridge built for shadowing');

    // Both candidates stay enumerable.
    final all = env.findAllBridgedClassesByName('Widget');
    expect(all.map((b) => b.nativeType), containsAll([_WidgetA, _WidgetB]));
  });
}
