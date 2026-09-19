import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/dartnative_plugin_registrant.dart';

import 'src/client/network_scanner.dart';
import 'src/client/project_model.dart';
import 'src/client/project_storage.dart';
import 'src/devtool/devtool_overlay.dart';
import 'src/runner/bundle_loader.dart';
import 'src/runner/interpreter_runner.dart';
import 'src/runner/live_connection.dart';
import 'src/widgets/interpreter_error_view.dart';
import 'src/widgets/project_splash_screen.dart';

void main(List<String> args) {
  DartNativePluginRegistrant.registerAll();

  runApp(const DartNativeGo());
}

class DartNativeGo extends StatefulWidget {
  const DartNativeGo({super.key});

  @override
  State<DartNativeGo> createState() => _DartNativeGoState();
}

class _DartNativeGoState extends State<DartNativeGo> {
  final DartGoNetworkScanner _scanner = DartGoNetworkScanner(
    storage: ProjectStorage(),
  );
  final TextEditingController _urlController = TextEditingController();
  List<DartGoProject> _projects = [];
  StreamSubscription? _scannerSub;
  bool _isLoading = true;

  // Active Runner & Guest App State
  bool _isAppMounted = false;
  bool _isLoadingBundle = false;
  String _statusMessage = 'Connecting to project...';
  String? _errorMessage;
  ProjectBundle? _activeBundle;
  Widget? _interpretedWidget;
  int _reloadGeneration = 0;

  final BundleLoader _bundleLoader = BundleLoader();
  late InterpreterRunner _interpreterRunner;
  LiveConnection? _liveConnection;

  @override
  void initState() {
    super.initState();
    _interpreterRunner = InterpreterRunner(
      onLog: (msg) => _liveConnection?.sendDeviceLog(msg),
      onExit: _unmountApp,
    );
    _initScanner();
  }

  Future<void> _initScanner() async {
    _scannerSub = _scanner.projectsStream.listen((projects) {
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      }
    });

