/// Reload driver: scripted hot-reload / hot-restart edits for tests.
///
/// Thin script layer over [DnHarness] so scenarios read as event streams:
/// launch → tap → edit → reload → assert, mirroring what the dev server +
/// mobile client do over the WebSocket (`reload` broadcast in
/// `lib/src/cli/server.dart`).
library;

import 'package:dartnative/dartnative.dart';

import 'harness.dart';

/// Kind of refresh to apply after a source edit.
enum RefreshKind {
  /// State-preserving re-evaluate (`isHotReload: true`).
  reload,

  /// Full restart (fresh interpreter, state reset).
  restart,
}

/// Applies [newFiles] to [harness] with the given [kind].
Future<Widget> applyEdit(
  DnHarness harness,
  Map<String, String> newFiles, {
  RefreshKind kind = RefreshKind.reload,
}) {
  return switch (kind) {
    RefreshKind.reload => harness.hotReload(newFiles),
    RefreshKind.restart => harness.hotRestart(newFiles),
  };
}

/// A single scripted step: edit sources then refresh.
class EditStep {
  final Map<String, String> newFiles;
  final RefreshKind kind;

  const EditStep(this.newFiles, {this.kind = RefreshKind.reload});
}

/// Applies [steps] in order, returning the final root widget.
Future<Widget> applyEditScript(DnHarness harness, List<EditStep> steps) async {
  Widget? root = harness.lastRoot;
  for (final step in steps) {
    root = await applyEdit(harness, step.newFiles, kind: step.kind);
  }
  return root!;
}
