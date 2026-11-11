import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/dartnative_plugin_registrant.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'src/app_shell.dart';
import 'src/client/theme_storage.dart';
import 'src/runner/interpreter_runner.dart';
import 'src/runner/runtime_mode.dart';
import 'src/theme/theme_providers.dart';

/// Development entrypoint: links the analyzer-based Source runtime.
/// Use `-t lib/main_source.dart`; `lib/main.dart` remains AST-only by default.
Future<void> main(List<String> args) async {
  kSourceRuntimeLinked = true;
  DartNativePluginRegistrant.registerAll();

  final theme = await ThemeStorage.loadPreference();
  ThemeController.applyNativeAppearance(theme);

  runApp(
    const ProviderScope(
      child: DartNativeGo(createRunner: InterpreterRunner.create),
    ),
  );
}
