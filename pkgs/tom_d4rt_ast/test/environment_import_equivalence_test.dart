import 'package:test/test.dart';
import 'package:tom_d4rt_ast/runtime.dart';

class _WidgetA {
  const _WidgetA();
}

class _WidgetB {
  const _WidgetB();
}

enum _Flavor { vanilla, chocolate }

BridgedEnum _flavorEnum([List<_Flavor>? values]) {
  final selected = values ?? _Flavor.values;
  final e = BridgedEnum('Flavor', {});
  for (var i = 0; i < selected.length; i++) {
    final v = selected[i];
    e.values[v.name] = BridgedEnumValue(e, v.name, i, v);
  }
  return e;
}

// Reload regression test: hot reload rebuilds every stdlib surface while
// bundle modules reuse their previous generation's environments. Re-running
// an export merge (`errorOnConflict: true`, e.g. `package:collection`
// re-exporting `dart:collection`) must not throw a spurious conflict for
// two distinct-but-equivalent bridge instances of one declaration.
void main() {
  test('export merge accepts the same class rebuilt in another generation',
      () {
    final target = Environment();
    target.defineBridge(
      BridgedClass(nativeType: _WidgetA, name: 'Widget'),
      sourceUri: 'dart:collection',
    );
    final source = Environment();
    source.defineBridge(
      BridgedClass(nativeType: _WidgetA, name: 'Widget'),
      sourceUri: 'dart:collection',
    );

    expect(
      () => target.importEnvironment(source, errorOnConflict: true),
      returnsNormally,
    );
    expect(target.findBridgedClassByName('Widget')?.nativeType, _WidgetA);
  });

  test('export merge still rejects genuinely different same-named classes',
      () {
    final target = Environment();
    target.defineBridge(
      BridgedClass(nativeType: _WidgetA, name: 'Widget'),
      sourceUri: 'package:a/a.dart',
    );
    final source = Environment();
    source.defineBridge(
      BridgedClass(nativeType: _WidgetB, name: 'Widget'),
      sourceUri: 'package:b/b.dart',
    );

    expect(
      () => target.importEnvironment(source, errorOnConflict: true),
      throwsA(isA<RuntimeD4rtException>()),
    );
  });

  test('Function-typed typedef placeholders keep the legacy identity rule',
      () {
    final target = Environment();
    target.defineBridge(BridgedClass(nativeType: Function, name: 'Callback'));
    final source = Environment();
    source.defineBridge(BridgedClass(nativeType: Function, name: 'Callback'));

    // Same-named typedefs from different libraries are different
    // declarations despite sharing the placeholder type.
    expect(
      () => target.importEnvironment(source, errorOnConflict: true),
      throwsA(isA<RuntimeD4rtException>()),
    );
  });

  test('import merge of the same class keeps the first binding, no shadow',
      () {
    final first = BridgedClass(nativeType: _WidgetA, name: 'Widget');
    final target = Environment();
    target.defineBridge(first, sourceUri: 'dart:collection');
    final source = Environment();
    source.defineBridge(
      BridgedClass(nativeType: _WidgetA, name: 'Widget'),
      sourceUri: 'dart:collection',
    );

    expect(
      () => target.importEnvironment(source),
      returnsNormally,
    );
    expect(
      target.findAllBridgedClassesByName('Widget'),
      hasLength(1),
    );
    expect(identical(target.findBridgedClassByName('Widget'), first), isTrue);
  });

  test('export merge accepts the same enum rebuilt in another generation',
      () {
    final target = Environment();
    target.defineBridgedEnum(_flavorEnum());
    final source = Environment();
    source.defineBridgedEnum(_flavorEnum());

    expect(
      () => target.importEnvironment(source, errorOnConflict: true),
      returnsNormally,
    );
  });

  test('export merge still rejects same-named enums with different values',
      () {
    final target = Environment();
    target.defineBridgedEnum(_flavorEnum());
    final source = Environment();
    source.defineBridgedEnum(_flavorEnum([_Flavor.vanilla]));

    expect(
      () => target.importEnvironment(source, errorOnConflict: true),
      throwsA(isA<RuntimeD4rtException>()),
    );
  });
}
