import 'dart:io';

import 'package:dartnative_go/src/cli/commands/command_line.dart';
import 'package:dartnative_go/src/cli/diagnostics/asset_detector.dart';
import 'package:dartnative_go/src/cli/diagnostics/icon_font_detector.dart';
import 'package:dartnative_go/src/cli/diagnostics/pubspec_validator.dart';
import 'package:dartnative_go/src/cli/diagnostics/version_info.dart';
import 'package:dartnative_go/src/cli/server/dev_socket_hub.dart';
import 'package:dartnative_go/src/cli/server/terminal_ui.dart';
import 'package:dartnative_go/src/runner/bundle_loader.dart';
import 'package:dartnative_go/src/runner/live_connection.dart';
import 'package:dartnative_go/src/runner/logger.dart';
import 'package:test/test.dart';

StartupScreenInfo _sampleStartupInfo({
  bool verbose = false,
  bool devLogs = false,
  bool enableQrCode = true,
  List<String> unsupported = const [
    'dartnative_skia',
    'dartnative_firebase',
    'dartnative_camera',
  ],
}) {
  return StartupScreenInfo(
    projectPath: '/Users/dev/playground',
    serverUrl: 'http://172.20.10.3:8088',
    deepLink:
        'dartnativego://open?url=http%3A%2F%2F172.20.10.3%3A8088&name=playground',
    validation: PubspecValidationResult(
      appName: 'playground',
      packageName: 'playground',
      appVersion: '0.1.0+1',
      validSupportedPlugins: const {
        'dartnative': '^1.0.0',
        'dartnative_sqlite': '^1.0.0',
      },
      versionMismatches: const [],
      unsupportedNativePlugins: unsupported,
      pureDartDependencies: const [],
      hasPubspec: true,
    ),
    assets: ProjectAssets(
      iconFile: File('/dev/null'),
      iconPath: 'assets/apple-logo.png',
      splashFile: File('/dev/null'),
      splashPath: 'assets/dn-logo.png',
      splashBackgroundColor: '#000000',
    ),
    iconFonts: const IconFontReport(
      glyphsByFamily: {
        'CupertinoIcons': {'home', 'play', 'search'},
        'Material Symbols Rounded': {'settings'},
        'Courier': {},
        r'Figtree-$weight': {},
      },
      customFonts: [
        CustomFontDecl(
          family: 'Figtree-Regular',
          asset: 'assets/fonts/Figtree-Regular.ttf',
        ),
        CustomFontDecl(
          family: 'Figtree-Bold',
          asset: 'assets/fonts/Figtree-Bold.ttf',
        ),
      ],
    ),
    versions: const DngoVersionInfo(
      dngoVersion: '0.1.0',
      dartNativeVersion: '1.8.0',
      runtimeVersion: '0.1.0',
    ),
    rebuildAst: true,
    enableQrCode: enableQrCode,
    verbose: verbose,
    devLogs: devLogs,
  );
}

