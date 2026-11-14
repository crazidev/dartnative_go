import 'package:dartnative_go_ui/src/theme/shadcn_converter.dart';
import 'package:test/test.dart';

const _sampleCss = '''
:root {
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --card: oklch(1 0 0);
  --card-foreground: oklch(0.145 0 0);
  --popover: oklch(1 0 0);
  --popover-foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --primary-foreground: oklch(0.985 0 0);
  --secondary: oklch(0.97 0 0);
  --secondary-foreground: oklch(0.205 0 0);
  --muted: oklch(0.97 0 0);
  --muted-foreground: oklch(0.556 0 0);
  --accent: oklch(0.97 0 0);
  --accent-foreground: oklch(0.205 0 0);
  --destructive: oklch(0.577 0.245 27.325);
  --border: oklch(0.922 0 0);
  --input: oklch(0.922 0 0);
  --ring: oklch(0.708 0 0);
  --chart-1: oklch(0.87 0 0);
  --chart-2: oklch(0.556 0 0);
  --chart-3: oklch(0.439 0 0);
  --chart-4: oklch(0.371 0 0);
  --chart-5: oklch(0.269 0 0);
  --radius: 0.625rem;
  --sidebar: oklch(0.985 0 0);
  --sidebar-foreground: oklch(0.145 0 0);
  --sidebar-primary: oklch(0.205 0 0);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.97 0 0);
  --sidebar-accent-foreground: oklch(0.205 0 0);
  --sidebar-border: oklch(0.922 0 0);
  --sidebar-ring: oklch(0.708 0 0);
}

.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --card: oklch(0.205 0 0);
  --card-foreground: oklch(0.985 0 0);
  --popover: oklch(0.205 0 0);
  --popover-foreground: oklch(0.985 0 0);
  --primary: oklch(0.922 0 0);
  --primary-foreground: oklch(0.205 0 0);
  --secondary: oklch(0.269 0 0);
  --secondary-foreground: oklch(0.985 0 0);
  --muted: oklch(0.269 0 0);
  --muted-foreground: oklch(0.708 0 0);
  --accent: oklch(0.269 0 0);
  --accent-foreground: oklch(0.985 0 0);
  --destructive: oklch(0.704 0.191 22.216);
  --border: oklch(1 0 0 / 10%);
  --input: oklch(1 0 0 / 15%);
  --ring: oklch(0.556 0 0);
  --chart-1: oklch(0.87 0 0);
  --chart-2: oklch(0.556 0 0);
  --chart-3: oklch(0.439 0 0);
  --chart-4: oklch(0.371 0 0);
  --chart-5: oklch(0.269 0 0);
  --sidebar: oklch(0.205 0 0);
  --sidebar-foreground: oklch(0.985 0 0);
  --sidebar-primary: oklch(0.488 0.243 264.376);
  --sidebar-primary-foreground: oklch(0.985 0 0);
  --sidebar-accent: oklch(0.269 0 0);
  --sidebar-accent-foreground: oklch(0.985 0 0);
  --sidebar-border: oklch(1 0 0 / 10%);
  --sidebar-ring: oklch(0.556 0 0);
}
''';

