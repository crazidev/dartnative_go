import 'package:dartnative/dartnative.dart';

import 'package:dartnative_go_ui/dartnative_go_ui.dart';
import '../interpreter/debug_controller.dart';

/// Top-centered on-screen overlay displayed when execution is paused at a breakpoint.
///
/// Features:
/// 1. Floating pill at the top center of the screen.
/// 2. Clear location display (`file:line`).
/// 3. Responsive **Continue** button to resume execution directly from the device.
class BreakpointOverlay extends StatelessWidget {
  final BreakpointHitEvent hit;
  final VoidCallback onContinue;

  const BreakpointOverlay({
    super.key,
    required this.hit,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final fileName = widgetFileName(hit.file);
    final line = hit.line?.toString() ?? '?';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: theme.card.withOpacity(0.96),
              borderRadius: theme.radius.xl,
              border: Border.all(
                color: const Color(0xFFFF9F0A),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Amber Status Indicator Dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9F0A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),

                // Location Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'PAUSED AT BREAKPOINT',
                      style: TextStyle(
                        color: Color(0xFFFF9F0A),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '$fileName:$line',
                      style: TextStyle(
                        color: theme.cardForeground,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // Continue Button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('▶️ [UI] Continue button tapped on screen');
                    onContinue();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.play_fill,
                          size: 13,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  static String widgetFileName(String? raw) {
    if (raw == null || raw.isEmpty) return 'unknown';
    final clean = raw.replaceAll(r'\', '/');
    return clean.contains('/') ? clean.split('/').last : clean;
  }
}
