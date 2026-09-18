import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final port = 8088;
  final guestDir = Directory('guest_app');
  final guestFile = File('guest_app/main.dart');

  if (!await guestFile.exists()) {
    print('Error: guest_app/main.dart not found.');
    exit(1);
  }

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('╔══════════════════════════════════════════════════════════╗');
  print('║             ⚡️ DartNative Go Dev Server ⚡️             ║');
  print('╠══════════════════════════════════════════════════════════╣');
  print('║  HTTP Bundle: http://localhost:$port/app.dart           ║');
  print('║  WebSocket:   ws://localhost:$port/ws                   ║');
  print('║  Watching:    guest_app/main.dart                        ║');
  print('╚══════════════════════════════════════════════════════════╝\n');

  final sockets = <WebSocket>[];

  // Watch for changes with debouncing
  Timer? debounceTimer;
  guestDir.watch(recursive: true).listen((event) {
    if (event.path.endsWith('.dart')) {
      debounceTimer?.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 150), () {
        print('[DevServer] 🔄 File change detected: ${event.path}. Broadcasting reload...');
        final payload = jsonEncode({
          'type': 'reload',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        for (final ws in sockets) {
          try {
            ws.add(payload);
          } catch (e) {
            // Socket disconnected
          }
        }
      });
    }
  });

  await for (final request in server) {
    if (request.uri.path == '/ws') {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final socket = await WebSocketTransformer.upgrade(request);
        sockets.add(socket);
        print('[DevServer] 📱 Client connected via WebSocket (${sockets.length} active)');
        socket.listen(
          (message) {
            print('[DevServer] Received message: $message');
          },
          onDone: () {
            sockets.remove(socket);
            print('[DevServer] 📱 Client disconnected (${sockets.length} active)');
          },
          onError: (e) {
            sockets.remove(socket);
          },
        );
      } else {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Expected WebSocket upgrade')
          ..close();
      }
    } else if (request.uri.path == '/bundle.json') {
      try {
        final bundle = <String, String>{};
        await for (final entity in guestDir.list(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            final relPath = entity.path
                .replaceFirst('${guestDir.path}/', '')
                .replaceAll(r'\', '/');
            bundle[relPath] = await entity.readAsString();
          }
        }
        final jsonStr = jsonEncode(bundle);
        request.response
          ..headers.contentType = ContentType.json
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(jsonStr)
          ..close();
        print('[DevServer] 📦 Served bundle.json (${bundle.length} files, ${jsonStr.length} bytes)');
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Error reading bundle: $e')
          ..close();
      }
    } else if (request.uri.path == '/app.dart') {
      try {
        final content = await guestFile.readAsString();
        request.response
          ..headers.contentType = ContentType('application', 'dart', charset: 'utf-8')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(content)
          ..close();
        print('[DevServer] 📦 Served guest_app/main.dart (${content.length} bytes)');
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Error reading guest_app/main.dart: $e')
          ..close();
      }
    } else if (request.uri.path == '/health') {
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'status': 'ok', 'clients': sockets.length}))
        ..close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('404 Not Found')
        ..close();
    }
  }
}
