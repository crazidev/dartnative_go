/// Pure-Dart conversion of shadcn CSS tokens into Dart theme code.
///
/// No Flutter/dartnative imports: this library runs both in the host CLI
/// (`tool/shadcn_to_dart.dart`) and in `package:test`. It parses `:root` and
/// `.dark` custom-property blocks, converts `oklch(...)` colors to sRGB, and
/// emits a generated `shadcn_theme.dart` with light/dark [ThemeData] plus a
/// [ShadcnLight]/[ShadcnDark] token bag for direct widget use.
library;

import 'dart:math' as math;

/// Custom properties of one theme block (`:root` = light, `.dark` = dark).
typedef TokenMap = Map<String, String>;

/// Parses [css] and returns the `:root` (light) and `.dark` token maps.
///
/// Throws [FormatException] when either block is missing.
Map<String, TokenMap> parseShadcnCss(String css) {
  final light = _parseBlock(css, ':root');
  final dark = _parseBlock(css, '.dark');
  if (light == null) {
    throw const FormatException('shadcn CSS has no :root block');
  }
  if (dark == null) {
    throw const FormatException('shadcn CSS has no .dark block');
  }
  return {'light': light, 'dark': dark};
}

TokenMap? _parseBlock(String css, String selector) {
  final start = css.indexOf(selector);
  if (start < 0) return null;
  final open = css.indexOf('{', start);
  if (open < 0) return null;
  var depth = 0;
  var close = -1;
  for (var i = open; i < css.length; i++) {
    if (css[i] == '{') depth++;
    if (css[i] == '}') {
      depth--;
      if (depth == 0) {
        close = i;
        break;
      }
    }
  }
  if (close < 0) return null;
  final body = css.substring(open + 1, close);
  final tokens = <String, String>{};
  for (final decl in body.split(';')) {
    final colon = decl.indexOf(':');
    if (colon < 0) continue;
    final name = decl.substring(0, colon).trim();
    final value = decl.substring(colon + 1).trim();
    if (name.startsWith('--') && value.isNotEmpty) {
      tokens[name.substring(2)] = value;
    }
  }
  return tokens;
}

/// Converts an `oklch(L C H [/ alpha])` string to `0xAARRGGBB`.
///
/// Accepts space- or comma-separated channels; alpha is `%` or `0-1`.
/// Out-of-gamut channels are clipped to sRGB.
int oklchToArgb(String oklch) {
  final match = RegExp(
    r'oklch\(\s*([0-9.]+)[\s,]+([0-9.]+)[\s,]+([0-9.\-]+)(?:\s*/\s*([0-9.]+%?))?\s*\)',
  ).firstMatch(oklch);
  if (match == null) {
    throw FormatException('not an oklch() color: $oklch');
  }
  final l = double.parse(match.group(1)!);
  final c = double.parse(match.group(2)!);
  final hDeg = double.parse(match.group(3)!);
  var alpha = 1.0;
  final alphaRaw = match.group(4);
  if (alphaRaw != null) {
    alpha = alphaRaw.endsWith('%')
        ? double.parse(alphaRaw.substring(0, alphaRaw.length - 1)) / 100.0
        : double.parse(alphaRaw);
  }

  final h = hDeg * math.pi / 180.0;
  final a = c * math.cos(h);
  final b = c * math.sin(h);
  var l_ = l + 0.3963377774 * a + 0.2158037573 * b;
  var m_ = l - 0.1055613458 * a - 0.0638541728 * b;
  var s_ = l - 0.0894841775 * a - 1.2914855480 * b;
  l_ = l_ * l_ * l_;
  m_ = m_ * m_ * m_;
  s_ = s_ * s_ * s_;
  final r = 4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_;
  final g = -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_;
  final bl = -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_;

  final ai = (alpha.clamp(0.0, 1.0) * 255).round().clamp(0, 255);
  return (ai << 24) |
      (_toSrbgByte(r) << 16) |
      (_toSrbgByte(g) << 8) |
      _toSrbgByte(bl);
}

int _toSrbgByte(double linear) {
  final c = linear.clamp(0.0, 1.0);
  final v = c <= 0.0031308 ? 12.92 * c : 1.055 * math.pow(c, 1.0 / 2.4) - 0.055;
  return (v * 255).round().clamp(0, 255);
}

