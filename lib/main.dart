import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tom_d4rt/tom_d4rt.dart';
import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';
import 'src/interpreter/dn_bridge.dart';

void main() {
  // Platform bindings + FFI symbols
  DartNativePluginRegistrant.registerAll();

  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  runApp(const DartNativeGoShell());
}

/// The top-level DartNative Go shell application
class DartNativeGoShell extends StatefulWidget {
  const DartNativeGoShell({super.key});

  @override
  State<DartNativeGoShell> createState() => _DartNativeGoShellState();
}

class _DartNativeGoShellState extends State<DartNativeGoShell> {
  // Application mounting state
  bool _isAppMounted = false;
  int _counter = 0;
  int _scriptVersion = 1;
  bool _isLiveDevMode = false;
  String _liveScriptSource = '';
  WebSocket? _devSocket;
  String? _launcherNotice;

  late D4rt _interpreter;
  Widget? _interpretedWidget;
  String? _errorMessage;

  // -------------------------------------------------------------
  // Script Version 1: Standard Light Theme Counter
  // -------------------------------------------------------------
  static const String _counterScriptV1 = '''
import 'package:dartnative/dartnative.dart';

buildUI(int count, VoidCallback onInc, VoidCallback onDec, VoidCallback onReset, VoidCallback onHotReload, VoidCallback onExit) {
  return Scaffold(
    key: ValueKey('counter_screen_v1'),
    brightness: Brightness.light,
    appBar: AppBar(
      ios: AppBarIOSConfig(systemBar: false),
      backgroundColor: Color(0xFFFFFFFF),
      title: Text(
        'Counter App (v1)',
        style: TextStyle(
          color: Color(0xFF111111),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Button(
          title: '🔥 Hot Reload',
          variant: ButtonVariant.filled,
          color: Color(0xFFFF9500),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          onPressed: onHotReload,
        ),
        SizedBox(width: 8),
        Button(
          title: '✕ Exit',
          variant: ButtonVariant.plain,
          foregroundColor: Color(0xFF888888),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          onPressed: onExit,
        ),
        SizedBox(width: 8),
      ],
    ),
    backgroundColor: Color(0xFFF7F7F8),
    body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: Color(0xFFE8F2FF),
            child: Text(
              '📦 Interpreted Runtime • Version 1.0',
              style: TextStyle(
                color: Color(0xFF0066EE),
                fontSize: 12,
                fontWeight: FontWeight.semiBold,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            '\$count',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Current Count Value',
            style: TextStyle(
              color: Color(0xFF88888E),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                title: '➖ Decrement',
                variant: ButtonVariant.bordered,
                color: Color(0xFFFFFFFF),
                foregroundColor: Color(0xFF111111),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                onPressed: onDec,
              ),
              SizedBox(width: 14),
              Button(
                title: '➕ Increment',
                variant: ButtonVariant.filled,
                color: Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                onPressed: onInc,
              ),
            ],
          ),
          SizedBox(height: 16),
          Button(
            title: 'Reset to 0',
            variant: ButtonVariant.plain,
            foregroundColor: Color(0xFFFF3B30),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: onReset,
          ),
        ],
      ),
    ),
  );
}
''';

