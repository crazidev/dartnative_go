import 'package:dartnative/dartnative.dart';

import '../client/project_model.dart';
import '../theme/shadcn_theme.dart';
import 'project_card.dart';

/// Section rendering recent and scanned development projects styled per shadcn.
class RecentProjectsList extends StatelessWidget {
  final List<DartGoProject> projects;
  final bool isLoading;
  final ValueChanged<DartGoProject> onSelectProject;

  const RecentProjectsList({
    super.key,
    required this.projects,
    required this.isLoading,
    required this.onSelectProject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Projects',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.foreground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (projects.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              borderRadius: theme.radius.lg,
            ),
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
          )
        else
          ...List.generate(
            projects.length,
            (index) {
              var project = projects[index];
              var isFirst = index == 0;
              var divider = Divider(
                color: context.theme.background,
                height: 10,
              );

              return Column(
                key: ValueKey(project.url),
                children: [
                  ?(!isFirst ? divider : null),
                  ProjectCard(
                    project: project,
                    onTap: onSelectProject,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
