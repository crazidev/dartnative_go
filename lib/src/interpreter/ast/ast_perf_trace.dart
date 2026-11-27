import 'dart:async';

import 'package:dartnative/dartnative.dart';

/// Lightweight per-frame profiler for AST-interpreted widget proxies.
///
/// Collects interpreted build counts/time per class, `didUpdateWidget`
/// state re-creations, `CustomPainter.paint`, `setState`, `InheritedWidget`
/// notifications, and frame intervals, then emits one summary block every
/// [_window] through [sink] (wired to the guest log -> dev server).
class AstPerfTrace {
  AstPerfTrace._();

  static bool enabled = false;
  static void Function(String line)? sink;

  static const _window = Duration(seconds: 2);

  static final Map<String, _Stat> _builds = {};
  static final Map<String, _Stat> _recreates = {};
  static final Map<String, _Stat> _paints = {};
  static final Map<String, _Stat> _setStates = {};
  static int _inheritedNotifies = 0;
  static int _inheritedTotal = 0;
  static int _zones = 0;
  static int _frames = 0;
  static int _frameBuilds = 0;
  static int _frameBuildUs = 0;
  static int _maxFrameBuildUs = 0;
  static int _maxFrameBuilds = 0;
  static int _maxFrameGapUs = 0;
  static int _slowFrames = 0;
  static Duration? _lastStamp;
  static bool _armed = false;
  static Timer? _timer;
  static final Stopwatch _wall = Stopwatch();

  static void zone() {
    if (enabled) _zones++;
  }

  static void recordBuild(String cls, int us) {
    if (!enabled) return;
    (_builds[cls] ??= _Stat()).add(us);
    _frameBuilds++;
    _frameBuildUs += us;
    _arm();
  }

  static void recordRecreate(String cls, int us) {
    if (!enabled) return;
    (_recreates[cls] ??= _Stat()).add(us);
    _frameBuildUs += us;
    _arm();
  }

  static void recordPaint(String cls, int us) {
    if (!enabled) return;
    (_paints[cls] ??= _Stat()).add(us);
    _frameBuildUs += us;
    _arm();
  }

  static void recordSetState(String cls) {
    if (!enabled) return;
    (_setStates[cls] ??= _Stat()).add(0);
    _arm();
  }

  static void recordInherited(bool notified) {
    if (!enabled) return;
    _inheritedTotal++;
    if (notified) _inheritedNotifies++;
    _arm();
  }

  static void _arm() {
    _timer ??= Timer.periodic(_window, (_) => flush());
    if (!_wall.isRunning) _wall.start();
    if (_armed) return;
    _armed = true;
    try {
      WidgetsBinding.instance.addPostFrameCallback(_onFrame);
    } catch (_) {
      _armed = false;
    }
  }

  static void _onFrame(Duration stamp) {
    _armed = false;
    _frames++;
    final last = _lastStamp;
    if (last != null) {
      final gap = (stamp - last).inMicroseconds;
      if (gap > _maxFrameGapUs && gap < 2000000) _maxFrameGapUs = gap;
    }
    _lastStamp = stamp;
    if (_frameBuildUs > _maxFrameBuildUs) _maxFrameBuildUs = _frameBuildUs;
    if (_frameBuilds > _maxFrameBuilds) _maxFrameBuilds = _frameBuilds;
    if (_frameBuildUs > 16000) _slowFrames++;
    _frameBuilds = 0;
    _frameBuildUs = 0;
  }

  static String _top(Map<String, _Stat> m, int n, {bool countOnly = false}) {
    final e = m.entries.toList()
      ..sort(
        (a, b) => countOnly
            ? b.value.count.compareTo(a.value.count)
            : b.value.us.compareTo(a.value.us),
      );
    return e
        .take(n)
        .map(
          (x) => countOnly
              ? '${x.key}×${x.value.count}'
              : '${x.key}×${x.value.count}=${(x.value.us / 1000).toStringAsFixed(1)}ms'
                    '(max ${(x.value.max / 1000).toStringAsFixed(1)})',
        )
        .join(', ');
  }

  static void flush() {
    if (_builds.isEmpty &&
        _recreates.isEmpty &&
        _paints.isEmpty &&
        _setStates.isEmpty &&
        _inheritedTotal == 0) {
      _timer?.cancel();
      _timer = null;
      _wall
        ..stop()
        ..reset();
      _lastStamp = null;
      return;
    }
    var buildCount = 0, buildUs = 0;
    for (final s in _builds.values) {
      buildCount += s.count;
      buildUs += s.us;
    }
    var recCount = 0, recUs = 0;
    for (final s in _recreates.values) {
      recCount += s.count;
      recUs += s.us;
    }
    var paintCount = 0, paintUs = 0;
    for (final s in _paints.values) {
      paintCount += s.count;
      paintUs += s.us;
    }
    var ssCount = 0;
    for (final s in _setStates.values) {
      ssCount += s.count;
    }
    final wallMs = _wall.elapsedMilliseconds;
    final buf = StringBuffer()
      ..write(
        '[Perf] ${wallMs}ms: frames=$_frames builds=$buildCount '
        '(${(buildUs / 1000).toStringAsFixed(1)}ms) '
        'paints=$paintCount (${(paintUs / 1000).toStringAsFixed(1)}ms) '
        'recreates=$recCount (${(recUs / 1000).toStringAsFixed(1)}ms) '
        'setState=$ssCount inh=$_inheritedNotifies/$_inheritedTotal zones=$_zones '
        '| perFrame max ${(_maxFrameBuildUs / 1000).toStringAsFixed(1)}ms '
        '/$_maxFrameBuilds builds, slow(>16ms)=$_slowFrames, '
        'maxGap=${(_maxFrameGapUs / 1000).toStringAsFixed(1)}ms',
      );
    if (_builds.isNotEmpty) {
      buf.write('\n[Perf]   top builds: ${_top(_builds, 6)}');
    }
    if (_paints.isNotEmpty) {
      buf.write('\n[Perf]   top paints: ${_top(_paints, 4)}');
    }
    if (_recreates.isNotEmpty) {
      buf.write('\n[Perf]   top recreates: ${_top(_recreates, 4)}');
    }
    if (_setStates.isNotEmpty) {
      buf.write(
        '\n[Perf]   top setState: ${_top(_setStates, 4, countOnly: true)}',
      );
    }
    _builds.clear();
    _recreates.clear();
    _paints.clear();
    _setStates.clear();
    _inheritedNotifies = 0;
    _inheritedTotal = 0;
    _zones = 0;
    _frames = 0;
    _maxFrameBuildUs = 0;
    _maxFrameBuilds = 0;
    _maxFrameGapUs = 0;
    _slowFrames = 0;
    _wall.reset();
    final line = buf.toString();
    final s = sink;
    if (s != null) {
      s(line);
    } else {
      print(line);
    }
  }
}

class _Stat {
  int count = 0;
  int us = 0;
  int max = 0;
  void add(int v) {
    count++;
    us += v;
    if (v > max) max = v;
  }
}
