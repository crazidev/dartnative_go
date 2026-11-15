#!/usr/bin/env dart
// ignore_for_file: avoid_print
//
// tool/scale_inject.dart
//
// Injects N synthetic Dart modules (widgets + services + providers) into a
// real DartNative guest project so you can stress-test hot reload at scale.
//
// Each injected module is a realistic Flutter widget file, making the test
// representative of an actual app's import graph.
//
// USAGE:
//   dart run tool/scale_inject.dart inject --project=example --count=2000
//   dart run tool/scale_inject.dart reload --project=example --changed=10 --cycles=5
//   dart run tool/scale_inject.dart clean  --project=example
//   dart run tool/scale_inject.dart bench  --project=example --count=500 --changed=10
//
// FLAGS:
//   --project=<path>   Guest project path (default: example)
//   --count=<N>        Modules to inject  (default: 500)
//   --changed=<N>      Files to touch per reload cycle (default: 10)
//   --cycles=<N>       Reload cycles to run (default: 3)
//   --type=<mixed|widget|service|stateful>  Module flavour (default: mixed)

import 'dart:io';
import 'dart:math';

const _injectedDir = '_scale_test';
const _barrelFile = '_scale_test.dart';
const _marker = '// scale_inject:auto-generated';

// ──────────────────────────────────────────────────────────────────────────────
// Module templates: realistic widget / service / provider code
// ──────────────────────────────────────────────────────────────────────────────

/// Stateless widget (most common Flutter widget type).
String _statelessWidget(int i) =>
    '''$_marker
import 'package:dartnative/dartnative.dart';

class ScaleWidget$i extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback? onTap;

  const ScaleWidget$i({
    super.key,
    this.title = 'Item $i',
    this.value = $i,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.square_grid_2x2, color: Colors.blue.shade${_shade(i)}, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '\$title #\$value',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'v${_ver(i)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''';

/// Stateful widget with local counter state.
String _statefulWidget(int i) =>
    '''$_marker
import 'package:dartnative/dartnative.dart';

class ScaleStateful$i extends StatefulWidget {
  final String label;
  const ScaleStateful$i({super.key, this.label = 'Counter $i'});

  @override
  State<ScaleStateful$i> createState() => _ScaleStateful${i}State();
}

class _ScaleStateful${i}State extends State<ScaleStateful$i> {
  int _count = 0;
  bool _expanded = false;

  void _increment() => setState(() => _count++);
  void _toggle()    => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(widget.label),
            subtitle: Text('Taps: \$_count · v${_ver(i)}'),
            trailing: IconButton(
              icon: Icon(_expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down),
              onPressed: _toggle,
            ),
            onTap: _increment,
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Module $i detail view — count: \$_count',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
''';

/// Pure Dart service / data model (no Flutter import needed).
String _serviceModel(int i) =>
    '''$_marker

class ScaleModel$i {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  const ScaleModel$i({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory ScaleModel$i.sample() => ScaleModel$i(
    id: $i,
    name: 'Model $i',
    description: 'Auto-generated model for scale test — v${_ver(i)}',
    createdAt: DateTime(2024, 1, ${(i % 28) + 1}),
  );

  ScaleModel$i copyWith({String? name, String? description}) => ScaleModel$i(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => 'ScaleModel$i(id: \$id, name: \$name)';
}

class ScaleService$i {
  static final _items = <ScaleModel$i>[];

  static void seed(int n) {
    _items.clear();
    for (var i = 0; i < n; i++) _items.add(ScaleModel$i.sample());
  }

  static List<ScaleModel$i> getAll() => List.unmodifiable(_items);

  static ScaleModel$i? findById(int id) {
    try { return _items.firstWhere((m) => m.id == id); } catch (_) { return null; }
  }

  static int get count => _items.length;
  static String version() => '${_ver(i)}';
}
''';

