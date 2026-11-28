import 'dart:math' as math;

import 'package:dartnative/dartnative.dart';

import 'controller.dart';

const _colors = [
  Color(0xE6E3268C),
  Color(0xE6E8336E),
  Color(0xE61F95AE),
  Color(0xE622E6A5),
  Color(0xE6FFD24A),
  Color(0xE69B4BE0),
];

class _Ball {
  _Ball(this.x, this.y, this.vx, this.vy, this.size, Color color)
    : view = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  final double size;
  final Widget view;
  double x, y, vx, vy;
}

class BallArena extends StatefulWidget {
  const BallArena({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
  });

  final BenchController controller;
  final double width;
  final double height;

  @override
  State<BallArena> createState() => _BallArenaState();
}

class _BallArenaState extends State<BallArena> {
  final _rng = math.Random(7);
  final _balls = <_Ball>[];
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  int _resetSeen = 0;

  BenchController get _c => widget.controller;
  double get _w => widget.width;
  double get _h => widget.height;
  bool get _sized => _w.isFinite && _h.isFinite && _w > 0 && _h > 0;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = math.min((elapsed - _last).inMicroseconds / 1e6, 0.05);
    _last = elapsed;
    if (!mounted || !_sized) return;

    if (_c.resetCount.value != _resetSeen) {
      _resetSeen = _c.resetCount.value;
      _balls.clear();
      setState(() {});
    }

    for (var i = _c.takePending(); i > 0; i--) {
      _balls.add(_newBall());
    }
    _c.ballCount = _balls.length;
    if (_balls.isEmpty || dt <= 0) return;

    for (final b in _balls) {
      final maxX = math.max(_w - b.size, 0.0);
      final maxY = math.max(_h - b.size, 0.0);
      var x = b.x + b.vx * dt;
      var y = b.y + b.vy * dt;
      if (x < 0 || x > maxX) {
        b.vx = -b.vx;
        x = x < 0 ? -x : 2 * maxX - x;
      }
      if (y < 0 || y > maxY) {
        b.vy = -b.vy;
        y = y < 0 ? -y : 2 * maxY - y;
      }
      b.x = x.clamp(0.0, maxX);
      b.y = y.clamp(0.0, maxY);
    }
    setState(() {});
  }

  _Ball _newBall() {
    final size = 10 + _rng.nextDouble() * 18;
    final angle = _rng.nextDouble() * math.pi * 2;
    final speed = 90 + _rng.nextDouble() * 260;
    return _Ball(
      _w / 2 - size / 2 + (_rng.nextDouble() - 0.5) * 24,
      _h / 2 - size / 2 + (_rng.nextDouble() - 0.5) * 24,
      math.cos(angle) * speed,
      math.sin(angle) * speed,
      size,
      _colors[_rng.nextInt(_colors.length)],
    );
  }

  @override
  Widget build(BuildContext context) {
    const group = BenchController.batch;
    return SizedBox(
      width: _sized ? _w : 0,
      height: _sized ? _h : 0,
      child: Stack(
        children: [
          for (var start = 0; start < _balls.length; start += group)
            Positioned.fill(
              child: Stack(
                children: [
                  for (final b in _balls.skip(start).take(group))
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Transform.translate(
                        offset: Offset(b.x, b.y),
                        child: b.view,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