/// Relative luminance of an `0xAARRGGBB` color (alpha ignored).
double relativeLuminance(int argb) {
  double channel(int byte) {
    final c = byte / 255.0;
    return c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel((argb >> 16) & 0xFF) +
      0.7152 * channel((argb >> 8) & 0xFF) +
      0.0722 * channel(argb & 0xFF);
}

/// Picks the highest-contrast candidate against [backgroundArgb].
int bestOnColor(int backgroundArgb, List<int> candidates) {
  var best = candidates.first;
  var bestScore = -1.0;
  for (final c in candidates) {
    final l1 = relativeLuminance(backgroundArgb);
    final l2 = relativeLuminance(c);
    final contrast = (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
    if (contrast > bestScore) {
      bestScore = contrast;
      best = c;
    }
  }
  return best;
}

/// Parses a `--radius` value (`0.625rem`, `10px`, `10`) to logical pixels.
double parseRadius(String raw) {
  final value = raw.trim();
  if (value.endsWith('rem')) {
    return double.parse(value.substring(0, value.length - 3)) * 16.0;
  }
  if (value.endsWith('px')) {
    return double.parse(value.substring(0, value.length - 2));
  }
  return double.parse(value);
}

/// Token names carried into the generated token bag, in output order.
const List<String> kTokenNames = [
  'background',
  'foreground',
  'card',
  'card-foreground',
  'popover',
  'popover-foreground',
  'primary',
  'primary-foreground',
  'secondary',
  'secondary-foreground',
  'muted',
  'muted-foreground',
  'accent',
  'accent-foreground',
  'destructive',
  'border',
  'input',
  'ring',
];

String _dartField(String name) {
  final parts = name.split('-');
  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

const List<String> kAllTokenNames = [
  ...kTokenNames,
  'sidebar',
  'sidebar-foreground',
  'sidebar-primary',
  'sidebar-primary-foreground',
  'sidebar-accent',
  'sidebar-accent-foreground',
  'sidebar-border',
  'sidebar-ring',
  'chart-1',
  'chart-2',
  'chart-3',
  'chart-4',
  'chart-5',
];

String _hex(int argb) =>
    '0x${argb.toUnsigned(32).toRadixString(16).padLeft(8, '0').toUpperCase()}';

/// Emits the full `shadcn_theme.dart` source for [light]/[dark] token maps.
///
/// shadcn → ColorScheme mapping: surface/card pair, muted/accent/secondary as
/// the container ramp, muted-foreground as onSurfaceVariant, border as
/// outline. `destructive` has no `-foreground` token in this set, so onError
/// is derived as the highest-contrast theme neutral.
String generateThemeDart({
  required TokenMap light,
  required TokenMap dark,
  required String sourcePath,
}) {
  final out = StringBuffer();
  out.writeln('// GENERATED CODE — do not edit by hand.');
  out.writeln('// Source: $sourcePath');
  out.writeln('// Regenerate with: dart run tool/shadcn_to_dart.dart');
  out.writeln();
  out.writeln("import 'package:dartnative/dartnative.dart';");
  out.writeln("import '../client/theme_storage.dart';");
  out.writeln();

  final radiusVal = parseRadius(
    light['radius'] ?? dark['radius'] ?? '0.625rem',
  );

  for (final entry in [('Light', light, 'light'), ('Dark', dark, 'dark')]) {
    final className = 'Shadcn${entry.$1}';
    final tokens = entry.$2;
    final brightness = entry.$3;
    final argb = <String, int>{};
    for (final name in kAllTokenNames) {
      final raw = tokens[name];
      if (raw == null) {
        throw FormatException('theme $brightness is missing token --$name');
      }
      argb[name] = oklchToArgb(raw);
    }
    final radius = parseRadius(tokens['radius'] ?? '0.625rem');

    // Neutrals for derived on-colors: darkest/lightest of the theme.
    final neutrals = [
      argb['primary-foreground']!,
      argb['foreground']!,
      argb['primary']!,
      argb['secondary-foreground']!,
    ];
    final onError = bestOnColor(argb['destructive']!, neutrals);

    out.writeln('/// shadcn `$brightness` tokens as Dart colors.');
    out.writeln('abstract final class $className {');
    for (final name in kTokenNames) {
      out.writeln(
        '  static const Color ${_dartField(name)} = Color(${_hex(argb[name]!)});',
      );
    }
    for (final name in [
      'chart-1',
      'chart-2',
      'chart-3',
      'chart-4',
      'chart-5',
      'sidebar',
      'sidebar-foreground',
      'sidebar-primary',
      'sidebar-primary-foreground',
      'sidebar-accent',
      'sidebar-accent-foreground',
      'sidebar-border',
      'sidebar-ring',
    ]) {
      out.writeln(
        '  static const Color ${_dartField(name)} = Color(${_hex(argb[name]!)});',
      );
    }
    out.writeln('  static const double radius = $radius;');
    out.writeln();
    out.writeln('  static ThemeData get theme => const ThemeData(');
    out.writeln('    brightness: Brightness.$brightness,');
    out.writeln('    scaffoldBackgroundColor: background,');
    out.writeln('    primaryColor: primary,');
    out.writeln('    dividerColor: border,');
    out.writeln('    colorScheme: ColorScheme(');
    out.writeln('      brightness: Brightness.$brightness,');
    out.writeln('      primary: primary,');
    out.writeln('      onPrimary: primaryForeground,');
    out.writeln('      primaryContainer: accent,');
    out.writeln('      onPrimaryContainer: accentForeground,');
    out.writeln('      secondary: secondary,');
    out.writeln('      onSecondary: secondaryForeground,');
    out.writeln('      error: destructive,');
    out.writeln('      onError: Color(${_hex(onError)}),');
    out.writeln('      surface: card,');
    out.writeln('      onSurface: cardForeground,');
    out.writeln('      surfaceContainerHighest: accent,');
    out.writeln('      surfaceContainerHigh: muted,');
    out.writeln('      surfaceContainer: secondary,');
    out.writeln('      onSurfaceVariant: mutedForeground,');
    out.writeln('      outline: border,');
    out.writeln('    ),');
    out.writeln('  );');
    out.writeln('}');
    out.writeln();
  }

  // --- ShadcnTokens ---
  out.writeln(
    '/// Multi-theme token bag. Each color is a [ShadcnColor] holding both light and dark values.',
  );
  out.writeln('abstract final class ShadcnTokens {');
  for (final name in kAllTokenNames) {
    final field = _dartField(name);
    out.writeln('  static const ShadcnColor $field = ShadcnColor(');
    out.writeln('    light: ShadcnLight.$field,');
    out.writeln('    dark: ShadcnDark.$field,');
    out.writeln('  );');
  }
  out.writeln('  static const ShadcnSize radius = ShadcnSize.px($radiusVal);');
  out.writeln('}');
  out.writeln();

  // --- ShadcnColor ---
  out.writeln(
    '/// Dynamic theme color token pairing a light and dark [Color].',
  );
  out.writeln('class ShadcnColor {');
  out.writeln('  final Color light;');
  out.writeln('  final Color dark;');
  out.writeln();
  out.writeln('  const ShadcnColor({');
  out.writeln('    required this.light,');
  out.writeln('    required this.dark,');
  out.writeln('  });');
  out.writeln();
  out.writeln('  /// Resolves the concrete [Color] according to [brightness].');
  out.writeln('  Color resolve(Brightness brightness) =>');
  out.writeln('      brightness == Brightness.dark ? dark : light;');
  out.writeln();
  out.writeln(
    '  /// Resolves the concrete [Color] according to the ambient [context] theme.',
  );
  out.writeln(
    '  Color of(BuildContext context) => resolve(Theme.of(context).brightness);',
  );
  out.writeln('}');
  out.writeln();
  out.writeln('typedef ShadncColor = ShadcnColor;');
  out.writeln();

  // --- ShadcnSize ---
  out.writeln('/// Pixel sizing token wrapper.');
  out.writeln('class ShadcnSize {');
  out.writeln('  final double value;');
  out.writeln();
  out.writeln('  const ShadcnSize.px(this.value);');
  out.writeln();
  out.writeln('  double toDouble() => value;');
  out.writeln();
  out.writeln('  @override');
  out.writeln(r"  String toString() => '${value}px';");
  out.writeln('}');
  out.writeln();
  out.writeln('typedef ShadncSize = ShadcnSize;');
  out.writeln();

  // --- ShadcnRadius ---
  out.writeln('/// Border-radius scale derived from the base radius token.');
  out.writeln('class ShadcnRadius {');
  out.writeln('  final double base;');
  out.writeln();
  out.writeln('  const ShadcnRadius([this.base = $radiusVal]);');
  out.writeln();
  out.writeln('  BorderRadius get none => BorderRadius.zero;');
  out.writeln('  BorderRadius get sm =>');
  out.writeln(
    '      BorderRadius.all(Radius.circular((base - 4.0).clamp(0.0, double.infinity)));',
  );
  out.writeln('  BorderRadius get md =>');
  out.writeln(
    '      BorderRadius.all(Radius.circular((base - 2.0).clamp(0.0, double.infinity)));',
  );
  out.writeln(
    '  BorderRadius get lg => BorderRadius.all(Radius.circular(base));',
  );
  out.writeln(
    '  BorderRadius get xl => BorderRadius.all(Radius.circular(base + 4.0));',
  );
  out.writeln(
    '  BorderRadius get full => const BorderRadius.all(Radius.circular(9999.0));',
  );
  out.writeln(
    '  BorderRadius px(double radius) => BorderRadius.all(Radius.circular(radius));',
  );
  out.writeln('}');
  out.writeln();

  // --- ShadcnThemeData ---
  out.writeln(
    '/// Resolved theme data representing active colors and metrics.',
  );
  out.writeln('class ShadcnThemeData {');
  out.writeln('  final Brightness brightness;');
  out.writeln('  final ShadcnRadius radius;');
  for (final name in kAllTokenNames) {
    out.writeln('  final Color ${_dartField(name)};');
  }
  out.writeln();
  out.writeln('  const ShadcnThemeData({');
  out.writeln('    required this.brightness,');
  out.writeln('    required this.radius,');
  for (final name in kAllTokenNames) {
    out.writeln('    required this.${_dartField(name)},');
  }
  out.writeln('  });');
  out.writeln();
  out.writeln('  bool get isDark => brightness == Brightness.dark;');
  out.writeln('  bool get isLight => brightness == Brightness.light;');
  out.writeln(
    '  ThemeData get materialTheme => isDark ? ShadcnDark.theme : ShadcnLight.theme;',
  );
  out.writeln();
  out.writeln('  static final ShadcnThemeData light = ShadcnThemeData(');
  out.writeln('    brightness: Brightness.light,');
  out.writeln('    radius: const ShadcnRadius($radiusVal),');
  for (final name in kAllTokenNames) {
    final field = _dartField(name);
    out.writeln('    $field: ShadcnLight.$field,');
  }
  out.writeln('  );');
  out.writeln();
  out.writeln('  static final ShadcnThemeData dark = ShadcnThemeData(');
  out.writeln('    brightness: Brightness.dark,');
  out.writeln('    radius: const ShadcnRadius($radiusVal),');
  for (final name in kAllTokenNames) {
    final field = _dartField(name);
    out.writeln('    $field: ShadcnDark.$field,');
  }
  out.writeln('  );');
  out.writeln();
  out.writeln(
    '  factory ShadcnThemeData.fromBrightness(Brightness brightness) =>',
  );
  out.writeln('      brightness == Brightness.dark ? dark : light;');
  out.writeln();
  out.writeln('  ShadcnThemeData copyWith({');
  out.writeln('    Brightness? brightness,');
  out.writeln('    ShadcnRadius? radius,');
  for (final name in kAllTokenNames) {
    out.writeln('    Color? ${_dartField(name)},');
  }
  out.writeln('  }) {');
  out.writeln('    return ShadcnThemeData(');
  out.writeln('      brightness: brightness ?? this.brightness,');
  out.writeln('      radius: radius ?? this.radius,');
  for (final name in kAllTokenNames) {
    final field = _dartField(name);
    out.writeln('      $field: $field ?? this.$field,');
  }
  out.writeln('    );');
  out.writeln('  }');
  out.writeln('}');
  out.writeln();

  // --- ShadcnAppearanceMode ---
  out.writeln('/// Application appearance preference.');
  out.writeln('enum ShadcnAppearanceMode {');
  out.writeln('  system,');
  out.writeln('  light,');
  out.writeln('  dark;');
  out.writeln();
  out.writeln('  ThemeMode toThemeMode() => switch (this) {');
  out.writeln('        ShadcnAppearanceMode.system => ThemeMode.system,');
  out.writeln('        ShadcnAppearanceMode.light => ThemeMode.light,');
  out.writeln('        ShadcnAppearanceMode.dark => ThemeMode.dark,');
  out.writeln('      };');
  out.writeln();
  out.writeln('  Brightness? toNativeBrightness() => switch (this) {');
  out.writeln('        ShadcnAppearanceMode.light => Brightness.light,');
  out.writeln('        ShadcnAppearanceMode.dark => Brightness.dark,');
  out.writeln('        ShadcnAppearanceMode.system => null,');
  out.writeln('      };');
  out.writeln('}');
  out.writeln();

  // --- ShadcnTheme & Inherited ---
  out.writeln('/// Root or subtree theme controller.');
  out.writeln('class ShadcnTheme extends StatefulWidget {');
  out.writeln('  final Widget child;');
  out.writeln('  final ShadcnThemeData? data;');
  out.writeln('  final ShadcnAppearanceMode? mode;');
  out.writeln('  final ShadcnAppearanceMode? initialMode;');
  out.writeln('  final ValueChanged<ShadcnAppearanceMode>? onModeChanged;');
  out.writeln();
  out.writeln('  const ShadcnTheme({');
  out.writeln('    super.key,');
  out.writeln('    this.data,');
  out.writeln('    this.mode,');
  out.writeln('    this.initialMode,');
  out.writeln('    this.onModeChanged,');
  out.writeln('    required this.child,');
  out.writeln('  });');
  out.writeln();
  out.writeln(
    '  factory ShadcnTheme.dark({Key? key, required Widget child}) =>',
  );
  out.writeln(
    '      ShadcnTheme(key: key, data: ShadcnThemeData.dark, child: child);',
  );
  out.writeln();
  out.writeln(
    '  factory ShadcnTheme.light({Key? key, required Widget child}) =>',
  );
  out.writeln(
    '      ShadcnTheme(key: key, data: ShadcnThemeData.light, child: child);',
  );
  out.writeln();
  out.writeln('  static ShadcnThemeData of(BuildContext context) {');
  out.writeln('    final inherited =');
  out.writeln(
    '        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();',
  );
  out.writeln('    if (inherited != null) return inherited.data;');
  out.writeln('    final brightness = Theme.of(context).brightness;');
  out.writeln('    return ShadcnThemeData.fromBrightness(brightness);');
  out.writeln('  }');
  out.writeln();
  out.writeln(
    '  static void setAppearance(BuildContext context, ShadcnAppearanceMode mode) {',
  );
  out.writeln('    final scope =');
  out.writeln(
    '        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();',
  );
  out.writeln('    scope?.onSetMode(mode);');
  out.writeln('  }');
  out.writeln();
  out.writeln('  static void cycleAppearance(BuildContext context) {');
  out.writeln('    final scope =');
  out.writeln(
    '        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();',
  );
  out.writeln('    scope?.onCycleMode();');
  out.writeln('  }');
  out.writeln();
  out.writeln(
    '  static ShadcnAppearanceMode getAppearance(BuildContext context) {',
  );
  out.writeln('    final scope =');
  out.writeln(
    '        context.dependOnInheritedWidgetOfExactType<_ShadcnInheritedTheme>();',
  );
  out.writeln('    return scope?.mode ?? ShadcnAppearanceMode.system;');
  out.writeln('  }');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  State<ShadcnTheme> createState() => _ShadcnThemeState();');
  out.writeln('}');
  out.writeln();
  out.writeln('typedef ShadncTheme = ShadcnTheme;');
  out.writeln();

  // --- _ShadcnThemeState ---
  out.writeln(
    'class _ShadcnThemeState extends State<ShadcnTheme> with WidgetsBindingObserver {',
  );
  out.writeln('  late ShadcnAppearanceMode _mode;');
  out.writeln();
  out.writeln('  ShadcnAppearanceMode get mode => widget.mode ?? _mode;');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  void initState() {');
  out.writeln('    super.initState();');
  out.writeln('    WidgetsBinding.instance.addObserver(this);');
  out.writeln('    _mode = widget.mode ??');
  out.writeln('        widget.initialMode ??');
  out.writeln('        _prefToMode(ThemeStorage.currentPreference);');
  out.writeln('  }');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  void didUpdateWidget(covariant ShadcnTheme oldWidget) {');
  out.writeln('    super.didUpdateWidget(oldWidget);');
  out.writeln(
    '    if (widget.mode != null && widget.mode != oldWidget.mode) {',
  );
  out.writeln('      _mode = widget.mode!;');
  out.writeln('    } else if (widget.initialMode != null &&');
  out.writeln('        widget.initialMode != oldWidget.initialMode) {');
  out.writeln('      _mode = widget.initialMode!;');
  out.writeln('    }');
  out.writeln('  }');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  void dispose() {');
  out.writeln('    WidgetsBinding.instance.removeObserver(this);');
  out.writeln('    super.dispose();');
  out.writeln('  }');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  void didChangePlatformBrightness() {');
  out.writeln('    if (mode == ShadcnAppearanceMode.system && mounted) {');
  out.writeln('      setState(() {});');
  out.writeln('    }');
  out.writeln('  }');
  out.writeln();
  out.writeln('  Future<void> setMode(ShadcnAppearanceMode newMode) async {');
  out.writeln('    if (mode == newMode) return;');
  out.writeln('    setState(() => _mode = newMode);');
  out.writeln('    widget.onModeChanged?.call(newMode);');
  out.writeln('    await ThemeStorage.savePreference(_modeToPref(newMode));');
  out.writeln('    try {');
  out.writeln('      setAppBrightness(newMode.toNativeBrightness());');
  out.writeln('    } catch (_) {}');
  out.writeln('  }');
  out.writeln();
  out.writeln('  void cycleMode() {');
  out.writeln('    final next = switch (mode) {');
  out.writeln(
    '      ShadcnAppearanceMode.system => ShadcnAppearanceMode.light,',
  );
  out.writeln('      ShadcnAppearanceMode.light => ShadcnAppearanceMode.dark,');
  out.writeln(
    '      ShadcnAppearanceMode.dark => ShadcnAppearanceMode.system,',
  );
  out.writeln('    };');
  out.writeln('    setMode(next);');
  out.writeln('  }');
  out.writeln();
  out.writeln('  Brightness _resolveBrightness(BuildContext context) {');
  out.writeln('    return switch (mode) {');
  out.writeln('      ShadcnAppearanceMode.light => Brightness.light,');
  out.writeln('      ShadcnAppearanceMode.dark => Brightness.dark,');
  out.writeln('      ShadcnAppearanceMode.system => () {');
  out.writeln('        try {');
  out.writeln('          return Theme.of(context).brightness;');
  out.writeln('        } catch (_) {');
  out.writeln('          try {');
  out.writeln('            return MediaQuery.of(context).platformBrightness;');
  out.writeln('          } catch (_) {');
  out.writeln('            return Brightness.light;');
  out.writeln('          }');
  out.writeln('        }');
  out.writeln('      }(),');
  out.writeln('    };');
  out.writeln('  }');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  Widget build(BuildContext context) {');
  out.writeln('    final effectiveData = widget.data ??');
  out.writeln(
    '        ShadcnThemeData.fromBrightness(_resolveBrightness(context));',
  );
  out.writeln('    return _ShadcnInheritedTheme(');
  out.writeln('      data: effectiveData,');
  out.writeln('      mode: mode,');
  out.writeln('      onSetMode: (newMode) => setMode(newMode),');
  out.writeln('      onCycleMode: cycleMode,');
  out.writeln('      child: widget.child,');
  out.writeln('    );');
  out.writeln('  }');
  out.writeln('}');
  out.writeln();
  out.writeln(
    'ThemePreference _modeToPref(ShadcnAppearanceMode mode) => switch (mode) {',
  );
  out.writeln('      ShadcnAppearanceMode.system => ThemePreference.system,');
  out.writeln('      ShadcnAppearanceMode.light => ThemePreference.light,');
  out.writeln('      ShadcnAppearanceMode.dark => ThemePreference.dark,');
  out.writeln('    };');
  out.writeln();
  out.writeln(
    'ShadcnAppearanceMode _prefToMode(ThemePreference pref) => switch (pref) {',
  );
  out.writeln('      ThemePreference.system => ShadcnAppearanceMode.system,');
  out.writeln('      ThemePreference.light => ShadcnAppearanceMode.light,');
  out.writeln('      ThemePreference.dark => ShadcnAppearanceMode.dark,');
  out.writeln('    };');
  out.writeln();

  // --- _ShadcnInheritedTheme ---
  out.writeln('class _ShadcnInheritedTheme extends InheritedWidget {');
  out.writeln('  final ShadcnThemeData data;');
  out.writeln('  final ShadcnAppearanceMode mode;');
  out.writeln('  final ValueChanged<ShadcnAppearanceMode> onSetMode;');
  out.writeln('  final VoidCallback onCycleMode;');
  out.writeln();
  out.writeln('  const _ShadcnInheritedTheme({');
  out.writeln('    required this.data,');
  out.writeln('    required this.mode,');
  out.writeln('    required this.onSetMode,');
  out.writeln('    required this.onCycleMode,');
  out.writeln('    required super.child,');
  out.writeln('  });');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  bool updateShouldNotify(_ShadcnInheritedTheme oldWidget) =>');
  out.writeln('      data != oldWidget.data || mode != oldWidget.mode;');
  out.writeln('}');
  out.writeln();

  // --- ShadcnApp ---
  out.writeln(
    '/// Convenience root application widget preconfigured with shadcn themes.',
  );
  out.writeln('class ShadcnApp extends StatelessWidget {');
  out.writeln('  final Widget? home;');
  out.writeln('  final String title;');
  out.writeln('  final ShadcnAppearanceMode initialMode;');
  out.writeln('  final Map<String, WidgetBuilder> routes;');
  out.writeln('  final String? initialRoute;');
  out.writeln('  final NavigatorObserver? navigatorObserver;');
  out.writeln('  final bool debugShowCheckedModeBanner;');
  out.writeln();
  out.writeln('  const ShadcnApp({');
  out.writeln('    super.key,');
  out.writeln('    this.home,');
  out.writeln("    this.title = '',");
  out.writeln('    this.initialMode = ShadcnAppearanceMode.system,');
  out.writeln('    this.routes = const {},');
  out.writeln('    this.initialRoute,');
  out.writeln('    this.navigatorObserver,');
  out.writeln('    this.debugShowCheckedModeBanner = true,');
  out.writeln('  });');
  out.writeln();
  out.writeln('  @override');
  out.writeln('  Widget build(BuildContext context) {');
  out.writeln('    return ShadcnTheme(');
  out.writeln('      initialMode: initialMode,');
  out.writeln('      child: Builder(');
  out.writeln('        builder: (context) {');
  out.writeln('          final mode = ShadcnTheme.getAppearance(context);');
  out.writeln('          return App(');
  out.writeln('            title: title,');
  out.writeln('            theme: ShadcnLight.theme,');
  out.writeln('            darkTheme: ShadcnDark.theme,');
  out.writeln('            themeMode: mode.toThemeMode(),');
  out.writeln('            home: home,');
  out.writeln('            routes: routes,');
  out.writeln('            initialRoute: initialRoute,');
  out.writeln('            navigatorObserver: navigatorObserver,');
  out.writeln(
    '            debugShowCheckedModeBanner: debugShowCheckedModeBanner,',
  );
  out.writeln('          );');
  out.writeln('        },');
  out.writeln('      ),');
  out.writeln('    );');
  out.writeln('  }');
  out.writeln('}');
  out.writeln();

  // --- ShadcnThemeContextExtension ---
  out.writeln('/// Extensions on [BuildContext] for ergonomic theme access.');
  out.writeln('extension ShadcnThemeContextExtension on BuildContext {');
  out.writeln(
    '  /// The active resolved theme data (e.g. `context.theme.background`, `context.theme.radius.lg`).',
  );
  out.writeln('  ShadcnThemeData get theme => ShadcnTheme.of(this);');
  out.writeln();
  out.writeln('  /// The current application appearance mode.');
  out.writeln(
    '  ShadcnAppearanceMode get appearanceMode => ShadcnTheme.getAppearance(this);',
  );
  out.writeln();
  out.writeln(
    '  /// Sets application appearance mode (`system`, `light`, `dark`).',
  );
  out.writeln('  void setAppearance(ShadcnAppearanceMode mode) =>');
  out.writeln('      ShadcnTheme.setAppearance(this, mode);');
  out.writeln();
  out.writeln('  /// Cycles appearance mode (system → light → dark → system).');
  out.writeln('  void cycleAppearance() => ShadcnTheme.cycleAppearance(this);');
  out.writeln();
  out.writeln(
    '  // Direct token getters returning [ShadcnColor] (e.g. `context.background.dark`, `context.background.light`).',
  );
  for (final name in kAllTokenNames) {
    final field = _dartField(name);
    out.writeln('  ShadcnColor get $field => ShadcnTokens.$field;');
  }
  out.writeln('}');
  out.writeln();

  return out.toString();
}