/// A combined card + service (mixed, most representative).
String _mixedModule(int i) =>
    '''$_marker
import 'package:dartnative/dartnative.dart';

// ── Model ────────────────────────────────────────────────────────────────────

class ScaleItem$i {
  final int id;
  final String label;
  int value;

  ScaleItem$i({required this.id, required this.label, this.value = 0});

  String get version => '${_ver(i)}';
  void increment() => value++;
  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'value': value};
}

// ── Widget ───────────────────────────────────────────────────────────────────

class ScaleCard$i extends StatefulWidget {
  final ScaleItem$i item;
  final Color? accentColor;
  final VoidCallback? onChanged;

  const ScaleCard$i({
    super.key,
    required this.item,
    this.accentColor,
    this.onChanged,
  });

  @override
  State<ScaleCard$i> createState() => _ScaleCard${i}State();
}

class _ScaleCard${i}State extends State<ScaleCard$i> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? Colors.indigo;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: _selected ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selected ? color : Colors.grey.shade200,
          width: _selected ? 1.5 : 1.0,
        ),
        boxShadow: _selected ? [
          BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2)),
        ] : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            '\${widget.item.id % 100}',
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(widget.item.label),
        subtitle: Text('val: \${widget.item.value} · \${widget.item.version}'),
        trailing: IconButton(
          icon: Icon(
            _selected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
            color: color,
          ),
          onPressed: () => setState(() => _selected = !_selected),
        ),
        onTap: () {
          setState(() => widget.item.increment());
          widget.onChanged?.call();
        },
      ),
    );
  }
}
''';

// ── Template helpers ──────────────────────────────────────────────────────────

String _shade(int i) => ['300', '400', '500', '600', '700'][i % 5];
String _ver(int i) => '1.${i % 100}.$i';

String _generateModule(int i, String type) {
  switch (type) {
    case 'widget':
      return _statelessWidget(i);
    case 'stateful':
      return _statefulWidget(i);
    case 'service':
      return _serviceModel(i);
    case 'mixed':
    default:
      // Mix: 40% mixed cards, 25% stateless, 20% stateful, 15% services
      final r = i % 20;
      if (r < 8) return _mixedModule(i);
      if (r < 13) return _statelessWidget(i);
      if (r < 17) return _statefulWidget(i);
      return _serviceModel(i);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// COMMANDS
// ──────────────────────────────────────────────────────────────────────────────

void main(List<String> args) async {
  if (args.isEmpty) {
    _usage();
    exit(1);
  }

  final cmd = args[0];
  final flags = _parseFlags(args.skip(1).toList());
  final projPath = flags['project'] ?? 'example';
  final count = int.tryParse(flags['count'] ?? '500') ?? 500;
  final changed = int.tryParse(flags['changed'] ?? '10') ?? 10;
  final cycles = int.tryParse(flags['cycles'] ?? '3') ?? 3;
  final type = flags['type'] ?? 'mixed';
  final proj = Directory(projPath);

  if (!proj.existsSync()) {
    print('❌ Not found: $projPath');
    exit(1);
  }

  switch (cmd) {
    case 'inject':
      await _inject(proj, count, type);
    case 'clean':
      await _clean(proj);
    case 'reload':
      await _reload(proj, changed, cycles);
    case 'bench':
      await _bench(proj, count, changed, cycles, type);
    default:
      print('❌ Unknown: $cmd');
      _usage();
      exit(1);
  }
}

// ── inject ────────────────────────────────────────────────────────────────────

Future<void> _inject(Directory proj, int count, String type) async {
  print('━' * 64);
  print('⚡️  Scale Injector  —  $count modules  (type: $type)');
  print('   Project: ${proj.path}');
  print('━' * 64);

  final lib = Directory('${proj.path}/lib');
  final scaleDir = Directory('${lib.path}/$_injectedDir');

  if (scaleDir.existsSync()) {
    print('⚠️  Already injected. Run "clean" first to re-inject.');
    return;
  }
  scaleDir.createSync(recursive: true);

  final sw = Stopwatch()..start();
  const chunkSize = 50;
  final numChunks = (count / chunkSize).ceil();

  // 1. Individual module files.
  print('\n🛠️  Generating $count module files...');
  for (var i = 0; i < count; i++) {
    File(
      '${scaleDir.path}/mod_$i.dart',
    ).writeAsStringSync(_generateModule(i, type));
  }

  // 2. Barrel chunks.
  final topBarrel = StringBuffer(
    '$_marker\n// Scale-test barrel — $count modules ($type)\n',
  );
  for (var b = 0; b < numChunks; b++) {
    final start = b * chunkSize;
    final end = min(start + chunkSize, count);
    final buf = StringBuffer('$_marker\n');
    for (var i = start; i < end; i++) {
      buf.writeln("export 'mod_$i.dart';");
    }
    File('${scaleDir.path}/barrel_$b.dart').writeAsStringSync(buf.toString());
    topBarrel.writeln("export '$_injectedDir/barrel_$b.dart';");
  }
  File('${lib.path}/$_barrelFile').writeAsStringSync(topBarrel.toString());

  // 3. Patch main.dart.
  final mainFile = File('${lib.path}/main.dart');
  if (mainFile.existsSync()) {
    final src = mainFile.readAsStringSync();
    if (!src.contains(_barrelFile)) {
      final lines = src.split('\n');
      int last = 0;
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trim().startsWith('import ')) last = i;
      }
      lines.insert(
        last + 1,
        "// ignore: unused_import\nimport '$_barrelFile'; $_marker",
      );
      mainFile.writeAsStringSync(lines.join('\n'));
      print('   ✅ Patched lib/main.dart with scale barrel import');
    }
  }

  sw.stop();
  final totalFiles = count + numChunks + 1;
  print('   ✅ $totalFiles files in ${sw.elapsedMilliseconds} ms\n');

  // Breakdown of generated types.
  final mixed = (type == 'mixed')
      ? count * 8 ~/ 20
      : (type == 'mixed' ? count : 0);
  final stateless = (type == 'mixed')
      ? count * 5 ~/ 20
      : (type == 'widget' ? count : 0);
  final stateful = (type == 'mixed')
      ? count * 4 ~/ 20
      : (type == 'stateful' ? count : 0);
  final services = (type == 'mixed')
      ? count - mixed - stateless - stateful
      : (type == 'service' ? count : 0);

  print('📦 Module breakdown:');
  if (type == 'mixed') {
    print('   • ScaleCard (mixed widget+model) : ~$mixed');
    print('   • StatelessWidget                : ~$stateless');
    print('   • StatefulWidget                 : ~$stateful');
    print('   • Pure Dart service/model        : ~$services');
  } else {
    print('   • $type modules : $count');
  }
  print('   • Barrel files : $numChunks  +  1 top-level barrel');

  print('\n💡 Next steps:');
  print('   Start server:  dart_go start --project=${proj.path}');
  print(
    '   Reload test:   dart run tool/scale_inject.dart reload --project=${proj.path} --changed=10',
  );
  print(
    '   Clean up:      dart run tool/scale_inject.dart clean  --project=${proj.path}',
  );
}

