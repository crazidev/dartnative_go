import 'package:dartnative/dartnative.dart';

import 'shadcn_theme.dart';

/// Single source of truth for the host UI palette.
///
/// Token values come from [ShadcnLight] / [ShadcnDark], which are generated
/// from `tool/shadcn_tokens.css` by `tool/shadcn_to_dart.dart`. This library
/// only adds the [HostUiTheme] scope and the [HostUiThemeData] aliases the
/// launcher and DevTools widgets already use.

/// Theme currently published by the nearest [HostUiTheme] build.
///
/// Not an [InheritedWidget]: the guest interpreter does not wrap interpreted
/// subclasses of [InheritedWidget] as real widgets, so returning one from
/// [HostUiTheme.build] fails. The launcher rebuilds this scope when the
/// preference changes, and descendants read `context.theme`.
ShadcnThemeData _activeHostUiTheme = ShadcnThemeData.light;

/// Visual tokens for the host launcher.
///
/// Kept in this package so `dart_go start` can render the UI without
/// importing the shell. `system` reads [MediaQuery] during build; a host
/// theme change rebuilds this widget because the launcher stores the
/// preference from the API.
class HostUiTheme extends StatelessWidget {
  final String mode;
  final Widget child;

  const HostUiTheme({super.key, required this.mode, required this.child});

  @override
  Widget build(BuildContext context) {
    // Publish before returning the child so the child's build sees it.
    // Return the child itself: it is already a bridged widget.
    _activeHostUiTheme = resolveHostUiTheme(mode, context);
    return child;
  }
}

/// Border-radius scale used by the host UI widgets.
///
/// Alias over [ShadcnRadius] so launcher widgets keep using
/// `theme.radius.md` / `.lg` / `.full`.
typedef HostUiRadius = ShadcnRadius;

/// Resolved host UI theme data.
///
/// Alias over [ShadcnThemeData]; the generated token class already carries
/// every field the launcher and DevTools widgets read.
typedef HostUiThemeData = ShadcnThemeData;

/// Resolves the tokens for [mode] (`system`, `light`, or `dark`).
ShadcnThemeData resolveHostUiTheme(String mode, BuildContext context) {
  switch (mode) {
    case 'light':
      return ShadcnThemeData.light;
    case 'dark':
      return ShadcnThemeData.dark;
    default:
      try {
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? ShadcnThemeData.dark
            : ShadcnThemeData.light;
      } catch (_) {
        return ShadcnThemeData.light;
      }
  }
}

/// Reads the theme published by the nearest [HostUiTheme] build.
///
/// Static-backed (not `ShadcnTheme.of`) so interpreted guests can read it;
/// `ShadcnThemeContextExtension` is hidden from the barrel to avoid an
/// ambiguous `context.theme`.
extension HostUiThemeContext on BuildContext {
  ShadcnThemeData get theme => _activeHostUiTheme;
}
