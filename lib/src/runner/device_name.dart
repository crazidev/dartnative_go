/// Cross-platform human-readable device name resolution for the DartNative Go
/// mobile shell (iOS Simulator, physical iPhone/iPad, Android, and desktop).
library;

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

typedef _MallocNative = Pointer<Void> Function(IntPtr size);
typedef _MallocDart = Pointer<Void> Function(int size);
typedef _FreeNative = Void Function(Pointer<Void> ptr);
typedef _FreeDart = void Function(Pointer<Void> ptr);
typedef _ObjcGetClassNative = Pointer<Void> Function(Pointer<Uint8> name);
typedef _ObjcGetClassDart = Pointer<Void> Function(Pointer<Uint8> name);
typedef _SelRegisterNameNative = Pointer<Void> Function(Pointer<Uint8> name);
typedef _SelRegisterNameDart = Pointer<Void> Function(Pointer<Uint8> name);
typedef _ObjcMsgSend0Native =
    Pointer<Void> Function(Pointer<Void> target, Pointer<Void> selector);
typedef _ObjcMsgSend0Dart =
    Pointer<Void> Function(Pointer<Void> target, Pointer<Void> selector);
typedef _SysctlByNameNative =
    Int32 Function(
      Pointer<Uint8> name,
      Pointer<Void> oldp,
      Pointer<IntPtr> oldlenp,
      Pointer<Void> newp,
      IntPtr newlen,
    );
typedef _SysctlByNameDart =
    int Function(
      Pointer<Uint8> name,
      Pointer<Void> oldp,
      Pointer<IntPtr> oldlenp,
      Pointer<Void> newp,
      int newlen,
    );

/// Resolves a human-readable device name to advertise to the dev server when
/// connecting over WebSocket (e.g. `iPhone 13 Pro`, `Pixel 9 Pro`).
///
/// On iOS (Simulator and physical devices), this never falls back to the Mac
/// host's `Platform.localHostname` when running in a simulator.
String resolveDeviceName({
  Map<String, String>? environment,
  String? operatingSystem,
  String? localHostname,
  String? Function()? readIosUiDeviceName,
  String? Function()? readIosHardwareMachine,
  String? Function(String prop)? readAndroidProp,
}) {
  final env = environment ?? Platform.environment;
  final os = operatingSystem ?? Platform.operatingSystem;

  if (os == 'ios') {
    return _resolveIosDeviceName(
      env: env,
      localHostname: localHostname,
      readUiDeviceName: readIosUiDeviceName ?? _readIosUiDeviceNameFfi,
      readHwMachine: readIosHardwareMachine ?? _readDarwinHwMachineFfi,
    );
  }

  if (os == 'android') {
    final reader = readAndroidProp ?? _readAndroidSystemProp;
    final marketName = reader('ro.product.marketname')?.trim();
    if (marketName != null && marketName.isNotEmpty) {
      return marketName;
    }
    final model = reader('ro.product.model')?.trim();
    final manufacturer = reader('ro.product.manufacturer')?.trim();
    if (model != null && model.isNotEmpty) {
      if (manufacturer != null &&
          manufacturer.isNotEmpty &&
          !model.toLowerCase().startsWith(manufacturer.toLowerCase()) &&
          !model.toLowerCase().startsWith('sdk_')) {
        return '$manufacturer $model';
      }
      return model;
    }
    return 'Android';
  }

  // Desktop / host VM: use local hostname without `.local`.
  String? host = localHostname;
  if (host == null) {
    try {
      host = Platform.localHostname;
    } catch (_) {}
  }
  final cleanedHost = host
      ?.trim()
      .replaceFirst(RegExp(r'\.local$', caseSensitive: false), '');
  if (cleanedHost != null &&
      cleanedHost.isNotEmpty &&
      cleanedHost.toLowerCase() != 'localhost') {
    return cleanedHost;
  }

  switch (os) {
    case 'macos':
      return 'macOS';
    case 'linux':
      return 'Linux';
    case 'windows':
      return 'Windows';
    default:
      return os.isEmpty ? 'Device' : os;
  }
}

