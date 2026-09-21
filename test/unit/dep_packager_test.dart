import 'dart:io';
import 'package:test/test.dart';
import 'package:dartnative_go/src/cli/dep_packager.dart';

void main() {
  test('DepPackager packs files, computes deterministic hash and creates ZIP', () {
    final tempDir = Directory.systemTemp.createTempSync('dn_dep_packager_test_');

    try {
      final codeDir = Directory('${tempDir.path}/lib')..createSync(recursive: true);
      File('${codeDir.path}/main.dart').writeAsStringSync('void main() { print("Hello"); }');
      File('${codeDir.path}/util.dart').writeAsStringSync('String get greeting => "Hi";');

      final userCode = DepPackager.packUserCode(codeDir);
      expect(userCode.bytes.isNotEmpty, isTrue);
      expect(userCode.hash.isNotEmpty, isTrue);

      // Verify hash is deterministic
      final userCode2 = DepPackager.packUserCode(codeDir);
      expect(userCode2.hash, equals(userCode.hash));

      // Verify deps hash computation
      final deps = [
        const DepEntry(
          name: 'riverpod',
          version: '3.3.2',
          zipUrl: 'http://localhost/pkg/riverpod@3.3.2.zip',
          contentHash: 'abc123',
          byteSize: 1000,
        ),
        const DepEntry(
          name: 'crypto',
          version: '3.0.3',
          zipUrl: 'http://localhost/pkg/crypto@3.0.3.zip',
          contentHash: 'def456',
          byteSize: 500,
        ),
      ];

      final hash1 = DepPackager.computeDepsHash(deps);
      final hash2 = DepPackager.computeDepsHash(deps.reversed.toList());
      expect(hash1, equals(hash2)); // Order independent
      expect(hash1.length, equals(16));
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  });
}
