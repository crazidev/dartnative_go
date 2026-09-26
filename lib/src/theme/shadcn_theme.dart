// GENERATED CODE — do not edit by hand.
// Source: tool/shadcn_tokens.css
// Regenerate with: dart run tool/shadcn_to_dart.dart

import 'package:dartnative/dartnative.dart';
import '../client/theme_storage.dart';

/// shadcn `light` tokens as Dart colors.
abstract final class ShadcnLight {
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0A0A0A);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0A0A0A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0A0A0A);
  static const Color primary = Color(0xFF171717);
  static const Color primaryForeground = Color(0xFFFAFAFA);
  static const Color secondary = Color(0xFFF5F5F5);
  static const Color secondaryForeground = Color(0xFF171717);
  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF737373);
  static const Color accent = Color(0xFFF5F5F5);
  static const Color accentForeground = Color(0xFF171717);
  static const Color destructive = Color(0xFFE7000B);
  static const Color border = Color(0xFFE5E5E5);
  static const Color input = Color(0xFFE5E5E5);
  static const Color ring = Color(0xFFA1A1A1);
  static const Color chart1 = Color(0xFFD4D4D4);
  static const Color chart2 = Color(0xFF737373);
  static const Color chart3 = Color(0xFF525252);
  static const Color chart4 = Color(0xFF404040);
  static const Color chart5 = Color(0xFF262626);
  static const Color sidebar = Color(0xFFFAFAFA);
  static const Color sidebarForeground = Color(0xFF0A0A0A);
  static const Color sidebarPrimary = Color(0xFF171717);
  static const Color sidebarPrimaryForeground = Color(0xFFFAFAFA);
  static const Color sidebarAccent = Color(0xFFF5F5F5);
  static const Color sidebarAccentForeground = Color(0xFF171717);
  static const Color sidebarBorder = Color(0xFFE5E5E5);
  static const Color sidebarRing = Color(0xFFA1A1A1);
  static const double radius = 10.0;

  static ThemeData get theme => const ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    dividerColor: border,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: primaryForeground,
      primaryContainer: accent,
      onPrimaryContainer: accentForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      error: destructive,
      onError: Color(0xFFFAFAFA),
      surface: card,
      onSurface: cardForeground,
      surfaceContainerHighest: accent,
      surfaceContainerHigh: muted,
      surfaceContainer: secondary,
      onSurfaceVariant: mutedForeground,
      outline: border,
    ),
  );
}

/// shadcn `dark` tokens as Dart colors.
abstract final class ShadcnDark {
  static const Color background = Color(0xFF0A0A0A);
  static const Color foreground = Color(0xFFFAFAFA);
  static const Color card = Color(0xFF171717);
  static const Color cardForeground = Color(0xFFFAFAFA);
  static const Color popover = Color(0xFF171717);
  static const Color popoverForeground = Color(0xFFFAFAFA);
  static const Color primary = Color(0xFFE5E5E5);
  static const Color primaryForeground = Color(0xFF171717);
  static const Color secondary = Color(0xFF262626);
  static const Color secondaryForeground = Color(0xFFFAFAFA);
  static const Color muted = Color(0xFF262626);
  static const Color mutedForeground = Color(0xFFA1A1A1);
  static const Color accent = Color(0xFF262626);
  static const Color accentForeground = Color(0xFFFAFAFA);
  static const Color destructive = Color(0xFFFF6467);
  static const Color border = Color(0x1AFFFFFF);
  static const Color input = Color(0x26FFFFFF);
  static const Color ring = Color(0xFF737373);
  static const Color chart1 = Color(0xFFD4D4D4);
  static const Color chart2 = Color(0xFF737373);
  static const Color chart3 = Color(0xFF525252);
  static const Color chart4 = Color(0xFF404040);
  static const Color chart5 = Color(0xFF262626);
  static const Color sidebar = Color(0xFF171717);
  static const Color sidebarForeground = Color(0xFFFAFAFA);
  static const Color sidebarPrimary = Color(0xFF1447E6);
  static const Color sidebarPrimaryForeground = Color(0xFFFAFAFA);
  static const Color sidebarAccent = Color(0xFF262626);
  static const Color sidebarAccentForeground = Color(0xFFFAFAFA);
  static const Color sidebarBorder = Color(0x1AFFFFFF);
  static const Color sidebarRing = Color(0xFF737373);
  static const double radius = 10.0;

