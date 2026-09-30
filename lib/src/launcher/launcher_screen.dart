import 'package:dartnative/dartnative.dart' hide Button;
import 'package:riverpod_kit/riverpod_kit.dart';

import '../client/project_model.dart';
import '../client/theme_storage.dart';
import '../theme/launcher_theme.dart';
import '../theme/shadcn_theme.dart';
import '../theme/theme_providers.dart';
import 'launcher_app_bar.dart';
import 'recent_projects_list.dart';
import 'server_url_input.dart';

/// Launcher home screen when no guest project is actively mounted.
class LauncherScreen extends StatefulWidget {
  final List<DartGoProject> projects;
  final bool isLoading;
  final TextEditingController urlController;
  final ValueChanged<String> onUrlSubmitted;
  final ValueChanged<DartGoProject> onSelectProject;
  final VoidCallback onRescan;
  final VoidCallback? onCycleMode;
  final String? runtimeModeLabel;

  const LauncherScreen({
    super.key,
    required this.projects,
    required this.isLoading,
    required this.urlController,
    required this.onUrlSubmitted,
    required this.onSelectProject,
    required this.onRescan,
    this.onCycleMode,
    this.runtimeModeLabel,
  });

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LauncherScreen oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final preference = ref.watch(themePreferenceProvider);
        final appearanceMode = switch (preference) {
          ThemePreference.system => ShadcnAppearanceMode.system,
          ThemePreference.light => ShadcnAppearanceMode.light,
          ThemePreference.dark => ShadcnAppearanceMode.dark,
        };

        return App(
          home: ShadcnTheme(
            mode: appearanceMode,
            child: Builder(
              builder: (context) {
                final theme = context.theme;
                final colors = LauncherColors.fromTheme(theme);
                return Scaffold(
                  backgroundColor: theme.background,
                  brightness: theme.brightness,
                  appBar: LauncherAppBar(
                    onRescan: widget.onRescan,
                    colors: colors,
                    onChangeTheme: () =>
                        ref.read(themePreferenceProvider.notifier).cycle(),
                    onCycleMode: widget.onCycleMode,
                    runtimeModeLabel: widget.runtimeModeLabel,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Development Server',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Connect to an active DartNative local dev server.',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ServerUrlInput(
                          controller: widget.urlController,
                          onSubmitted: widget.onUrlSubmitted,
                          colors: colors,
                        ),
                        const SizedBox(height: 32),
                        // Button.root(
                        //   onPressed: () => {},
                        //   child: const Text('Submit'),
                        // ),
                        RecentProjectsList(
                          projects: widget.projects,
                          isLoading: widget.isLoading,
                          onSelectProject: widget.onSelectProject,
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
