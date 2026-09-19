import 'dart:math' as math;

/// Self-contained Pure-Dart QR Code generator and terminal ANSI renderer.
///
/// Implements QR Code Model 2 (Versions 1-6, Byte mode, Error Correction Level L)
/// with zero external dependencies and full offline support.
class QrCode {
  final String text;
  late final int version;
  late final int size;
  late final List<List<int>> _modules; // 1 = black, 0 = white, -1 = empty
  late final List<List<bool>> _isFunctionPattern;

  QrCode(this.text) {
    _init();
  }

  // Version specs for Level L:
  // [version, totalCodewords, dataCodewords, ecCodewords, size, alignmentPatternPos]
  static const List<_VersionSpec> _specs = [
    _VersionSpec(version: 1, total: 26, data: 19, ec: 7, size: 21, alignPos: []),
    _VersionSpec(version: 2, total: 44, data: 34, ec: 10, size: 25, alignPos: [6, 18]),
    _VersionSpec(version: 3, total: 70, data: 55, ec: 15, size: 29, alignPos: [6, 22]),
    _VersionSpec(version: 4, total: 100, data: 80, ec: 20, size: 33, alignPos: [6, 26]),
    _VersionSpec(version: 5, total: 134, data: 108, ec: 26, size: 37, alignPos: [6, 30]),
    _VersionSpec(version: 6, total: 172, data: 136, ec: 36, size: 41, alignPos: [6, 34]),
  ];

  void _init() {
    final bytes = text.codeUnits;
    // Header is 4 bits (mode) + 8 bits (count) = 12 bits = 1.5 bytes
    final requiredDataBytes = bytes.length + 2;

    _VersionSpec? spec;
    for (final s in _specs) {
      if (s.data >= requiredDataBytes) {
        spec = s;
        break;
      }
    }
    spec ??= _specs.last;

    version = spec.version;
    size = spec.size;
    _modules = List.generate(size, (_) => List<int>.filled(size, -1));
    _isFunctionPattern = List.generate(size, (_) => List<bool>.filled(size, false));

    // 1. Encode data bits into bytes
    final dataBytes = _encodeData(bytes, spec.data);

    // 2. Generate Error Correction Codewords
    final ecBytes = _generateEcBytes(dataBytes, spec.ec);

    // 3. Combined codewords
    final allCodewords = [...dataBytes, ...ecBytes];

    // 4. Place function patterns
    _placeFinderPatterns();
    _placeTimingPatterns();
    if (spec.alignPos.isNotEmpty) {
      _placeAlignmentPatterns(spec.alignPos);
    }
    _placeDarkModule();

    // 5. Reserve format info
    _reserveFormatInfo();

    // 6. Place data bits with masking (Mask 0: (row + col) % 2 == 0)
    _placeDataBits(allCodewords);

    // 7. Write format info (Level L, Mask 0)
    _writeFormatInfo();
  }

  List<int> _encodeData(List<int> data, int totalDataBytes) {
    final bits = <int>[];

    // Byte mode indicator: 0100
    bits.addAll([0, 1, 0, 0]);

    // Character count indicator (8 bits for v1-9)
    for (var i = 7; i >= 0; i--) {
      bits.add((data.length >> i) & 1);
    }

    // Data bytes
    for (final b in data) {
      for (var i = 7; i >= 0; i--) {
        bits.add((b >> i) & 1);
      }
    }

    // Terminator: up to 4 zeros
    final bitCapacity = totalDataBytes * 8;
    final termLen = math.min(4, bitCapacity - bits.length);
    for (var i = 0; i < termLen; i++) {
      bits.add(0);
    }

    // Pad to multiple of 8
    while (bits.length % 8 != 0) {
      bits.add(0);
    }

    // Pack into bytes
    final result = <int>[];
    for (var i = 0; i < bits.length; i += 8) {
      var byte = 0;
      for (var j = 0; j < 8; j++) {
        byte = (byte << 1) | bits[i + j];
      }
      result.add(byte);
    }

    // Pad bytes alternate 0xEC and 0x11
    final padBytes = [0xEC, 0x11];
    var padIdx = 0;
    while (result.length < totalDataBytes) {
      result.add(padBytes[padIdx % 2]);
      padIdx++;
    }

    return result;
  }

