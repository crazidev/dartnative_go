import 'dart:async';

import 'package:dartnative/dartnative.dart';

import '../theme/host_ui_theme.dart';

/// A floating, draggable DevTools pill that can be moved anywhere on screen.
///
/// Lives in this package (not the shell) so `dart_go start` can preview and
/// hot-reload the DevTools UI. The shell embeds the same widget for a normal
/// preview; a previewed UI that claims DevTools renders it instead.
///
/// Features:
/// - Freeform positioning from pan gestures, following the finger 1:1.
/// - Elastic edges: dragging past the safe area stretches the pill with
///   resistance instead of stopping dead, and releasing springs it back to the
///   nearest in-bounds position (keeping the release velocity).
/// - Always snaps to an edge: released anywhere in the middle of the screen,
///   the pill springs to the closer side (left or right) instead of resting
///   where it was dropped. Only the vertical position is kept, clamped to the
///   safe area.
/// - Clamps the resting position to the visible screen area and safe area
///   insets, so a rotation or inset change cannot strand it off-screen.
/// - Distinct tap vs. drag detection so taps open DevTools without accidental
///   drags.
/// - Can be minimized to an edge icon ('+') or expanded back to full pill.
///
/// The pill positions itself against [MediaQuery] screen coordinates, so its
/// parent must be a full-screen [Stack] — not a [Scaffold] body, whose origin
/// sits below the app bar and would push the default bottom-right corner off
/// the bottom edge.
class HostDevToolButton extends StatefulWidget {
  /// Palette resolved by the caller; the pill may sit above a route and cannot
  /// rely on the ambient [HostUiTheme] scope.
  final HostUiThemeData theme;
  final Function onTap;
  final bool isConnected;

  const HostDevToolButton({
    super.key,
    required this.theme,
    required this.onTap,
    required this.isConnected,
  });

  @override
  State<HostDevToolButton> createState() => _HostDevToolButtonState();
}

class _HostDevToolButtonState extends State<HostDevToolButton> {
  /// Where the pill is drawn, in screen coordinates.
  Offset? _position;

  /// Finger-following position while dragging, before edge resistance.
  ///
  /// Kept separately from [_position] so the elastic pull is derived from the
  /// raw finger travel: the pill tracks the finger exactly inside the safe
  /// area, and easing back in resumes from the same place.
  Offset _rawPosition = Offset.zero;

  bool _isDragging = false;
  bool _isMinimized = false;
  Offset _dragDeltaAccumulator = Offset.zero;

  /// Drives the spring-back after an out-of-bounds release; null when idle.
  Timer? _springTimer;
  Offset _springVelocity = Offset.zero;

  /// In-bounds resting area, refreshed from [MediaQuery] on every build.
  Offset _minBounds = const Offset(_margin, _margin);
  Offset _maxBounds = const Offset(_margin, _margin);

  // Approximate dimensions for boundary clamping
  static const double _pillWidth = 140.0;
  static const double _pillHeight = 44.0;
  static const double _minimizedWidth = 36.0;
  static const double _minimizedHeight = 36.0;
  static const double _margin = 12.0;

  /// How far past a safe-area edge the pill can stretch while dragging.
  static const double _overshoot = 56.0;

  /// Spring constants. Slightly under-damped, so the return settles with one
  /// soft overshoot rather than snapping.
  static const double _springStiffness = 240.0;
  static const double _springDamping = 30.0;
  static const double _springStep = 1 / 60;
  static const double _maxFling = 2400.0;
  static const Duration _springInterval = Duration(milliseconds: 16);

