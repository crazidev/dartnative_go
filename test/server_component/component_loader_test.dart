import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/widgets/server_component_loader.dart';
import 'package:test/test.dart';

import '../test_lab/server_component_harness.dart';
import 'component_fixture.dart';

/// Exercises [ServerComponentLoader] — the manual-use loading API — against
/// a minimal loopback HTTP server (manifest + delta bytes, ephemeral port).
void main() {
  group('ServerComponentLoader', () {
    late ComponentDemoProject project;
    late ServerComponentHarness harness;
    late HttpServer http;
    late Map<String, List<int>> bytesById;
    var astRequests = 0;

    setUpAll(() async {
      project = await ComponentDemoProject.create();
      harness = ServerComponentHarness();
      await harness.loadClientBundle(project.clientBundle);

      bytesById = {
        for (final e in project.componentBundles.entries)
          e.key: e.value.toBytes(),
      };
      http = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      http.listen((req) async {
        final path = req.uri.path;
        if (path == '/server-components/manifest.json') {
          req.response
            ..headers.contentType = ContentType.json
            ..write(jsonEncode({
              'version': 1,
              'components': {
                for (final id in bytesById.keys)
                  id: {
                    'url': 'server_components/$id.ast',
                    'fingerprint': 'fp-$id',
                  },
              },
            }));
          await req.response.close();
        } else if (path.startsWith('/server-components/') &&
            path.endsWith('.ast')) {
          final id = path.split('/').last.split('.').first;
          final bytes = bytesById[id];
          if (bytes == null) {
            req.response.statusCode = HttpStatus.notFound;
            await req.response.close();
          } else {
            astRequests++;
            req.response
              ..headers.contentType =
                  ContentType('application', 'octet-stream')
              ..add(bytes);
            await req.response.close();
          }
        } else {
          req.response.statusCode = HttpStatus.notFound;
          await req.response.close();
        }
      });
    });

    tearDownAll(() async {
      await http.close(force: true);
      harness.dispose();
      project.delete();
    });

    ServerComponentLoader newLoader() => ServerComponentLoader(
          serverUrl: 'http://127.0.0.1:${http.port}',
          runner: harness.runner,
        );

    test('loads a component over HTTP', () async {
      final loader = newLoader();
      final cls = await loader.loadComponent('profile_card');
      expect(cls, isNotNull);
      expect(cls!.name, equals('ProfileCard'));
      expect(loader.isLoaded('profile_card'), isTrue);
    });

    test('fingerprint-identical reload skips the bundle fetch', () async {
      final loader = newLoader();
      final before = astRequests;
      await loader.loadComponent('badge');
      expect(astRequests, equals(before + 1));
      await loader.loadComponent('badge');
      expect(
        astRequests,
        equals(before + 1),
        reason: 'second load must reuse the loaded bytes',
      );
      expect(loader.isLoaded('badge'), isTrue);
    });

    test('forceReload refetches', () async {
      final loader = newLoader();
      await loader.loadComponent('badge');
      final before = astRequests;
      await loader.loadComponent('badge', forceReload: true);
      expect(astRequests, equals(before + 1));
    });

    test('unknown id returns null', () async {
      final loader = newLoader();
      expect(await loader.loadComponent('nope'), isNull);
      expect(loader.isLoaded('nope'), isFalse);
    });

    test('fallback id loads when the primary is missing', () async {
      final loader = newLoader();
      final cls = await loader.loadComponentWithFallback(
        'nope',
        fallbackId: 'badge',
      );
      expect(cls, isNotNull);
      expect(cls!.name, equals('Badge'));
    });

    test('both ids missing returns null', () async {
      final loader = newLoader();
      expect(
        await loader.loadComponentWithFallback('nope', fallbackId: 'alsono'),
        isNull,
      );
    });

    test('preloadAll loads several components', () async {
      final loader = newLoader();
      final out = await loader.preloadAll(['profile_card', 'badge']);
      expect(out['profile_card']!.name, equals('ProfileCard'));
      expect(out['badge']!.name, equals('Badge'));
    });

    test('mountComponent mounts with props', () async {
      final loader = newLoader();
      await loader.loadComponent('profile_card');
      final widget = loader.mountComponent(
        'profile_card',
        props: {'userId': 9},
      );
      expect(widget, isNotNull);
    });

    test('mountComponent without load returns null', () {
      final loader = newLoader();
      expect(
        loader.mountComponent('never_loaded_xyz'),
        isNull,
      );
    });
  });
}
