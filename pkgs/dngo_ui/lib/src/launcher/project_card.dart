import 'package:dartnative/dartnative.dart';
import 'package:dngo_api/host_api.dart';

import '../theme/host_ui_theme.dart';

enum ProjectPosition {
  first,
  firstAndLast,
  middle,
  last;

  /// Row position for [index] in a list of [length] items.
  static ProjectPosition at(int index, int length) {
    if (length <= 1) return ProjectPosition.firstAndLast;
    if (index == 0) return ProjectPosition.first;
    if (index == length - 1) return ProjectPosition.last;
    return ProjectPosition.middle;
  }
}

/// Card item representing a discovered or recent project.
///
/// Pressed state scales slightly and tints the row for click feedback.
class ProjectCard extends StatefulWidget {
  final DartGoProject project;

  /// `Function`, not `ValueChanged`: guest closures are `dynamic Function()`.
  final Function onTap;

  /// Optional long-press handler (project actions / DevTools sheet).
  final Function? onLongPress;

  /// When true and [project.isActive], shows the Online pill. Recent lists
  /// pass false so status lives only in the active-servers section.
  final bool showActiveBadge;

  final ProjectPosition position;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onLongPress,
    this.showActiveBadge = true,
    required this.position,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final project = widget.project;
    final showOnline = widget.showActiveBadge && project.isActive;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () => widget.onTap(project),
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              _setPressed(false);
              widget.onLongPress!(project);
            },
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: widget.position == ProjectPosition.firstAndLast
              ? BorderRadius.circular(15)
              : BorderRadius.vertical(
                  bottom: widget.position == ProjectPosition.last
                      ? Radius.circular(20)
                      : Radius.circular(0),
                  top: widget.position == ProjectPosition.first
                      ? Radius.circular(20)
                      : Radius.circular(0),
                ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              // color: _pressed ? theme.muted.withOpacity(0.55) : null,
              color: theme.secondary,
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    // border: Border.all(color: theme.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.project.iconUrl != null
                      ? Image.network(
                          widget.project.iconUrl!,
                          key: ValueKey(widget.project.iconUrl!),
                          cachePolicy: ImageCachePolicy.standard,
                        )
                      : Image.asset(
                          'assets/dn-logo.png',
                          fit: BoxFit.contain,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                      const SizedBox(height: 3),
                      Text(
                        project.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Courier',
                          color: theme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (showOnline)
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
                    size: 20,
                    color: theme.mutedForeground,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
