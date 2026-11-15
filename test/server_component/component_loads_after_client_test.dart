import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent loads after client', () {
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

    test('component bundle exists for the annotated class', () {
      expect(
        project.annotated.map((c) => c.componentId),
        containsAll(['profile_card', 'badge']),
      );
      expect(
        project.componentBundles.keys,
        containsAll(['profile_card', 'badge']),
      );
    });

    test('client-only resolve misses before component load', () {
      // Sanity: the component class is server-only — it must NOT resolve
      // from the client bundle alone.
      expect(harness.runner.resolveTopLevel('ProfileCard'), isNull);
    });

    test('loadComponent resolves the annotated class', () async {
      final cls = await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: project.componentBundles['profile_card']!,
      );
      expect(cls, isNotNull);
      expect(cls!.name, equals('ProfileCard'));
      expect(harness.runner.resolveTopLevel('ProfileCard'), isNotNull);
    });

    test('mountComponent returns a native Widget', () async {
      await harness.loadComponent(
        componentId: 'profile_card',
        componentBundle: project.componentBundles['profile_card']!,
      );
      final widget = harness.mountComponent(
        'profile_card',
        props: {'userId': 7},
      );
      expect(widget, isNotNull);
    });
  });
}
