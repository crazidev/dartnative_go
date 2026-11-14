import 'dart:async';

import 'package:dartnative/dartnative.dart';

import '../runner/guest_error_format.dart';
import '../theme/shadcn_theme.dart';

/// Full-screen error display for guest runtime and evaluation failures.
///
/// Colours follow `context.theme` (light or dark).
class InterpreterErrorView extends StatefulWidget {
  final String errorMessage;
  final String? stackTrace;
  final VoidCallback onGoHome;
  final VoidCallback onRetry;

  /// Optional close action (banner-opened case); returns to the running app.
  final VoidCallback? onClose;

  /// Header title. Deliberately generic for every failure kind; the stage is
  /// described by [subtitle] instead.
  final String title;

  /// The exception type, e.g. `Argument Error`, shown under [title].
  ///
  /// When null the view falls back to [subtitle].
  final String? errorType;

  /// One-line explanation under [title], e.g. whether the project failed to
  /// load or crashed while running.
  final String subtitle;

  const InterpreterErrorView({
    super.key,
    required this.errorMessage,
    this.stackTrace,
    required this.onGoHome,
    required this.onRetry,
    this.onClose,
    this.title = 'Unhandled Exception',
    this.errorType,
    this.subtitle = 'Runtime exception during execution',
  });

  @override
  State<InterpreterErrorView> createState() => _InterpreterErrorViewState();
}

class _InterpreterErrorViewState extends State<InterpreterErrorView> {
  bool _isCopied = false;
  Timer? _copyResetTimer;

  /// Frames are collapsed past this many; long traces keep the screen usable.
  static const int _collapsedFrameCount = 5;
  bool _showAllFrames = false;

  /// Width of the `#N` gutter. Fixed for every row so the members line up.
  static const double _gutterWidth = 20;
  static const double _gutterGap = 2;

  List<StackFrame> get _frames => parseStackFrames(widget.stackTrace);

