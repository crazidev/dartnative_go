import 'package:dartnative/dartnative.dart';

import '../client/project_model.dart';
import '../theme/launcher_theme.dart';
import '../theme/shadcn_theme.dart';

/// Card item representing a discovered or recent project styled per shadcn.
class ProjectCard extends StatelessWidget {
  final DartGoProject project;
  final ValueChanged<DartGoProject> onTap;
  final LauncherColors? colors;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(project),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(color: context.theme.secondary),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.accent,
                borderRadius: theme.radius.md,
                border: Border.all(color: theme.border, width: 0.5),
              ),
              child: Image.asset(
                'assets/dn-logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          project.appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: theme.cardForeground,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    project.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (project.isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x1F34C759),
                  borderRadius: theme.radius.full,
                  border: Border.all(
                    color: const Color(0x4034C759),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34C759),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34C759),
                      ),
                    ),
                  ],
                ),
              )
            else
              Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: theme.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }
}
