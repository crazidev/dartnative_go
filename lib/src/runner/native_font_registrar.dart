import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'logger.dart';

/// Maps declared pubspec/IconData font family names (e.g. `'Lucide'`,
/// `'ArialRoundedBold'`) to the internal PostScript/family name registered
/// with CoreText (`'lucide'`, `'ArialRoundedMTBold'`).
class FontFamilyResolver {
  static final Map<String, String> _aliases = {};

  /// Registers a mapping from [declaredFamily] to [nativeName].
  static void registerAlias(String declaredFamily, String nativeName) {
    final key = declaredFamily.trim();
    final val = nativeName.trim();
    if (key.isEmpty || val.isEmpty) return;
    _aliases[key] = val;
  }

  /// Resolves [family] to its registered native font name if an alias exists,
  /// otherwise returns [family] unchanged.
  static String? resolve(String? family) {
    if (family == null) return null;
    final trimmed = family.trim();
    if (trimmed.isEmpty) return family;
    return _aliases[trimmed] ?? family;
  }

  /// Clears all registered aliases.
  static void clear() => _aliases.clear();

  /// Parses a TrueType / OpenType `name` table and returns the PostScript name
  /// (`nameID == 6`) or Family name (`nameID == 1`), or null if unreadable.
  static String? extractNativeFontName(List<int> bytes) {
    if (bytes.length < 12) return null;
    final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    final bd = ByteData.sublistView(data);
    final numTables = bd.getUint16(4, Endian.big);
    if (12 + numTables * 16 > data.length) return null;

    int? nameOffset;
    int? nameLength;
    for (var i = 0; i < numTables; i++) {
      final entryOffset = 12 + i * 16;
      final tag = String.fromCharCodes(
        data.sublist(entryOffset, entryOffset + 4),
      );
      if (tag == 'name') {
        nameOffset = bd.getUint32(entryOffset + 8, Endian.big);
        nameLength = bd.getUint32(entryOffset + 12, Endian.big);
        break;
      }
    }
    if (nameOffset == null ||
        nameLength == null ||
        nameOffset + 6 > data.length) {
      return null;
    }

    final count = bd.getUint16(nameOffset + 2, Endian.big);
    final stringOffset = bd.getUint16(nameOffset + 4, Endian.big);
    final storageStart = nameOffset + stringOffset;

    String? postScriptName;
    String? familyName;

    for (var i = 0; i < count; i++) {
      final rec = nameOffset + 6 + i * 12;
      if (rec + 12 > data.length) break;
      final platformId = bd.getUint16(rec, Endian.big);
      final nameId = bd.getUint16(rec + 6, Endian.big);
      if (nameId != 1 && nameId != 6) continue;
      final length = bd.getUint16(rec + 8, Endian.big);
      final offset = bd.getUint16(rec + 10, Endian.big);
      final start = storageStart + offset;
      final end = start + length;
      if (end > data.length) continue;

      String? decoded;
      if (platformId == 3 || platformId == 0) {
        // UTF-16BE
        final codeUnits = <int>[];
        for (var j = start; j + 1 < end; j += 2) {
          codeUnits.add((data[j] << 8) | data[j + 1]);
        }
        decoded = String.fromCharCodes(codeUnits).trim();
      } else if (platformId == 1) {
        // Mac Roman / ASCII
        decoded = latin1.decode(data.sublist(start, end)).trim();
      }
      if (decoded == null || decoded.isEmpty) continue;
      if (nameId == 6) {
        postScriptName ??= decoded;
      } else if (nameId == 1) {
        familyName ??= decoded;
      }
    }
    return postScriptName ?? familyName;
  }
}

// CoreText / CoreFoundation FFI typedefs for Darwin (iOS / macOS).
typedef _MallocNative = Pointer<Uint8> Function(IntPtr size);
typedef _MallocDart = Pointer<Uint8> Function(int size);
typedef _FreeNative = Void Function(Pointer<Void> ptr);
typedef _FreeDart = void Function(Pointer<Void> ptr);

typedef _CFURLCreateFromFSRepNative =
    Pointer<Void> Function(
      Pointer<Void> allocator,
      Pointer<Uint8> buffer,
      IntPtr bufLen,
      Uint8 isDirectory,
    );
typedef _CFURLCreateFromFSRepDart =
    Pointer<Void> Function(
      Pointer<Void> allocator,
      Pointer<Uint8> buffer,
      int bufLen,
      int isDirectory,
    );

typedef _CFReleaseNative = Void Function(Pointer<Void> cf);
typedef _CFReleaseDart = void Function(Pointer<Void> cf);

typedef _CTFontManagerRegisterFontsForURLNative =
    Uint8 Function(
      Pointer<Void> fontURL,
      Uint32 scope,
      Pointer<Pointer<Void>> error,
    );
typedef _CTFontManagerRegisterFontsForURLDart =
    int Function(
      Pointer<Void> fontURL,
      int scope,
      Pointer<Pointer<Void>> error,
    );

typedef _CFErrorGetCodeNative = IntPtr Function(Pointer<Void> err);
typedef _CFErrorGetCodeDart = int Function(Pointer<Void> err);

/// Registers downloaded `.ttf` / `.otf` font files at runtime so `TextStyle`
/// and `IconData` can render on-demand fonts without bundling them at build
/// time.
///
/// On iOS and macOS, uses CoreText (`CTFontManagerRegisterFontsForURL` with
/// `kCTFontManagerScopeProcess`) via `dart:ffi`. On other platforms, acts as
/// a safe no-op.
class NativeFontRegistrar {
  static const int _kCTFontManagerScopeProcess = 1;
  static const int _kCTFontManagerErrorAlreadyRegistered = 105;