  /// Clipboard payload: message (with type) plus stack.
  String get _fullErrorText => buildCopyText(
    title: widget.title,
    message: widget.errorType == null
        ? widget.errorMessage
        : '${widget.errorType}: ${widget.errorMessage}',
    stack: widget.stackTrace,
  );

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    super.dispose();
  }

  void _copyError() {
    try {
      Clipboard.setData(ClipboardData(text: _fullErrorText));
    } catch (_) {
      // Fallback if clipboard platform channel is unavailable
    }

    setState(() {
      _isCopied = true;
    });

    _copyResetTimer?.cancel();
    _copyResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: theme.sidebar,
        brightness: theme.brightness,
        automaticallyImplyLeading: false,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.destructive.withOpacity(0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: theme.destructive,
            size: 20,
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: theme.destructive,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  // The exception type is the subtitle: it says what failed,
                  // while the card below says why.
                  widget.errorType ?? widget.subtitle,
                  style: TextStyle(fontSize: 12, color: theme.mutedForeground),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (widget.onClose != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Icon(
                  CupertinoIcons.xmark,
                  color: theme.mutedForeground,
                  size: 18,
                ),
              ),
            ),
        ],
      ),

      // Actions stay pinned below the scroll area: a load failure takes over
      // the screen, so Retry/Home must be reachable without scrolling.
      bottomAccessory: Container(
        color: theme.sidebar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          child: Row(
            children: [
              Expanded(
                child: Button(
                  title: 'Back to Home',
                  variant: ButtonVariant.bordered,
                  foregroundColor: theme.foreground,
                  onPressed: widget.onGoHome,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  title: 'Reload again',
                  variant: ButtonVariant.filled,
                  color: theme.primary,
                  foregroundColor: theme.primaryForeground,
                  onPressed: widget.onRetry,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ErrorMessageCard(
                    copyError: _copyError,
                    isCopied: _isCopied,
                    errorMessage: widget.errorMessage,
                  ),

                  if (_frames.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildStackCard(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The stack trace card: a fixed `#N` gutter on the left, each frame's method
  /// and its file location stacked on the right.
  ///
  /// The frame block scrolls horizontally and never wraps, so a long
  /// `package:…/file.dart:line:col` stays on one line and can be panned.
  /// Frames are separated by a hairline rule except the last one (and a single
  /// frame gets none).
  Widget _buildStackCard() {
    final theme = context.theme;
    final frames = _frames;
    final collapsed = !_showAllFrames && frames.length > _collapsedFrameCount;
    final visible = collapsed
        ? frames.take(_collapsedFrameCount).toList()
        : frames;
    final hidden = frames.length - _collapsedFrameCount;

    // The rules span the full width of the frame block: the viewport when the
    // content fits, otherwise as wide as the longest line so the rule runs to
    // the end of the scrolled content.
    final viewportWidth = MediaQuery.of(context).size.width - 40 - 28;
    final contentWidth = frames.fold<double>(
      viewportWidth,
      (widest, frame) =>
          widest < _frameWidth(frame) ? _frameWidth(frame) : widest,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: theme.radius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 40,
            // decoration: BoxDecoration(
            //   color: theme.accent,
            // ),
            child: Row(
              children: [
                Text(
                  'STACK TRACE',
                  style: TextStyle(
                    color: theme.mutedForeground,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Text(
                  '${frames.length} '
                  '${frames.length == 1 ? 'frame' : 'frames'}',
                  style: TextStyle(
                    color: theme.mutedForeground.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            showScrollBar: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < visible.length; i++)
                    _buildFrameRow(
                      visible[i],
                      ruleWidth: contentWidth,
                      showRule: visible.length > 1 && i != visible.length - 1,
                    ),
                  if (collapsed)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _showAllFrames = true),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Show $hidden more '
                          '${hidden == 1 ? 'frame' : 'frames'}',
                          style: TextStyle(
                            color: theme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Rough rendered width of a frame's widest line, used to size the rules.
  ///
  /// Courier is monospaced, so a character-count estimate is reliable; the
  /// constant is a generous upper bound on the advance width. Rows are not
  /// forced to this width, so an underestimate can never clip a line — it only
  /// makes a rule slightly shorter than the longest one.
  static double _frameWidth(StackFrame frame) {
    final member = frame.member.isEmpty ? frame.raw : frame.member;
    final memberWidth = member.length * 12.5 * 0.62;
    final locationWidth = frame.hasLocation
        ? frame.location!.length * 11 * 0.62
        : 0.0;
    final textWidth = memberWidth > locationWidth ? memberWidth : locationWidth;
    return _gutterWidth + _gutterGap + textWidth + 4;
  }

  /// One frame: `#N` in the fixed gutter, then the method and its location on
  /// the following line, with a hairline rule beneath (see [showRule]).
  Widget _buildFrameRow(
    StackFrame frame, {
    required double ruleWidth,
    required bool showRule,
  }) {
    final theme = context.theme;
    final isThrowSite = frame.index == 0;
    final memberColor = isThrowSite
        ? theme.foreground
        : frame.isGuest
        ? theme.cardForeground
        : theme.mutedForeground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: _gutterWidth,
              child: Text(
                frame.gutter,
                style: TextStyle(
                  color: isThrowSite
                      ? theme.destructive
                      : theme.mutedForeground.withOpacity(0.75),
                  fontSize: 11,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: _gutterGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    frame.member.isEmpty ? frame.raw : frame.member,
                    selectable: true,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      color: memberColor,
                      fontSize: 12.5,
                      fontFamily: 'Courier',
                      height: 1.35,
                      fontWeight: isThrowSite
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (frame.hasLocation)
                    Text(
                      frame.location!,
                      selectable: true,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        color: theme.mutedForeground,
                        fontSize: 12,
                        fontFamily: 'Courier',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (showRule)
          Container(
            width: ruleWidth,
            height: 1,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            color: theme.border,
          ),
      ],
    );
  }
}

class ErrorMessageCard extends StatelessWidget {
  const ErrorMessageCard({
    super.key,
    required this.copyError,
    required this.isCopied,
    required this.errorMessage,
  });

  final VoidCallback copyError;
  final bool isCopied;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: theme.radius.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 40,
            // decoration: BoxDecoration(
            //   color: theme.secondary,
            // ),
            child: Row(
              children: [
                Text(
                  'ERROR MESSAGE',
                  style: TextStyle(
                    color: theme.mutedForeground,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                // Copies the message *and* the trace (see [_fullErrorText]).
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: copyError,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isCopied
                          ? theme.primary.withOpacity(0.12)
                          : theme.secondary,
                      borderRadius: theme.radius.sm,
                      border: Border.all(
                        color: isCopied ? theme.primary : theme.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCopied
                              ? CupertinoIcons.checkmark_alt
                              : CupertinoIcons.doc_on_doc,
                          size: 13,
                          color: isCopied
                              ? theme.primary
                              : theme.secondaryForeground,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isCopied ? 'Copied' : 'Copy all',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCopied
                                ? theme.primary
                                : theme.secondaryForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              errorMessage,
              selectable: true,
              style: TextStyle(
                color: theme.destructive,
                fontSize: 13,
                fontFamily: 'Courier',
                // height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
