/// In-memory fake dev server: HTTP manifest/bundle + WebSocket events.
///
/// Mirrors the endpoints of the real `DartGoServer`
/// (`lib/src/cli/server.dart`) that matter for client tests —
/// `/manifest.json`, `/bundle.json`, `/guest.ast`, `/health`, `/ws` —
/// without file watchers, UDP broadcast, or stdin handling.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Minimal fake of the `dart_go` dev server for `LiveConnection` tests.
class FakeDevServer {
  final Map<String, String> files;
  final String appName;
  final bool initialVerbose;

  /// AST bytes served at `/guest.ast` (null → 404). Mutable so tests can
  /// simulate a bundle that appears mid-retry, mirroring the real server's
  /// background initial build.
  List<int>? astBytes;

  /// Mirrors the real manifest's `astPending`: a bundle is still building.
  bool astPending;

  /// Generation fingerprint served as `X-Ast-Bundle` on `/guest.ast`.
  /// Null omits the header (an older server without lineage).
  String? bundleFp;

  /// Delta bytes served at `/guest.ast.patch` (null → 404). Mutable so
  /// tests can advance generations like consecutive rebuilds.
  List<int>? patchBytes;

  /// Base generation [patchBytes] was computed against. When non-null, a
  /// `?base=` mismatch is rejected with 404, mirroring the real server.
  String? patchBaseFp;

  /// Generation fingerprint served as `X-Ast-Bundle` on patch responses.
  String? patchBundleFp;

  HttpServer? _server;
  final List<WebSocket> _sockets = [];
  final List<Map<String, dynamic>> receivedLogs = [];
  final List<Map<String, dynamic>> receivedBreakpointHits = [];
  final List<Map<String, dynamic>> receivedVerboseToggles = [];

  FakeDevServer({
    this.files = const {'main.dart': "void main() {}"},
    this.appName = 'Fake App',
    this.astBytes,
    this.astPending = false,
    this.bundleFp,
    this.patchBytes,
    this.patchBaseFp,
    this.patchBundleFp,
    this.initialVerbose = false,
  });

