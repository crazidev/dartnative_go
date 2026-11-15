import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server_components/client_module_index.dart';
import 'package:dartnative_go/src/cli/packaging/safe_ast_converter.dart';
import 'package:dartnative_go/src/cli/server_components/server_annotation_scanner.dart';
import 'package:dartnative_go/src/cli/server_components/server_component_bundler.dart';
import 'package:tom_d4rt_ast/runtime.dart' show AstBundle;

/// Temp-project sources for server-component headless tests.
///
/// Layout (`package:demo_app/`):
/// - `main.dart` — client entry, imports only `helper.dart`.
/// - `helper.dart` — client-shared code (`greeting`).
/// - `card.dart` — `@ServerComponent(id: 'profile_card')`, imports
///   `helper.dart` (shared) + `card_detail.dart` (server-only).
/// - `card_detail.dart` — server-only code (`detail`), shared by two comps.
/// - `badge.dart` — `@Server(id: 'badge')`, imports `card_detail.dart`.
Map<String, String> demoComponentSources() => {
  'main.dart': '''
import 'helper.dart';
void main() {}
''',
  'helper.dart': '''
String greeting(String name) => 'hi \$name';
''',
  'card.dart': '''
import 'package:flutter/widgets.dart';
import 'helper.dart';
import 'card_detail.dart';
class ServerComponent {
  final String id;
  final int version;
  const ServerComponent({required this.id, this.version = 1});
}
@ServerComponent(id: 'profile_card', version: 1)
class ProfileCard extends StatelessWidget {
  final int userId;
  const ProfileCard({required this.userId});
  String greet() => greeting('bob');
  @override
  Widget build(BuildContext context) {
    return Text('user \$userId \${detail()}');
  }
}
''',
  'card_detail.dart': '''
String detail() => 'detail!';
''',
  'badge.dart': '''
import 'package:flutter/widgets.dart';
import 'card_detail.dart';
class Server {
  final String id;
  final int version;
  const Server({required this.id, this.version = 1});
}
@Server(id: 'badge')
class Badge extends StatelessWidget {
  const Badge();
  String describe() => 'badge \${detail()}';
  @override
  Widget build(BuildContext context) {
    return Text(describe());
  }
}
''',
};

/// A built demo project: client bundle + index + per-component delta bundles.
class ComponentDemoProject {
  final Directory dir;
  final String packageName;
  final AstBundle clientBundle;
  final ClientModuleIndex clientIndex;
  final Map<String, AstBundle> componentBundles;
  final Set<AnnotatedComponent> annotated;

  ComponentDemoProject._({
    required this.dir,
    required this.packageName,
    required this.clientBundle,
    required this.clientIndex,
    required this.componentBundles,
    required this.annotated,
  });

  /// Creates the temp project, builds the client bundle from `main.dart`,
  /// discovers `@ServerComponent`s by scanning the component entries, and
  /// builds one delta bundle per component.
  static Future<ComponentDemoProject> create({
    String packageName = 'demo_app',
  }) async {
    final dir = Directory.systemTemp.createTempSync('dn_server_comp_fixture_');
    final lib = Directory('${dir.path}/lib')..createSync(recursive: true);
    File('${dir.path}/pubspec.yaml').writeAsStringSync('name: $packageName\n');
    for (final entry in demoComponentSources().entries) {
      File('${lib.path}/${entry.key}').writeAsStringSync(entry.value);
    }

    final bundler = IncrementalAstBundler(
      bridgedLibraries: kAstBridgedLibraries,
      packageName: packageName,
      projectRoot: dir.path,
      converter: SafeAstConverter(),
    );
    final clientBundle = await bundler.createFromFile('${lib.path}/main.dart');
    final clientIndex = ClientModuleIndex.fromBundle(
      clientBundle,
      bridgedUris: kAstBridgedLibraries,
    );

    // Component discovery: scan each component entry's own closure.
    // (The client bundle cannot discover them — `main.dart` never imports
    // server-only modules. This mirrors the Phase-5 dev-server watch.)
    final annotated = <AnnotatedComponent>{};
    for (final entry in ['card.dart', 'badge.dart']) {
      final entryBundle = await bundler.createFromFile('${lib.path}/$entry');
      annotated.addAll(ServerAnnotationScanner.scanBundle(entryBundle));
    }

    final allSources = <String, String>{
      for (final entry in demoComponentSources().entries)
        'package:$packageName/${entry.key}': entry.value,
    };
    final componentBundler = ServerComponentBundler(
      bridgedLibraries: kAstBridgedLibraries,
      packageName: packageName,
      projectRoot: dir.path,
      converter: SafeAstConverter(),
      clientModuleIndex: clientIndex,
    );
    final componentBundles = <String, AstBundle>{};
    for (final component in annotated) {
      final bundle = await componentBundler.buildComponentBundle(
        component,
        allSources: allSources,
      );
      if (bundle != null) {
        componentBundles[component.componentId] = bundle;
      }
    }

    return ComponentDemoProject._(
      dir: dir,
      packageName: packageName,
      clientBundle: clientBundle,
      clientIndex: clientIndex,
      componentBundles: componentBundles,
      annotated: annotated,
    );
  }

  void delete() {
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  }
}