  List<int> _generateEcBytes(List<int> data, int ecCount) {
    // GF(256) tables
    final exp = List<int>.filled(512, 0);
    final log = List<int>.filled(256, 0);
    var x = 1;
    for (var i = 0; i < 255; i++) {
      exp[i] = x;
      log[x] = i;
      x <<= 1;
      if ((x & 0x100) != 0) x ^= 0x11D;
    }
    for (var i = 255; i < 512; i++) {
      exp[i] = exp[i - 255];
    }

    int gMul(int a, int b) => (a == 0 || b == 0) ? 0 : exp[log[a] + log[b]];

    // Generator polynomial
    var poly = [1];
    for (var i = 0; i < ecCount; i++) {
      final nextPoly = List<int>.filled(poly.length + 1, 0);
      final alpha = exp[i];
      for (var j = 0; j < poly.length; j++) {
        nextPoly[j] ^= poly[j];
        nextPoly[j + 1] ^= gMul(poly[j], alpha);
      }
      poly = nextPoly;
    }

    // Polynomial division
    final message = [...data, ...List<int>.filled(ecCount, 0)];
    for (var i = 0; i < data.length; i++) {
      final coef = message[i];
      if (coef != 0) {
        for (var j = 0; j < poly.length; j++) {
          message[i + j] ^= gMul(poly[j], coef);
        }
      }
    }

    return message.sublist(data.length);
  }

  void _placeFinderPatterns() {
    void place(int r, int c) {
      for (var dr = -1; dr <= 7; dr++) {
        for (var dc = -1; dc <= 7; dc++) {
          final row = r + dr;
          final col = c + dc;
          if (row >= 0 && row < size && col >= 0 && col < size) {
            final isBorder = dr == -1 || dr == 7 || dc == -1 || dc == 7;
            final isOuterSquare =
                dr == 0 || dr == 6 || dc == 0 || dc == 6;
            final isInnerDot = dr >= 2 && dr <= 4 && dc >= 2 && dc <= 4;
            final val = (!isBorder && (isOuterSquare || isInnerDot)) ? 1 : 0;
            _modules[row][col] = val;
            _isFunctionPattern[row][col] = true;
          }
        }
      }
    }

    place(0, 0);
    place(0, size - 7);
    place(size - 7, 0);
  }

  void _placeTimingPatterns() {
    for (var i = 8; i < size - 8; i++) {
      final val = (i % 2 == 0) ? 1 : 0;
      if (_modules[6][i] == -1) {
        _modules[6][i] = val;
        _isFunctionPattern[6][i] = true;
      }
      if (_modules[i][6] == -1) {
        _modules[i][6] = val;
        _isFunctionPattern[i][6] = true;
      }
    }
  }

  void _placeAlignmentPatterns(List<int> pos) {
    for (final r in pos) {
      for (final c in pos) {
        // Skip if overlaps with finders
        if ((r < 9 && c < 9) ||
            (r < 9 && c > size - 9) ||
            (r > size - 9 && c < 9)) {
          continue;
        }

        for (var dr = -2; dr <= 2; dr++) {
          for (var dc = -2; dc <= 2; dc++) {
            final isBorder = dr.abs() == 2 || dc.abs() == 2;
            final isCenter = dr == 0 && dc == 0;
            final val = (isBorder || isCenter) ? 1 : 0;
            _modules[r + dr][c + dc] = val;
            _isFunctionPattern[r + dr][c + dc] = true;
          }
        }
      }
    }
  }

  void _placeDarkModule() {
    final r = 4 * version + 9;
    _modules[r][8] = 1;
    _isFunctionPattern[r][8] = true;
  }

