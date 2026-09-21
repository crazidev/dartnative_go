/// Shared fixtures for Riverpod interpreter suites.
///
/// Both `riverpod_comprehensive_test.dart` and `riverpod_hot_reload_test.dart`
/// need a host-side `ConsumerHost` (no engine) plus throwaway guest projects.
/// Defined once here so the suites stay focused on behavior.
library;

import 'dart:io';

import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
import 'package:riverpod_kit/src/widget_ref.dart';

/// Minimal `BuildContext` for driving interpreted `ConsumerWidget.build`
/// directly on the host VM.
class FakeBuildContext implements BuildContext {
  @override
  Widget get widget => throw UnimplementedError();

  @override
  bool get mounted => true;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Minimal `ConsumerHost` with a live `ProviderContainer`.
class TestConsumerHost implements ConsumerHost {
  @override
  final BuildContext context = FakeBuildContext();

  @override
  final ProviderContainer container = ProviderContainer();

  @override
  void markNeedsBuild() {}

  @override
  void onNextBuild(void Function() teardown) {}
}

/// Creates `<parent>/<name>/` with a Riverpod guest pubspec + empty `lib/`.
/// Returns the project dir; callers write their guest `lib/*.dart` files.
Directory createRiverpodProjectShell(Directory parent, String name) {
  final dir = Directory('${parent.path}/$name')..createSync(recursive: true);
  File('${dir.path}/pubspec.yaml').writeAsStringSync('''
name: $name
dependencies:
  dartnative: ^1.0.0
  riverpod_kit:
    hosted: https://dartpub.dev
    version: ^0.1.0
''');
  Directory('${dir.path}/lib').createSync();
  return dir;
}

/// Best-effort recursive delete for temp dirs (for `tearDownAll`).
void deleteTempDir(Directory dir) {
  try {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  } catch (_) {}
}
