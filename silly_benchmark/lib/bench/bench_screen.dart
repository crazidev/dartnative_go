import 'package:dartnative/dartnative.dart';

import 'arena.dart';
import 'controller.dart';
import 'hud.dart';
import 'metrics.dart';

class BenchScreen extends StatefulWidget {
  const BenchScreen({super.key});

  @override
  State<BenchScreen> createState() => _BenchScreenState();
}

class _BenchScreenState extends State<BenchScreen> {
  final _controller = BenchController();
  late final _metrics = BenchMetrics(ballCount: () => _controller.ballCount);

  @override
  void initState() {
    super.initState();
    _controller.resetCount.addListener(_metrics.reset);
    _metrics.start();
  }

  @override
  void dispose() {
    _controller.resetCount.removeListener(_metrics.reset);
    _metrics.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      brightness: Brightness.light,
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) => BallArena(
                controller: _controller,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: pad.top + 8,
            child: BenchHud(metrics: _metrics, controller: _controller),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: pad.bottom + 12,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _Button(
                    '+${BenchController.batch} balls',
                    _controller.addBatch,
                    const Color(0xEE16B47E),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Button(
                    'Reset',
                    _controller.reset,
                    const Color(0xEE1D2433),
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

class _Button extends StatelessWidget {
  const _Button(this.label, this.onTap, this.color);

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
