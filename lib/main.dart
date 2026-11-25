import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/dartnative_plugin_registrant.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'src/app_shell.dart';
import 'package:dngo_ui/dngo_ui.dart';
import 'src/runner/ast_guest_runner.dart';
import 'src/theme/theme_providers.dart';

/// Product entrypoint: links AST runtime only (`tom_d4rt_ast`).
/// The Source engine (`package:analyzer`) is not reachable here, keeping ~690k lines out of AOT.
Future<void> main(List<String> args) async {
  DartNativePluginRegistrant.registerAll();

  final ThemePreference theme = await ThemeStorage.loadPreference();
  ThemeController.applyNativeAppearance(theme);

  runApp(
    const ProviderScope(
      child: DartNativeGo(createRunner: AstGuestRunner.create),
    ),
  );
}
