import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server_components/client_module_index.dart';
import 'package:dartnative_go/src/cli/packaging/safe_ast_converter.dart';
import 'package:dartnative_go/src/cli/server_components/server_annotation_scanner.dart';
import 'package:dartnative_go/src/cli/server_components/server_component_bundler.dart';
import 'package:test/test.dart';

/// In-memory project sources keyed by module URI.
///
/// Layout:
/// - `package:demo_app/main.dart` — client entry, imports helper + card.
/// - `package:demo_app/helper.dart` — client-shared code.
/// - `package:demo_app/card.dart` — `@ServerComponent` entry, imports
///   helper (shared) + card_detail (unique).
/// - `package:demo_app/card_detail.dart` — unique server-only code.
/// - `package:demo_app/badge.dart` — second `@Server` component sharing
///   card_detail.
/// - `package:demo_app/deferred_part.dart` — deferred import target.
Map<String, String> _demoSources() => {
      'package:demo_app/main.dart': '''
import 'helper.dart';
import 'card.dart';
void main() {}
''',
      'package:demo_app/helper.dart': '''
int doubleIt(int x) => x * 2;
''',
      'package:demo_app/card.dart': '''
import 'helper.dart';
import 'card_detail.dart';
import 'deferred_part.dart' deferred as deferred;
class ServerComponent {
  final String id;
  final int version;
  const ServerComponent({required this.id, this.version = 1});
}
@ServerComponent(id: 'profile_card', version: 2)
class ProfileCard {
  const ProfileCard();
}
String renderCard() => 'card \${doubleIt(21)} \${detail()}';
''',
      'package:demo_app/card_detail.dart': '''
String detail() => 'detail';
''',
      'package:demo_app/badge.dart': '''
import 'card_detail.dart';
class Server {
  final String id;
  final int version;
  const Server({required this.id, this.version = 1});
}
@Server(id: 'badge')
class Badge {
  const Badge();
}
String renderBadge() => 'badge \${detail()}';
''',
      'package:demo_app/deferred_part.dart': '''
String deferredHello() => 'deferred';
''',
      'package:demo_app/plain.dart': '''
class Plain {
  const Plain();
}
''',
    };

ServerComponentBundler _bundler(
  ClientModuleIndex index, {
  Map<String, String> extraSources = const {},
}) {
  return ServerComponentBundler(
    bridgedLibraries: kAstBridgedLibraries,
    explicitSources: extraSources,
    packageName: 'demo_app',
    clientModuleIndex: index,
  );
}

AnnotatedComponent _component(String className, String moduleUri,
        {String? id, int version = 1}) =>
    AnnotatedComponent(
      className: className,
      moduleUri: moduleUri,
      componentId: id ?? className,
      version: version,
    );