  static ThemeData get theme => const ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    dividerColor: border,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: primaryForeground,
      primaryContainer: accent,
      onPrimaryContainer: accentForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      error: destructive,
      onError: Color(0xFF171717),
      surface: card,
      onSurface: cardForeground,
      surfaceContainerHighest: accent,
      surfaceContainerHigh: muted,
      surfaceContainer: secondary,
      onSurfaceVariant: mutedForeground,
      outline: border,
    ),
  );
}

/// Multi-theme token bag. Each color is a [ShadcnColor] holding both light and dark values.
abstract final class ShadcnTokens {
  static const ShadcnColor background = ShadcnColor(
    light: ShadcnLight.background,
    dark: ShadcnDark.background,
  );
  static const ShadcnColor foreground = ShadcnColor(
    light: ShadcnLight.foreground,
    dark: ShadcnDark.foreground,
  );
  static const ShadcnColor card = ShadcnColor(
    light: ShadcnLight.card,
    dark: ShadcnDark.card,
  );
  static const ShadcnColor cardForeground = ShadcnColor(
    light: ShadcnLight.cardForeground,
    dark: ShadcnDark.cardForeground,
  );
  static const ShadcnColor popover = ShadcnColor(
    light: ShadcnLight.popover,
    dark: ShadcnDark.popover,
  );
  static const ShadcnColor popoverForeground = ShadcnColor(
    light: ShadcnLight.popoverForeground,
    dark: ShadcnDark.popoverForeground,
  );
  static const ShadcnColor primary = ShadcnColor(
    light: ShadcnLight.primary,
    dark: ShadcnDark.primary,
  );
  static const ShadcnColor primaryForeground = ShadcnColor(
    light: ShadcnLight.primaryForeground,
    dark: ShadcnDark.primaryForeground,
  );
  static const ShadcnColor secondary = ShadcnColor(
    light: ShadcnLight.secondary,
    dark: ShadcnDark.secondary,
  );
  static const ShadcnColor secondaryForeground = ShadcnColor(
    light: ShadcnLight.secondaryForeground,
    dark: ShadcnDark.secondaryForeground,
  );
  static const ShadcnColor muted = ShadcnColor(
    light: ShadcnLight.muted,
    dark: ShadcnDark.muted,
  );
  static const ShadcnColor mutedForeground = ShadcnColor(
    light: ShadcnLight.mutedForeground,
    dark: ShadcnDark.mutedForeground,
  );
  static const ShadcnColor accent = ShadcnColor(
    light: ShadcnLight.accent,
    dark: ShadcnDark.accent,
  );
  static const ShadcnColor accentForeground = ShadcnColor(
    light: ShadcnLight.accentForeground,
    dark: ShadcnDark.accentForeground,
  );
  static const ShadcnColor destructive = ShadcnColor(
    light: ShadcnLight.destructive,
    dark: ShadcnDark.destructive,
  );
  static const ShadcnColor border = ShadcnColor(
    light: ShadcnLight.border,
    dark: ShadcnDark.border,
  );
  static const ShadcnColor input = ShadcnColor(
    light: ShadcnLight.input,
    dark: ShadcnDark.input,
  );
  static const ShadcnColor ring = ShadcnColor(
    light: ShadcnLight.ring,
    dark: ShadcnDark.ring,
  );
  static const ShadcnColor sidebar = ShadcnColor(
    light: ShadcnLight.sidebar,
    dark: ShadcnDark.sidebar,
  );
  static const ShadcnColor sidebarForeground = ShadcnColor(
    light: ShadcnLight.sidebarForeground,
    dark: ShadcnDark.sidebarForeground,
  );
  static const ShadcnColor sidebarPrimary = ShadcnColor(
    light: ShadcnLight.sidebarPrimary,
    dark: ShadcnDark.sidebarPrimary,
  );
  static const ShadcnColor sidebarPrimaryForeground = ShadcnColor(
    light: ShadcnLight.sidebarPrimaryForeground,
    dark: ShadcnDark.sidebarPrimaryForeground,
  );
  static const ShadcnColor sidebarAccent = ShadcnColor(
    light: ShadcnLight.sidebarAccent,
    dark: ShadcnDark.sidebarAccent,
  );
  static const ShadcnColor sidebarAccentForeground = ShadcnColor(
    light: ShadcnLight.sidebarAccentForeground,
    dark: ShadcnDark.sidebarAccentForeground,
  );
  static const ShadcnColor sidebarBorder = ShadcnColor(
    light: ShadcnLight.sidebarBorder,
    dark: ShadcnDark.sidebarBorder,
  );
  static const ShadcnColor sidebarRing = ShadcnColor(
    light: ShadcnLight.sidebarRing,
    dark: ShadcnDark.sidebarRing,
  );
  static const ShadcnColor chart1 = ShadcnColor(
    light: ShadcnLight.chart1,
    dark: ShadcnDark.chart1,
  );
  static const ShadcnColor chart2 = ShadcnColor(
    light: ShadcnLight.chart2,
    dark: ShadcnDark.chart2,
  );
  static const ShadcnColor chart3 = ShadcnColor(
    light: ShadcnLight.chart3,
    dark: ShadcnDark.chart3,
  );
  static const ShadcnColor chart4 = ShadcnColor(
    light: ShadcnLight.chart4,
    dark: ShadcnDark.chart4,
  );
  static const ShadcnColor chart5 = ShadcnColor(
    light: ShadcnLight.chart5,
    dark: ShadcnDark.chart5,
  );
  static const ShadcnSize radius = ShadcnSize.px(10.0);
}