// ── clean ─────────────────────────────────────────────────────────────────────

Future<void> _clean(Directory proj) async {
  print('🧹 Cleaning scale modules from ${proj.path}...');
  final lib = Directory('${proj.path}/lib');

  final scaleDir = Directory('${lib.path}/$_injectedDir');
  if (scaleDir.existsSync()) {
    scaleDir.deleteSync(recursive: true);
    print('   ✅ Removed lib/$_injectedDir/');
  }
  final barrel = File('${lib.path}/$_barrelFile');
  if (barrel.existsSync()) {
    barrel.deleteSync();
    print('   ✅ Removed lib/$_barrelFile');
  }

  final main = File('${lib.path}/main.dart');
  if (main.existsSync()) {
    final src = main.readAsStringSync();
    if (src.contains(_marker)) {
      main.writeAsStringSync(
        src.split('\n').where((l) => !l.contains(_marker)).join('\n'),
      );
      print('   ✅ Restored lib/main.dart');
    }
  }
  print('\n✔ Project restored to original state.');
}

// ── reload ────────────────────────────────────────────────────────────────────

Future<void> _reload(Directory proj, int changedCount, int cycles) async {
  final scaleDir = Directory('${proj.path}/lib/$_injectedDir');
  if (!scaleDir.existsSync()) {
    print('❌ No scale modules found. Run "inject" first.');
    exit(1);
  }

  final modFiles = scaleDir
      .listSync()
      .whereType<File>()
      .where((f) => f.uri.pathSegments.last.startsWith('mod_'))
      .toList();
  final total = modFiles.length;

  print('━' * 64);
  print(
    '⚡️  Reload Trigger  —  $changedCount/$total changed  ×  $cycles cycles',
  );
  print('━' * 64);

  final rng = Random();
  final allMs = <int>[];

  for (var c = 1; c <= cycles; c++) {
    modFiles.shuffle(rng);
    final batch = modFiles.take(changedCount).toList();
    final sw = Stopwatch()..start();

    for (final f in batch) {
      final src = f.readAsStringSync();
      // Bump the version string so content genuinely changes.
      f.writeAsStringSync(
        src.replaceAllMapped(
          RegExp(r"'v(\d+)\.(\d+)\.(\d+)'"),
          (m) => "'v${m.group(1)}.${int.parse(m.group(2)!) + 1}.${m.group(3)}'",
        ),
      );
    }
    sw.stop();
    allMs.add(sw.elapsedMilliseconds);

    final names = batch.take(4).map((f) => f.uri.pathSegments.last).join(', ');
    final types = _detectTypes(batch.take(4).toList());
    print(
      '\n   Cycle $c/$cycles  →  ${sw.elapsedMilliseconds} ms to write $changedCount files',
    );
    print('   Samples : $names${changedCount > 4 ? ' …' : ''}');
    print('   Types   : $types');
    print('   ⏱️  Check dart_go server log for actual rebuild latency.');

    if (c < cycles) await Future.delayed(const Duration(seconds: 2));
  }

  final avg = allMs.reduce((a, b) => a + b) ~/ allMs.length;
  print(
    '\n📊 File-write timings: ${allMs.map((t) => '${t}ms').join(' | ')}  (avg: ${avg}ms)',
  );
  print(
    '   Note: server rebuild latency is separate — visible in dart_go logs.',
  );
}

