import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/theme/launcher_theme.dart';
import 'package:dartnative_go/src/theme/shadcn_theme.dart';
import 'package:test/test.dart';

void main() {
  group('ShadcnColor', () {
    test('resolves light and dark correctly', () {
      const color = ShadcnColor(
        light: ShadcnLight.background,
        dark: ShadcnDark.background,
      );

      expect(color.light.value, equals(ShadcnLight.background.value));
      expect(color.dark.value, equals(ShadcnDark.background.value));
      expect(color.resolve(Brightness.light).value, equals(ShadcnLight.background.value));
      expect(color.resolve(Brightness.dark).value, equals(ShadcnDark.background.value));
    });

    test('ShadcnTokens exposes dual-tone tokens', () {
      expect(ShadcnTokens.background.light.value, equals(ShadcnLight.background.value));
      expect(ShadcnTokens.background.dark.value, equals(ShadcnDark.background.value));
      expect(ShadcnTokens.foreground.light.value, equals(ShadcnLight.foreground.value));
      expect(ShadcnTokens.foreground.dark.value, equals(ShadcnDark.foreground.value));
    });
  });

  group('ShadcnSize & ShadcnRadius', () {
    test('ShadcnSize.px formats and converts', () {
      const size = ShadcnSize.px(10.0);
      expect(size.value, equals(10.0));
      expect(size.toDouble(), equals(10.0));
      expect(size.toString(), equals('10.0px'));
    });

    test('ShadcnRadius computes correct values', () {
      const radius = ShadcnRadius(10.0);
      expect(radius.none.topLeft.x, equals(0.0));
      expect(radius.sm.topLeft.x, equals(6.0));
      expect(radius.md.topLeft.x, equals(8.0));
      expect(radius.lg.topLeft.x, equals(10.0));
      expect(radius.xl.topLeft.x, equals(14.0));
      expect(radius.full.topLeft.x, equals(9999.0));
      expect(radius.px(20.0).topLeft.x, equals(20.0));
    });
  });

  group('ShadcnThemeData', () {
    test('light and dark presets match token definitions', () {
      final light = ShadcnThemeData.light;
      final dark = ShadcnThemeData.dark;

      expect(light.isLight, isTrue);
      expect(light.isDark, isFalse);
      expect(light.background.value, equals(ShadcnLight.background.value));
      expect(light.foreground.value, equals(ShadcnLight.foreground.value));

      expect(dark.isDark, isTrue);
      expect(dark.isLight, isFalse);
      expect(dark.background.value, equals(ShadcnDark.background.value));
      expect(dark.foreground.value, equals(ShadcnDark.foreground.value));

      expect(ShadcnThemeData.fromBrightness(Brightness.light).background.value, equals(ShadcnLight.background.value));
      expect(ShadcnThemeData.fromBrightness(Brightness.dark).background.value, equals(ShadcnDark.background.value));
    });
  });

  group('ShadcnAppearanceMode', () {
    test('maps to ThemeMode and native Brightness', () {
      expect(ShadcnAppearanceMode.system.toThemeMode(), equals(ThemeMode.system));
      expect(ShadcnAppearanceMode.light.toThemeMode(), equals(ThemeMode.light));
      expect(ShadcnAppearanceMode.dark.toThemeMode(), equals(ThemeMode.dark));

      expect(ShadcnAppearanceMode.system.toNativeBrightness(), isNull);
      expect(ShadcnAppearanceMode.light.toNativeBrightness(), equals(Brightness.light));
      expect(ShadcnAppearanceMode.dark.toNativeBrightness(), equals(Brightness.dark));
    });
  });

  group('LauncherColors', () {
    test('fromTheme maps all properties from ShadcnThemeData', () {
      final lightColors = LauncherColors.fromTheme(ShadcnThemeData.light);
      expect(lightColors.background.value, equals(ShadcnLight.background.value));
      expect(lightColors.foreground.value, equals(ShadcnLight.foreground.value));
      expect(lightColors.card.value, equals(ShadcnLight.card.value));
      expect(lightColors.input.value, equals(ShadcnLight.input.value));
      expect(lightColors.mutedForeground.value, equals(ShadcnLight.mutedForeground.value));

      final darkColors = LauncherColors.fromTheme(ShadcnThemeData.dark);
      expect(darkColors.background.value, equals(ShadcnDark.background.value));
      expect(darkColors.foreground.value, equals(ShadcnDark.foreground.value));
      expect(darkColors.card.value, equals(ShadcnDark.card.value));
      expect(darkColors.input.value, equals(ShadcnDark.input.value));
      expect(darkColors.mutedForeground.value, equals(ShadcnDark.mutedForeground.value));
    });
  });
}