String _resolveIosDeviceName({
  required Map<String, String> env,
  required String? localHostname,
  required String? Function() readUiDeviceName,
  required String? Function() readHwMachine,
}) {
  // 1. iOS Simulator explicit device name (set by Xcode / simctl).
  final simDeviceName = env['SIMULATOR_DEVICE_NAME']?.trim();
  if (simDeviceName != null && simDeviceName.isNotEmpty) {
    return simDeviceName;
  }

  // 2. Physical hardware identifier or simulator model identifier.
  final hwMachine = readHwMachine()?.trim();
  final simModelId = env['SIMULATOR_MODEL_IDENTIFIER']?.trim();
  final isSimulator =
      (simModelId != null && simModelId.isNotEmpty) ||
      env.containsKey('SIMULATOR_UDID') ||
      env.containsKey('SIMULATOR_ROOT') ||
      hwMachine == 'x86_64' ||
      hwMachine == 'arm64';

  // 3. On physical iOS, prefer the exact Apple marketing model (`iPhone 13 Pro`)
  //    over iOS 16+'s generic `"iPhone"`.
  if (!isSimulator && hwMachine != null && hwMachine.isNotEmpty) {
    final mapped = appleModelDisplayName(hwMachine);
    if (mapped != null) return mapped;
  }

  // 4. `UIDevice.current.name` (returns exact simulator name on many runtimes,
  //    or custom name if entitled). Skip generic `"iPhone"` / `"iPad"` so we
  //    can resolve the specific model from `SIMULATOR_MODEL_IDENTIFIER` first.
  final uiName = readUiDeviceName()?.trim();
  if (uiName != null && uiName.isNotEmpty && !_isGenericIosName(uiName)) {
    return uiName;
  }

  // 5. `SIMULATOR_MODEL_IDENTIFIER` (e.g. `iPhone14,2` → `iPhone 13 Pro`).
  if (simModelId != null && simModelId.isNotEmpty) {
    return appleModelDisplayName(simModelId) ?? simModelId;
  }

  // 6. Fallback for unknown physical model identifiers.
  if (hwMachine != null &&
      hwMachine.isNotEmpty &&
      hwMachine != 'x86_64' &&
      hwMachine != 'arm64') {
    return hwMachine;
  }

  if (uiName != null && uiName.isNotEmpty) {
    return isSimulator ? '$uiName Simulator' : uiName;
  }

  // Never fall back to the host Mac's hostname inside an iOS Simulator.
  if (isSimulator) return 'iOS Simulator';

  String? host = localHostname;
  if (host == null) {
    try {
      host = Platform.localHostname;
    } catch (_) {}
  }
  final cleanedHost = host
      ?.trim()
      .replaceFirst(RegExp(r'\.local$', caseSensitive: false), '');
  if (cleanedHost != null &&
      cleanedHost.isNotEmpty &&
      cleanedHost.toLowerCase() != 'localhost') {
    return cleanedHost;
  }
  return 'iOS Device';
}

bool _isGenericIosName(String name) {
  final lower = name.toLowerCase();
  return lower == 'iphone' || lower == 'ipad' || lower == 'ipod touch';
}

/// Maps Apple hardware model identifiers (`iPhone14,2`, `iPad16,3`, …) to
/// human-readable marketing names (`iPhone 13 Pro`, …).
String? appleModelDisplayName(String identifier) =>
    _kAppleModelNames[identifier.trim()];

