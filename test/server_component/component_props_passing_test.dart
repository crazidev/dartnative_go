import 'package:dartnative_go/src/interpreter/ast/ast_widget_proxies.dart';
import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent props passing', () {
    late ComponentDemoProject project;
    late ServerComponentHarness harness;

    setUpAll(() async {
      project = await ComponentDemoProject.create();
      harness = ServerComponentHarness();
      await harness.loadClientBundle(project.clientBundle);
      await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: project.componentBundles['profile_card']!,
      );
    });

    tearDownAll(() {
      harness.dispose();
      project.delete();
    });

    test('props reach the interpreted constructor', () async {
      final widget = harness.mountComponent(
        'profile_card',
        props: {'userId': 42},
      );
      expect(widget, isNotNull);
      // The mount path wraps the interpreted instance in a native proxy;
      // the prop must be visible on the instance's fields.
      expect(widget, isA<InterpretedStatelessWidget>());
      final instance = (widget as InterpretedStatelessWidget).instance;
      expect(instance.hasInstanceMember('userId'), isTrue);
      expect(instance.get('userId'), equals(42));
    });

    test('different props produce distinct instances', () async {
      final first = harness.mountComponent(
        'profile_card',
        props: {'userId': 1},
      );
      final second = harness.mountComponent(
        'profile_card',
        props: {'userId': 2},
      );
      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(
        (first as InterpretedStatelessWidget).instance.get('userId'),
        equals(1),
      );
      expect(
        (second as InterpretedStatelessWidget).instance.get('userId'),
        equals(2),
      );
    });
  });
}
