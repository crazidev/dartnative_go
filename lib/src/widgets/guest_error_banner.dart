import 'package:dartnative/dartnative.dart';

/// Dismissible error banner rendered on top of the working guest app.
///
/// Used when [ErrorDisplayMode.overlay] is active: the failure is visible
/// without unmounting the tree behind it. Tapping the banner expands the
/// full message; the close button dismisses it. A successful reload clears
/// it automatically (the host nulls the error on success).
class GuestErrorBanner extends StatefulWidget {
  final String errorMessage;
  final String? stackTrace;
  final VoidCallback onDismiss;
  final VoidCallback onRestart;

  const GuestErrorBanner({
    super.key,
    required this.errorMessage,
    this.stackTrace,
    required this.onDismiss,
    required this.onRestart,
  });

  @override
  State<GuestErrorBanner> createState() => _GuestErrorBannerState();
}

class _GuestErrorBannerState extends State<GuestErrorBanner> {
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant GuestErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.errorMessage != widget.errorMessage ||
        oldWidget.stackTrace != widget.stackTrace) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.errorMessage.split('\n');
    final summary = lines.first;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF321417).withOpacity(0.96),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF453A), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        color: Color(0xFFFF453A),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _expanded ? widget.errorMessage : summary,
                            maxLines: _expanded ? null : 2,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Courier',
                              height: 1.35,
                            ),
                          ),
                          if (_expanded && widget.stackTrace != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              constraints: const BoxConstraints(maxHeight: 220),
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.stackTrace!,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontFamily: 'Courier',
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onRestart,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          CupertinoIcons.arrow_clockwise,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onDismiss,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_expanded)
                  const Padding(
                    padding: EdgeInsets.only(top: 2, left: 26),
                    child: Text(
                      'Tap to expand · working app kept running',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
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
