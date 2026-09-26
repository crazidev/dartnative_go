import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import '../client/theme_storage.dart';

/// The app-wide theme state, owned by Riverpod.
///
/// The initial state is the persisted [ThemeStorage] value, preloaded in
/// `main()` before `runApp` so the first frame already uses the right theme.
/// Every mutation persists and pins the native appearance via
/// [setAppBrightness] (best-effort: framework shims throw on the host VM,
/// where there is no native appearance to pin).
final themePreferenceProvider =
    NotifierProvider<ThemeController, ThemePreference>(ThemeController.new);

class ThemeController extends Notifier<ThemePreference> {
  @override
  ThemePreference build() => ThemeStorage.currentPreference;

  Future<void> setPreference(ThemePreference preference) async {
    state = preference;
    await ThemeStorage.savePreference(preference);
    _applyNativeAppearance(preference);
  }

  /// Cycles system → light → dark → system.
  Future<void> cycle() {
    return setPreference(switch (state) {
      ThemePreference.system => ThemePreference.light,
      ThemePreference.light => ThemePreference.dark,
      ThemePreference.dark => ThemePreference.system,
    });
  }

  /// Applies a preference loaded outside the provider (startup preload).
  static void applyNativeAppearance(ThemePreference preference) {
    _applyNativeAppearance(preference);
  }

  static void _applyNativeAppearance(ThemePreference preference) {
    try {
      setAppBrightness(switch (preference) {
        ThemePreference.light => Brightness.light,
        ThemePreference.dark => Brightness.dark,
        ThemePreference.system => null,
      });
    } catch (_) {
      // Host VM / headless tests: no native appearance exists.
    }
  }
}

/// Maps a preference to the framework [ThemeMode] for `App.themeMode`.
ThemeMode themeModeOf(ThemePreference preference) => switch (preference) {
  ThemePreference.system => ThemeMode.system,
  ThemePreference.light => ThemeMode.light,
  ThemePreference.dark => ThemeMode.dark,
};
