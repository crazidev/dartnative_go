import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent shared server-only module', () {
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

    test('both deltas carry the shared non-client module (v1)', () {
      // v1 duplicates shared server-only modules into each bundle.
      for (final id in ['profile_card', 'badge']) {
        expect(
          project.componentBundles[id]!.modules.keys,
          contains('package:demo_app/card_detail.dart'),
          reason: '$id must carry its server-only dependency',
        );
      }
    });

    test('both components resolve and share one detail()', () async {
      await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: project.componentBundles['profile_card']!,
      );
      await harness.loadComponent(
        componentId: 'badge',
        componentBundle: project.componentBundles['badge']!,
      );
      expect(harness.runner.resolveTopLevel('ProfileCard'), isNotNull);
      expect(harness.runner.resolveTopLevel('Badge'), isNotNull);
    });
  });
}
