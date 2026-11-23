/// In-process version snapshot advertised by `dngo --version` and the
/// local dev server.
///
/// Values are the constants baked into the binary by `tool/sync_versions.dart`
/// at install/compile time. Resolution is a few field reads — never spawns
/// `dngo`, `dn`, or touches the filesystem on the hot path.
library;

import 'dart_go_version.dart';

/// Versions this CLI / shell build reports for compatibility checks.
class DngoVersionInfo {
  const DngoVersionInfo({
    required this.dngoVersion,
    required this.runtimeVersion,
    required this.dartNativeVersion,
  });

  /// Same numbers `dngo --version` prints (compiled into this process).
  static const DngoVersionInfo current = DngoVersionInfo(
    dngoVersion: kDartGoVersion,
    runtimeVersion: kDartGoRuntimeVersion,
    dartNativeVersion: kDartNativeVersion,
  );

  final String dngoVersion;
  final String runtimeVersion;
  final String dartNativeVersion;

  /// Payload shared by `/manifest.json`, `/health`, `/`, and the loading page.
  Map<String, Object?> toJson() => {
    'dartGoVersion': dngoVersion,
    'runtimeVersion': runtimeVersion,
    'dartnativeVersion': dartNativeVersion,
  };
}