const Map<String, String> _kAppleModelNames = {
  // iPhone X / XS / XR / 11
  'iPhone10,3': 'iPhone X',
  'iPhone10,6': 'iPhone X',
  'iPhone11,2': 'iPhone XS',
  'iPhone11,4': 'iPhone XS Max',
  'iPhone11,6': 'iPhone XS Max',
  'iPhone11,8': 'iPhone XR',
  'iPhone12,1': 'iPhone 11',
  'iPhone12,3': 'iPhone 11 Pro',
  'iPhone12,5': 'iPhone 11 Pro Max',
  'iPhone12,8': 'iPhone SE (2nd gen)',
  // iPhone 12
  'iPhone13,1': 'iPhone 12 mini',
  'iPhone13,2': 'iPhone 12',
  'iPhone13,3': 'iPhone 12 Pro',
  'iPhone13,4': 'iPhone 12 Pro Max',
  // iPhone 13 / SE 3
  'iPhone14,2': 'iPhone 13 Pro',
  'iPhone14,3': 'iPhone 13 Pro Max',
  'iPhone14,4': 'iPhone 13 mini',
  'iPhone14,5': 'iPhone 13',
  'iPhone14,6': 'iPhone SE (3rd gen)',
  // iPhone 14
  'iPhone14,7': 'iPhone 14',
  'iPhone14,8': 'iPhone 14 Plus',
  'iPhone15,2': 'iPhone 14 Pro',
  'iPhone15,3': 'iPhone 14 Pro Max',
  // iPhone 15
  'iPhone15,4': 'iPhone 15',
  'iPhone15,5': 'iPhone 15 Plus',
  'iPhone16,1': 'iPhone 15 Pro',
  'iPhone16,2': 'iPhone 15 Pro Max',
  // iPhone 16
  'iPhone17,1': 'iPhone 16 Pro',
  'iPhone17,2': 'iPhone 16 Pro Max',
  'iPhone17,3': 'iPhone 16',
  'iPhone17,4': 'iPhone 16 Plus',
  'iPhone17,5': 'iPhone 16e',
  // iPhone 17
  'iPhone18,1': 'iPhone 17 Pro',
  'iPhone18,2': 'iPhone 17 Pro Max',
  'iPhone18,3': 'iPhone 17',
  'iPhone18,4': 'iPhone Air',
  // iPad
  'iPad13,1': 'iPad Air (4th gen)',
  'iPad13,2': 'iPad Air (4th gen)',
  'iPad13,4': 'iPad Pro 11-inch (3rd gen)',
  'iPad13,5': 'iPad Pro 11-inch (3rd gen)',
  'iPad13,6': 'iPad Pro 11-inch (3rd gen)',
  'iPad13,7': 'iPad Pro 11-inch (3rd gen)',
  'iPad13,8': 'iPad Pro 12.9-inch (5th gen)',
  'iPad13,9': 'iPad Pro 12.9-inch (5th gen)',
  'iPad13,10': 'iPad Pro 12.9-inch (5th gen)',
  'iPad13,11': 'iPad Pro 12.9-inch (5th gen)',
  'iPad13,16': 'iPad Air (5th gen)',
  'iPad13,17': 'iPad Air (5th gen)',
  'iPad13,18': 'iPad (10th gen)',
  'iPad13,19': 'iPad (10th gen)',
  'iPad14,1': 'iPad mini (6th gen)',
  'iPad14,2': 'iPad mini (6th gen)',
  'iPad14,3': 'iPad Pro 11-inch (4th gen)',
  'iPad14,4': 'iPad Pro 11-inch (4th gen)',
  'iPad14,5': 'iPad Pro 12.9-inch (6th gen)',
  'iPad14,6': 'iPad Pro 12.9-inch (6th gen)',
  'iPad14,8': 'iPad Air 11-inch (M2)',
  'iPad14,9': 'iPad Air 11-inch (M2)',
  'iPad14,10': 'iPad Air 13-inch (M2)',
  'iPad14,11': 'iPad Air 13-inch (M2)',
  'iPad15,3': 'iPad Air 11-inch (M3)',
  'iPad15,4': 'iPad Air 11-inch (M3)',
  'iPad15,5': 'iPad Air 13-inch (M3)',
  'iPad15,6': 'iPad Air 13-inch (M3)',
  'iPad16,1': 'iPad mini (A17 Pro)',
  'iPad16,2': 'iPad mini (A17 Pro)',
  'iPad16,3': 'iPad Pro 11-inch (M4)',
  'iPad16,4': 'iPad Pro 11-inch (M4)',
  'iPad16,5': 'iPad Pro 13-inch (M4)',
  'iPad16,6': 'iPad Pro 13-inch (M4)',
};

// ---------------------------------------------------------------------------
// Native FFI Readers (iOS / Darwin & Android)
// ---------------------------------------------------------------------------

