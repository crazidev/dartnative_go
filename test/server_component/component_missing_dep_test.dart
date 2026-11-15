import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server_components/client_module_index.dart';
import 'package:dartnative_go/src/cli/packaging/safe_ast_converter.dart';
import 'package:dartnative_go/src/cli/server_components/server_annotation_scanner.dart';
import 'package:dartnative_go/src/cli/server_components/server_component_bundler.dart';
import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

void main() {
  group('ServerComponent missing dependency', () {
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

    test('component referencing an unknown module fails to load', () async {
      // A component whose import exists in NEITHER the client bundle NOR
      // its own delta must surface a load-time error (not silent null).
      final tmp = Directory.systemTemp.createTempSync('dn_server_missing_');
      try {
        final lib = Directory('${tmp.path}/lib')..createSync();
        File(
          '${tmp.path}/pubspec.yaml',
        ).writeAsStringSync('name: ${project.packageName}\n');
        File('${lib.path}/ghost.dart').writeAsStringSync('''
class ServerComponent {
  final String id;
  final int version;
  const ServerComponent({required this.id, this.version = 1});
}
import 'does_not_exist.dart';
@ServerComponent(id: 'ghost')
class Ghost {
  const Ghost();
  String haunt() => nope();
}
''');
        // NOTE: discovery deliberately skips IncrementalAstBundler here —
        // the full bundler rejects unresolvable imports at parse time, while
        // the delta bundler treats them as external boundaries (skipped).
        // The component is addressed directly, as the manifest would.
        const ghost = AnnotatedComponent(
          className: 'Ghost',
          moduleUri: 'package:demo_app/ghost.dart',
          componentId: 'ghost',
        );
        final delta = ServerComponentBundler(
          bridgedLibraries: kAstBridgedLibraries,
          packageName: project.packageName,
          projectRoot: tmp.path,
          converter: SafeAstConverter(),
          clientModuleIndex: project.clientIndex,
        );
        final ghostBundle = await delta.buildComponentBundle(
          ghost,
          allSources: {
            'package:${project.packageName}/ghost.dart': File(
              '${lib.path}/ghost.dart',
            ).readAsStringSync(),
          },
        );
        expect(ghostBundle, isNotNull);
        // The delta holds only the entry; the ghost import is absent
        // everywhere, so loading must throw.
        await expectLater(
          harness.loadComponent(
            componentId: 'ghost',
            componentBundle: ghostBundle!,
          ),
          throwsA(anything),
        );
        expect(harness.runner.resolveTopLevel('Ghost'), isNull);
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('ClientModuleIndex round-trips through JSON', () {
      // The index is served to component builders as JSON — it must
      // survive serialization with its module set intact.
      final json = project.clientIndex.toJson();
      final restored = ClientModuleIndex.fromJson(
        Map<String, dynamic>.from(json as Map),
      );
      expect(restored.modules, equals(project.clientIndex.modules));
      expect(restored.fingerprint, equals(project.clientIndex.fingerprint));
    });
  });
}
