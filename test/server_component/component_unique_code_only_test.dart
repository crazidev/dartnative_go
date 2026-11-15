import 'package:test/test.dart';

import 'component_fixture.dart';

void main() {
  group('ServerComponent delta contains only unique code', () {
    late ComponentDemoProject project;

    setUpAll(() async {
      project = await ComponentDemoProject.create();
    });

    tearDownAll(() {
      project.delete();
    });

    test('no client-indexed module leaks into the delta', () {
      for (final entry in project.componentBundles.entries) {
        final leaked = entry.value.modules.keys
            .where(project.clientIndex.contains)
            .toList();
        expect(
          leaked,
          isEmpty,
          reason:
              '${entry.key} must not re-bundle client modules; '
              'leaked: $leaked',
        );
      }
    });

    test('server-only dependency is in the delta', () {
      final card = project.componentBundles['profile_card']!;
      expect(
        card.modules.keys,
        contains('package:demo_app/card_detail.dart'),
      );
      expect(
        card.modules.keys,
        contains('package:demo_app/card.dart'),
      );
    });

    test('entry point URI is the annotated module', () {
      final card = project.componentBundles['profile_card']!;
      expect(card.entryPointUri, equals('package:demo_app/card.dart'));
    });
  });
}
