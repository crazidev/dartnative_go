import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server_components/server_annotation_source.dart';
import 'package:test/test.dart';

void main() {
  group('serverAnnotationSources', () {
    test('injects the real host annotation sources', () {
      // Runs inside the dartnative_go checkout, so root discovery works.
      final sources = serverAnnotationSources();
      expect(
        sources.keys.toSet(),
        equals(kServerAnnotationUris),
      );
      expect(
        sources['package:dartnative_go/server.dart'],
        contains("export 'src/server/server_annotation.dart'"),
      );
      final annotation =
          sources['package:dartnative_go/src/server/server_annotation.dart']!;
      expect(annotation, contains('class ServerComponent'));
      expect(annotation, contains('class Server'));
      expect(annotation, contains('final String id'));
    });

    test('injected sources stay identical to the real files', () async {
      final sources = serverAnnotationSources();
      expect(sources, isNotEmpty);
      final root = Directory.current;
      for (final uri in kServerAnnotationUris) {
        final rel = uri.replaceFirst('package:dartnative_go/', 'lib/');
        final onDisk = await File('${root.path}/$rel').readAsString();
        expect(
          sources[uri],
          equals(onDisk),
          reason: '$uri injection must match $rel exactly',
        );
      }
    });
  });

  group('guest imports package:dartnative_go/server.dart', () {
    late Directory tmp;

    setUpAll(() {
      tmp = Directory.systemTemp.createTempSync('dn_server_annot_e2e_');
    });

    tearDownAll(() {
      try {
        tmp.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('annotated guest component is discovered with zero guest config',
        () async {
      final proj = Directory('${tmp.path}/annot_app')..createSync();
      final lib = Directory('${proj.path}/lib')..createSync();
      File('${proj.path}/pubspec.yaml')
          .writeAsStringSync('name: annot_app\n');
      File('${lib.path}/helper.dart')
          .writeAsStringSync('int doubleIt(int x) => x * 2;\n');
      File('${lib.path}/card.dart').writeAsStringSync(
        "import 'package:dartnative_go/server.dart';\n"
        "import 'helper.dart';\n"
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

      final result = await buildGuestAstBundle(
        proj,
        outputArg: '${tmp.path}/annot_guest.ast',
        force: true,
      );
      expect(result.success, isTrue, reason: result.error);
      // The host annotation flowed through the client bundle…
      expect(
        result.clientModuleIndex!.modules,
        contains('package:dartnative_go/server.dart'),
      );
      // …and the annotated class was discovered and split out.
      expect(result.serverComponents, isNotNull);
      expect(
        result.serverComponents!.components.keys,
        contains('profile_card'),
      );
      // Shared annotation modules stay out of the delta.
      final delta = result.serverComponents!.components['profile_card']!;
      expect(delta.moduleCount, greaterThanOrEqualTo(1));
    });
  });
}
