import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative_go/src/cli/server.dart';

void main() async {
  final server = DartGoServer(
    DartGoServerOptions(
      projectDir: Directory.current,
      startPort: 9120,
      endPort: 9125,
      enableBroadcast: false,
      enableQrCode: false,
      customHost: '127.0.0.1',
    ),
  );

  // Run server in background
  unawaited(server.start());

  // Wait a short moment for server to bind
  await Future.delayed(const Duration(milliseconds: 500));

  final client = HttpClient();
  try {
    // 1. Check /health
    final healthReq =
        await client.getUrl(Uri.parse('http://127.0.0.1:9120/health'));
    final healthRes = await healthReq.close();
    assert(healthRes.statusCode == HttpStatus.ok);
    final healthBody = await healthRes.transform(utf8.decoder).join();
    final healthJson = jsonDecode(healthBody);
    assert(healthJson['status'] == 'ok');
    assert(healthJson['appName'] == 'dartnative_go');
    print('✔ /health passed');

    // 2. Check /manifest.json
    final manifestReq =
        await client.getUrl(Uri.parse('http://127.0.0.1:9120/manifest.json'));
    final manifestRes = await manifestReq.close();
    assert(manifestRes.statusCode == HttpStatus.ok);
    final manifestBody = await manifestRes.transform(utf8.decoder).join();
    final manifestJson = jsonDecode(manifestBody);
    assert(manifestJson['protocol'] == 'dart_go');
    assert(manifestJson['appName'] == 'dartnative_go');
    assert(manifestJson['hasIcon'] == true);
    assert(manifestJson['iconUrl'] != null);
    print('✔ /manifest.json passed: app=${manifestJson['appName']} icon=${manifestJson['iconUrl']}');

    // 3. Check /assets/icon.png
    final iconReq =
        await client.getUrl(Uri.parse('http://127.0.0.1:9120/assets/icon.png'));
    final iconRes = await iconReq.close();
    assert(iconRes.statusCode == HttpStatus.ok);
    final iconBytes = await iconRes.fold<List<int>>([], (a, b) => a..addAll(b));
    assert(iconBytes.isNotEmpty);
    print('✔ /assets/icon.png passed (${iconBytes.length} bytes)');

    // 4. Check /assets.json
    final assetsReq =
        await client.getUrl(Uri.parse('http://127.0.0.1:9120/assets.json'));
    final assetsRes = await assetsReq.close();
    assert(assetsRes.statusCode == HttpStatus.ok);
    final assetsBody = await assetsRes.transform(utf8.decoder).join();
    final assetsJson = jsonDecode(assetsBody);
    assert(assetsJson['assets'] is List);
    print('✔ /assets.json passed (${(assetsJson['assets'] as List).length} assets discovered)');

    // 5. Check direct asset serving /assets/dn-logo.png
    final logoReq = await client
        .getUrl(Uri.parse('http://127.0.0.1:9120/assets/dn-logo.png'));
    final logoRes = await logoReq.close();
    assert(logoRes.statusCode == HttpStatus.ok);
    assert(logoRes.headers.contentType?.mimeType == 'image/png');
    final logoBytes = await logoRes.fold<List<int>>([], (a, b) => a..addAll(b));
    assert(logoBytes.isNotEmpty);
    print('✔ /assets/dn-logo.png passed (${logoBytes.length} bytes, type=${logoRes.headers.contentType})');

    // 6. Check query-parameter asset serving /asset?path=assets/dn-logo.png
    final queryAssetReq = await client.getUrl(
        Uri.parse('http://127.0.0.1:9120/asset?path=assets/dn-logo.png'));
    final queryAssetRes = await queryAssetReq.close();
    assert(queryAssetRes.statusCode == HttpStatus.ok);
    assert(queryAssetRes.headers.contentType?.mimeType == 'image/png');
    print('✔ /asset?path=assets/dn-logo.png passed');

    // 7. Check /bundle.json
    final bundleReq =
        await client.getUrl(Uri.parse('http://127.0.0.1:9120/bundle.json'));
    final bundleRes = await bundleReq.close();
    assert(bundleRes.statusCode == HttpStatus.ok);
    final bundleBody = await bundleRes.transform(utf8.decoder).join();
    final bundleJson = jsonDecode(bundleBody);
    assert(bundleJson['files'] is Map);
    assert(bundleJson['manifest'] is Map);
    assert(bundleJson['assets'] is List);
    assert(bundleJson['manifest']['assets'] is List);
    print('✔ /bundle.json passed (${(bundleJson['files'] as Map).length} files, ${(bundleJson['assets'] as List).length} assets)');

    print('\n🎉 All Server Integration Tests Passed!');
  } finally {
    server.stop();
    client.close(force: true);
  }

  exit(0);
}