  // -------------------------------------------------------------
  // Script Version 2: Hot Reloaded Dark/Cyan Theme (Step ±5)
  // -------------------------------------------------------------
  static const String _counterScriptV2 = '''
import 'package:dartnative/dartnative.dart';

buildUI(int count, VoidCallback onInc, VoidCallback onDec, VoidCallback onReset, VoidCallback onHotReload, VoidCallback onExit) {
  return Scaffold(
    key: ValueKey('counter_screen_v2'),
    brightness: Brightness.dark,
    appBar: AppBar(
      ios: AppBarIOSConfig(systemBar: false),
      backgroundColor: Color(0xFF16161A),
      title: Text(
        'Counter v2 (🔥 Reloaded!)',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Button(
          title: '🔥 Reload v1',
          variant: ButtonVariant.filled,
          color: Color(0xFFFF9500),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          onPressed: onHotReload,
        ),
        SizedBox(width: 8),
        Button(
          title: '✕ Exit',
          variant: ButtonVariant.plain,
          foregroundColor: Color(0xFF999999),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          onPressed: onExit,
        ),
        SizedBox(width: 8),
      ],
    ),
    backgroundColor: Color(0xFF16161A),
    body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: Color(0xFF231E10),
            child: Text(
              '🔥 Hot Reloaded • Step is ±5 • State Preserved!',
              style: TextStyle(
                color: Color(0xFFFF9F0A),
                fontSize: 12,
                fontWeight: FontWeight.semiBold,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            '\$count',
            style: TextStyle(
              color: Color(0xFF00D2FF),
              fontSize: 78,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Preserved Counter State across Code Reload',
            style: TextStyle(
              color: Color(0xFF9E9EA6),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                title: '➖ (-5)',
                variant: ButtonVariant.bordered,
                color: Color(0xFF24242A),
                foregroundColor: Color(0xFFFFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                onPressed: onDec,
              ),
              SizedBox(width: 14),
              Button(
                title: '➕ (+5)',
                variant: ButtonVariant.filled,
                color: Color(0xFF00D2FF),
                foregroundColor: Color(0xFF000000),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                onPressed: onInc,
              ),
            ],
          ),
          SizedBox(height: 16),
          Button(
            title: 'Reset to 0',
            variant: ButtonVariant.plain,
            foregroundColor: Color(0xFFFF453A),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: onReset,
          ),
        ],
      ),
    ),
  );
}
''';

  @override
  void initState() {
    super.initState();
    _initInterpreter();
  }

  void _initInterpreter() {
    _interpreter = D4rt();
    registerDartNativeBridges(_interpreter);
    _interpreter.registertopLevelFunction(
      'exitToLauncher',
      (visitor, positional, named, typeArgs) {
        _unmountApp();
        return null;
      },
      'package:dartnative/dartnative.dart',
      signature: 'void exitToLauncher()',
    );
  }

  /// Mounts the local embedded counter demo
  void _mountApp() {
    _devSocket?.close();
    _devSocket = null;
    setState(() {
      _isAppMounted = true;
      _isLiveDevMode = false;
      _counter = 0;
      _scriptVersion = 1;
      _errorMessage = null;
      _launcherNotice = null;
    });
    _evaluateInterpretedUI();
  }

  /// Connects to the Live Dev Server at localhost:8088
  Future<void> _mountLiveApp() async {
    setState(() {
      _launcherNotice = 'Connecting to dev server at http://localhost:8088/app.dart...';
    });

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final request = await client.getUrl(Uri.parse('http://localhost:8088/app.dart'));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Server returned HTTP ${response.statusCode}');
      }
      final source = await response.transform(utf8.decoder).join();
      _liveScriptSource = source;

      // Connect WebSocket for automated Hot Reload
      try {
        _devSocket?.close();
        final ws = await WebSocket.connect('ws://localhost:8088/ws').timeout(const Duration(seconds: 3));
        _devSocket = ws;
        ws.listen(
          (message) async {
            try {
              final data = jsonDecode(message as String);
              if (data['type'] == 'reload') {
                print('[DartNative Go] 🔄 DevServer triggered Live Hot Reload!');
                final reloadReq = await client.getUrl(Uri.parse('http://localhost:8088/app.dart'));
                final reloadRes = await reloadReq.close();
                if (reloadRes.statusCode == HttpStatus.ok) {
                  _liveScriptSource = await reloadRes.transform(utf8.decoder).join();
                  _evaluateInterpretedUI();
                }
              }
            } catch (e) {
              print('[DartNative Go] Live reload update error: $e');
            }
          },
          onDone: () {
            print('[DartNative Go] Dev server WebSocket closed');
          },
        );
      } catch (e) {
        print('[DartNative Go] WebSocket connection failed (HTTP bundle loaded): $e');
      }

