import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent resolves client imports', () {
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

    test('interpreted method reaches the client-shared helper', () async {
      final cls = harness.runner.resolveTopLevel('ProfileCard');
      expect(cls, isNotNull);
      final visitor = harness.runner.visitor;
      expect(visitor, isNotNull);
      final instance = cls!.call(
        visitor!,
        const <Object?>[],
        <String, Object?>{'userId': 1},
      );
      final greet = (instance as dynamic).get('greet', visitor: visitor);
      final result = (greet as dynamic).call(
        visitor,
        const <Object?>[],
        const <String, Object?>{},
      );
      // greeting() lives in the CLIENT bundle — this proves the delta
      // resolved a shared import from the host interpreter by reference.
      expect(result.toString(), contains('hi bob'));
    });

    test('interpreted method reaches the delta-local module', () async {
      final cls = harness.runner.resolveTopLevel('Badge');
      expect(cls, isNull,
          reason: 'badge must not resolve before its bundle loads');
      await harness.loadComponent(
        componentId: 'badge',
        componentBundle: project.componentBundles['badge']!,
      );
      final badge = harness.runner.resolveTopLevel('Badge');
      expect(badge, isNotNull);
      final visitor = harness.runner.visitor!;
      final instance = badge!.call(
        visitor,
        const <Object?>[],
        const <String, Object?>{},
      );
      final describe =
          (instance as dynamic).get('describe', visitor: visitor);
      final result = (describe as dynamic).call(
        visitor,
        const <Object?>[],
        const <String, Object?>{},
      );
      // detail() lives in NEITHER the client bundle NOR badge's own module —
      // it is the shared server-only module both deltas carry.
      expect(result.toString(), contains('detail!'));
    });
  });
}
