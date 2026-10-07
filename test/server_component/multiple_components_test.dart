import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('Multiple server components', () {
    late ComponentDemoProject project;
    late ServerComponentHarness harness;

    setUpAll(() async {
      project = await ComponentDemoProject.create();
      harness = ServerComponentHarness();
      await harness.loadClientBundle(project.clientBundle);
    });

    tearDownAll(() {
      harness.dispose();
      project.delete();
    });

    test('two components sharing client code both resolve', () async {
      final card = await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: project.componentBundles['profile_card']!,
      );
      final badge = await harness.loadComponent(
        componentId: 'badge',
        componentBundle: project.componentBundles['badge']!,
      );
      expect(card, isNotNull);
      expect(badge, isNotNull);
      expect(card!.name, equals('ProfileCard'));
      expect(badge!.name, equals('Badge'));
    });

    test('loading order does not matter', () async {
      final other = ServerComponentHarness();
      try {
        await other.loadClientBundle(project.clientBundle);
        // Badge first this time.
        await other.loadComponent(
          componentId: 'badge',
          componentBundle: project.componentBundles['badge']!,
        );
        await other.loadComponent(
          componentId: 'profile_card',
          componentBundle: project.componentBundles['profile_card']!,
        );
        expect(other.runner.resolveTopLevel('ProfileCard'), isNotNull);
        expect(other.runner.resolveTopLevel('Badge'), isNotNull);
      } finally {
        other.dispose();
      }
    });
  });
}
