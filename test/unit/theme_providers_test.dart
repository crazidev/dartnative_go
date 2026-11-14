import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go_ui/dartnative_go_ui.dart';
import 'package:dartnative_go/src/theme/theme_providers.dart';
import 'package:test/test.dart';

void main() {
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
}