// ── bench ─────────────────────────────────────────────────────────────────────

Future<void> _bench(
  Directory proj,
  int count,
  int changed,
  int cycles,
  String type,
) async {
  print('━' * 64);
  print(
    '⚡️  Scale Bench  —  $count modules  ($changed changed / $cycles cycles)',
  );
  print('   Project: ${proj.path}');
  print('━' * 64);

  final scaleDir = Directory('${proj.path}/lib/$_injectedDir');
  if (!scaleDir.existsSync()) {
    await _inject(proj, count, type);
  } else {
    print(
      '\n✅ Scale modules already present (${scaleDir.listSync().length} files)',
    );
  }

  print('\n📦 Cold build (dart_go build)...');
  final coldSw = Stopwatch()..start();
  final res = await Process.run(
    'dart',
    ['run', 'bin/dart_go.dart', 'build', '--project=${proj.path}'],
    workingDirectory: Directory.current.path,
  );
  coldSw.stop();

  if (res.exitCode != 0) {
    print('⚠️  Build exited ${res.exitCode}');
    if ((res.stderr as String).isNotEmpty) print(res.stderr);
  } else {
    print('   ✅ Cold build: ${coldSw.elapsedMilliseconds} ms');
  }

  await _reload(proj, changed, cycles);

  print('\n━' * 64);
  print('📋 Summary');
  print('   Injected modules : $count  (type: $type)');
  print('   Cold build       : ${coldSw.elapsedMilliseconds} ms');
  print('   Changed/cycle    : $changed');
  print(
    '\n🧹 Clean:  dart run tool/scale_inject.dart clean --project=${proj.path}',
  );
}

// ── helpers ───────────────────────────────────────────────────────────────────

String _detectTypes(List<File> files) {
  final types = <String>[];
  for (final f in files) {
    final src = f.readAsStringSync();
    if (src.contains('StatefulWidget')) {
      types.add('Stateful');
    } else if (src.contains('StatelessWidget')) {
      types.add('Stateless');
    } else if (src.contains('ScaleCard')) {
      types.add('Card+Model');
    } else {
      types.add('Service');
    }
  }
  return types.join(', ');
}

Map<String, String> _parseFlags(List<String> args) {
  final m = <String, String>{};
  for (final a in args) {
    if (a.startsWith('--')) {
      final p = a.substring(2).split('=');
      if (p.length == 2) m[p[0]] = p[1];
    }
  }
  return m;
}

void _usage() => print('''
scale_inject — Inject realistic Flutter widgets + services into a DartNative project.

  inject  --project=<p> --count=<N> [--type=mixed|widget|stateful|service]
  clean   --project=<p>
  reload  --project=<p> --changed=<N> --cycles=<N>
  bench   --project=<p> --count=<N>  --changed=<N> --cycles=<N>

Defaults: project=example  count=500  changed=10  cycles=3  type=mixed

Module types injected (mixed mode):
  40% ScaleCard<N>     — StatefulWidget + model class in one file
  25% ScaleWidget<N>   — StatelessWidget with styled row
  20% ScaleStateful<N> — StatefulWidget with counter + expand
  15% ScaleService<N>  — Pure Dart model + repository class
''');