void main() {
  setUp(() {
    DartGoLogger.verbose = false;
    DartGoLogger.devLogs = false;
  });

  group('formatStartupScreen', () {
    test('normal mode shows project path first, loading URL only, and key shortcuts', () {
      final out = formatStartupScreen(
        _sampleStartupInfo(verbose: false),
        useColor: false,
      );
      final lines = out.split('\n');
      expect(lines[0], matches(RegExp(r'^=+$')));
      expect(lines[1], equals('Starting project: /Users/dev/playground'));
      expect(lines[2], contains('playground (0.1.0+1)'));
      expect(lines[2], contains('dngo v0.1.0'));
      expect(lines[2], contains('DartNative v1.8.0'));
      expect(lines[3], matches(RegExp(r'^=+$')));

      final colored = formatStartupScreen(
        _sampleStartupInfo(verbose: false),
        useColor: true,
      );
      expect(colored, contains('\x1B[36m\x1B[1mStarting project:\x1B[0m'));
      expect(colored, contains('\x1B[32mdngo v0.1.0\x1B[0m'));

      // Single connect URL matches QR code (/_dngo/loading).
      expect(out, contains('http://172.20.10.3:8088/_dngo/loading'));
      expect(out, isNot(contains('ws://172.20.10.3:8088/ws')));
      expect(out, isNot(contains('dartnativego://open')));
      expect(out, isNot(contains('Assets & Fonts')));
      expect(out, isNot(contains('AST watch')));

      // Compact warning when unsupported plugins exist.
      expect(out, contains('3 unsupported native plugins (press v for details)'));

      // Essential shortcuts only; q / c live under `h`.
      expect(out, contains('› Press r │ hot reload'));
      expect(out, contains('› Press R │ hot restart'));
      expect(out, contains('› Press v │ verbose'));
      expect(out, contains('› Press h │ more commands'));
      expect(out, isNot(contains('show QR code')));
      expect(out, isNot(contains('clear screen')));

      // Expo-style prompt & Local URL sit directly below the QR code.
      final lastQrIdx = out.lastIndexOf('▀');
      expect(
        out.indexOf('› Scan the QR code above to open in DartNative Go.'),
        greaterThan(lastQrIdx),
      );
      expect(
        out.indexOf('› Local: http://172.20.10.3:8088/_dngo/loading'),
        greaterThan(lastQrIdx),
      );
      expect(out.indexOf('› Press r │ hot reload'), greaterThan(lastQrIdx));
    });

    test('omits QR code and scan prompt when enableQrCode is false', () {
      final out = formatStartupScreen(
        _sampleStartupInfo(verbose: false, enableQrCode: false),
        useColor: false,
      );
      expect(out, contains('Starting project: /Users/dev/playground'));
      expect(out, contains('› Local: http://172.20.10.3:8088/_dngo/loading'));
      expect(out, isNot(contains('Scan the QR code above')));
      expect(out, isNot(contains('█')));
    });

    test('verbose mode reveals endpoints, plugins tree, and filtered fonts', () {
      final out = formatStartupScreen(
        _sampleStartupInfo(verbose: true, enableQrCode: false),
        useColor: false,
      );
      expect(out, contains('[VERBOSE]'));
      expect(out, contains('› Server:    http://172.20.10.3:8088'));
      expect(out, contains('› WebSocket: ws://172.20.10.3:8088/ws'));
      expect(out, contains('› Deep link: dartnativego://open'));
      expect(out, contains('› AST watch: on (rebuild on save)'));

      expect(out, contains('Plugins'));
      expect(out, contains('✓ 2 supported'));
      expect(out, contains('✖ 3 unsupported'));
      expect(out, contains('skia, firebase, camera'));

      expect(out, contains('Assets & Fonts'));
      expect(out, contains('CupertinoIcons (3)'));
      expect(out, contains('Material Symbols Rounded (1)'));
      expect(out, contains('Figtree (Regular, Bold)'));
      // 0-glyph noise is omitted.
      expect(out, isNot(contains('Courier')));
      expect(out, isNot(contains(r'Figtree-$weight')));
    });

    test('emits ANSI action colors when useColor is enabled', () {
      final header = formatHotReloadHeader(
        changedFiles: const ['lib/main.dart'],
        useColor: true,
      );
      expect(header, contains('\x1B[36m↻\x1B[0m'));
      final restart = formatHotRestartHeader(useColor: true);
      expect(restart, contains('\x1B[35m⟳\x1B[0m'));
      final bundled = formatBundledResult(
        elapsedMs: 412,
        moduleCount: 93,
        byteSize: 1795063,
        useColor: true,
      );
      expect(bundled, contains('\x1B[32m✓\x1B[0m'));
    });

    test('bundling spinner animates across frames and includes elapsed time', () {
      final frame0 = formatBundlingStatus(frameIndex: 0, useColor: false);
      final frame1 = formatBundlingStatus(
        frameIndex: 1,
        elapsedMs: 350,
        useColor: false,
      );
      expect(frame0, equals('⠋ Bundling guest.ast…'));
      expect(frame1, equals('⠙ Bundling guest.ast… 0.3s'));
      expect(frame0[0], isNot(equals(frame1[0])));

      final launchPending = formatPendingBranch(
        label: 'launch',
        actionText: 'launching…',
        frameIndex: 2,
        elapsedMs: 1400,
        useColor: false,
      );
      expect(launchPending, equals('  └─ launch  ⠹ launching… 1.4s'));
    });

    test('commands help lists all shortcuts in a single column', () {
      final help = formatCommandsHelp(verbose: false, useColor: false);
      final lines = help
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.startsWith('›'))
          .toList();
      expect(lines, equals([
        '› Press r │ hot reload',
        '› Press R │ hot restart',
        '› Press v │ toggle verbose (off)',
        '› Press q │ show QR code',
        '› Press c │ clear screen',
        '› Press h │ show commands',
        '› Ctrl+C  │ quit',
      ]));
    });
  });

  group('DevServerConsole streaming (Option A)', () {
    test('streams single-file reload and omits dev-only stats in normal mode', () {
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);

      console.beginCodeReload(
        changedFiles: const ['lib/screens/home/showcase_tab.dart'],
        rebuildMs: 20,
        cached: false,
        patchBytes: 10555,
        totalModules: 93,
        totalPrepMs: 21,
        connectedClients: 1,
      );
      // Dev-internal device logs must be suppressed in normal mode.
      console.onDeviceLog(
        '[BundleLoader] [TIME] AST fetchPatch ready in 5ms (manifest=0ms, download=5ms)',
      );
      console.onDeviceLog(
        '[AstInterpreter] [TIME] AST evaluate (reload) ready in 226ms (decl_swaps=1407 swaps)',
      );
      console.onDeviceLog(
        '[RELOAD] AST finished in 299ms (fetch=8ms, sync=20ms, track=1ms, eval=261ms, remount=5ms)',
      );

      final joined = lines.join('\n');
      expect(joined, contains('↻ Hot reload · showcase_tab.dart'));
      expect(joined, isNot(contains('file    lib/screens/home/showcase_tab.dart')));
      expect(
        joined,
        contains('├─ server  rebuild 20ms · patch 10.3 KB (1/93 modules)'),
      );
      expect(
        joined,
        contains('└─ device  fetch 8ms · sync 20ms · eval 261ms · remount 5ms (299ms)'),
      );
      // Internal stats hidden in normal mode.
      expect(joined, isNot(contains('track')));
      expect(joined, isNot(contains('prep 21ms')));
      expect(joined, isNot(contains('fetchPatch')));
      expect(joined, isNot(contains('decl_swaps')));
    });

    test('multi-file batch reload summarizes files in normal mode and expands in verbose', () {
      final normalLines = <String>[];
      final normal = DevServerConsole(sink: normalLines.add, useColor: false);
      normal.beginCodeReload(
        changedFiles: const [
          'lib/a.dart',
          'lib/b.dart',
          'lib/c.dart',
          'lib/d.dart',
          'lib/e.dart',
        ],
        rebuildMs: 35,
        cached: false,
        patchBytes: 24576,
        totalModules: 93,
        connectedClients: 0,
      );
      final normalText = normalLines.join('\n');
      expect(normalText, contains('↻ Hot reload · 5 files'));
      expect(normalText, contains('├─ files   a.dart, b.dart, c.dart (+2 more)'));
      expect(normalText, contains('5/93 modules'));
      expect(normalText, contains('└─ device  no devices connected'));

      DartGoLogger.verbose = true;
      final verboseLines = <String>[];
      final verbose = DevServerConsole(sink: verboseLines.add, useColor: false);
      verbose.beginCodeReload(
        changedFiles: const ['lib/screens/a.dart', 'lib/screens/b.dart'],
        rebuildMs: 24,
        cached: false,
        patchBytes: 12000,
        totalModules: 93,
        connectedClients: 1,
      );
      final verboseText = verboseLines.join('\n');
      expect(verboseText, contains('├─ files   lib/screens/a.dart'));
      expect(verboseText, contains('│          lib/screens/b.dart'));
    });

    test('AST profile table appears ONLY on hot restart (verbose) and never on hot reload', () {
      DartGoLogger.verbose = true;
      final sampleProfileLogs = const [
        '[AstInterpreter] [PROFILE] bundle: modules=93, AST=13491.6KiB, source=1369.8KiB, classes=455, mainCallSync=3.2ms',
        '[AstInterpreter] [PROFILE] module package:playground/screens/system_components_demo.dart: AST=697.8KiB, source=79.4KiB classes=18, loadTotal=1.3ms inclusive, loads=1, cacheHits=0',
        '[AstInterpreter] [PROFILE] module package:playground/screens/tiktok/tiktok_demo.dart: AST=417.3KiB, source=37.6KiB classes=4, loadTotal=12.8ms inclusive, loads=1, cacheHits=1',
        '[AstInterpreter] [PROFILE] slow module package:playground/screens/home/home_shell.dart: loadTotal=145.6ms inclusive, avg=145.6ms across 1 loads, AST=118.4KiB',
        '[AstInterpreter] [PROFILE] slow module package:playground/screens/home/showcase_tab.dart: loadTotal=49.1ms inclusive, avg=49.1ms across 1 loads, AST=103.8KiB',
        '[AstInterpreter] [PROFILE] class package:playground/screens/system_components_demo.dart::_SystemComponentsDemoState: AST=466.5KiB',
        '[AstInterpreter] [PROFILE] class package:playground/screens/tiktok/tiktok_demo.dart::_TikTokDemoState: AST=382.7KiB',
      ];

      // 1. Hot reload must NOT display the profile table.
      final reloadLines = <String>[];
      final reloadConsole = DevServerConsole(
        sink: reloadLines.add,
        useColor: false,
      );
      reloadConsole.beginCodeReload(
        changedFiles: const ['lib/screens/home/showcase_tab.dart'],
        rebuildMs: 18,
        cached: false,
        patchBytes: 8192,
        totalModules: 93,
        connectedClients: 1,
      );
      for (final log in sampleProfileLogs) {
        reloadConsole.onDeviceLog(log);
      }
      reloadConsole.onDeviceLog('[RELOAD] AST finished in 250ms (eval=210ms)');
      expect(reloadLines.join('\n'), isNot(contains('Module / Class')));
      expect(reloadLines.join('\n'), isNot(contains('home/home_shell.dart')));

      // 2. Hot restart DOES display the compact single-column-target table.
      final restartLines = <String>[];
      final restartConsole = DevServerConsole(
        sink: restartLines.add,
        useColor: false,
      );
      restartConsole.beginHotRestart(connectedClients: 1);
      for (final log in sampleProfileLogs) {
        restartConsole.onDeviceLog(log);
      }
      restartConsole.onStructuredReloadOrRestart(
        isRestart: true,
        totalMs: 485,
        timings: const {'fetch': 18, 'eval': 412, 'mount': 9},
      );
      final restartText = restartLines.join('\n');
      expect(restartText, contains('⟳ Hot restart'));
      expect(restartText, contains('├─ bundle  93 modules · 455 classes'));
      expect(
        restartText,
        contains('├─ device  fetch 18ms · eval 412ms · mount 9ms · main 3.2ms (485ms)'),
      );
      expect(restartText, contains('└─ profile'));
      expect(restartText, contains('Module / Class'));
      expect(restartText, contains('home/home_shell.dart'));
      expect(restartText, contains('145.6ms'));
      expect(restartText, contains('system_components_demo::_SystemComponents'));
      expect(restartText, contains('tiktok/tiktok_demo::_TikTokDemoState'));
      expect(restartText, contains('12.8ms'));
      expect(restartText, contains('383 KiB'));
    });

    test('perf logs are hidden in normal mode and formatted cleanly in verbose', () {
      const perf =
          '[Perf] 2001ms: frames=1 builds=111 (96.8ms) paints=0 (0.0ms) recreates=0 (0.0ms) setState=0 inh=0/0 zones=1 | perFrame max 96.8ms /111 builds, slow(>16ms)=1, maxGap=0.0ms\n'
          '[Perf]   top builds: DemoRow×39=29.8ms(max 1.8), _PlaygroundHomeState×1=23.7ms(max 23.7)';

      final normalLines = <String>[];
      DevServerConsole(sink: normalLines.add, useColor: false).onDeviceLog(perf);
      expect(normalLines, isEmpty);

      DartGoLogger.verbose = true;
      final verboseLines = <String>[];
      DevServerConsole(sink: verboseLines.add, useColor: false).onDeviceLog(perf);
      final out = verboseLines.join('\n');
      expect(out, contains('⚡ Perf (2.0s) · 1 frame · 111 builds (96.8ms, 1 slow >16ms)'));
      expect(out, contains('└─ DemoRow×39 (29.8ms) · _PlaygroundHomeState×1 (23.7ms)'));
    });
  });

  group('URL normalization & CLI flags', () {
    test('BundleLoader.normalizeUrl strips /_dngo/loading from QR URLs', () {
      expect(
        BundleLoader.normalizeUrl('http://172.20.10.3:8088/_dngo/loading'),
        equals('http://172.20.10.3:8088'),
      );
      expect(
        BundleLoader.normalizeUrl(
          'http://172.20.10.3:8088/_dngo/loading?url=http%3A%2F%2F172.20.10.3%3A8088',
        ),
        equals('http://172.20.10.3:8088'),
      );
      expect(
        BundleLoader.normalizeUrl('172.20.10.3:8088/'),
        equals('http://172.20.10.3:8088'),
      );
    });

    test('DartGoCommandLine parses --dev-logs', () {
      final parsed = DartGoCommandLine.parse(
        ['start', '--dev-logs'],
        currentDir: Directory('/tmp'),
      );
      expect(parsed.devLogs, isTrue);
    });
  });

  group('reassembled wording & device name', () {
    test('uses reassembled for hot reload and restarted for hot restart without timings', () {
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);

      console.beginCodeReload(
        changedFiles: const ['lib/screens/home/showcase_tab.dart'],
        rebuildMs: 32,
        cached: false,
        patchBytes: 10555,
        totalModules: 93,
        connectedClients: 1,
      );
      console.onDeviceLog('[RELOAD] AST finished in 401ms');

      expect(lines.join('\n'), contains('└─ device  reassembled in 401ms'));

      lines.clear();
      console.beginHotRestart(connectedClients: 1);
      console.onDeviceLog('[RESTART] AST finished in 485ms');
      expect(lines.join('\n'), contains('└─ device  restarted in 485ms'));
    });

    test('resolveDeviceName handles iOS simulator, physical iPhone, Android, and desktop', () {
      // 1. iOS Simulator with SIMULATOR_DEVICE_NAME
      expect(
        resolveDeviceName(
          environment: const {'SIMULATOR_DEVICE_NAME': 'iPhone 16 Pro'},
          operatingSystem: 'ios',
          localHostname: 'Light-Errand-MacBook-Pro.local',
        ),
        equals('iPhone 16 Pro'),
      );
      // 2. iOS Simulator without SIMULATOR_DEVICE_NAME (uses SIMULATOR_MODEL_IDENTIFIER, never Mac hostname!)
      expect(
        resolveDeviceName(
          environment: const {'SIMULATOR_MODEL_IDENTIFIER': 'iPhone14,2'},
          operatingSystem: 'ios',
          localHostname: 'Light-Errand-MacBook-Pro.local',
          readIosUiDeviceName: () => 'iPhone',
          readIosHardwareMachine: () => 'arm64',
        ),
        equals('iPhone 13 Pro'),
      );
      // 3. iOS Simulator with UIDevice.current.name set to simulator name
      expect(
        resolveDeviceName(
          environment: const {'SIMULATOR_UDID': 'abc'},
          operatingSystem: 'ios',
          localHostname: 'Light-Errand-MacBook-Pro.local',
          readIosUiDeviceName: () => 'iPhone 13 Pro',
          readIosHardwareMachine: () => 'arm64',
        ),
        equals('iPhone 13 Pro'),
      );
      // 4. Physical iPhone 13 Pro (iOS 16+ returns generic "iPhone" for UIDevice.name)
      expect(
        resolveDeviceName(
          environment: const {},
          operatingSystem: 'ios',
          localHostname: 'iPhone.local',
          readIosUiDeviceName: () => 'iPhone',
          readIosHardwareMachine: () => 'iPhone14,2',
        ),
        equals('iPhone 13 Pro'),
      );
      // 5. Android marketname & manufacturer/model
      expect(
        resolveDeviceName(
          environment: const {},
          operatingSystem: 'android',
          localHostname: 'localhost',
          readAndroidProp: (prop) =>
              prop == 'ro.product.marketname' ? 'Pixel 9 Pro' : null,
        ),
        equals('Pixel 9 Pro'),
      );
      expect(
        resolveDeviceName(
          environment: const {},
          operatingSystem: 'android',
          localHostname: 'localhost',
          readAndroidProp: (prop) => switch (prop) {
            'ro.product.manufacturer' => 'Google',
            'ro.product.model' => 'Pixel 8',
            _ => null,
          },
        ),
        equals('Google Pixel 8'),
      );
      // 6. Desktop macOS uses hostname without .local
      expect(
        resolveDeviceName(
          environment: const {},
          operatingSystem: 'macos',
          localHostname: 'Light-Errand-MacBook-Pro.local',
        ),
        equals('Light-Errand-MacBook-Pro'),
      );
    });

    test('LiveConnection advertises deviceName and DevSocketHub prints it on connect/disconnect', () async {
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);
      final hub = DevSocketHub(Directory.current, console: console);
      final httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final sub = httpServer.listen((req) {
        if (req.uri.path == '/ws') {
          hub.accept(req);
        }
      });

      final conn = LiveConnection(
        serverUrl: 'http://127.0.0.1:${httpServer.port}',
        deviceName: 'iPhone 16 Pro',
        autoReconnect: false,
      );
      await conn.connect();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        lines.join('\n'),
        contains('● Device connected · iPhone 16 Pro (1 active)'),
      );

      conn.disconnect();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        lines.join('\n'),
        contains('○ Device disconnected · iPhone 16 Pro (0 active)'),
      );

      await sub.cancel();
      await httpServer.close(force: true);
    });

    test('prints bundle and fetch/exec/total launch timings when device connects', () async {
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);
      final hub = DevSocketHub(Directory.current, console: console);
      final httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final sub = httpServer.listen((req) {
        if (req.uri.path == '/ws') {
          hub.accept(req);
        }
      });

      final conn = LiveConnection(
        serverUrl: 'http://127.0.0.1:${httpServer.port}',
        deviceName: 'iPhone 16 Pro',
        autoReconnect: false,
      );
      await conn.connect();
      conn.sendLaunchStats(
        mode: 'AST',
        totalMs: 395,
        bundleBytes: 1795063,
        moduleCount: 93,
        assetCount: 12,
        timings: const {
          'fetch': 42,
          'sync': 14,
          'ws': 8,
          'exec': 318,
          'mount': 6,
        },
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final out = lines.join('\n');
      expect(out, contains('● Device connected · iPhone 16 Pro (1 active)'));
      expect(out, contains('├─ bundle  AST · 1.71 MB · 93 modules · 12 assets'));
      expect(
        out,
        contains('└─ launch  fetch 42ms · sync 14ms · exec 318ms · mount 6ms (395ms)'),
      );
      // `ws` is hidden in normal mode.
      expect(out, isNot(contains('ws 8ms')));

      conn.disconnect();
      await sub.cancel();
      await httpServer.close(force: true);
    });

    test('parses legacy project launch profile log when launch_stats was not sent', () {
      DartGoLogger.verbose = true;
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);

      console.onDeviceConnected(1, deviceName: 'Pixel 9');
      console.onDeviceLog(
        '[Runner] [PROFILE] project launch: bundleFetch=40ms, iconFonts=10ms, websocket=7ms, evaluation=280ms, total=340ms',
      );

      final out = lines.join('\n');
      expect(out, contains('● Device connected · Pixel 9 (1 active)'));
      expect(
        out,
        contains('└─ launch  fetch 40ms · sync 10ms · ws 7ms · exec 280ms (340ms)'),
      );
    });

    test('attaches pre-connect served guest.ast bundle summary in normal mode without duplicating on launch', () {
      DartGoLogger.verbose = false;
      final lines = <String>[];
      final console = DevServerConsole(sink: lines.add, useColor: false);

      // Device downloads /guest.ast right before upgrading /ws.
      console.onArtifactServed(
        name: 'guest.ast',
        byteSize: 1795063,
        moduleCount: 93,
        assetCount: 12,
        serveMs: 14,
      );
      console.onDeviceConnected(1, deviceName: 'iPhone 16 Pro');
      console.onDeviceLaunch(
        mode: 'AST',
        totalMs: 395,
        bundleBytes: 1795063,
        moduleCount: 93,
        assetCount: 12,
        timings: const {'fetch': 42, 'sync': 14, 'exec': 318, 'mount': 6},
      );

      final out = lines.join('\n');
      expect(out, contains('● Device connected · iPhone 16 Pro (1 active)'));
      expect(
        out,
        contains('├─ bundle  guest.ast · 1.71 MB · 93 modules · 12 assets · served 14ms'),
      );
      expect(
        out,
        contains('└─ launch  fetch 42ms · sync 14ms · exec 318ms · mount 6ms (395ms)'),
      );
      // Must print the bundle line only once.
      expect('├─ bundle'.allMatches(out).length, equals(1));
    });
  });
}
