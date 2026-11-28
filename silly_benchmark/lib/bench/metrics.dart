import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform, ProcessInfo;
import 'dart:math' as math;

import 'package:dartnative/dartnative.dart';

class MetricsSnapshot {
  const MetricsSnapshot({
    this.balls = 0,
    this.fps = 0,
    this.cpu,
    this.rssMb = 0,
    this.missed = 0,
    this.hz,
    this.peakCpu = 0,
    this.fpsHistory = const [],
    this.cpuHistory = const [],
    this.missedHistory = const [],
  });

  final int balls;
  final double fps;
  final double? cpu;
  final double rssMb;
  final int missed;
  final int? hz;
  final double peakCpu;
  final List<double> fpsHistory;
  final List<double> cpuHistory;
  final List<double> missedHistory;
}

int Function()? _openClock() {
  final libs = [
    () => ffi.DynamicLibrary.process(),
    if (Platform.isAndroid) () => ffi.DynamicLibrary.open('libc.so'),
  ];
  for (final open in libs) {
    try {
      final clock = open().lookupFunction<ffi.Long Function(), int Function()>(
        'clock',
      );
      clock();
      return clock;
    } catch (_) {}
  }
  return null;
}

class BenchMetrics {
  BenchMetrics({required this.ballCount});

  final int Function() ballCount;
  final snapshot = ValueNotifier(const MetricsSnapshot());

  static const _historyLength = 60;
  static const _calibrationTicks = 60;

  final _clock = _openClock();
  final _wall = Stopwatch();
  Timer? _timer;

  final _calibration = <int>[];
  int? _frameUs;
  int _frames = 0;
  int _missed = 0;
  int _lastWallUs = 0;
  int? _lastCpuUs;
  double _peakCpu = 0;
  final _fps = <double>[];
  final _cpu = <double>[];
  final _missedHistory = <double>[];

  void start() {
    DartNativePerformance.addFrameTimingCallback(_onFrame);
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _sample(),
    );
    reset();
  }

  void dispose() {
    _timer?.cancel();
    DartNativePerformance.removeFrameTimingCallback(_onFrame);
    snapshot.dispose();
  }

  void reset() {
    _calibration.clear();
    _frameUs = null;
    _frames = 0;
    _missed = 0;
    _peakCpu = 0;
    _fps.clear();
    _cpu.clear();
    _missedHistory.clear();
    _wall
      ..reset()
      ..start();
    _lastWallUs = 0;
    _lastCpuUs = _clock?.call();
    snapshot.value = const MetricsSnapshot();
    // ignore: avoid_print
    print('[bench] t_s,balls,fps,cpu_pct,rss_mb,missed_total,refresh_hz');
  }

  void _onFrame(Duration sincePrevious) {
    final us = sincePrevious.inMicroseconds;
    if (us <= 0) return;
    _frames++;
    if (us > 3000000) return;

    final frameUs = _frameUs;
    if (frameUs == null) {
      _calibration.add(us);
      if (_calibration.length >= _calibrationTicks) {
        _frameUs = _snapToDisplayRate(_calibration);
      }
      return;
    }
    final slots = (us / frameUs).round();
    if (slots > 1) _missed += slots - 1;
  }

  static int _snapToDisplayRate(List<int> ticks) {
    final median = ([...ticks]..sort())[ticks.length ~/ 2];
    const rates = [120, 90, 60, 30];
    final hz = rates.reduce(
      (a, b) => (1e6 / a - median).abs() <= (1e6 / b - median).abs() ? a : b,
    );
    return (1e6 / hz).round();
  }

  void _sample() {
    final nowUs = _wall.elapsedMicroseconds;
    final wallUs = nowUs - _lastWallUs;
    if (wallUs <= 0) return;

    final fps = _frames * 1e6 / wallUs;
    _frames = 0;

    final cpuNow = _clock?.call();
    final cpuPrev = _lastCpuUs;
    final cpu = cpuNow != null && cpuPrev != null
        ? math.max(0.0, (cpuNow - cpuPrev) * 100 / wallUs)
        : null;
    _lastCpuUs = cpuNow;
    _lastWallUs = nowUs;

    final rssMb = ProcessInfo.currentRss / 1048576;
    final balls = ballCount();
    final frameUs = _frameUs;
    final hz = frameUs == null ? null : (1e6 / frameUs).round();
    _peakCpu = math.max(_peakCpu, cpu ?? 0);
    _push(_fps, fps);
    _push(_cpu, cpu ?? 0);
    _push(_missedHistory, _missed.toDouble());

    snapshot.value = MetricsSnapshot(
      balls: balls,
      fps: fps,
      cpu: cpu,
      rssMb: rssMb,
      missed: _missed,
      hz: hz,
      peakCpu: _peakCpu,
      fpsHistory: List.unmodifiable(_fps),
      cpuHistory: List.unmodifiable(_cpu),
      missedHistory: List.unmodifiable(_missedHistory),
    );

    // ignore: avoid_print
    print(
      '[bench] ${(nowUs / 1e6).toStringAsFixed(1)},$balls,'
      '${fps.toStringAsFixed(1)},${cpu?.toStringAsFixed(1) ?? 'na'},'
      '${rssMb.toStringAsFixed(1)},$_missed,${hz ?? 'na'}',
    );
  }

  static void _push(List<double> list, double v) {
    list.add(v);
    if (list.length > _historyLength) list.removeAt(0);
  }
}
