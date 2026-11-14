/// Host UI for DartNative Go.
///
/// The shell embeds [HostLauncher]. `lib/main.dart` is the `dart_go start`
/// entrypoint so the same widgets can be previewed as a guest.
library;

export 'src/devtool/host_devtool_button.dart';
export 'src/devtool/host_devtool_sheet.dart';
export 'src/launcher/host_launcher.dart';
export 'src/theme/host_ui_theme.dart';
export 'src/theme/shadcn_theme.dart' hide ShadcnThemeContextExtension;
export 'src/theme/theme_storage.dart';
