import 'package:dartnative/dartnative.dart';

import '../client/project_model.dart';
import 'launcher_app_bar.dart';
import 'recent_projects_list.dart';
import 'server_url_input.dart';

/// Launcher home screen when no guest project is actively mounted.
class LauncherScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return App(
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: LauncherAppBar(
          onRescan: onRescan,
          onCycleMode: onCycleMode,
          runtimeModeLabel: runtimeModeLabel,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Development Servers',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ServerUrlInput(
                      controller: urlController,
                      onSubmitted: onUrlSubmitted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RecentProjectsList(
                projects: projects,
                isLoading: isLoading,
                onSelectProject: onSelectProject,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
