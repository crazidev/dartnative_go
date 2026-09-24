import 'package:dartnative/dartnative.dart';

import '../client/project_model.dart';
import 'project_card.dart';

/// Section rendering recent and scanned development projects.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Projects',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        if (projects.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              isLoading
                  ? 'Scanning connected networks (8088..8098)...'
                  : 'No active or recent projects found.',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white38,
              ),
            ),
          )
        else
          ...projects.map(
            (project) => ProjectCard(
              project: project,
              onTap: onSelectProject,
            ),
          ),
      ],
    );
  }
}