    await _scanner.start();
    if (mounted) {
      setState(() {
        _projects = _scanner.currentProjects;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scannerSub?.cancel();
    _scanner.dispose();
    _urlController.dispose();
    _liveConnection?.disconnect();
    _bundleLoader.close();
    _interpreterRunner.unmount();
    super.dispose();
  }

  /// Launches a project given its server URL.
  Future<void> _launchProject(String rawUrl, {String? fallbackAppName}) async {
    final serverUrl = BundleLoader.normalizeUrl(rawUrl);
    setState(() {
      _isLoadingBundle = true;
      _errorMessage = null;
      _statusMessage = 'Connecting to dev server...';
      _activeBundle = ProjectBundle(
        appName: fallbackAppName ?? 'DartNative App',
        serverUrl: serverUrl,
        sources: const {},
        entrypointCode: '',
        entrypointLibrary: 'main.dart',
      );
    });

    try {
      setState(() {
        _statusMessage = 'Loading project manifest & bundle...';
      });

      // 1. Fetch manifest & multi-file bundle
      final bundle = await _bundleLoader.fetchBundle(serverUrl);
      if (!mounted) return;

      setState(() {
        _activeBundle = bundle;
        _statusMessage = 'Connecting live hot reload...';
      });

      // 2. Connect WebSocket for live hot reload and logs
      _liveConnection?.disconnect();
      _liveConnection = LiveConnection(
        serverUrl: bundle.serverUrl,
        onReload: (changed) => _reloadApp(changedFile: changed),
        onBreakpoints: (bps) {
          _interpreterRunner.debugController.setBreakpoints(bps);
          _reloadApp();
        },
        onResume: () {
          _interpreterRunner.debugController.resume();
        },
      );
      await _liveConnection!.connect();

      // 3. Compile and execute in the interpreter
      setState(() {
        _statusMessage = 'Compiling & mounting application...';
      });

      _interpreterRunner.currentServerUrl = bundle.serverUrl;
      _interpreterRunner.initInterpreter();
      final widget = _interpreterRunner.evaluate(
        source: bundle.entrypointCode,
        library: bundle.entrypointLibrary,
        sources: bundle.sources,
      );

      if (!mounted) return;
      setState(() {
        _interpretedWidget = widget;
        _isAppMounted = true;
        _isLoadingBundle = false;
        _reloadGeneration++;
      });
    } catch (e, stack) {
      final err = e.toString();
      print('🔴 [Interpreter Error] $err\n$stack');
      _liveConnection?.sendDeviceLog(
        '🔴 [Interpreter Error] $err',
        level: 'ERROR',
      );
      if (!mounted) return;
      setState(() {
        _isLoadingBundle = false;
        _isAppMounted = true;
        _errorMessage = err;
      });
    }
  }

  /// Re-evaluates updated code upon Hot Reload.
  Future<void> _reloadApp({String? changedFile}) async {
    if (_activeBundle == null) return;
    try {
      final updatedBundle = await _bundleLoader.fetchBundle(
        _activeBundle!.serverUrl,
      );
      if (!mounted) return;
      _activeBundle = updatedBundle;

      final widget = _interpreterRunner.evaluate(
        source: updatedBundle.entrypointCode,
        library: updatedBundle.entrypointLibrary,
        sources: updatedBundle.sources,
        isHotReload: true,
      );

      if (!mounted) return;
      setState(() {
        _interpretedWidget = widget;
        _reloadGeneration++;
        _errorMessage = null;
      });
    } catch (e, stack) {
      final err = 'Hot Reload Error: $e';
      print('🔴 [Hot Reload Error] $err\n$stack');
      _liveConnection?.sendDeviceLog(
        '🔴 [Hot Reload Error] $err',
        level: 'ERROR',
      );
      if (!mounted) return;
      setState(() {
        _errorMessage = err;
      });
    }
  }

  /// Unmounts the guest app and returns to the Go launcher screen.
  void _unmountApp() {
    _liveConnection?.disconnect();
    _liveConnection = null;
    _interpreterRunner.unmount();
    if (!mounted) return;
    setState(() {
      _isAppMounted = false;
      _isLoadingBundle = false;
      _interpretedWidget = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Loading state: Project Splash Screen while fetching bundle
    if (_isLoadingBundle) {
      return ProjectSplashScreen(
        appName: _activeBundle?.appName ?? 'DartNative App',
        splashUrl: _activeBundle?.splashUrl,
        iconUrl: _activeBundle?.iconUrl,
        backgroundColor: ProjectSplashScreen.parseHexColor(
          _activeBundle?.splashBackgroundColor,
        ),
        statusMessage: _statusMessage,
      );
    }

    // 2. Mounted state: Show guest app wrapped in DevToolOverlay (or error screen)
    if (_isAppMounted) {
      if (_errorMessage != null) {
        return InterpreterErrorView(
          errorMessage: _errorMessage!,
          onGoHome: _unmountApp,
          onRetry: () => _reloadApp(),
          onLogToTerminal: (error) {
            print('🔴 [Interpreter Error] $error');
            _liveConnection?.sendDeviceLog(
              '🔴 [Interpreter Error] $error',
              level: 'ERROR',
            );
          },
        );
      }

      return DevToolOverlay(
        appName: _activeBundle?.appName ?? 'DartNative App',
        appVersion: _activeBundle?.appVersion,
        serverUrl: _activeBundle?.serverUrl ?? '',
        isConnected: _liveConnection?.isConnected ?? false,
        onGoHome: _unmountApp,
        onReload: () => _reloadApp(),
        child: KeyedSubtree(
          key: ValueKey('guest_root_$_reloadGeneration'),
          child:
              _interpretedWidget ??
              const Scaffold(
                body: Center(child: Text('Evaluating widget...')),
              ),
        ),
      );
    }

    // 3. Default state: Launcher Screen
    return App(
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          actions: [
            BarButtonItem(
              fontIcon: CupertinoIcons.ellipsis,
              titleStyle: const TextStyle(color: Colors.white),
              menu: [
                MenuAction(
                  onTap: () {},
                  icon: CupertinoIcons.sun_max,
                  title: 'Change Theme',
                ),
                MenuAction(
                  onTap: () => _scanner.scanNow(),
                  icon: CupertinoIcons.arrow_clockwise,
                  title: 'Rescan Network',
                ),
              ],
            ),
          ],
          leading: Image.asset(
            'assets/dn-logo.png',
            width: 40,
            height: 40,
          ),
          title: Row(
            children: [
              const Text(
                'DartNative Go',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Development Servers",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter URL (e.g. 192.168.3.159:8088)',
                        filled: true,
                        fillColor: Color(0xFF0e1012),
                      ),
                      prefixIconPadding: const EdgeInsets.only(left: 10),
                      prefixIcon: CupertinoIcons.link,
                      prefixIconColor: Colors.white,
                      clearButtonMode: ClearButtonMode.whileEditing,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) async {
                        if (value.trim().isNotEmpty) {
                          final project = await _scanner.addManualProject(
                            value,
                          );
                          _urlController.clear();
                          _launchProject(
                            project.url,
                            fallbackAppName: project.appName,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Projects",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_projects.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _isLoading
                            ? "Scanning connected networks (8088..8098)..."
                            : "No active or recent projects found.",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white38,
                        ),
                      ),
                    )
                  else
                    ..._projects.map(
                      (project) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            print(
                              '[DartNativeGo] Selected project from list: ${project.appName} (${project.url})',
                            );
                            _urlController.text = project.url;
                            _launchProject(
                              project.url,
                              fallbackAppName: project.appName,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0e1012),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/dn-logo.png',
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            project.appName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        project.url,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (project.isActive)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF34C759),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book_fill),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear_alt_fill),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
