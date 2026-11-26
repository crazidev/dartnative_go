/// Regression guards for two `tom_d4rt` (source engine) defects that the AST
/// engine never had. Both were recorded in
/// `docs/architecture/playground-headless.md` as *upstream* limits that blocked
/// source-mode runs of the playground, and both are fixed in the vendored
/// version (`third_party/tom_d4rt`, 1.279.0):
///
///  1. **1.244.0 — a library's own declaration shadows an imported one.**
///     Two modules each declaring a private class of the same name (`_Card`)
///     used to collide: imports were merged before the declaration pass, the
///     second module filled in the *imported* (already frozen) class and threw
///     `FrozenNameMap is frozen and cannot be mutated`.
///  2. **1.233.0 — static and top-level initializers read later
///     declarations.** A `static const` referenced by a member declared above
///     it failed with `Undefined variable`, because initializers ran eagerly in
///     declaration order.
///
/// These run through [DnHarness] in **source** mode, which is the engine the
/// suite otherwise does not exercise (the playground test targets the AST
/// engine `kUseAst` selects on device).
library;

import 'package:dartnative/dartnative.dart';
import 'package:test/test.dart';

import '../test_lab/harness.dart';

void main() {
  group('source engine: cross-module private-name collisions', () {
    test('each module keeps its own private class of the same name', () async {
      final harness = DnHarness(onLog: (_) {});
      addTearDown(harness.dispose);

      // `a.dart` and `b.dart` import each other (a real cycle) and each
      // declares its own `_Card`. In Dart these are distinct, private types.
      final root = await harness.evaluate({
        'a.dart': '''
import 'b.dart';

class _Card {
  final String value;
  const _Card(this.value);
}

String fromA() => const _Card('a').value;
String peerFromA() => fromB();
''',
        'b.dart': '''
import 'a.dart';

class _Card {
  final String value;
  const _Card(this.value);
}

String fromB() => const _Card('b').value;
''',
        'main.dart': '''
import 'package:dartnative/dartnative.dart';
import 'a.dart';
import 'b.dart';

void main() {
  runApp(Text('\${fromA()}/\${fromB()}'));
}
''',
      });

      final text = _firstText(root);
      expect(
        text,
        'a/b',
        reason: 'each module must resolve _Card to its own declaration',
      );
    });
  });

  group('source engine: forward references in static initializers', () {
    test('a static const may be referenced by a member declared above it',
        () async {
      final harness = DnHarness(onLog: (_) {});
      addTearDown(harness.dispose);

      final root = await harness.evaluate({
        'main.dart': r'''
import 'package:dartnative/dartnative.dart';

class Demo {
  // Declared ABOVE the constants it reads.
  static String get label => 'v=${values.join(",")}';

  static const values = [base, extra];
  static const base = 'x';
  static const extra = 'y';
}

void main() {
  runApp(Text(Demo.label));
}
''',
      });

      expect(
        _firstText(root),
        'v=x,y',
        reason: 'static initializers must resolve regardless of declaration '
            'order (tom_d4rt 1.233.0)',
      );
    });

    test('a top-level final may be referenced by a later declaration', () async {
      final harness = DnHarness(onLog: (_) {});
      addTearDown(harness.dispose);

      final root = await harness.evaluate({
        'main.dart': r'''
import 'package:dartnative/dartnative.dart';

final joined = values.join('-');
final values = [base, 'tail'];
const base = 'head';

void main() {
  runApp(Text(joined));
}
''',
      });

      expect(_firstText(root), 'head-tail');
    });
  });
}

/// The first `Text` in a built widget tree, walking the layouts the fixtures
/// use.
String _firstText(Widget root) {
  final queue = <Widget>[root];
  while (queue.isNotEmpty) {
    final node = queue.removeLast();
    if (node is Text) return node.data ?? '';
    if (node is Scaffold) queue.add(node.body!);
    if (node is Center) queue.add(node.child);
    if (node is Padding) queue.add(node.child);
    if (node is Column) queue.addAll(node.children);
    if (node is Row) queue.addAll(node.children);
  }
  throw StateError('no Text in ${root.runtimeType}');
}