      setState(() {
        _isAppMounted = true;
        _isLiveDevMode = true;
        _counter = 0;
        _errorMessage = null;
        _launcherNotice = null;
      });
      _evaluateInterpretedUI();
    } catch (e) {
      print('[DartNative Go] Dev server connect error: $e');
      setState(() {
        _launcherNotice = 'Could not connect to Dev Server on localhost:8088.\nStart it with:\ndart run tool/dev_server.dart';
      });
    }
  }

  /// Unmounts the app and returns to the Go Launcher screen
  void _unmountApp() {
    _devSocket?.close();
    _devSocket = null;
    setState(() {
      _isAppMounted = false;
      _isLiveDevMode = false;
      _interpretedWidget = null;
      _errorMessage = null;
    });
  }

  /// Evaluates the active script with current counter state & callbacks
  void _evaluateInterpretedUI() {
    try {
      final currentScript = _isLiveDevMode
          ? _liveScriptSource
          : (_scriptVersion == 1 ? _counterScriptV1 : _counterScriptV2);
      final step = _isLiveDevMode ? 1 : (_scriptVersion == 1 ? 1 : 5);

      final Object? rawResult;
      if (currentScript.contains(RegExp(r'\bmain\s*\('))) {
        rawResult = _interpreter.execute(
          source: currentScript,
          name: 'main',
        );
      } else {
        // Pass the current state & action callbacks directly to the interpreted entrypoint
        rawResult = _interpreter.execute(
          source: currentScript,
          name: 'buildUI',
          positionalArgs: [
            _counter,
            () {
              setState(() {
                _counter += step;
              });
              _evaluateInterpretedUI();
            },
            () {
              setState(() {
                _counter -= step;
              });
              _evaluateInterpretedUI();
            },
            () {
              setState(() {
                _counter = 0;
              });
              _evaluateInterpretedUI();
            },
            () {
              if (!_isLiveDevMode) {
                _triggerHotReload();
              }
            },
            () {
              _unmountApp();
            },
          ],
        );
      }

      final widget = unwrap<Widget>(rawResult);
      setState(() {
        _interpretedWidget = widget;
        _errorMessage = null;
      });
    } catch (e, st) {
      print('[DartNative Go Evaluation Error]: $e\n$st');
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  /// Simulates Hot Reload by switching to updated code while preserving state
  void _triggerHotReload() {
    print(
      '[DartNative Go] Triggering Hot Reload. Preserving counter: $_counter',
    );
    setState(() {
      _scriptVersion = _scriptVersion == 1 ? 2 : 1;
    });
    _evaluateInterpretedUI();
  }

  @override
  Widget build(BuildContext context) {
    // 1. If an interpreted app is mounted, display it directly
    if (_isAppMounted) {
      if (_errorMessage != null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Interpreter Error')),
          body: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Evaluation Error:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Button(
                  title: 'Back to Launcher',
                  variant: ButtonVariant.bordered,
                  onPressed: _unmountApp,
                ),
              ],
            ),
          ),
        );
      }

      return _interpretedWidget ??
          const Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Text('Evaluating widget...'),
            ),
          );
    }

    // 2. Default state: DartNative Go Launcher screen (unmounted)
    return _buildLauncherScreen();
  }

  /// The DartNative Go Launcher Screen (Unmounted State)
  Widget _buildLauncherScreen() {
    return Scaffold(
      key: const ValueKey('launcher_screen'),
      brightness: Brightness.light,
      appBar: AppBar(
        ios: const AppBarIOSConfig(systemBar: false),
        title: const Text(
          'DartNative Go',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F7),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '⚡️ DartNative Go',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dynamic AST Runtime Sandbox',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFFFFFFF),
              child: Column(
                children: const [
                  Text(
                    'Ready to Mount Project',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Target: Counter App Demo\nEngine: tom_d4rt + Automated Bridges (Modular AST)\nState: Unmounted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B6B70),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_launcherNotice != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFFFFF4E5),
                child: Text(
                  _launcherNotice!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB25E00),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Button(
              title: '⚡️ Connect to Live Dev Server (localhost:8088)',
              variant: ButtonVariant.filled,
              color: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              onPressed: _mountLiveApp,
            ),
            const SizedBox(height: 12),
            Button(
              title: '🚀 Launch Embedded Demo (v1 ⇄ v2)',
              variant: ButtonVariant.bordered,
              color: const Color(0xFFFFFFFF),
              foregroundColor: const Color(0xFF111111),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onPressed: _mountApp,
            ),
            const SizedBox(height: 16),
            const Text(
              'Real-time interpreted hot reload powered by tom_d4rt',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