/// Dynamic theme color token pairing a light and dark [Color].
class ShadcnColor {
  final Color light;
  final Color dark;

  const ShadcnColor({
    required this.light,
    required this.dark,
  });

  /// Resolves the concrete [Color] according to [brightness].
  Color resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Resolves the concrete [Color] according to the ambient [context] theme.
  Color of(BuildContext context) => resolve(Theme.of(context).brightness);
}

typedef ShadncColor = ShadcnColor;

/// Pixel sizing token wrapper.
class ShadcnSize {
  final double value;

  const ShadcnSize.px(this.value);

  double toDouble() => value;

  @override
  String toString() => '${value}px';
}

typedef ShadncSize = ShadcnSize;

/// Border-radius scale derived from the base radius token.
class ShadcnRadius {
  final double base;

  const ShadcnRadius([this.base = 10.0]);

  BorderRadius get none => BorderRadius.zero;
  BorderRadius get sm =>
      BorderRadius.all(Radius.circular((base - 4.0).clamp(0.0, double.infinity)));
  BorderRadius get md =>
      BorderRadius.all(Radius.circular((base - 2.0).clamp(0.0, double.infinity)));
  BorderRadius get lg => BorderRadius.all(Radius.circular(base));
  BorderRadius get xl => BorderRadius.all(Radius.circular(base + 4.0));
  BorderRadius get full => const BorderRadius.all(Radius.circular(9999.0));
  BorderRadius px(double radius) => BorderRadius.all(Radius.circular(radius));
}

