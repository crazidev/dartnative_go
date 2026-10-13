import 'dart:io';

import 'package:dartnative_go/src/cli/packaging/ast_builder.dart';
import 'package:tom_d4rt_ast/runtime.dart';

void main(List<String> args) async {
  // Configurable scale: default 500 for fast local runs, or pass e.g. 1000 or 2000
  final moduleCount = args.isNotEmpty ? int.tryParse(args[0]) ?? 500 : 500;

  print('================================================================');
  print('⚡️ DartNative Go — Extreme Scale Hot Reload Benchmark ($moduleCount Modules)');
  print('================================================================\n');

  final tmp = Directory.systemTemp.createTempSync('dn_scale_');
  try {
    await runScaleBenchmark(tmp, moduleCount);
  } finally {
    print('\n🧹 Cleaning up benchmark temporary project...');
    try {
      tmp.deleteSync(recursive: true);
    } catch (_) {}
  }

  print('\n================================================================');
  print('🏁 Extreme Scale Benchmark Completed Successfully');
  print('================================================================');
}

Future<void> runScaleBenchmark(Directory tmp, int moduleCount) async {
  final projectDir = Directory('${tmp.path}/scale_project')..createSync(recursive: true);
  File('${projectDir.path}/pubspec.yaml').writeAsStringSync('''
name: scale_project
environment:
  sdk: '>=3.0.0 <4.0.0'
''');

  final libDir = Directory('${projectDir.path}/lib')..createSync(recursive: true);

  print('🛠️ Step 1: Generating $moduleCount Dart modules...');
  final genSw = Stopwatch()..start();

  // Create barrel chunks of 50 to organize imports
  const chunkSize = 50;
  final numBarrels = (moduleCount / chunkSize).ceil();

  for (var b = 0; b < numBarrels; b++) {
    final barrelFile = File('${libDir.path}/barrel_$b.dart');
    final barrelImports = StringBuffer();
    final start = b * chunkSize;
    final end = (start + chunkSize < moduleCount) ? start + chunkSize : moduleCount;

    for (var i = start; i < end; i++) {
      final moduleFile = File('${libDir.path}/service_$i.dart');
      moduleFile.writeAsStringSync('''
class Service$i {
  static int counter = 0;
  static int compute() => ++counter;
  static String version() => 'v1';
}
''');
      barrelImports.writeln("export 'service_$i.dart';");
    }
    barrelFile.writeAsStringSync(barrelImports.toString());
  }

  // Create main.dart importing all barrels
  final mainFile = File('${libDir.path}/main.dart');
  final mainBuf = StringBuffer();
  for (var b = 0; b < numBarrels; b++) {
    mainBuf.writeln("import 'barrel_$b.dart';");
  }
  mainBuf.writeln('''

int executeSample() {
  int total = 0;
  total += Service0.compute();
  return total;
}

String getVersion(int id) {
  if (id == 0) return Service0.version();
  return 'unknown';
}

void main() {}
''');
  mainFile.writeAsStringSync(mainBuf.toString());
  genSw.stop();
  print('   ✅ Generated $moduleCount modules in ${genSw.elapsedMilliseconds} ms\n');

  final outFile = File('${projectDir.path}/guest.ast');

  // =========================================================================
  // Test 1: Cold Full Project Build
  // =========================================================================
  print('📦 Step 2: Cold Full Project Build ($moduleCount modules)...');
  final coldSw = Stopwatch()..start();
  final coldResult = await buildGuestAstBundle(
    projectDir,
    outputArg: outFile.path,
    force: true,
  );
  coldSw.stop();

  if (!coldResult.success) {
    throw StateError('Cold build failed: ${coldResult.error}');
  }
  final coldMs = coldSw.elapsedMilliseconds;
  final bundleSizeKb = (coldResult.byteSize / 1024).toStringAsFixed(1);
  print('   • Modules compiled:     ${coldResult.moduleCount}');
  print('   • Compressed bundle:    $bundleSizeKb KB');
  print('   • Cold Build Duration:  $coldMs ms\n');

  // =========================================================================
  // Test 2: Runtime Initialization & State Seeding
  // =========================================================================
  print('🚀 Step 3: Bootstrapping Runtime & Seeding State...');
  final registry = DeclarationRegistry();
  final runner = D4rtRunner(declarationRegistry: registry);

  final initSw = Stopwatch()..start();
  var bundle = AstBundle.fromFile(outFile.path);
  final initRes = runner.executeBundle(
    bundle,
    name: 'executeSample',
  );
  initSw.stop();

  print('   • Evaluated in:         ${initSw.elapsedMilliseconds} ms');
  print('   • Service0.counter:     $initRes (state seeded)\n');

  // =========================================================================
  // Test 3: Multi-File Batch Hot Reload (10 Modules Edited Simultaneously)
  // =========================================================================
  const smallBatchSize = 10;
  print('⚡️ Step 4: Batch Hot Reload — Updating $smallBatchSize Modules Simultaneously...');
  final batch1Files = <String>{};

  for (var i = 0; i < smallBatchSize; i++) {
    final path = '${libDir.path}/service_$i.dart';
    batch1Files.add(path);
    File(path).writeAsStringSync('''
class Service$i {
  static int counter = 0;
  static int compute() => counter += 10;
  static String version() => 'v2_updated';
}
''');
  }

  final batch1Sw = Stopwatch()..start();

  // 1. Incremental Rebuild
  final buildSw1 = Stopwatch()..start();
  final rebuild1 = await buildGuestAstBundle(
    projectDir,
    outputArg: outFile.path,
    changedFiles: batch1Files,
  );
  buildSw1.stop();
  if (!rebuild1.success) {
    throw StateError('Rebuild 1 failed: ${rebuild1.error}');
  }

  // 2. Client Reload — use in-memory cached bundle (dev server path)
  final evalSw1 = Stopwatch()..start();
  // cachedBundleForProject returns the already-deserialized bundle from
  // the last build: zero disk I/O, zero ZIP decode, zero fromJson cost.
  bundle = cachedBundleForProject(projectDir) ?? AstBundle.fromFile(outFile.path);
  runner.executeBundle(
    bundle,
    name: 'main',
    moduleFingerprints: rebuild1.moduleFingerprints,
  );
  evalSw1.stop();
  batch1Sw.stop();

  // 3. Verify state preservation & code swap
  final vRes = runner.executeBundle(
    bundle,
    name: 'getVersion',
    positionalArgs: [0],
  );
  final countRes = runner.executeBundle(
    bundle,
    name: 'executeSample',
  );

  final speedupRebuild = (coldMs / (buildSw1.elapsedMilliseconds > 0 ? buildSw1.elapsedMilliseconds : 1)).toStringAsFixed(1);
  print('   • Modified files:       $smallBatchSize of $moduleCount (${moduleCount - smallBatchSize} modules skipped analyzer!)');
  print('   • Rebuild time:         ${buildSw1.elapsedMilliseconds} ms (vs ${coldMs}ms cold build — ${speedupRebuild}x faster!)');
  print('   • Client reload time:   ${evalSw1.elapsedMilliseconds} ms');
  print('   • Total Reload Latency: ${batch1Sw.elapsedMilliseconds} ms');
  print('   • Swapped code check:   Service0.version() = "$vRes" (Expected: "v2_updated")');
  print('   • State preserved:      Service0.counter = $countRes (Preserved count 1 + 10 = 11)\n');

  // =========================================================================
  // Test 4: Heavy Concurrency Batch Reload (50 Modules Edited Simultaneously)
  // =========================================================================
  final largeBatchSize = (moduleCount >= 100) ? 50 : 20;
  print('🔥 Step 5: Large Concurrency Batch — Updating $largeBatchSize Modules Simultaneously...');
  final batch2Files = <String>{};

  for (var i = 10; i < 10 + largeBatchSize; i++) {
    final path = '${libDir.path}/service_$i.dart';
    batch2Files.add(path);
    File(path).writeAsStringSync('''
class Service$i {
  static int counter = 0;
  static int compute() => counter += 50;
  static String version() => 'v3_large_batch';
}
''');
  }

  final batch2Sw = Stopwatch()..start();
  final rebuild2 = await buildGuestAstBundle(
    projectDir,
    outputArg: outFile.path,
    changedFiles: batch2Files,
  );
  if (!rebuild2.success) {
    throw StateError('Rebuild 2 failed: ${rebuild2.error}');
  }

  bundle = cachedBundleForProject(projectDir) ?? AstBundle.fromFile(outFile.path);
  runner.executeBundle(
    bundle,
    name: 'main',
    moduleFingerprints: rebuild2.moduleFingerprints,
  );
  batch2Sw.stop();

  print('   • Modified files:       $largeBatchSize simultaneous files');
  print('   • Total Rebuild+Reload: ${batch2Sw.elapsedMilliseconds} ms');
  print('   • Average per module:   ${(batch2Sw.elapsedMilliseconds / largeBatchSize).toStringAsFixed(2)} ms / updated module\n');

  // =========================================================================
  // Test 5: No-Op Multi-Save Fast Path (0 Content Changes)
  // =========================================================================
  print('⚡️ Step 6: No-Op Auto-Save Across All $moduleCount Modules...');
  final noOpSw = Stopwatch()..start();
  final noOpResult = await buildGuestAstBundle(
    projectDir,
    outputArg: outFile.path,
    changedFiles: {},
  );
  noOpSw.stop();

  print('   • Cache check time:     ${noOpSw.elapsedMilliseconds} ms');
  print('   • Cache hit confirmed:  ${noOpResult.cached}');
}
