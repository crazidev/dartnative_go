/// Source-engine (`tom_d4rt`) coverage of the upstream `playground/` app.
///
/// [playground_headless_test.dart] drives the analyzer-free AST engine, which
/// is what `kUseAst` selects on device. This suite boots the same app through
/// [InterpreterRunner] in source mode — the engine `kUseAst` falls back to —
/// so both interpreter paths are exercised against real app code.
///
/// Scope is the boot path plus a route sweep. It asserts the same thing the
/// AST suite does — every captured route builds — because the two engines
/// disagree often enough to be worth pinning separately; the AST suite keeps
/// the tab walk.
///
/// Run: `dn test test/playground/playground_source_headless_test.dart`
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/interpreter/routes_bridge.dart';
import 'package:test/test.dart';

import '../test_lab/fakes/fake_audio_player_ast.dart';
import '../test_lab/fakes/fake_connectivity_ast.dart';
import '../test_lab/fakes/fake_media_gallery_ast.dart';
import '../test_lab/fakes/fake_shared_preferences.dart';
import '../test_lab/harness.dart';

/// Minimal `BuildContext` for driving an interpreted `build(context)`.
class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Widget _render(Widget widget, BuildContext context) {
  if (widget is StatefulWidget) {
    final state = widget.createState();
    (state as dynamic).initState();
    (state as dynamic).didChangeDependencies();
    return (state as dynamic).build(context) as Widget;
  }
  if (widget is StatelessWidget) {
    return (widget as dynamic).build(context) as Widget;
  }
  return widget;
}

void main() {
  final playground = Directory('playground');
  late DnHarness harness;
  late Widget root;

  setUpAll(() async {
    if (!playground.existsSync()) {
      throw StateError(
        'playground/ missing — clone DartNative/dartnative into this repo',
      );
    }
    final files = <String, String>{};
    for (final entity in Directory('playground/lib').listSync(
      recursive: true,
    )) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = entity.path.substring('playground/lib/'.length);
      files[relative] = await entity.readAsString();
    }
    final prefs = FakeSharedPreferencesHost();
    harness = DnHarness(
      mode: DnMode.source,
      packageName: 'playground',
      onLog: (_) {},
      bridgeOverrides: [
        (interpreter) {
          installFakeSharedPreferences(interpreter, prefs);
          installFakeMediaGallerySource(interpreter);
          installFakeConnectivitySource(interpreter);
          installFakeAudioPlayerSource(interpreter);
        },
      ],
    );
    root = await harness.evaluate(files);
  });

  tearDownAll(() {
    harness.dispose();
  });

  test('boot: main() mounts the playground shell', () {
    expect(root, isNotNull, reason: 'runApp must capture a root widget');
    expect(
      D4rtRoutes.paths,
      isNotEmpty,
      reason: 'main() registers ~43 named routes; none were captured',
    );
  });

  test('routes: every captured route builds', () {
    final context = _FakeContext();
    final failures = <String>[];
    for (final entry in D4rtRoutes.routes.entries) {
      try {
        _render(entry.value(context), context);
      } catch (error, stack) {
        failures.add(
          '${entry.key}: ${error.toString().split('\n').first}\n'
          '    ${stack.toString().split('\n').take(3).join('\n    ')}',
        );
      }
    }
    expect(
      failures,
      isEmpty,
      reason: 'undocumented route failures:\n${failures.join('\n')}',
    );
  });
}