/// Resolved theme data representing active colors and metrics.
class ShadcnThemeData {
  final Brightness brightness;
  final ShadcnRadius radius;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color border;
  final Color input;
  final Color ring;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  const ShadcnThemeData({
    required this.brightness,
    required this.radius,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.border,
    required this.input,
    required this.ring,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
  ThemeData get materialTheme => isDark ? ShadcnDark.theme : ShadcnLight.theme;

  static final ShadcnThemeData light = ShadcnThemeData(
    brightness: Brightness.light,
    radius: const ShadcnRadius(10.0),
    background: ShadcnLight.background,
    foreground: ShadcnLight.foreground,
    card: ShadcnLight.card,
    cardForeground: ShadcnLight.cardForeground,
    popover: ShadcnLight.popover,
    popoverForeground: ShadcnLight.popoverForeground,
    primary: ShadcnLight.primary,
    primaryForeground: ShadcnLight.primaryForeground,
    secondary: ShadcnLight.secondary,
    secondaryForeground: ShadcnLight.secondaryForeground,
    muted: ShadcnLight.muted,
    mutedForeground: ShadcnLight.mutedForeground,
    accent: ShadcnLight.accent,
    accentForeground: ShadcnLight.accentForeground,
    destructive: ShadcnLight.destructive,
    border: ShadcnLight.border,
    input: ShadcnLight.input,
    ring: ShadcnLight.ring,
    sidebar: ShadcnLight.sidebar,
    sidebarForeground: ShadcnLight.sidebarForeground,
    sidebarPrimary: ShadcnLight.sidebarPrimary,
    sidebarPrimaryForeground: ShadcnLight.sidebarPrimaryForeground,
    sidebarAccent: ShadcnLight.sidebarAccent,
    sidebarAccentForeground: ShadcnLight.sidebarAccentForeground,
    sidebarBorder: ShadcnLight.sidebarBorder,
    sidebarRing: ShadcnLight.sidebarRing,
    chart1: ShadcnLight.chart1,
    chart2: ShadcnLight.chart2,
    chart3: ShadcnLight.chart3,
    chart4: ShadcnLight.chart4,
    chart5: ShadcnLight.chart5,
  );

  static final ShadcnThemeData dark = ShadcnThemeData(
    brightness: Brightness.dark,
    radius: const ShadcnRadius(10.0),
    background: ShadcnDark.background,
    foreground: ShadcnDark.foreground,
    card: ShadcnDark.card,
    cardForeground: ShadcnDark.cardForeground,
    popover: ShadcnDark.popover,
    popoverForeground: ShadcnDark.popoverForeground,
    primary: ShadcnDark.primary,
    primaryForeground: ShadcnDark.primaryForeground,
    secondary: ShadcnDark.secondary,
    secondaryForeground: ShadcnDark.secondaryForeground,
    muted: ShadcnDark.muted,
    mutedForeground: ShadcnDark.mutedForeground,
    accent: ShadcnDark.accent,
    accentForeground: ShadcnDark.accentForeground,
    destructive: ShadcnDark.destructive,
    border: ShadcnDark.border,
    input: ShadcnDark.input,
    ring: ShadcnDark.ring,
    sidebar: ShadcnDark.sidebar,
    sidebarForeground: ShadcnDark.sidebarForeground,
    sidebarPrimary: ShadcnDark.sidebarPrimary,
    sidebarPrimaryForeground: ShadcnDark.sidebarPrimaryForeground,
    sidebarAccent: ShadcnDark.sidebarAccent,
    sidebarAccentForeground: ShadcnDark.sidebarAccentForeground,
    sidebarBorder: ShadcnDark.sidebarBorder,
    sidebarRing: ShadcnDark.sidebarRing,
    chart1: ShadcnDark.chart1,
    chart2: ShadcnDark.chart2,
    chart3: ShadcnDark.chart3,
    chart4: ShadcnDark.chart4,
    chart5: ShadcnDark.chart5,
  );

  factory ShadcnThemeData.fromBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  ShadcnThemeData copyWith({
    Brightness? brightness,
    ShadcnRadius? radius,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? border,
    Color? input,
    Color? ring,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return ShadcnThemeData(
      brightness: brightness ?? this.brightness,
      radius: radius ?? this.radius,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      sidebar: sidebar ?? this.sidebar,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
      sidebarPrimaryForeground: sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
      sidebarAccent: sidebarAccent ?? this.sidebarAccent,
      sidebarAccentForeground: sidebarAccentForeground ?? this.sidebarAccentForeground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      sidebarRing: sidebarRing ?? this.sidebarRing,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }
}

/// Application appearance preference.
enum ShadcnAppearanceMode {
  system,
  light,
  dark;

  ThemeMode toThemeMode() => switch (this) {
        ShadcnAppearanceMode.system => ThemeMode.system,
        ShadcnAppearanceMode.light => ThemeMode.light,
        ShadcnAppearanceMode.dark => ThemeMode.dark,
      };

  Brightness? toNativeBrightness() => switch (this) {
        ShadcnAppearanceMode.light => Brightness.light,
        ShadcnAppearanceMode.dark => Brightness.dark,
        ShadcnAppearanceMode.system => null,
      };
}

/// Root or subtree theme controller.
class ShadcnTheme extends StatefulWidget {
  final Widget child;
  final ShadcnThemeData? data;
  final ShadcnAppearanceMode? mode;
  final ShadcnAppearanceMode? initialMode;
  final ValueChanged<ShadcnAppearanceMode>? onModeChanged;

  const ShadcnTheme({
    super.key,
    this.data,
    this.mode,
    this.initialMode,
    this.onModeChanged,
    required this.child,
  });

  factory ShadcnTheme.dark({Key? key, required Widget child}) =>
      ShadcnTheme(key: key, data: ShadcnThemeData.dark, child: child);

  factory ShadcnTheme.light({Key? key, required Widget child}) =>
      ShadcnTheme(key: key, data: ShadcnThemeData.light, child: child);

  static ShadcnThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();
    if (inherited != null) return inherited.data;
    final brightness = Theme.of(context).brightness;
    return ShadcnThemeData.fromBrightness(brightness);
  }

  static void setAppearance(BuildContext context, ShadcnAppearanceMode mode) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();
    scope?.onSetMode(mode);
  }

  static void cycleAppearance(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();
    scope?.onCycleMode();
  }

  static ShadcnAppearanceMode getAppearance(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();
    return scope?.mode ?? ShadcnAppearanceMode.system;
  }

  @override
  State<ShadcnTheme> createState() => _ShadcnThemeState();
}

typedef ShadncTheme = ShadcnTheme;

class _ShadcnThemeState extends State<ShadcnTheme> with WidgetsBindingObserver {
  late ShadcnAppearanceMode _mode;

  ShadcnAppearanceMode get mode => widget.mode ?? _mode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mode = widget.mode ??
        widget.initialMode ??
        _prefToMode(ThemeStorage.currentPreference);
  }

  @override
  void didUpdateWidget(covariant ShadcnTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != null && widget.mode != oldWidget.mode) {
      _mode = widget.mode!;
    } else if (widget.initialMode != null &&
        widget.initialMode != oldWidget.initialMode) {
      _mode = widget.initialMode!;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mode == ShadcnAppearanceMode.system && mounted) {
      setState(() {});
    }
  }

