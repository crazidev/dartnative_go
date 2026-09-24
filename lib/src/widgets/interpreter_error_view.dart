import 'dart:async';

import 'package:dartnative/dartnative.dart';

/// A styled full-screen error display for runtime and evaluation errors
/// encountered while running interpreted guest code in DartNative Go.
class InterpreterErrorView extends StatefulWidget {
  final String errorMessage;
  final String? stackTrace;
  final VoidCallback onGoHome;
  final VoidCallback onRetry;
  final void Function(String error)? onLogToTerminal;

  const InterpreterErrorView({
    super.key,
    required this.errorMessage,
    this.stackTrace,
    required this.onGoHome,
    required this.onRetry,
    this.onLogToTerminal,
  });

  @override
  State<InterpreterErrorView> createState() => _InterpreterErrorViewState();
}

class _InterpreterErrorViewState extends State<InterpreterErrorView> {
  bool _isCopied = false;
  Timer? _copyResetTimer;

  @override
  void initState() {
    super.initState();
    // Automatically dispatch the error to the logs upon mounting
    widget.onLogToTerminal?.call(widget.errorMessage);
  }

  @override
  void didUpdateWidget(InterpreterErrorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.errorMessage != widget.errorMessage) {
      widget.onLogToTerminal?.call(widget.errorMessage);
    }
  }

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    super.dispose();
  }

  String get _fullErrorText => widget.stackTrace == null
      ? widget.errorMessage
      : '${widget.errorMessage}\n\n${widget.stackTrace}';

  void _copyError() {
    try {
      Clipboard.setData(ClipboardData(text: _fullErrorText));
    } catch (_) {
      // Fallback if clipboard platform channel is unavailable
    }

    widget.onLogToTerminal?.call(widget.errorMessage);

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Interpreter Error',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error Header Banner
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF321417),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        color: Color(0xFFFF453A),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Evaluation Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Runtime exception during interpreted execution',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error Code / Trace Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1012),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF2C1619),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Bar with Copy Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF16181D),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'ERROR LOG',
                              style: TextStyle(
                                color: Color(0xFFFF453A),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const Spacer(),
                            // Interactive Copy Button
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _copyError,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _isCopied
                                      ? const Color(0xFF1C3A27)
                                      : const Color(0xFF22252B),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _isCopied
                                        ? const Color(0xFF34C759)
                                        : const Color(0xFF383B42),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isCopied
                                          ? CupertinoIcons.checkmark_alt
                                          : CupertinoIcons.doc_on_doc,
                                      size: 13,
                                      color: _isCopied
                                          ? const Color(0xFF34C759)
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _isCopied ? 'Copied' : 'Copy',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _isCopied
                                            ? const Color(0xFF34C759)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Error Text Content
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          widget.errorMessage,
                          style: const TextStyle(
                            color: Color(0xFFFF8B8B),
                            fontSize: 12,
                            fontFamily: 'Courier',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.stackTrace != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1012),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF2C2C2E),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF16181D),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'STACK TRACE',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            widget.stackTrace!,
                            style: const TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 11,
                              fontFamily: 'Courier',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Primary Actions: Retry & Back to Launcher
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        title: 'Reload again',
                        variant: ButtonVariant.filled,
                        color: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        onPressed: widget.onRetry,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Button(
                        title: 'Back to Home',
                        variant: ButtonVariant.bordered,
                        color: Colors.white24,
                        foregroundColor: Colors.white,
                        onPressed: widget.onGoHome,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Helper Footer Note
                const Center(
                  child: Text(
                    'Error has been sent to the live dev server terminal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
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