  final Set<String> _registeredPaths = {};

  _MallocDart? _malloc;
  _FreeDart? _free;
  _CFURLCreateFromFSRepDart? _cfUrlCreate;
  _CFReleaseDart? _cfRelease;
  _CTFontManagerRegisterFontsForURLDart? _ctRegister;
  _CTFontManagerRegisterFontsForURLDart? _ctUnregister;
  _CFErrorGetCodeDart? _cfErrorGetCode;
  bool _ffiInitAttempted = false;
  bool _ffiAvailable = false;

  /// Paths successfully registered in this process.
  Set<String> get registeredPaths => Set<String>.of(_registeredPaths);

  bool _ensureFfi() {
    if (_ffiInitAttempted) return _ffiAvailable;
    _ffiInitAttempted = true;
    if (!Platform.isIOS && !Platform.isMacOS) return false;
    try {
      final proc = DynamicLibrary.process();
      DynamicLibrary openOrProcess(String path, String probeSymbol) {
        if (proc.providesSymbol(probeSymbol)) return proc;
        return DynamicLibrary.open(path);
      }

      final cf = openOrProcess(
        '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation',
        'CFURLCreateFromFileSystemRepresentation',
      );
      final ct = openOrProcess(
        '/System/Library/Frameworks/CoreText.framework/CoreText',
        'CTFontManagerRegisterFontsForURL',
      );
      _malloc = proc.lookupFunction<_MallocNative, _MallocDart>('malloc');
      _free = proc.lookupFunction<_FreeNative, _FreeDart>('free');
      _cfUrlCreate = cf
          .lookupFunction<
            _CFURLCreateFromFSRepNative,
            _CFURLCreateFromFSRepDart
          >('CFURLCreateFromFileSystemRepresentation');
      _cfRelease = cf.lookupFunction<_CFReleaseNative, _CFReleaseDart>(
        'CFRelease',
      );
      _cfErrorGetCode = cf
          .lookupFunction<_CFErrorGetCodeNative, _CFErrorGetCodeDart>(
            'CFErrorGetCode',
          );
      _ctRegister = ct
          .lookupFunction<
            _CTFontManagerRegisterFontsForURLNative,
            _CTFontManagerRegisterFontsForURLDart
          >('CTFontManagerRegisterFontsForURL');
      _ctUnregister = ct
          .lookupFunction<
            _CTFontManagerRegisterFontsForURLNative,
            _CTFontManagerRegisterFontsForURLDart
          >('CTFontManagerUnregisterFontsForURL');
      _ffiAvailable = true;
    } catch (e) {
      DartGoLogger.warn('NativeFontRegistrar: CoreText FFI unavailable: $e');
      _ffiAvailable = false;
    }
    return _ffiAvailable;
  }

  /// Registers [file] with the process font manager and records any
  /// [declaredFamily] → native PostScript/family name alias.
  bool registerFile(File file, {String? declaredFamily}) {
    final path = file.absolute.path;
    if (declaredFamily != null && file.existsSync()) {
      try {
        final nativeName = FontFamilyResolver.extractNativeFontName(
          file.readAsBytesSync(),
        );
        if (nativeName != null && nativeName.isNotEmpty) {
          FontFamilyResolver.registerAlias(declaredFamily, nativeName);
        }
      } catch (_) {}
    }
    if (_registeredPaths.contains(path)) return true;
    if (!file.existsSync()) return false;
    if (!_ensureFfi()) return false;

    return _withCfUrl(path, (cfUrl) {
      final errPtr = _malloc!(sizeOf<Pointer<Void>>()).cast<Pointer<Void>>();
      errPtr.value = nullptr;
      try {
        final ok = _ctRegister!(cfUrl, _kCTFontManagerScopeProcess, errPtr);
        if (ok != 0) {
          _registeredPaths.add(path);
          return true;
        }
        final err = errPtr.value;
        if (err != nullptr) {
          final code = _cfErrorGetCode!(err);
          _cfRelease!(err);
          if (code == _kCTFontManagerErrorAlreadyRegistered) {
            _registeredPaths.add(path);
            return true;
          }
          DartGoLogger.warn(
            'NativeFontRegistrar: failed to register $path (CoreText error $code)',
          );
        }
        return false;
      } finally {
        _free!(errPtr.cast<Void>());
      }
    });
  }

  /// Unregisters a previously registered font [file] (used when reinvalidating
  /// an updated font file on disk).
  bool unregisterFile(File file) {
    final path = file.absolute.path;
    _registeredPaths.remove(path);
    if (!_ensureFfi()) return false;

    return _withCfUrl(path, (cfUrl) {
      final errPtr = _malloc!(sizeOf<Pointer<Void>>()).cast<Pointer<Void>>();
      errPtr.value = nullptr;
      try {
        final ok = _ctUnregister!(cfUrl, _kCTFontManagerScopeProcess, errPtr);
        final err = errPtr.value;
        if (err != nullptr) {
          _cfRelease!(err);
        }
        return ok != 0;
      } finally {
        _free!(errPtr.cast<Void>());
      }
    });
  }

  bool _withCfUrl(String path, bool Function(Pointer<Void> cfUrl) fn) {
    final bytes = utf8.encode(path);
    final buf = _malloc!(bytes.length);
    try {
      buf.asTypedList(bytes.length).setAll(0, bytes);
      final cfUrl = _cfUrlCreate!(nullptr, buf, bytes.length, 0);
      if (cfUrl == nullptr) return false;
      try {
        return fn(cfUrl);
      } finally {
        _cfRelease!(cfUrl);
      }
    } finally {
      _free!(buf.cast<Void>());
    }
  }
}