void main() {
  group('parseShadcnCss', () {
    test('extracts light and dark token maps', () {
      final themes = parseShadcnCss(_sampleCss);
      expect(themes['light']!['background'], equals('oklch(1 0 0)'));
      expect(themes['dark']!['background'], equals('oklch(0.145 0 0)'));
      expect(themes['light']!['radius'], equals('0.625rem'));
    });

    test('missing .dark block throws', () {
      expect(
        () => parseShadcnCss(':root { --background: oklch(1 0 0); }'),
        throwsFormatException,
      );
    });
  });

  group('oklchToArgb', () {
    test('white and black anchors are exact', () {
      expect(oklchToArgb('oklch(1 0 0)'), equals(0xFFFFFFFF));
      expect(oklchToArgb('oklch(0 0 0)'), equals(0xFF000000));
    });

    test('CSS red anchor lands within rounding tolerance', () {
      // CSS `red` == oklch(0.62796 0.25768 29.23388).
      final argb = oklchToArgb('oklch(0.62796 0.25768 29.23388)');
      expect(((argb >> 16) & 0xFF) - 0xFF, inInclusiveRange(-2, 2));
      expect((argb >> 8) & 0xFF, inInclusiveRange(0, 2));
      expect(argb & 0xFF, inInclusiveRange(0, 2));
    });

    test('slash alpha becomes the alpha channel', () {
      expect(
        oklchToArgb('oklch(1 0 0 / 10%)'),
        equals(0x1AFFFFFF),
        reason: 'dark shadcn border is white at 10% opacity',
      );
    });

    test('known shadcn neutrals match their published hex', () {
      expect(oklchToArgb('oklch(0.145 0 0)'), equals(0xFF0A0A0A));
      expect(oklchToArgb('oklch(0.985 0 0)'), equals(0xFFFAFAFA));
      expect(oklchToArgb('oklch(0.922 0 0)'), equals(0xFFE5E5E5));
      expect(oklchToArgb('oklch(0.556 0 0)'), equals(0xFF737373));
    });

    test('shadcn destructive reds match', () {
      expect(
        oklchToArgb('oklch(0.577 0.245 27.325)'),
        equals(0xFFE7000B),
      );
      expect(
        oklchToArgb('oklch(0.704 0.191 22.216)'),
        equals(0xFFFF6467),
      );
    });

    test('garbage input throws', () {
      expect(() => oklchToArgb('#fff'), throwsFormatException);
    });
  });

  group('parseRadius', () {
    test('rem converts at 16px per rem', () {
      expect(parseRadius('0.625rem'), equals(10.0));
    });
  });

  group('generateThemeDart', () {
    late String dart;
    setUp(() {
      final themes = parseShadcnCss(_sampleCss);
      dart = generateThemeDart(
        light: themes['light']!,
        dark: themes['dark']!,
        sourcePath: 'test.css',
      );
    });

    test('emits both token bags with header', () {
      expect(dart, contains('ShadcnLight'));
      expect(dart, contains('ShadcnDark'));
      expect(dart, contains('do not edit by hand'));
      expect(dart, contains('Source: test.css'));
    });

    test('emits ThemeData with the ColorScheme mapping', () {
      expect(dart, contains('static ThemeData get theme'));
      expect(dart, contains('brightness: Brightness.light'));
      expect(dart, contains('brightness: Brightness.dark'));
      expect(dart, contains('scaffoldBackgroundColor: background'));
      expect(dart, contains('onSurfaceVariant: mutedForeground'));
      expect(dart, contains('static const double radius = 10.0'));
    });

    test('derived onError contrasts with destructive in both themes', () {
      // Light destructive is dark red → light on-color; dark destructive
      // is salmon → dark on-color.
      final lightOnError = RegExp(
        r'error: destructive,\n\s*onError: Color\((0x[0-9A-F]+)\)',
      ).allMatches(dart).map((m) => int.parse(m.group(1)!)).toList();
      expect(lightOnError, hasLength(2));
      expect(
        relativeLuminance(lightOnError[0]),
        greaterThan(relativeLuminance(0xFFE7000B)),
        reason: 'light onError must be lighter than its destructive bg',
      );
      expect(
        relativeLuminance(lightOnError[1]),
        lessThan(relativeLuminance(0xFFFF6467)),
        reason: 'dark onError must be darker than its destructive bg',
      );
    });

    test('missing token throws with the token name', () {
      final themes = parseShadcnCss(_sampleCss);
      final broken = Map<String, String>.from(themes['light']!)
        ..remove('destructive');
      expect(
        () => generateThemeDart(
          light: broken,
          dark: themes['dark']!,
          sourcePath: 'x',
        ),
        throwsA(
          isFormatException.having(
            (e) => e.message,
            'message',
            contains('destructive'),
          ),
        ),
      );
    });
  });
}
