import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/client/theme_storage.dart';
import 'package:dartnative_go/src/theme/shadcn_theme.dart';
import 'package:dartnative_go/src/theme/theme_providers.dart';
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
      expect(
        color.resolve(Brightness.light).value,
        equals(ShadcnLight.background.value),
      );
      expect(
        color.resolve(Brightness.dark).value,
        equals(ShadcnDark.background.value),
      );
    });

    test('ShadcnTokens exposes dual-tone tokens', () {
      expect(
        ShadcnTokens.background.light.value,
        equals(ShadcnLight.background.value),
      );
      expect(
        ShadcnTokens.background.dark.value,
        equals(ShadcnDark.background.value),
      );
      expect(
        ShadcnTokens.foreground.light.value,
        equals(ShadcnLight.foreground.value),
      );
      expect(
        ShadcnTokens.foreground.dark.value,
        equals(ShadcnDark.foreground.value),
      );
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

      expect(
        ShadcnThemeData.fromBrightness(Brightness.light).background.value,
        equals(ShadcnLight.background.value),
      );
      expect(
        ShadcnThemeData.fromBrightness(Brightness.dark).background.value,
        equals(ShadcnDark.background.value),
      );
    });
  });

  group('ShadcnAppearanceMode', () {
    test('maps to ThemeMode and native Brightness', () {
      expect(
        ShadcnAppearanceMode.system.toThemeMode(),
        equals(ThemeMode.system),
      );
      expect(ShadcnAppearanceMode.light.toThemeMode(), equals(ThemeMode.light));
      expect(ShadcnAppearanceMode.dark.toThemeMode(), equals(ThemeMode.dark));

      expect(ShadcnAppearanceMode.system.toNativeBrightness(), isNull);
      expect(
        ShadcnAppearanceMode.light.toNativeBrightness(),
        equals(Brightness.light),
      );
      expect(
        ShadcnAppearanceMode.dark.toNativeBrightness(),
        equals(Brightness.dark),
      );
    });
  });

  group('theme preference mapping', () {
    test('themeModeOf maps every preference', () {
      expect(themeModeOf(ThemePreference.system), equals(ThemeMode.system));
      expect(themeModeOf(ThemePreference.light), equals(ThemeMode.light));
      expect(themeModeOf(ThemePreference.dark), equals(ThemeMode.dark));
    });

    test('resolveAppearance turns system into a concrete mode', () {
      expect(
        resolveAppearance(ThemePreference.system, Brightness.dark),
        equals(ShadcnAppearanceMode.dark),
      );
      expect(
        resolveAppearance(ThemePreference.system, Brightness.light),
        equals(ShadcnAppearanceMode.light),
      );
    });

    test('resolveAppearance honours an explicit preference', () {
      expect(
        resolveAppearance(ThemePreference.light, Brightness.dark),
        equals(ShadcnAppearanceMode.light),
        reason: 'an explicit light choice ignores the device',
      );
      expect(
        resolveAppearance(ThemePreference.dark, Brightness.light),
        equals(ShadcnAppearanceMode.dark),
      );
    });

    test('resolveAppearance never returns system', () {
      for (final preference in ThemePreference.values) {
        for (final brightness in Brightness.values) {
          expect(
            resolveAppearance(preference, brightness),
            isNot(equals(ShadcnAppearanceMode.system)),
            reason: 'the shell must hand a concrete mode to ShadcnTheme',
          );
        }
      }
    });
  });

  group('ThemeStorage cache', () {
    tearDown(ThemeStorage.resetForTesting);

    test('currentPreference falls back to system when cold', () {
      ThemeStorage.resetForTesting();
      expect(ThemeStorage.isLoaded, isFalse);
      expect(ThemeStorage.currentPreference, ThemePreference.system);
    });

    test('isLoaded reports a warm cache and returns the saved value', () {
      ThemeStorage.resetForTesting(ThemePreference.dark);
      expect(ThemeStorage.isLoaded, isTrue);
      expect(ThemeStorage.currentPreference, ThemePreference.dark);
    });
  });
}
