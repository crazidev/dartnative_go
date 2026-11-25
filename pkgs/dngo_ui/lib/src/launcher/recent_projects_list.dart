import 'package:dartnative/dartnative.dart';
import 'package:dngo_api/host_api.dart';

import '../theme/host_ui_theme.dart';
import 'project_card.dart';

/// Section rendering recent projects the user has opened.
///
/// Includes active servers too, but never shows the Online badge — that
/// status belongs in the Development Server active list.
class RecentProjectsList extends StatelessWidget {
  final List<DartGoProject> projects;
  final bool isLoading;

  /// `Function`, not `ValueChanged`: guest closures are `dynamic Function()`.
  final Function onSelectProject;

  /// Long-press opens the project DevTools / actions sheet.
  final Function? onLongPressProject;

  const RecentProjectsList({
    super.key,
    required this.projects,
    required this.isLoading,
    required this.onSelectProject,
    this.onLongPressProject,
  });

  static const int _maxRecentProjects = 5;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    // [projects] is most-recently-opened first — keep the newest five.
    final visible = projects.length <= _maxRecentProjects
        ? projects
        : projects.sublist(0, _maxRecentProjects);

    if (visible.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Projects'.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: theme.mutedForeground,
          ),
        ),
        const SizedBox(height: 7),

        ListView.separated(
          itemCount: visible.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              Divider(color: theme.background, height: 2, thickness: 2),
          itemBuilder: (context, index) => ProjectCard(
            project: visible[index],
            showActiveBadge: false,
            onTap: onSelectProject,
            position: ProjectPosition.at(index, visible.length),
            onLongPress: onLongPressProject,
          ),
        ),
      ],
    );
  }
}