  int get port => _server?.port ?? -1;
  String get baseUrl => 'http://127.0.0.1:$port';
  String get wsUrl => 'ws://127.0.0.1:$port/ws';

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(_handle);
  }

  Future<void> _handle(HttpRequest request) async {
    final path = request.uri.path;
    if (path == '/ws') {
      if (!WebSocketTransformer.isUpgradeRequest(request)) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Expected WebSocket upgrade')
          ..close();
        return;
      }
      final socket = await WebSocketTransformer.upgrade(request);
      _sockets.add(socket);
      socket.add(jsonEncode({
        'type': 'set_verbose',
        'enabled': initialVerbose,
      }));
      socket.listen(
        (message) {
          try {
            final data = jsonDecode(message as String);
            if (data is! Map<String, dynamic>) return;
            switch (data['type']) {
              case 'log':
                receivedLogs.add(data);
              case 'breakpoint_hit':
                receivedBreakpointHits.add(data);
              case 'set_verbose':
                receivedVerboseToggles.add(data);
              // UI automation relay: like the real `DartGoServer`, forward
              // probe/tap/hover/focus/blur/submit/type requests and
              // tree/action answers to every client so a test script and
              // its (simulated) device can talk through us.
              // `reload`/`restart` (test origin) pass through the same way.
              case 'ui_probe_request':
              case 'ui_tap':
              case 'ui_hover':
              case 'ui_focus':
              case 'ui_blur':
              case 'ui_submit':
              case 'ui_type':
              case 'ui_scroll':
              case 'ui_tree':
              case 'ui_tap_result':
              case 'ui_hover_result':
              case 'ui_focus_result':
              case 'ui_blur_result':
              case 'ui_submit_result':
              case 'ui_type_result':
              case 'ui_scroll_result':
              case 'reload':
              case 'restart':
                _broadcast(data);
            }
          } catch (_) {}
        },
        onDone: () => _sockets.remove(socket),
        onError: (_) => _sockets.remove(socket),
      );
      return;
    }

    request.response.headers.add('Access-Control-Allow-Origin', '*');
    switch (path) {
      case '/manifest.json':
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode({
          'protocol': 'dart_go',
          'appName': appName,
          'appVersion': '1.0.0',
          'serverUrl': baseUrl,
          'hasAstBundle': astBytes != null,
          'astPending': astPending,
        }));
        await request.response.close();
      case '/bundle.json':
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode({
          'manifest': {'appName': appName, 'appVersion': '1.0.0'},
          'files': files,
        }));
        await request.response.close();
      case '/guest.ast':
        if (astBytes != null) {
          final etag = '"${astBytes.hashCode}"';
          request.response.headers.set(HttpHeaders.etagHeader, etag);
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          request.response.headers.set('Access-Control-Expose-Headers', 'ETag');
          if (bundleFp != null && bundleFp!.isNotEmpty) {
            request.response.headers.set('X-Ast-Bundle', bundleFp!);
            request.response.headers.set(
                'Access-Control-Expose-Headers', 'ETag, X-Ast-Bundle');
          }
          final ifNoneMatch = request.headers.value(HttpHeaders.ifNoneMatchHeader)?.trim();
          if (ifNoneMatch != null && (ifNoneMatch == etag || ifNoneMatch == '${astBytes.hashCode}')) {
            request.response.statusCode = HttpStatus.notModified;
            await request.response.close();
            return;
          }
          request.response.headers.contentType =
              ContentType('application', 'octet-stream');
          request.response.add(astBytes!);
          await request.response.close();
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('No AST bundle');
          await request.response.close();
        }
      case '/guest.ast.patch':
        final patch = patchBytes;
        if (patch != null && patch.isNotEmpty) {
          final base = request.uri.queryParameters['base'];
          if (base != null &&
              patchBaseFp != null &&
              patchBaseFp!.isNotEmpty &&
              base != patchBaseFp) {
            request.response.statusCode = HttpStatus.notFound;
            request.response.write('Patch base mismatch; fetch full /guest.ast.');
            await request.response.close();
            return;
          }
          if (patchBundleFp != null && patchBundleFp!.isNotEmpty) {
            request.response.headers.set('X-Ast-Bundle', patchBundleFp!);
            request.response.headers.set(
                'Access-Control-Expose-Headers', 'X-Ast-Bundle');
          }
          request.response.headers.contentType =
              ContentType('application', 'octet-stream');
          request.response.add(patch);
          await request.response.close();
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('No active AST patch available.');
          await request.response.close();
        }
      case '/health':
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode({
          'status': 'ok',
          'protocol': 'dart_go',
          'appName': appName,
          'clients': _sockets.length,
        }));
        await request.response.close();
      default:
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('404 Not Found');
        await request.response.close();
    }
  }

  void _broadcast(Map<String, dynamic> data) {
    final payload = jsonEncode(data);
    for (final ws in List.of(_sockets)) {
      try {
        ws.add(payload);
      } catch (_) {}
    }
  }

  /// Emits a `reload` event like the real server's file-watcher broadcast.
  void emitReload([String? changedFile]) => _broadcast({
        'type': 'reload',
        'changedFile': changedFile,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

  /// Emits a `set_verbose` event like the server's `v` stdin command.
  void emitVerbose(bool enabled) => _broadcast({
        'type': 'set_verbose',
        'enabled': enabled,
      });

  /// Emits a `breakpoints` event.
  void emitBreakpoints(List<Map<String, dynamic>> breakpoints) => _broadcast({
        'type': 'breakpoints',
        'breakpoints': breakpoints,
      });

  /// Emits a `resume` event.
  void emitResume() => _broadcast({'type': 'resume'});

  /// Emits a `restart` event like a test-originated restart relay.
  void emitRestart() => _broadcast({
        'type': 'restart',
        'origin': 'test',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

  Future<void> stop() async {
    for (final ws in List.of(_sockets)) {
      try {
        await ws.close();
      } catch (_) {}
    }
    _sockets.clear();
    await _server?.close(force: true);
    _server = null;
  }
}
