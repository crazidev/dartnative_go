import 'package:dartnative/dartnative.dart' hide Button;
import 'package:riverpod_kit/riverpod_kit.dart';

import '../client/project_model.dart';
import '../theme/shadcn_theme.dart';
import '../theme/theme_providers.dart';
import 'launcher_app_bar.dart';
import 'recent_projects_list.dart';
import 'server_url_input.dart';

/// Launcher home screen when no guest project is actively mounted.
///
/// This is the root route of the host [App] (see `lib/main.dart`); opening a
/// project pushes a separate route for the launch/preview instead of swapping
/// this screen's content.
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
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          backgroundColor: theme.background,
          // Omit brightness so Scaffold doesn't override MediaQuery theme inheritance.
          appBar: LauncherAppBar(
            onRescan: widget.onRescan,
            onChangeTheme: () =>
                ref.read(themePreferenceProvider.notifier).cycle(),
            onCycleMode: widget.onCycleMode,
            runtimeModeLabel: widget.runtimeModeLabel,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                ),
                const SizedBox(height: 32),
                RecentProjectsList(
                  projects: widget.projects,
                  isLoading: widget.isLoading,
                  onSelectProject: widget.onSelectProject,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