  @override
  void dispose() {
    _stopSpring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    final targetWidth = _isMinimized ? _minimizedWidth : _pillWidth;
    final targetHeight = _isMinimized ? _minimizedHeight : _pillHeight;

    _minBounds = Offset(_margin, padding.top + _margin);
    _maxBounds = Offset(
      (screenSize.width - targetWidth - _margin).clamp(
        _margin,
        double.infinity,
      ),
      (screenSize.height - targetHeight - padding.bottom - _margin).clamp(
        padding.top + _margin,
        double.infinity,
      ),
    );

    if (_position == null) {
      // Default corner: bottom-right, just above the safe area.
      _position = Offset(_maxBounds.dx, _maxBounds.dy - 20);
    } else if (!_isDragging && _springTimer == null) {
      // A rotation or inset change may leave the resting spot out of bounds.
      _position = _clampToBounds(_position!);
    }

    final currentPos = _position!;

    return Positioned(
      left: currentPos.dx,
      top: currentPos.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          _stopSpring();
          _dragDeltaAccumulator = Offset.zero;
          _isDragging = false;
          _springVelocity = Offset.zero;
          _rawPosition = _position!;
        },
        onPanUpdate: (details) {
          _dragDeltaAccumulator = _dragDeltaAccumulator + details.delta;
          if (_dragDeltaAccumulator.distance > 4.0) {
            _isDragging = true;
          }
          _rawPosition = _rawPosition + details.delta;
          setState(() {
            // Elastic edges: past the safe area the pill keeps following the
            // finger, but with increasing resistance instead of a hard stop.
            _position = _rubberBand(_rawPosition);
          });
        },
        onPanEnd: (details) {
          _isDragging = false;
          _startSpring(details.velocity.pixelsPerSecond);
        },
        onTap: () {
          if (_isMinimized) {
            setState(() {
              _isMinimized = false;
            });
          } else {
            widget.onTap();
          }
        },
        child: _isMinimized ? _buildMinimizedPill() : _buildFullPill(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Elastic edges
  // ---------------------------------------------------------------------------

  /// Applies edge resistance to a raw finger position.
  Offset _rubberBand(Offset raw) {
    return Offset(
      _rubberBandAxis(raw.dx, _minBounds.dx, _maxBounds.dx),
      _rubberBandAxis(raw.dy, _minBounds.dy, _maxBounds.dy),
    );
  }

  double _rubberBandAxis(double value, double min, double max) {
    if (value < min) return min - _resist(min - value);
    if (value > max) return max + _resist(value - max);
    return value;
  }

  /// Asymptotic pull: 1:1 at the edge, easing to at most [_overshoot] past it.
  ///
  /// `overshoot * over / (over + overshoot)` has slope 1 at `over == 0`, so
  /// crossing the edge never jumps, and it saturates, so the pill can never be
  /// dragged far enough to lose the finger.
  double _resist(double over) {
    if (over <= 0) return 0;
    return _overshoot * over / (over + _overshoot);
  }

  Offset _clampToBounds(Offset value) {
    return Offset(
      value.dx.clamp(_minBounds.dx, _maxBounds.dx),
      value.dy.clamp(_minBounds.dy, _maxBounds.dy),
    );
  }

  /// Whether [value] differs from [target] by more than [slack].
  bool _away(double value, double target, double slack) {
    final diff = value - target;
    return diff > slack || diff < -slack;
  }

  // ---------------------------------------------------------------------------
  // Spring-back
  // ---------------------------------------------------------------------------

  /// Springs the pill to the closer side of the screen.
  ///
  /// The pill always rests against an edge: released in the middle of the
  /// screen it springs left or right (whichever is nearer) rather than staying
  /// where it was dropped. The vertical position is kept, clamped to the safe
  /// area, so the pill stays at the height the user chose. [fling] (screen
  /// pixels per second) is carried into the motion when it points the same way
  /// as the snap, so a flick feels thrown instead of eased.
  void _startSpring(Offset fling) {
    _stopSpring();
    final position = _position;
    if (position == null) return;

    final middle = (_minBounds.dx + _maxBounds.dx) / 2;
    final targetX = position.dx <= middle ? _minBounds.dx : _maxBounds.dx;
    final target = Offset(
      targetX,
      position.dy.clamp(_minBounds.dy, _maxBounds.dy),
    );

    final needsSpring =
        _away(position.dx, target.dx, 0.5) ||
        _away(position.dy, target.dy, 0.5);
    if (!needsSpring) {
      _springVelocity = Offset.zero;
      _position = target;
      return;
    }

    _springVelocity = Offset(
      _flingAxis(fling.dx, position.dx, target.dx),
      _flingAxis(fling.dy, position.dy, target.dy),
    );
    _springTimer = Timer.periodic(_springInterval, (_) => _stepSpring(target));
  }

  /// Keeps a fling only when it does not fight the spring's direction.
  double _flingAxis(double velocity, double value, double target) {
    if (value < target && velocity < 0) return 0;
    if (value > target && velocity > 0) return 0;
    return velocity.clamp(-_maxFling, _maxFling);
  }

  /// One integration step of a damped spring toward [target].
  void _stepSpring(Offset target) {
    final position = _position;
    if (!mounted || position == null) {
      _stopSpring();
      return;
    }

    const dt = _springStep;
    double vx = _springVelocity.dx;
    double vy = _springVelocity.dy;
    vx =
        vx +
        ((target.dx - position.dx) * _springStiffness - vx * _springDamping) *
            dt;
    vy =
        vy +
        ((target.dy - position.dy) * _springStiffness - vy * _springDamping) *
            dt;
    final nextX = position.dx + vx * dt;
    final nextY = position.dy + vy * dt;

    final settled =
        !_away(nextX, target.dx, 0.5) &&
        !_away(nextY, target.dy, 0.5) &&
        !_away(vx, 0, 12) &&
        !_away(vy, 0, 12);
    if (settled) {
      _stopSpring();
      setState(() {
        _springVelocity = Offset.zero;
        _position = target;
      });
      return;
    }

    setState(() {
      _springVelocity = Offset(vx, vy);
      _position = Offset(nextX, nextY);
    });
  }

  void _stopSpring() {
    final timer = _springTimer;
    _springTimer = null;
    timer?.cancel();
  }

  // ---------------------------------------------------------------------------
  // Visuals
  // ---------------------------------------------------------------------------

  Widget _buildFullPill() {
    final theme = widget.theme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.border, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/app-logo.png', width: 22, height: 22),
          const SizedBox(width: 8),
          Text(
            'DevTool',
            style: TextStyle(
              color: theme.cardForeground,
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
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: () {
          //     setState(() {
          //       _isMinimized = true;
          //     });
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.all(4),
          //     child: Text(
          //       '✕',
          //       style: TextStyle(
          //         color: theme.mutedForeground,
          //         fontSize: 11,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMinimizedPill() {
    final theme = widget.theme;
    return Container(
      width: _minimizedWidth,
      height: _minimizedHeight,
      decoration: BoxDecoration(
        color: theme.card,
        shape: BoxShape.circle,
        border: Border.all(color: theme.border, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '+',
          style: TextStyle(fontSize: 16, color: theme.cardForeground),
        ),
      ),
    );
  }
}
