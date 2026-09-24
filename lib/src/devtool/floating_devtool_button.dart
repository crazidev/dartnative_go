import 'package:dartnative/dartnative.dart';

/// A floating, draggable DevTool pill that can be moved anywhere on the screen.
///
/// Features:
/// - Smooth pan gestures (`onPanStart`, `onPanUpdate`, `onPanEnd`) for freeform positioning.
/// - Clamps coordinates to the visible screen area and safe area insets.
/// - Distinct tap vs. drag detection so taps open DevTools without accidental drags.
/// - Can be minimized to an edge icon ('⚡️') or expanded back to full pill.
class FloatingDevToolButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isConnected;

  const FloatingDevToolButton({
    super.key,
    required this.onTap,
    required this.isConnected,
  });

  @override
  State<FloatingDevToolButton> createState() => _FloatingDevToolButtonState();
}

class _FloatingDevToolButtonState extends State<FloatingDevToolButton> {
  Offset? _position;
  bool _isDragging = false;
  bool _isMinimized = false;
  Offset _dragDeltaAccumulator = Offset.zero;

  // Approximate dimensions for boundary clamping
  static const double _pillWidth = 140.0;
  static const double _pillHeight = 44.0;
  static const double _minimizedWidth = 36.0;
  static const double _minimizedHeight = 36.0;
  static const double _margin = 12.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;

    final targetWidth = _isMinimized ? _minimizedWidth : _pillWidth;
    final targetHeight = _isMinimized ? _minimizedHeight : _pillHeight;

    final minX = _margin;
    final maxX = (screenSize.width - targetWidth - _margin).clamp(minX, double.infinity);
    final minY = padding.top + _margin;
    final maxY = (screenSize.height - targetHeight - padding.bottom - _margin).clamp(minY, double.infinity);

    // Initial default position: bottom-right corner above safe area
    _position ??= Offset(maxX, maxY - 20);

    // Clamp position within safe screen boundaries
    final currentPos = Offset(
      _position!.dx.clamp(minX, maxX),
      _position!.dy.clamp(minY, maxY),
    );

    return Positioned(
      left: currentPos.dx,
      top: currentPos.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          _dragDeltaAccumulator = Offset.zero;
          _isDragging = false;
        },
        onPanUpdate: (details) {
          _dragDeltaAccumulator += details.delta;
          if (_dragDeltaAccumulator.distance > 4.0) {
            _isDragging = true;
          }
          setState(() {
            _position = Offset(
              (_position!.dx + details.delta.dx).clamp(minX, maxX),
              (_position!.dy + details.delta.dy).clamp(minY, maxY),
            );
          });
        },
        onPanEnd: (_) {
          // Finished dragging
        },
        onTap: () {
          if (!_isDragging) {
            if (_isMinimized) {
              setState(() {
                _isMinimized = false;
              });
            } else {
              widget.onTap();
            }
          }
        },
        child: _isMinimized ? _buildMinimizedPill() : _buildFullPill(),
      ),
    );
  }

  Widget _buildFullPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xEE1C1C1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0x33FFFFFF),
          width: 0.8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/dn-logo.png', width: 22, height: 22),
          const SizedBox(width: 8),
          const Text(
            'DevTool',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.isConnected
                  ? const Color(0xFF34C759)
                  : const Color(0xFFFF9500),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Minimize button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _isMinimized = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Text(
                '✕',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimizedPill() {
    return Container(
      width: _minimizedWidth,
      height: _minimizedHeight,
      decoration: BoxDecoration(
        color: const Color(0xEE1C1C1E),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x33FFFFFF),
          width: 0.8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '⚡️',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
