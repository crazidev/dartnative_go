import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'bytecode_models.dart';

/// Magic header for binary encoded Bytecode Bundles ("DNBC").
const int kBytecodeMagic = 0x444E4243;

/// Codec to serialize and deserialize Bytecode Bundles and Delta patches.
class BytecodeBundleCodec {
  /// Encodes a [BytecodeBundle] into gzip-compressed JSON bytes.
  static Uint8List encodeBundle(BytecodeBundle bundle) {
    final jsonStr = jsonEncode(bundle.toJson());
    final utf8Bytes = utf8.encode(jsonStr);
    final compressed = gzip.encode(utf8Bytes);
    return Uint8List.fromList(compressed);
  }

  /// Decodes a [BytecodeBundle] from bytes (supports raw JSON or gzip).
  static BytecodeBundle decodeBundle(List<int> bytes) {
    List<int> decompressed = bytes;
    // Check if gzipped (magic bytes 0x1F, 0x8B)
    if (bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B) {
      decompressed = gzip.decode(bytes);
    }
    final jsonStr = utf8.decode(decompressed);
    final dynamic map = jsonDecode(jsonStr);
    if (map is Map<String, dynamic>) {
      return BytecodeBundle.fromJson(map);
    }
    throw FormatException('Invalid BytecodeBundle payload');
  }

  /// Encodes a [BytecodeDelta] into JSON bytes.
  static Uint8List encodeDelta(BytecodeDelta delta) {
    final jsonStr = jsonEncode(delta.toJson());
    final utf8Bytes = utf8.encode(jsonStr);
    return Uint8List.fromList(utf8Bytes);
  }

  /// Decodes a [BytecodeDelta] from bytes.
  static BytecodeDelta decodeDelta(List<int> bytes) {
    List<int> decompressed = bytes;
    if (bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B) {
      decompressed = gzip.decode(bytes);
    }
    final jsonStr = utf8.decode(decompressed);
    final dynamic map = jsonDecode(jsonStr);
    if (map is Map<String, dynamic>) {
      return BytecodeDelta.fromJson(map);
    }
    throw FormatException('Invalid BytecodeDelta payload');
  }
}
