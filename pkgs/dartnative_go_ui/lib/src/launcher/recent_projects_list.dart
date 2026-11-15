import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go_api/host_api.dart';

import '../theme/host_ui_theme.dart';
import 'project_card.dart';

/// Section rendering recent and scanned development projects.
class RecentProjectsList extends StatelessWidget {
  final List<DartGoProject> projects;
  final bool isLoading;

  /// `Function`, not `ValueChanged`: guest closures are `dynamic Function()`.
  final Function onSelectProject;

  const RecentProjectsList({
    super.key,
    required this.projects,
    required this.isLoading,
    required this.onSelectProject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    // print(projects);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Projects',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.foreground,
          ),
        ),
        const SizedBox(height: 12),
        if (projects.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLoading
                      ? CupertinoIcons.arrow_2_circlepath
                      : CupertinoIcons.tray,
                  size: 50,
                  color: theme.mutedForeground,
                ),
                const SizedBox(height: 12),
                Text(
                  isLoading
                      ? 'Scanning local networks...'
                      : 'No projects detected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.cardForeground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoading
                      ? 'Probing subnet on ports 8088..8098'
                      : 'Start a DartNative server or enter a URL above.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ListView.separated(
          itemCount: projects.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(
            color: theme.background,
            height: 10,
          ),
          itemBuilder: (context, index) => ProjectCard(
            project: projects[index],
            onTap: onSelectProject,
          ),
        ),
      ],
    );
  }
}
