import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent caching', () {
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

    test('loading the same component twice is idempotent', () async {
      final bundle = project.componentBundles['profile_card']!;
      final first = await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: bundle,
      );
      expect(first, isNotNull);
      final cellsBefore = harness.runner.declarationRegistry.classCellCount;

      final second = await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: bundle,
      );
      expect(second, isNotNull);
      // Same declaration identity — re-declaration stabilizes into the
      // existing registry cells instead of accumulating duplicates.
      expect(second!.declarationIdentity, equals(first!.declarationIdentity));
      expect(
        harness.runner.declarationRegistry.classCellCount,
        equals(cellsBefore),
        reason: 'second load must not publish new class declarations',
      );
      // Still resolvable and mountable after the double load.
      expect(
        harness.mountComponent('profile_card', props: {'userId': 3}),
        isNotNull,
      );
    });
  });
}