  Future<void> setMode(ShadcnAppearanceMode newMode) async {
    if (mode == newMode) return;
    setState(() => _mode = newMode);
    widget.onModeChanged?.call(newMode);
    await ThemeStorage.savePreference(_modeToPref(newMode));
    try {
      setAppBrightness(newMode.toNativeBrightness());
    } catch (_) {}
  }

  void cycleMode() {
    final next = switch (mode) {
      ShadcnAppearanceMode.system => ShadcnAppearanceMode.light,
      ShadcnAppearanceMode.light => ShadcnAppearanceMode.dark,
      ShadcnAppearanceMode.dark => ShadcnAppearanceMode.system,
    };
    setMode(next);
  }

  Brightness _resolveBrightness(BuildContext context) {
    return switch (mode) {
      ShadcnAppearanceMode.light => Brightness.light,
      ShadcnAppearanceMode.dark => Brightness.dark,
      ShadcnAppearanceMode.system => () {
        try {
          return Theme.of(context).brightness;
        } catch (_) {
          try {
            return MediaQuery.of(context).platformBrightness;
          } catch (_) {
            return Brightness.light;
          }
        }
      }(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final effectiveData = widget.data ??
        ShadcnThemeData.fromBrightness(_resolveBrightness(context));
    return _ShadcnInheritedTheme(
      data: effectiveData,
      mode: mode,
      onSetMode: (newMode) => setMode(newMode),
      onCycleMode: cycleMode,
      child: widget.child,
    );
  }
}

ThemePreference _modeToPref(ShadcnAppearanceMode mode) => switch (mode) {
      ShadcnAppearanceMode.system => ThemePreference.system,
      ShadcnAppearanceMode.light => ThemePreference.light,
      ShadcnAppearanceMode.dark => ThemePreference.dark,
    };

ShadcnAppearanceMode _prefToMode(ThemePreference pref) => switch (pref) {
      ThemePreference.system => ShadcnAppearanceMode.system,
      ThemePreference.light => ShadcnAppearanceMode.light,
      ThemePreference.dark => ShadcnAppearanceMode.dark,
    };

class _ShadcnInheritedTheme extends InheritedWidget {
  final ShadcnThemeData data;
  final ShadcnAppearanceMode mode;
  final ValueChanged<ShadcnAppearanceMode> onSetMode;
  final VoidCallback onCycleMode;

  const _ShadcnInheritedTheme({
    required this.data,
    required this.mode,
    required this.onSetMode,
    required this.onCycleMode,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ShadcnInheritedTheme oldWidget) =>
      data != oldWidget.data || mode != oldWidget.mode;
}

/// Convenience root application widget preconfigured with shadcn themes.
class ShadcnApp extends StatelessWidget {
  final Widget? home;
  final String title;
  final ShadcnAppearanceMode initialMode;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final NavigatorObserver? navigatorObserver;
  final bool debugShowCheckedModeBanner;

  const ShadcnApp({
    super.key,
    this.home,
    this.title = '',
    this.initialMode = ShadcnAppearanceMode.system,
    this.routes = const {},
    this.initialRoute,
    this.navigatorObserver,
    this.debugShowCheckedModeBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      initialMode: initialMode,
      child: Builder(
        builder: (context) {
          final mode = ShadcnTheme.getAppearance(context);
          return App(
            title: title,
            theme: ShadcnLight.theme,
            darkTheme: ShadcnDark.theme,
            themeMode: mode.toThemeMode(),
            home: home,
            routes: routes,
            initialRoute: initialRoute,
            navigatorObserver: navigatorObserver,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          );
        },
      ),
    );
  }
}

/// Extensions on [BuildContext] for ergonomic theme access.
extension ShadcnThemeContextExtension on BuildContext {
  /// The active resolved theme data (e.g. `context.theme.background`, `context.theme.radius.lg`).
  ShadcnThemeData get theme => ShadcnTheme.of(this);

  /// The current application appearance mode.
  ShadcnAppearanceMode get appearanceMode => ShadcnTheme.getAppearance(this);

  /// Sets application appearance mode (`system`, `light`, `dark`).
  void setAppearance(ShadcnAppearanceMode mode) =>
      ShadcnTheme.setAppearance(this, mode);

  /// Cycles appearance mode (system → light → dark → system).
  void cycleAppearance() => ShadcnTheme.cycleAppearance(this);

  // Direct token getters returning [ShadcnColor] (e.g. `context.background.dark`, `context.background.light`).
  ShadcnColor get background => ShadcnTokens.background;
  ShadcnColor get foreground => ShadcnTokens.foreground;
  ShadcnColor get card => ShadcnTokens.card;
  ShadcnColor get cardForeground => ShadcnTokens.cardForeground;
  ShadcnColor get popover => ShadcnTokens.popover;
  ShadcnColor get popoverForeground => ShadcnTokens.popoverForeground;
  ShadcnColor get primary => ShadcnTokens.primary;
  ShadcnColor get primaryForeground => ShadcnTokens.primaryForeground;
  ShadcnColor get secondary => ShadcnTokens.secondary;
  ShadcnColor get secondaryForeground => ShadcnTokens.secondaryForeground;
  ShadcnColor get muted => ShadcnTokens.muted;
  ShadcnColor get mutedForeground => ShadcnTokens.mutedForeground;
  ShadcnColor get accent => ShadcnTokens.accent;
  ShadcnColor get accentForeground => ShadcnTokens.accentForeground;
  ShadcnColor get destructive => ShadcnTokens.destructive;
  ShadcnColor get border => ShadcnTokens.border;
  ShadcnColor get input => ShadcnTokens.input;
  ShadcnColor get ring => ShadcnTokens.ring;
  ShadcnColor get sidebar => ShadcnTokens.sidebar;
  ShadcnColor get sidebarForeground => ShadcnTokens.sidebarForeground;
  ShadcnColor get sidebarPrimary => ShadcnTokens.sidebarPrimary;
  ShadcnColor get sidebarPrimaryForeground => ShadcnTokens.sidebarPrimaryForeground;
  ShadcnColor get sidebarAccent => ShadcnTokens.sidebarAccent;
  ShadcnColor get sidebarAccentForeground => ShadcnTokens.sidebarAccentForeground;
  ShadcnColor get sidebarBorder => ShadcnTokens.sidebarBorder;
  ShadcnColor get sidebarRing => ShadcnTokens.sidebarRing;
  ShadcnColor get chart1 => ShadcnTokens.chart1;
  ShadcnColor get chart2 => ShadcnTokens.chart2;
  ShadcnColor get chart3 => ShadcnTokens.chart3;
  ShadcnColor get chart4 => ShadcnTokens.chart4;
  ShadcnColor get chart5 => ShadcnTokens.chart5;
}

