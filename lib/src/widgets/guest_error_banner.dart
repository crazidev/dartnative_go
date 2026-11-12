import 'package:dartnative/dartnative.dart';

import '../theme/shadcn_theme.dart';

/// Dismissible error banner over the still-running guest app.
///
/// Automatic failure surface (no full-screen flash). Tap opens
/// `InterpreterErrorView`; close dismisses; ↻ restarts. Cleared on recovery.
class GuestErrorBanner extends StatelessWidget {
  /// The failure's cause, already stripped of host/interpreter framing.
  final String errorMessage;

  /// The exception type (`Argument Error`, …), shown as a small label. Null
  /// when the message names none.
  final String? errorType;

  final VoidCallback onOpen;
  final VoidCallback onDismiss;
  final VoidCallback onRestart;

  const GuestErrorBanner({
    super.key,
    required this.errorMessage,
    this.errorType,
    required this.onOpen,
    required this.onDismiss,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final summary = errorMessage.split('\n').first;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onOpen,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.card.withOpacity(0.96),
              borderRadius: theme.radius.lg,
              border: Border.all(color: theme.destructive, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        color: theme.destructive,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.cardForeground,
                          fontSize: 12,
                          fontFamily: 'Courier',
                          height: 1.35,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onRestart,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          CupertinoIcons.arrow_clockwise,
                          color: theme.mutedForeground,
                          size: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onDismiss,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: theme.mutedForeground,
                          size: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2),
                      child: Icon(
                        CupertinoIcons.chevron_forward,
                        color: theme.mutedForeground,
                        size: 14,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 26),
                  child: Text(
                    // The type names the failure; the line above says why.
                    errorType == null
                        ? 'Tap for details · working app kept running'
                        : '$errorType · Tap for details',
                    style: TextStyle(
                      color: theme.mutedForeground,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