  void _reserveFormatInfo() {
    for (var i = 0; i <= 8; i++) {
      if (!_isFunctionPattern[8][i]) _isFunctionPattern[8][i] = true;
      if (!_isFunctionPattern[i][8]) _isFunctionPattern[i][8] = true;
    }
    for (var i = size - 8; i < size; i++) {
      if (!_isFunctionPattern[8][i]) _isFunctionPattern[8][i] = true;
      if (!_isFunctionPattern[i][8]) _isFunctionPattern[i][8] = true;
    }
  }

  void _placeDataBits(List<int> codewords) {
    // Convert to bit stream
    final bitStream = <int>[];
    for (final cw in codewords) {
      for (var i = 7; i >= 0; i--) {
        bitStream.add((cw >> i) & 1);
      }
    }

    var bitIdx = 0;
    var col = size - 1;
    var goingUp = true;

    while (col > 0) {
      if (col == 6) col--; // Skip vertical timing line

      for (var i = 0; i < size; i++) {
        final r = goingUp ? (size - 1 - i) : i;

        for (var dc = 0; dc < 2; dc++) {
          final c = col - dc;
          if (_isFunctionPattern[r][c]) continue;

          var bit = 0;
          if (bitIdx < bitStream.length) {
            bit = bitStream[bitIdx++];
          }

          // Apply Mask 0: (row + col) % 2 == 0
          if ((r + c) % 2 == 0) {
            bit ^= 1;
          }

          _modules[r][c] = bit;
        }
      }
      col -= 2;
      goingUp = !goingUp;
    }
  }

  void _writeFormatInfo() {
    // Level L = 01 (bits: 0, 1), Mask 0 = 000
    // Format data: 01000 = 8.
    // BCH(15, 5) code for 01000 gives 15-bit format info with mask 0x5412:
    // Level L + Mask 0: 0x77C4 (binary: 111011111000100)
    const formatBits = 0x77C4;

    for (var i = 0; i < 15; i++) {
      final bit = (formatBits >> (14 - i)) & 1;

      // Around top-left finder
      if (i < 6) {
        _modules[8][i] = bit;
      } else if (i == 6) {
        _modules[8][7] = bit;
      } else if (i == 7) {
        _modules[8][8] = bit;
      } else if (i == 8) {
        _modules[7][8] = bit;
      } else {
        _modules[14 - i][8] = bit;
      }

      // Around split finders
      if (i < 8) {
        _modules[size - 1 - i][8] = bit;
      } else {
        _modules[8][size - 15 + i] = bit;
      }
    }
  }

  /// Renders the QR code into terminal using Unicode half-blocks with no border.
  ///
  /// Each character cell represents two vertical dots:
  /// - ` ` (both 0)
  /// - `▀` (top 1, bottom 0)
  /// - `▄` (top 0, bottom 1)
  /// - `█` (both 1)
  String renderToTerminal({int quietZone = 0}) {
    final buffer = StringBuffer();
    final fullSize = size + (quietZone * 2);

    int getModule(int r, int c) {
      final origR = r - quietZone;
      final origC = c - quietZone;
      if (origR < 0 || origR >= size || origC < 0 || origC >= size) {
        return 0;
      }
      return _modules[origR][origC] == 1 ? 1 : 0;
    }

    for (var r = 0; r < fullSize; r += 2) {
      for (var c = 0; c < fullSize; c++) {
        final top = getModule(r, c);
        final bottom = (r + 1 < fullSize) ? getModule(r + 1, c) : 0;

        if (top == 1 && bottom == 1) {
          buffer.write('█');
        } else if (top == 1 && bottom == 0) {
          buffer.write('▀');
        } else if (top == 0 && bottom == 1) {
          buffer.write('▄');
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

class _VersionSpec {
  final int version;
  final int total;
  final int data;
  final int ec;
  final int size;
  final List<int> alignPos;

  const _VersionSpec({
    required this.version,
    required this.total,
    required this.data,
    required this.ec,
    required this.size,
    required this.alignPos,
  });
}