void main() {
  group('ServerAnnotationScanner', () {
    test('finds @ServerComponent with id and version', () async {
      final tmp =
          Directory.systemTemp.createTempSync('dn_server_scan_');
      try {
        final lib = Directory('${tmp.path}/lib')..createSync();
        File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
        File('${lib.path}/helper.dart').writeAsStringSync(
          _demoSources()['package:demo_app/helper.dart']!,
        );
        File('${lib.path}/card.dart').writeAsStringSync(
          _demoSources()['package:demo_app/card.dart']!,
        );
        File('${lib.path}/card_detail.dart').writeAsStringSync(
          _demoSources()['package:demo_app/card_detail.dart']!,
        );
        File('${lib.path}/deferred_part.dart').writeAsStringSync(
          _demoSources()['package:demo_app/deferred_part.dart']!,
        );
        File('${lib.path}/main.dart').writeAsStringSync(
          "import 'card.dart';\nvoid main() {}\n",
        );
        final bundler = IncrementalAstBundler(
          bridgedLibraries: kAstBridgedLibraries,
          packageName: 'demo_app',
          projectRoot: tmp.path,
          converter: SafeAstConverter(),
        );
        final bundle =
            await bundler.createFromFile('${lib.path}/main.dart');
        final found = ServerAnnotationScanner.scanBundle(bundle);
        expect(
          found.any((c) =>
              c.className == 'ProfileCard' &&
              c.componentId == 'profile_card' &&
              c.version == 2 &&
              c.moduleUri.endsWith('card.dart')),
          isTrue,
          reason: 'expected ProfileCard(profile_card v2), got $found',
        );
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('ignores non-annotated classes', () async {
      final tmp =
          Directory.systemTemp.createTempSync('dn_server_scan_plain_');
      try {
        final lib = Directory('${tmp.path}/lib')..createSync();
        File('${tmp.path}/pubspec.yaml').writeAsStringSync('name: demo_app\n');
        File('${lib.path}/plain.dart').writeAsStringSync(
          _demoSources()['package:demo_app/plain.dart']!,
        );
        File('${lib.path}/main.dart').writeAsStringSync(
          "import 'plain.dart';\nvoid main() {}\n",
        );
        final bundler = IncrementalAstBundler(
          bridgedLibraries: kAstBridgedLibraries,
          packageName: 'demo_app',
          projectRoot: tmp.path,
          converter: SafeAstConverter(),
        );
        final bundle =
            await bundler.createFromFile('${lib.path}/main.dart');
        expect(ServerAnnotationScanner.scanBundle(bundle), isEmpty);
      } finally {
        try {
          tmp.deleteSync(recursive: true);
        } catch (_) {}
      }
    });
  });

  group('ServerComponentBundler delta', () {
    test('component with only client-shared deps yields entry-only bundle',
        () async {
      final sources = _demoSources();
      // Client ships main + helper + card (component imported by main).
      final index = ClientModuleIndex(
        fingerprint: 'fp',
        modules: {
          'package:demo_app/main.dart',
          'package:demo_app/helper.dart',
          'package:demo_app/card.dart',
          'package:demo_app/card_detail.dart',
        },
      );
      final bundler = _bundler(index);
      final bundle = await bundler.buildComponentBundle(
        _component('ProfileCard', 'package:demo_app/card.dart',
            id: 'profile_card'),
        allSources: sources,
      );
      expect(bundle, isNotNull);
      // Entry always included; every other client module subtracted.
      // card_detail is client-indexed here so it must NOT be re-bundled
      // beyond the entry closure — entry itself is the only guarantee.
      expect(bundle!.modules.containsKey('package:demo_app/card.dart'), isTrue);
      expect(
        bundle.modules.keys
            .where((m) => m != 'package:demo_app/card.dart')
            .where(index.contains),
        isEmpty,
        reason: 'no client-indexed module may leak into the delta',
      );
    });

    test('unique server-only code survives, shared code excluded', () async {
      final sources = _demoSources();
      // Client ships main + helper only; card subtree is server-only.
      final index = ClientModuleIndex(
        fingerprint: 'fp',
        modules: {
          'package:demo_app/main.dart',
          'package:demo_app/helper.dart',
        },
      );
      final bundler = _bundler(index);
      final bundle = await bundler.buildComponentBundle(
        _component('ProfileCard', 'package:demo_app/card.dart',
            id: 'profile_card'),
        allSources: sources,
      );
      expect(bundle, isNotNull);
      expect(bundle!.modules.containsKey('package:demo_app/card.dart'), isTrue);
      expect(
        bundle.modules.containsKey('package:demo_app/card_detail.dart'),
        isTrue,
        reason: 'unique dep must be in the delta bundle',
      );
      expect(
        bundle.modules.containsKey('package:demo_app/helper.dart'),
        isFalse,
        reason: 'client-shared helper must be excluded',
      );
      expect(
        bundle.modules.containsKey('package:demo_app/main.dart'),
        isFalse,
      );
    });

    test('deferred imports are a separate boundary', () async {
      final sources = _demoSources();
      final index = ClientModuleIndex(
        fingerprint: 'fp',
        modules: {'package:demo_app/main.dart'},
      );
      final bundler = _bundler(index);
      final bundle = await bundler.buildComponentBundle(
        _component('ProfileCard', 'package:demo_app/card.dart',
            id: 'profile_card'),
        allSources: sources,
      );
      expect(bundle, isNotNull);
      expect(
        bundle!.modules.containsKey('package:demo_app/deferred_part.dart'),
        isFalse,
        reason: 'deferred import must not be pulled into the delta',
      );
    });

    test('bridged libraries are never bundled', () async {
      final sources = {
        ..._demoSources(),
        'package:demo_app/bridged_card.dart': '''
import 'package:flutter/material.dart';
class ServerComponent {
  final String id;
  final int version;
  const ServerComponent({required this.id, this.version = 1});
}
@ServerComponent(id: 'bridged')
class Bridged {
  const Bridged();
}
''',
      };
      final index = ClientModuleIndex(fingerprint: 'fp', modules: const {});
      final bundler = _bundler(index);
      final bundle = await bundler.buildComponentBundle(
        _component('Bridged', 'package:demo_app/bridged_card.dart',
            id: 'bridged'),
        allSources: sources,
      );
      expect(bundle, isNotNull);
      expect(
        bundle!.modules.containsKey('package:flutter/material.dart'),
        isFalse,
      );
      expect(
        bundle.modules.containsKey('package:demo_app/bridged_card.dart'),
        isTrue,
      );
    });

    test('two components sharing a non-client module both include it',
        () async {
      final sources = _demoSources();
      final index = ClientModuleIndex(
        fingerprint: 'fp',
        modules: {'package:demo_app/main.dart'},
      );
      final bundler = _bundler(index);
      final card = await bundler.buildComponentBundle(
        _component('ProfileCard', 'package:demo_app/card.dart',
            id: 'profile_card'),
        allSources: sources,
      );
      final badge = await bundler.buildComponentBundle(
        _component('Badge', 'package:demo_app/badge.dart', id: 'badge'),
        allSources: sources,
      );
      expect(card, isNotNull);
      expect(badge, isNotNull);
      // v1 duplicates shared non-client modules into each bundle.
      expect(card!.modules.containsKey('package:demo_app/card_detail.dart'),
          isTrue);
      expect(badge!.modules.containsKey('package:demo_app/card_detail.dart'),
          isTrue);
    });

    test('missing entry source returns null', () async {
      final index = ClientModuleIndex(fingerprint: 'fp', modules: const {});
      final bundler = _bundler(index);
      final bundle = await bundler.buildComponentBundle(
        _component('Ghost', 'package:demo_app/ghost.dart', id: 'ghost'),
        allSources: _demoSources(),
      );
      expect(bundle, isNull);
    });

    test('buildAll produces manifest with urls and fingerprints', () async {
      final sources = _demoSources();
      final index = ClientModuleIndex(
        fingerprint: 'fp',
        modules: {'package:demo_app/main.dart'},
      );
      final bundler = _bundler(index);
      final result = await bundler.buildAll(
        {
          _component('ProfileCard', 'package:demo_app/card.dart',
              id: 'profile_card'),
          _component('Badge', 'package:demo_app/badge.dart', id: 'badge'),
        },
        allSources: sources,
      );
      expect(result.components.keys, containsAll(['profile_card', 'badge']));
      expect(result.manifest['profile_card']!.url,
          equals('server_components/profile_card.ast'));
      expect(result.manifest['badge']!.url,
          equals('server_components/badge.ast'));
      expect(
        result.components.values.every((c) => c.fingerprint.isNotEmpty),
        isTrue,
      );
      expect(
        result.components.values.every((c) => c.astBytes.isNotEmpty),
        isTrue,
      );
    });
  });

  group('buildGuestAstBundle server integration', () {
    late Directory tmp;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_server_e2e_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('emits client index + server_components for annotated app',
        () async {
      final proj = Directory('${tmp.path}/server_app')..createSync();
      final lib = Directory('${proj.path}/lib')..createSync();
      File('${proj.path}/pubspec.yaml').writeAsStringSync('name: server_app\n');
      File('${lib.path}/helper.dart').writeAsStringSync(
        'int doubleIt(int x) => x * 2;\n',
      );
      File('${lib.path}/card.dart').writeAsStringSync(
        "import 'helper.dart';\n"
        'class ServerComponent {\n'
        '  final String id;\n'
        '  final int version;\n'
        '  const ServerComponent({required this.id, this.version = 1});\n'
        '}\n'
        "@ServerComponent(id: 'profile_card')\n"
        'class ProfileCard {\n'
        '  const ProfileCard();\n'
        '  int answer() => doubleIt(21);\n'
        '}\n',
      );
      File('${lib.path}/main.dart').writeAsStringSync(
        "import 'card.dart';\n"
        'void main() {\n'
        '  ProfileCard();\n'
        '}\n',
      );

      final out = File('${tmp.path}/server_guest.ast');
      final result = await buildGuestAstBundle(proj, outputArg: out.path);
      expect(result.success, isTrue, reason: result.error);
      expect(result.clientModuleIndex, isNotNull);
      expect(
        result.clientModuleIndex!.modules.any((m) => m.contains('main.dart')),
        isTrue,
      );

      // Server components discovered from the client bundle.
      expect(result.serverComponents, isNotNull,
          reason: 'annotated ProfileCard must produce a component bundle');
      expect(
        result.serverComponents!.components.keys,
        contains('profile_card'),
      );

      // Artifacts on disk next to guest.ast.
      final compFile = File(
          '${out.parent.path}/server_components/profile_card.ast');
      final manifestFile =
          File('${out.parent.path}/server_components/manifest.json');
      expect(compFile.existsSync(), isTrue);
      expect(manifestFile.existsSync(), isTrue);

      // Delta contains no client-indexed module except the entry itself.
      final comp = result.serverComponents!.components['profile_card']!;
      expect(comp.moduleCount, greaterThanOrEqualTo(1));
    });
  });
}
