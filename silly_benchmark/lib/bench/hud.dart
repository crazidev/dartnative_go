import 'package:dartnative/dartnative.dart';

import 'controller.dart';
import 'metrics.dart';

const _ink = Color(0xFF1D2433);
const _muted = Color(0xFF6B7385);
const _green = Color(0xFF16B47E);
const _amber = Color(0xFFF2A51A);
const _red = Color(0xFFE8336E);
const _teal = Color(0xFF1F95AE);

class BenchHud extends StatelessWidget {
  const BenchHud({super.key, required this.metrics, required this.controller});

  final BenchMetrics metrics;
  final BenchController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.hudExpanded.value = !controller.hudExpanded.value,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: const Color(0xEEFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ValueListenableBuilder<MetricsSnapshot>(
          valueListenable: metrics.snapshot,
          builder: (context, s, _) => ValueListenableBuilder<bool>(
            valueListenable: controller.hudExpanded,
            builder: (context, expanded, _) => _body(s, expanded),
          ),
        ),
      ),
    );
  }

  Widget _body(MetricsSnapshot s, bool expanded) {
    final hz = s.hz ?? 60;
    final stats = Row(
      children: [
        for (final (label, value) in [
          ('BALLS', '${s.balls}'),
          ('FPS', s.fps.toStringAsFixed(0)),
          ('CPU', s.cpu == null ? 'n/a' : '${s.cpu!.toStringAsFixed(0)}%'),
          ('RSS', '${s.rssMb.toStringAsFixed(0)}M'),
          ('MISSED', '${s.missed}'),
        ])
          Expanded(child: _Stat(label, value)),
      ],
    );
    if (!expanded) return stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        stats,
        const SizedBox(height: 10),
        _Chart(
          label: 'Frame rate',
          trailing: '${s.fps.toStringAsFixed(0)} fps · ${s.balls} balls',
          values: s.fpsHistory,
          top: hz.toDouble(),
          height: 44,
          colorFor: (v) =>
              v >= hz * 0.9 ? _green : (v >= hz * 0.5 ? _amber : _red),
        ),
        const SizedBox(height: 8),
        _Chart(
          label: 'CPU usage',
          trailing: 'peak ${s.peakCpu.toStringAsFixed(0)}%',
          values: s.cpuHistory,
          top: _scale(s.cpuHistory, 100),
          colorFor: (_) => _teal,
        ),
        const SizedBox(height: 8),
        _Chart(
          label: 'Missed frames',
          trailing:
              '${s.missed} total · ${s.hz == null ? 'calibrating' : '${s.hz} Hz'}',
          values: s.missedHistory,
          top: _scale(s.missedHistory, 10),
          colorFor: (_) => _red,
        ),
        const SizedBox(height: 6),
        const Text(
          'Tap to collapse',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: _muted),
        ),
      ],
    );
  }

  static double _scale(List<double> values, double floor) =>
      values.fold(floor, (a, b) => a > b ? a : b) * 1.1;
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: _muted,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({
    required this.label,
    required this.trailing,
    required this.values,
    required this.top,
    required this.colorFor,
    this.height = 26,
  });

  final String label;
  final String trailing;
  final List<double> values;
  final double top;
  final Color Function(double) colorFor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
            ),
            Text(
              trailing,
              maxLines: 1,
              style: const TextStyle(fontSize: 10, color: _muted),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final v in values)
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: SizedBox(
                    width: 3,
                    height: (v / top * height).clamp(1.0, height),
                    child: ColoredBox(color: colorFor(v)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
