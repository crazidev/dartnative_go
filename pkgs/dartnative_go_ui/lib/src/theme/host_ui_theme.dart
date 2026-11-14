import 'package:dartnative/dartnative.dart';

/// Theme currently published by the nearest [HostUiTheme] build.
///
/// Not an [InheritedWidget]: the guest interpreter does not wrap interpreted
/// subclasses of [InheritedWidget] as real widgets, so returning one from
/// [HostUiTheme.build] fails. The launcher rebuilds this scope when the
/// preference changes, and descendants read [HostUiThemeContext.theme].
HostUiThemeData _activeHostUiTheme = HostUiThemeData.light;

/// Visual tokens for the host launcher.
///
/// Kept in this package so `dart_go start` can render the UI without
/// importing the shell. Token values match the shell shadcn palette.
/// `system` reads [MediaQuery] during build; a host theme change rebuilds
/// this widget because the launcher stores the preference from the API.
class HostUiTheme extends StatelessWidget {
  final String mode;
  final Widget child;

  const HostUiTheme({super.key, required this.mode, required this.child});

  @override
  Widget build(BuildContext context) {
    // Publish before returning the child so the child's build sees it.
    // Return the child itself: it is already a bridged widget.
    _activeHostUiTheme = HostUiThemeData.resolve(mode, context);
    return child;
  }
}

class HostUiRadius {
  const HostUiRadius();

  BorderRadius get md => const BorderRadius.all(Radius.circular(8));
  BorderRadius get lg => const BorderRadius.all(Radius.circular(10));
  BorderRadius get full => const BorderRadius.all(Radius.circular(9999));
}

class HostUiThemeData {
  final Brightness brightness;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color secondary;
  final Color primary;
  final Color destructive;
  final Color border;
  final Color input;
  final HostUiRadius radius;

  const HostUiThemeData({
    required this.brightness,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.secondary,
    required this.primary,
    required this.destructive,
    required this.border,
    required this.input,
    this.radius = const HostUiRadius(),
  });

  /// Resolves the tokens for [mode] (`system`, `light`, or `dark`).
  static HostUiThemeData resolve(String mode, BuildContext context) {
    switch (mode) {
      case 'light':
        return light;
      case 'dark':
        return dark;
      default:
        try {
          return MediaQuery.of(context).platformBrightness == Brightness.dark
              ? dark
              : light;
        } catch (_) {
          return light;
        }
    }
  }

  static const light = HostUiThemeData(
    brightness: Brightness.light,
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF090B0C),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF090B0C),
    mutedForeground: Color(0xFF67787C),
    accent: Color(0xFF007595),
    accentForeground: Color(0xFFECFEFF),
    secondary: Color(0xFFF4F4F5),
    primary: Color(0xFF007595),
    destructive: Color(0xFFE7000B),
    border: Color(0xFFE3E7E8),
    input: Color(0xFFE3E7E8),
  );

  static const dark = HostUiThemeData(
    brightness: Brightness.dark,
    background: Color(0xFF090B0C),
    foreground: Color(0xFFF9FBFB),
    card: Color(0xFF161B1D),
    cardForeground: Color(0xFFF9FBFB),
    mutedForeground: Color(0xFF9CA8AB),
    accent: Color(0xFF005F78),
    accentForeground: Color(0xFFECFEFF),
    secondary: Color(0xFF27272A),
    primary: Color(0xFF005F78),
    destructive: Color(0xFFFF6467),
    border: Color(0x1AFFFFFF),
    input: Color(0x26FFFFFF),
  );
}

extension HostUiThemeContext on BuildContext {
  HostUiThemeData get theme => _activeHostUiTheme;
}
