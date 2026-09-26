import 'package:dartnative/dartnative.dart';

import '../client/theme_storage.dart';
import 'shadcn_theme.dart';

/// Concrete host-painted colors for the launcher subtree.
///
/// The framework `App.themeMode` resolves `system` natively, but these
/// hand-painted spots need a decided palette: `system` follows the dark
/// tokens (the historical launcher look) until a platform-brightness query
/// exists on the host.
class LauncherColors {
  final Color background;
  final Color foreground;
  final Color mutedForeground;
  final Color card;
  final Color input;

  const LauncherColors({
    required this.background,
    required this.foreground,
    required this.mutedForeground,
    required this.card,
    required this.input,
  });

  factory LauncherColors.of(ThemePreference preference) {
    final dark = preference != ThemePreference.light;
    return LauncherColors(
      background: dark ? ShadcnDark.background : ShadcnLight.background,
      foreground: dark ? ShadcnDark.foreground : ShadcnLight.foreground,
      mutedForeground: dark
          ? ShadcnDark.mutedForeground
          : ShadcnLight.mutedForeground,
      card: dark ? ShadcnDark.card : ShadcnLight.card,
      input: dark ? ShadcnDark.input : ShadcnLight.input,
    );
  }

  factory LauncherColors.fromTheme(ShadcnThemeData theme) {
    return LauncherColors(
      background: theme.background,
      foreground: theme.foreground,
      mutedForeground: theme.mutedForeground,
      card: theme.card,
      input: theme.input,
    );
  }
}