String? _readIosUiDeviceNameFfi() {
  if (!Platform.isIOS) return null;
  try {
    final proc = DynamicLibrary.process();
    if (!proc.providesSymbol('objc_getClass') ||
        !proc.providesSymbol('sel_registerName') ||
        !proc.providesSymbol('objc_msgSend')) {
      return null;
    }
    final mallocFn = proc.lookupFunction<_MallocNative, _MallocDart>('malloc');
    final freeFn = proc.lookupFunction<_FreeNative, _FreeDart>('free');
    final objcGetClass = proc
        .lookupFunction<_ObjcGetClassNative, _ObjcGetClassDart>(
          'objc_getClass',
        );
    final selRegisterName = proc
        .lookupFunction<_SelRegisterNameNative, _SelRegisterNameDart>(
          'sel_registerName',
        );
    final objcMsgSend0 = proc
        .lookupFunction<_ObjcMsgSend0Native, _ObjcMsgSend0Dart>('objc_msgSend');

    Pointer<Uint8> allocCString(String s) {
      final bytes = utf8.encode(s);
      final ptr = mallocFn(bytes.length + 1).cast<Uint8>();
      final view = ptr.asTypedList(bytes.length + 1);
      view.setRange(0, bytes.length, bytes);
      view[bytes.length] = 0;
      return ptr;
    }

    final clsNamePtr = allocCString('UIDevice');
    final curSelPtr = allocCString('currentDevice');
    final nameSelPtr = allocCString('name');
    final utf8SelPtr = allocCString('UTF8String');
    try {
      final uiDeviceCls = objcGetClass(clsNamePtr);
      if (uiDeviceCls == nullptr) return null;
      final currentDevice = objcMsgSend0(
        uiDeviceCls,
        selRegisterName(curSelPtr),
      );
      if (currentDevice == nullptr) return null;
      final nsName = objcMsgSend0(currentDevice, selRegisterName(nameSelPtr));
      if (nsName == nullptr) return null;
      final cStr = objcMsgSend0(
        nsName,
        selRegisterName(utf8SelPtr),
      ).cast<Uint8>();
      return _readCString(cStr);
    } finally {
      freeFn(clsNamePtr.cast());
      freeFn(curSelPtr.cast());
      freeFn(nameSelPtr.cast());
      freeFn(utf8SelPtr.cast());
    }
  } catch (_) {
    return null;
  }
}

String? _readDarwinHwMachineFfi() {
  if (!Platform.isIOS && !Platform.isMacOS) return null;
  try {
    final proc = DynamicLibrary.process();
    if (!proc.providesSymbol('sysctlbyname')) return null;
    final mallocFn = proc.lookupFunction<_MallocNative, _MallocDart>('malloc');
    final freeFn = proc.lookupFunction<_FreeNative, _FreeDart>('free');
    final sysctlbyname = proc
        .lookupFunction<_SysctlByNameNative, _SysctlByNameDart>('sysctlbyname');

    final keyBytes = utf8.encode('hw.machine');
    final keyPtr = mallocFn(keyBytes.length + 1).cast<Uint8>();
    final lenPtr = mallocFn(sizeOf<IntPtr>()).cast<IntPtr>();
    Pointer<Uint8> outPtr = nullptr;
    try {
      final view = keyPtr.asTypedList(keyBytes.length + 1);
      view.setRange(0, keyBytes.length, keyBytes);
      view[keyBytes.length] = 0;
      lenPtr.value = 0;

      if (sysctlbyname(keyPtr, nullptr, lenPtr, nullptr, 0) != 0) return null;
      final size = lenPtr.value;
      if (size <= 0 || size > 256) return null;

      outPtr = mallocFn(size).cast<Uint8>();
      if (sysctlbyname(keyPtr, outPtr.cast(), lenPtr, nullptr, 0) != 0) {
        return null;
      }
      return _readCString(outPtr, maxLen: size);
    } finally {
      freeFn(keyPtr.cast());
      freeFn(lenPtr.cast());
      if (outPtr != nullptr) freeFn(outPtr.cast());
    }
  } catch (_) {
    return null;
  }
}

String? _readCString(Pointer<Uint8> ptr, {int maxLen = 256}) {
  if (ptr == nullptr) return null;
  final bytes = <int>[];
  for (var i = 0; i < maxLen; i++) {
    final b = ptr[i];
    if (b == 0) break;
    bytes.add(b);
  }
  if (bytes.isEmpty) return null;
  return utf8.decode(bytes, allowMalformed: true).trim();
}

String? _readAndroidSystemProp(String prop) {
  try {
    final result = Process.runSync('getprop', [prop]);
    if (result.exitCode == 0) {
      final out = (result.stdout as String).trim();
      if (out.isNotEmpty) return out;
    }
  } catch (_) {}
  return null;
}
