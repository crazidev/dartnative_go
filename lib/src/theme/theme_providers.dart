import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'package:dartnative_go_ui/dartnative_go_ui.dart';

final themePreferenceProvider =
    NotifierProvider<ThemeController, ThemePreference>(ThemeController.new);

class ThemeController extends Notifier<ThemePreference> {
  @override
  ThemePreference build() {
    // Hydrate cold cache asynchronously if startup preload was skipped.
    if (!ThemeStorage.isLoaded) unawaited(_hydrateFromStorage());
    return ThemeStorage.currentPreference;
  }

  Future<void> _hydrateFromStorage() async {
    final persisted = await ThemeStorage.loadPreference();

    if (persisted == state) return;
    state = persisted;
    _applyNativeAppearance(persisted);
  }

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

ThemeMode themeModeOf(ThemePreference preference) => switch (preference) {
  ThemePreference.system => ThemeMode.system,
  ThemePreference.light => ThemeMode.light,
  ThemePreference.dark => ThemeMode.dark,
};

ShadcnAppearanceMode resolveAppearance(
  ThemePreference preference,
  Brightness platformBrightness,
) => switch (preference) {
  ThemePreference.system =>
    platformBrightness == Brightness.dark
        ? ShadcnAppearanceMode.dark
        : ShadcnAppearanceMode.light,
  ThemePreference.light => ShadcnAppearanceMode.light,
  ThemePreference.dark => ShadcnAppearanceMode.dark,
};

class ShellThemeScope extends ConsumerStatefulWidget {
  const ShellThemeScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ShellThemeScope> createState() => _ShellThemeScopeState();
}

class _ShellThemeScopeState extends ConsumerState<ShellThemeScope> {
  /// Resolves platform brightness with Theme fallback for headless testing.
  Brightness _systemBrightness(BuildContext context) {
    try {
      return MediaQuery.of(context).platformBrightness;
    } catch (_) {
      try {
        return Theme.of(context).brightness;
      } catch (_) {
        return Brightness.light;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preference = ref.watch(themePreferenceProvider);
    final brightness = _systemBrightness(context);

    return ShadcnTheme(
      mode: resolveAppearance(preference, brightness),
      child: widget.child,
    );
  }
}
