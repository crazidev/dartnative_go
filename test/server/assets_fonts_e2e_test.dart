import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:dartnative_go/src/cli/server/server.dart';
import 'package:dartnative_go/src/interpreter/ast/ast_asset_bridge.dart';
import 'package:dartnative_go/src/runner/app_cache.dart';
import 'package:dartnative_go/src/runner/ast_interpreter_runner.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:dartnative_go/src/runner/icon_font_manager.dart';
import 'package:dartnative_go/src/runner/native_font_registrar.dart';
import 'package:test/test.dart';

void main() {
  group('Assets + Fonts Server, AST Proxying & Client Caching', () {
    late DartGoServer server;
    late HttpClient client;
    late String baseUrl;
    late Directory tempCacheDir;

    setUpAll(() async {
      tempCacheDir = Directory.systemTemp.createTempSync('dngo_assets_test_');
      server = DartGoServer(
        DartGoServerOptions(
          projectDir: Directory('${Directory.current.path}/example'),
          startPort: 9140,
          endPort: 9145,
          enableBroadcast: false,
          enableQrCode: false,
          customHost: '127.0.0.1',
          rebuildAst: false,
        ),
      );
      unawaited(server.start());
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      while (server.boundPort == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(server.boundPort, isNotNull);
      baseUrl = 'http://127.0.0.1:${server.boundPort}';
      client = HttpClient();
    });

    tearDownAll(() {
      server.stop();
      client.close(force: true);
      if (tempCacheDir.existsSync()) {
        tempCacheDir.deleteSync(recursive: true);
      }
    });

    Future<Map<String, dynamic>> getJson(String path) async {
      final req = await client.getUrl(Uri.parse('$baseUrl$path'));
      final res = await req.close();
      expect(res.statusCode, equals(HttpStatus.ok), reason: 'GET $path');
      return jsonDecode(await res.transform(utf8.decoder).join())
          as Map<String, dynamic>;
    }

    test('binds customHost IP and rewrites all manifest/font/asset URLs', () async {
      final manifest = await getJson('/manifest.json');
      expect(manifest['serverUrl'], equals(baseUrl));
      expect(manifest['assetEtags'], isA<Map>());
      final assetEtags = manifest['assetEtags'] as Map;
      expect(assetEtags.containsKey('assets/dn-logo.png'), isTrue);

      final fonts = manifest['fonts'] as List;
      final fontFamilies = fonts.map((e) => (e as Map)['family']).toSet();
      expect(fontFamilies, containsAll(['ArialRoundedBold', 'AndaleMono']));
      for (final f in fonts) {
        expect((f as Map)['url'].toString(), startsWith('$baseUrl/fonts/'));
      }

      final iconFontsJson = await getJson('/icon-fonts.json');
      final entries = (iconFontsJson['iconFonts'] as List)
          .cast<Map<String, dynamic>>();
      final rounded = entries.firstWhere(
        (e) => e['family'] == 'ArialRoundedBold',
      );
      expect(rounded['url'], equals('$baseUrl/fonts/ArialRoundedBold.ttf'));
      expect(rounded['etag'], isNotEmpty);

      // External icon package (lucide_kit) auto-detected and served on demand
      final lucide = entries.firstWhere((e) => e['family'] == 'Lucide');
      expect(lucide['package'], equals('lucide_kit'));
      expect(lucide['hasFontFile'], isTrue);
      expect(lucide['url'], equals('$baseUrl/fonts/Lucide.ttf'));
      expect(lucide['etag'], isNotEmpty);
    });

    test('serves assets and fonts with ETag and 304 Not Modified', () async {
      // Asset via /assets/...
      final req1 = await client.getUrl(Uri.parse('$baseUrl/assets/dn-logo.png'));
      final res1 = await req1.close();
      expect(res1.statusCode, equals(HttpStatus.ok));
      final etag = res1.headers.value(HttpHeaders.etagHeader);
      expect(etag, isNotNull);
      final bytes1 = await res1.fold<List<int>>([], (a, b) => a..addAll(b));
      expect(bytes1, isNotEmpty);

      // Revalidate with If-None-Match -> 304
      final req2 = await client.getUrl(Uri.parse('$baseUrl/assets/dn-logo.png'));
      req2.headers.set(HttpHeaders.ifNoneMatchHeader, etag!);
      final res2 = await req2.close();
      await res2.drain<void>();
      expect(res2.statusCode, equals(HttpStatus.notModified));

      // Asset via /asset?path=... without assets/ prefix
      final req3 = await client.getUrl(
        Uri.parse('$baseUrl/asset?path=dn-logo.png'),
      );
      final res3 = await req3.close();
      expect(res3.statusCode, equals(HttpStatus.ok));
      await res3.drain<void>();

      // Custom font via /fonts/ArialRoundedBold.ttf + 304
      final fontReq1 = await client.getUrl(
        Uri.parse('$baseUrl/fonts/ArialRoundedBold.ttf'),
      );
      final fontRes1 = await fontReq1.close();
      expect(fontRes1.statusCode, equals(HttpStatus.ok));
      final fontEtag = fontRes1.headers.value(HttpHeaders.etagHeader);
      expect(fontEtag, isNotNull);
      await fontRes1.drain<void>();

      final fontReq2 = await client.getUrl(
        Uri.parse('$baseUrl/fonts/ArialRoundedBold.ttf'),
      );
      fontReq2.headers.set(HttpHeaders.ifNoneMatchHeader, fontEtag!);
      final fontRes2 = await fontReq2.close();
      await fontRes2.drain<void>();
      expect(fontRes2.statusCode, equals(HttpStatus.notModified));
    });

    test('AST asset bridges proxy all Image widgets & AssetImage', () async {
      final projectDir = Directory(
        '${tempCacheDir.path}/ast_image_guest',
      )..createSync(recursive: true);
      File('${projectDir.path}/pubspec.yaml').writeAsStringSync('''
name: ast_image_guest
environment:
  sdk: ^3.9.0
''');
      Directory('${projectDir.path}/lib').createSync();
      File('${projectDir.path}/lib/main.dart').writeAsStringSync('''
import 'package:dartnative/dartnative.dart';

void main() {
  runApp(
    Column(
      children: [
        Image.asset(
          'assets/dn-logo.png',
          width: 48.0,
          color: Color(0xFFFF0000),
          semanticLabel: 'App Logo',
        ),
        Image.asset('dn-logo.png'),
        CircleAvatar(
          backgroundImage: AssetImage('assets/dn-logo.png'),
        ),
      ],
    ),
  );
}
''');

      final buildResult = await buildGuestAstBundle(projectDir);
      expect(buildResult.success, isTrue, reason: buildResult.error);
      final astBytes = File(buildResult.outputPath).readAsBytesSync();

      File? mockCachedFile;
      AstAssetResolver.cachedAssetFileProvider = (_) => mockCachedFile;
      addTearDown(() => AstAssetResolver.cachedAssetFileProvider = null);

      final runner = AstInterpreterRunner(
        onLog: (_) {},
        onExit: () {},
        currentServerUrl: baseUrl,
      );
      final root = await runner.evaluateAstBundleAs<Widget>(astBytes) as Column;
      expect(root.children.length, equals(3));

      // 1. Image.asset with color + semanticLabel
      final img1 = root.children[0] as Image;
      expect(img1.image, isA<NetworkImage>());
      expect(
        (img1.image as NetworkImage).url,
        equals('$baseUrl/assets/dn-logo.png'),
      );
      expect(img1.color, isNotNull);
      expect(img1.semanticLabel, equals('App Logo'));

      // 2. Image.asset without leading assets/ prefix
      final img2 = root.children[1] as Image;
      expect(
        (img2.image as NetworkImage).url,
        equals('$baseUrl/assets/dn-logo.png'),
      );

      // 3. CircleAvatar(backgroundImage: AssetImage(...))
      final avatar = root.children[2] as CircleAvatar;
      expect(avatar.backgroundImage, isA<NetworkImage>());
      expect(
        (avatar.backgroundImage as NetworkImage).url,
        equals('$baseUrl/assets/dn-logo.png'),
      );

      // 4. Local disk cache / offline fallback resolves to FileImage
      final cached = File('${tempCacheDir.path}/cached_logo.png')
        ..writeAsBytesSync([1, 2, 3, 4]);
      mockCachedFile = cached;
      final offlineRoot =
          await runner.evaluateAstBundleAs<Widget>(astBytes) as Column;
      final offlineImg = offlineRoot.children[0] as Image;
      expect(offlineImg.image, isA<FileImage>());
      expect((offlineImg.image as FileImage).file.path, equals(cached.path));
    });

    test('IconFontManager loads fonts on demand, caches to disk, and reinvalidates', () async {
      final cache = await AppCache.create(tempCacheDir);
      final loader = BundleLoader();
      final registrar = NativeFontRegistrar();

      final bundle = await loader.fetchBundle(baseUrl);
      final manager = IconFontManager.fromLoader(
        loader,
        baseUrl,
        cache: cache,
        registrar: registrar,
      );

      final loaded = await manager.syncBundle(bundle);
      expect(loaded, containsAll(['ArialRoundedBold', 'AndaleMono']));
      expect(manager.fontBytes('ArialRoundedBold'), isNotEmpty);

      // Verify persisted on disk
      final cachedFont = cache.getCachedFontFile(baseUrl, 'ArialRoundedBold');
      expect(cachedFont, isNotNull);
      expect(cachedFont!.existsSync(), isTrue);

      // On macOS/iOS, verify CoreText registered the font file
      if (Platform.isMacOS || Platform.isIOS) {
        expect(
          registrar.registeredPaths,
          contains(cachedFont.absolute.path),
        );
      }

      // Second manager with same AppCache hits disk with zero HTTP calls
      var httpCalls = 0;
      final manager2 = IconFontManager(
        fetcher: (fam) async {
          httpCalls++;
          return null;
        },
        cache: cache,
        serverUrl: baseUrl,
        registrar: registrar,
      );
      await manager2.syncBundle(bundle);
      expect(httpCalls, equals(0));
      expect(manager2.fontBytes('ArialRoundedBold'), isNotEmpty);

      // Asset caching + reinvalidation
      await cache.saveAsset(
        baseUrl,
        'assets/dn-logo.png',
        [1, 2, 3],
        etag: 'old-etag',
      );
      expect(cache.getCachedAssetFile(baseUrl, 'assets/dn-logo.png'), isNotNull);

      final invalidated = await cache.invalidateStaleAssets(
        baseUrl,
        bundle.assetEtags,
      );
      expect(invalidated, contains('assets/dn-logo.png'));
      expect(cache.getCachedAssetFile(baseUrl, 'assets/dn-logo.png'), isNull);

      loader.close();
    });
  });
}
