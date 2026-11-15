import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dio/dio.dart';

/// Live demo for the pure-Dart `dio` HTTP client, run **headlessly** through
/// the DartNative AST interpreter — dio is *not* bridged, so every HTTP call
/// here is dio's own Dart code executing under `tom_d4rt_ast`.
///
/// The app starts a loopback [HttpServer] on a random port, so the whole
/// feature sweep is deterministic and needs no external network. A couple of
/// buttons also hit real public endpoints to confirm the live path.
class DioDemo extends StatefulWidget {
  const DioDemo({super.key});

  @override
  State<DioDemo> createState() => _DioDemoState();
}

class _DioDemoState extends State<DioDemo> {
  HttpServer? _server;
  int _port = 0;
  late Dio _dio;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _server?.close(force: true);
    super.dispose();
  }

  Future<void> _boot() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    if (!mounted) {
      await server.close(force: true);
      return;
    }
    _server = server;
    _port = server.port;
    _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:$_port'));
    server.listen(_handle);
    _log.add('loopback server on 127.0.0.1:$_port');
    setState(() {});
    print('[dio-demo] loopback server on 127.0.0.1:$_port');

    // The sweep is NOT run on open: each check drives a full dio round trip
    // through the interpreter, which is slow enough on-device that running all
    // eighteen at once makes the screen look frozen. The checks are one tap
    // away instead ("Run all checks" below, or any individual feature button).
  }

  // ---------------------------------------------------------------------------
  // Loopback endpoints
  // ---------------------------------------------------------------------------

  Future<void> _handle(HttpRequest req) async {
    final r = req.response;
    try {
      final path = req.uri.path;
      switch (path) {
        case '/json':
          r.headers.contentType = ContentType.json;
          r.write(
            '{"hello":"loopback","n":${req.uri.queryParameters['n'] ?? 0}}',
          );
          break;
        case '/echo-query':
          r.headers.contentType = ContentType.json;
          r.write(jsonEncode(req.uri.queryParameters));
          break;
        case '/echo-headers':
          r.headers.contentType = ContentType.json;
          r.write(
            jsonEncode(<String, dynamic>{
              'x-custom': req.headers.value('x-custom'),
              'accept': req.headers.value('accept'),
            }),
          );
          break;
        case '/echo-json':
          final body = await utf8.decoder.bind(req).join();
          r.headers.contentType = ContentType.json;
          r.write('{"received":$body}');
          break;
        case '/upload':
          final contentType = req.headers.contentType?.mimeType;
          final bytes = await req.fold<int>(0, (n, b) => n + b.length);
          r.headers.contentType = ContentType.json;
          r.write(jsonEncode({'contentType': contentType, 'bytes': bytes}));
          break;
        case '/plain':
          r.headers.contentType = ContentType.text;
          r.write('plain-text-body');
          break;
        case '/bytes':
          r.headers.contentType = ContentType.binary;
          r.add(<int>[1, 2, 3, 4, 5]);
          break;
        case '/slow':
          await Future<void>.delayed(const Duration(seconds: 3));
          r.headers.contentType = ContentType.json;
          r.write('{"slow":true}');
          break;
        case '/status/500':
          r.statusCode = 500;
          r.headers.contentType = ContentType.json;
          r.write('{"error":"boom"}');
          break;
        case '/redirect':
          r.statusCode = 302;
          r.headers.set(
            HttpHeaders.locationHeader,
            'http://127.0.0.1:$_port/json',
          );
          break;
        default:
          r.statusCode = 404;
          r.write('nope');
      }
    } finally {
      await r.close();
    }
  }

  // ---------------------------------------------------------------------------
  // Demo plumbing
  // ---------------------------------------------------------------------------

  void _reset() {
    if (_log.isNotEmpty) _log.clear();
  }

  Future<void> _pass(String label, Object? detail) async {
    _log.insert(0, 'PASS  $label  →  $detail');
    if (_log.length > 40) _log.removeLast();
    print('[dio-demo] PASS  $label  →  $detail');
    setState(() {});
  }

  Future<void> _fail(String label, Object error) async {
    _log.insert(0, 'FAIL  $label  →  ${error.runtimeType}: $error');
    if (_log.length > 40) _log.removeLast();
    print('[dio-demo] FAIL  $label  →  ${error.runtimeType}: $error');
    setState(() {});
  }

  Future<void> _run(String label, Future<String> Function() body) async {
    final started = DateTime.now();
    print('[dio-demo] >> $label');
    try {
      final detail = await body();
      final ms = DateTime.now().difference(started).inMilliseconds;
      await _pass('$label [${ms}ms]', detail);
    } catch (e) {
      final ms = DateTime.now().difference(started).inMilliseconds;
      await _fail('$label [${ms}ms]', e);
    }
  }

  String _summarize(Object? data) {
    if (data is Map) return '{${data.keys.take(3).join(', ')}}';
    if (data is List) return '[${data.length} items]';
    return '$data';
  }

  // ---------------------------------------------------------------------------
  // Feature checks
  // ---------------------------------------------------------------------------

  Future<void> _getJson() => _run('GET json (auto-decode)', () async {
    final res = await _dio.get('/json');
    final hello = (res.data as Map)['hello'];
    return '${res.statusCode} hello=$hello';
  });

  Future<void> _queryParams() => _run('Query parameters', () async {
    final res = await _dio.get(
      '/echo-query',
      queryParameters: <String, dynamic>{'a': 1, 'b': 'two words'},
    );
    return '${res.data}';
  });

  Future<void> _headers() => _run('Request headers', () async {
    final res = await _dio.get(
      '/echo-headers',
      options: Options(headers: <String, dynamic>{'x-custom': 'demo'}),
    );
    return 'x-custom=${(res.data as Map)['x-custom']}';
  });

  Future<void> _postJson() => _run('POST JSON body', () async {
    final res = await _dio.post(
      '/echo-json',
      data: <String, dynamic>{'k': 'v'},
    );
    return '${(res.data as Map)['received']}';
  });

  Future<void> _formData() => _run('FormData (multipart field)', () async {
    final form = FormData.fromMap(<String, dynamic>{
      'field1': 'value1',
      'field2': 42,
    });
    final res = await _dio.post('/upload', data: form);
    return '${res.data}';
  });

  Future<void> _multipartFile() => _run('MultipartFile upload', () async {
    final form = FormData.fromMap(<String, dynamic>{
      'name': 'demo',
      'file': MultipartFile.fromBytes(
        <int>[104, 105, 33],
        filename: 'hi.txt',
      ),
    });
    final res = await _dio.post('/upload', data: form);
    return '${res.data}';
  });

  Future<void> _plain() => _run('ResponseType.plain', () async {
    final res = await _dio.get(
      '/plain',
      options: Options(responseType: ResponseType.plain),
    );
    return '${res.data.runtimeType} ${res.data}';
  });

  Future<void> _bytes() => _run('ResponseType.bytes', () async {
    final res = await _dio.get(
      '/bytes',
      options: Options(responseType: ResponseType.bytes),
    );
    final list = res.data as List;
    return '${res.data.runtimeType} len=${list.length}';
  });

  Future<void> _stream() => _run('ResponseType.stream', () async {
    final res = await _dio.get(
      '/plain',
      options: Options(responseType: ResponseType.stream),
    );
    final body = res.data as ResponseBody;
    final bytes = await body.stream.fold<List<int>>(
      <int>[],
      (acc, chunk) => acc..addAll(chunk),
    );
    return 'stream bytes=${bytes.length}';
  });

  Future<void> _validateStatus() => _run('validateStatus', () async {
    final res = await _dio.get(
      '/status/500',
      options: Options(validateStatus: (s) => s != null && s < 600),
    );
    return '${res.statusCode} ${res.data}';
  });

  Future<void> _badResponse() => _run('Error → badResponse', () async {
    try {
      await _dio.get('/status/500');
      return 'no throw!';
    } on DioException catch (e) {
      return 'type=${e.type} status=${e.response?.statusCode} data=${e.response?.data}';
    }
  });

  Future<void> _interceptors() => _run('Interceptors', () async {
    final client = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:$_port'));
    final events = <String>[];
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          events.add('req');
          options.headers['x-custom'] = 'from-interceptor';
          handler.next(options);
        },
        onResponse: (response, handler) {
          events.add('res');
          response.data = <String, dynamic>{'wrapped': response.data};
          handler.next(response);
        },
        onError: (error, handler) {
          events.add('err');
          handler.next(error);
        },
      ),
    );
    final res = await client.get('/echo-headers');
    return 'events=${events.join("+")} data=${_summarize(res.data)}';
  });

  Future<void> _interceptorError() => _run('Interceptor onError', () async {
    final client = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:$_port'));
    String seen = '';
    client.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          seen = '${error.type}@${error.response?.statusCode}';
          handler.next(error);
        },
      ),
    );
    try {
      await client.get('/status/500');
    } on DioException catch (e) {
      return 'seen=$seen final=${e.type}';
    }
    return 'no throw!';
  });

  Future<void> _receiveTimeout() => _run('receiveTimeout', () async {
    final client = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:$_port',
        receiveTimeout: const Duration(milliseconds: 500),
      ),
    );
    try {
      await client.get('/slow');
      return 'no throw!';
    } on DioException catch (e) {
      return 'type=${e.type}';
    }
  });

  Future<void> _cancelToken() => _run('CancelToken', () async {
    final token = CancelToken();
    final future = _dio.get('/slow', cancelToken: token);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    token.cancel('user cancelled');
    try {
      await future;
      return 'no throw!';
    } on DioException catch (e) {
      return 'type=${e.type}';
    }
  });

  Future<void> _download() => _run('download to file', () async {
    final out = '${Directory.systemTemp.path}/dio_demo_download.json';
    final res = await _dio.download('/json', out);
    final text = await File(out).readAsString();
    return '${res.statusCode} file=$text';
  });

  Future<void> _fetch() => _run('fetch()', () async {
    final res = await _dio.fetch<String>(
      RequestOptions(path: '/json', baseUrl: 'http://127.0.0.1:$_port'),
    );
    return '${res.statusCode} ${res.data}';
  });

  Future<void> _redirect() => _run('Redirect follow', () async {
    final res = await _dio.get('/redirect');
    return '${res.statusCode} redirects=${res.redirects.length} data=${_summarize(res.data)}';
  });

  Future<void> _runAll() async {
    _reset();
    setState(() {});
    await _getJson();
    await _queryParams();
    await _headers();
    await _postJson();
    await _formData();
    await _multipartFile();
    await _plain();
    await _bytes();
    await _stream();
    await _validateStatus();
    await _badResponse();
    await _interceptors();
    await _interceptorError();
    await _receiveTimeout();
    await _cancelToken();
    await _download();
    await _fetch();
    await _redirect();

    final passed = _log.where((line) => line.startsWith('PASS')).length;
    final failed = _log.where((line) => line.startsWith('FAIL')).length;
    print('[dio-demo] SUMMARY passed=$passed failed=$failed');
  }

  Future<void> _liveGet() => _run('LIVE https://dio.js.org/', () async {
    final client = Dio();
    final res = await client.get<String>('https://dio.js.org/');
    return '${res.statusCode} bytes=${res.data?.length}';
  });

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'dio (headless)',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const _Section('Interpreter headless dio'),
          Text(
            _port == 0
                ? 'starting loopback server…'
                : 'loopback server on 127.0.0.1:$_port',
            style: const TextStyle(color: Color(0xFF636366), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Button(
            title: 'Run all checks',
            variant: ButtonVariant.filled,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            onPressed: _runAll,
          ),
          const SizedBox(height: 8),
          const _Hint(
            'dio is pure Dart served to the interpreter (no native bridge). '
            'Every check below drives dio end-to-end over a loopback '
            'HttpServer started inside the app.',
          ),
          const SizedBox(height: 24),
          const _Section('Live network'),
          Button(
            title: 'LIVE GET https://dio.js.org/',
            variant: ButtonVariant.filled,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            onPressed: _liveGet,
          ),
          const SizedBox(height: 24),
          const _Section('Individual features'),
          ..._features(),
          const SizedBox(height: 24),
          const _Section('Log'),
          if (_log.isEmpty)
            const _Hint('No runs yet. Tap "Run all checks".')
          else
            ..._log.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: TextStyle(
                    color: line.startsWith('FAIL')
                        ? const Color(0xFFD0021B)
                        : const Color(0xFF1E9E4A),
                    fontSize: 12,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _features() {
    final entries = <List<Object>>[
      <Object>['GET json', _getJson],
      <Object>['Query parameters', _queryParams],
      <Object>['Request headers', _headers],
      <Object>['POST JSON', _postJson],
      <Object>['FormData', _formData],
      <Object>['MultipartFile', _multipartFile],
      <Object>['ResponseType.plain', _plain],
      <Object>['ResponseType.bytes', _bytes],
      <Object>['ResponseType.stream', _stream],
      <Object>['validateStatus', _validateStatus],
      <Object>['Error → badResponse', _badResponse],
      <Object>['Interceptors', _interceptors],
      <Object>['Interceptor onError', _interceptorError],
      <Object>['receiveTimeout', _receiveTimeout],
      <Object>['CancelToken', _cancelToken],
      <Object>['download', _download],
      <Object>['fetch()', _fetch],
      <Object>['Redirect', _redirect],
    ];
    return <Widget>[
      for (final entry in entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Button(
            title: entry[0] as String,
            variant: ButtonVariant.bordered,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onPressed: entry[1] as Future<void> Function(),
          ),
        ),
    ];
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF636366),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 13),
    ),
  );
}
