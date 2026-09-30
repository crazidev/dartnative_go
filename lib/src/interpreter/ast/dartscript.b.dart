// D4rt Bridge - Generated file, do not edit
// Dartscript registration for dartnative_go_ast
// Generated: 2026-09-21T20:33:13.207071 by tom_d4rt_generator 1.26.2

/// D4rt Bridge Registration for dartnative_go_ast
library;

import 'package:tom_d4rt_ast/d4rt.dart';
import 'dartnative_bridges.b.dart' as dartnative_ui_bridges;
import 'dartnative_webview_bridges.b.dart' as dartnative_webview_bridges;
import 'dartnative_share_bridges.b.dart' as dartnative_share_bridges;
import 'dartnative_shared_preferences_bridges.b.dart' as dartnative_shared_preferences_bridges;
import 'dartnative_path_provider_bridges.b.dart' as dartnative_path_provider_bridges;
import 'dartnative_url_launcher_bridges.b.dart' as dartnative_url_launcher_bridges;
import 'dartnative_splash_bridges.b.dart' as dartnative_splash_bridges;
import 'crypto_bridges.b.dart' as crypto_bridges;
import 'native_bottomsheet_bridges.b.dart' as native_bottomsheet_bridges;
import 'riverpod_kit_bridges.b.dart' as riverpod_kit_bridges;
import 'dartnative_flutter_compat_bridges.b.dart' as dartnative_flutter_compat_bridges;
import 'relaxers.b.dart' as relaxer_factories;

/// Combined bridge registration for dartnative_go_ast.
class DartnativeGoAstBridges {
  /// Register all bridges with D4rt interpreter.
  static void register([D4rt? interpreter]) {
    final d4rt = interpreter ?? D4rt();

    dartnative_ui_bridges.DartnativeUiBridge.registerBridges(
      d4rt,
      'package:dartnative/dartnative.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_ui_bridges.DartnativeUiBridge.subPackageBarrels()) {
      dartnative_ui_bridges.DartnativeUiBridge.registerBridges(d4rt, barrel);
    }
    dartnative_flutter_compat_bridges.DartnativeFlutterCompatBridge.registerBridges(
      d4rt,
      'package:dartnative/flutter_compat.dart',
    );
    for (final barrel in dartnative_flutter_compat_bridges.DartnativeFlutterCompatBridge.subPackageBarrels()) {
      dartnative_flutter_compat_bridges.DartnativeFlutterCompatBridge.registerBridges(d4rt, barrel);
    }
    dartnative_webview_bridges.DartnativeWebviewBridge.registerBridges(
      d4rt,
      'package:dartnative_webview/dartnative_webview.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_webview_bridges.DartnativeWebviewBridge.subPackageBarrels()) {
      dartnative_webview_bridges.DartnativeWebviewBridge.registerBridges(d4rt, barrel);
    }
    dartnative_share_bridges.DartnativeShareBridge.registerBridges(
      d4rt,
      'package:dartnative_share/dartnative_share.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_share_bridges.DartnativeShareBridge.subPackageBarrels()) {
      dartnative_share_bridges.DartnativeShareBridge.registerBridges(d4rt, barrel);
    }
    dartnative_shared_preferences_bridges.DartnativeSharedPreferencesBridge.registerBridges(
      d4rt,
      'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_shared_preferences_bridges.DartnativeSharedPreferencesBridge.subPackageBarrels()) {
      dartnative_shared_preferences_bridges.DartnativeSharedPreferencesBridge.registerBridges(d4rt, barrel);
    }
    dartnative_path_provider_bridges.DartnativePathProviderBridge.registerBridges(
      d4rt,
      'package:dartnative_path_provider/dartnative_path_provider.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_path_provider_bridges.DartnativePathProviderBridge.subPackageBarrels()) {
      dartnative_path_provider_bridges.DartnativePathProviderBridge.registerBridges(d4rt, barrel);
    }
    dartnative_url_launcher_bridges.DartnativeUrlLauncherBridge.registerBridges(
      d4rt,
      'package:dartnative_url_launcher/dartnative_url_launcher.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_url_launcher_bridges.DartnativeUrlLauncherBridge.subPackageBarrels()) {
      dartnative_url_launcher_bridges.DartnativeUrlLauncherBridge.registerBridges(d4rt, barrel);
    }
    dartnative_splash_bridges.DartnativeSplashBridge.registerBridges(
      d4rt,
      'package:dartnative_splash/dartnative_splash.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dartnative_splash_bridges.DartnativeSplashBridge.subPackageBarrels()) {
      dartnative_splash_bridges.DartnativeSplashBridge.registerBridges(d4rt, barrel);
    }
    crypto_bridges.CryptoBridge.registerBridges(
      d4rt,
      'package:crypto/crypto.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in crypto_bridges.CryptoBridge.subPackageBarrels()) {
      crypto_bridges.CryptoBridge.registerBridges(d4rt, barrel);
    }
    native_bottomsheet_bridges.NativeBottomsheetBridge.registerBridges(
      d4rt,
      'package:native_bottomsheet/native_bottomsheet.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in native_bottomsheet_bridges.NativeBottomsheetBridge.subPackageBarrels()) {
      native_bottomsheet_bridges.NativeBottomsheetBridge.registerBridges(d4rt, barrel);
    }
    riverpod_kit_bridges.RiverpodKitBridge.registerBridges(
      d4rt,
      'package:riverpod_kit/riverpod_kit.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in riverpod_kit_bridges.RiverpodKitBridge.subPackageBarrels()) {
      riverpod_kit_bridges.RiverpodKitBridge.registerBridges(d4rt, barrel);
    }

    // RC-2: Register generic constructor factories
    relaxer_factories.registerGenericConstructors();
    // GEN-079: Register relaxer wrapper factories
    relaxer_factories.registerRelaxers();
  }

  /// Get import block for all modules.
  static String getImportBlock() {
    final buffer = StringBuffer();
    buffer.writeln(dartnative_ui_bridges.DartnativeUiBridge.getImportBlock());
    buffer.writeln(dartnative_flutter_compat_bridges.DartnativeFlutterCompatBridge.getImportBlock());
    buffer.writeln(dartnative_webview_bridges.DartnativeWebviewBridge.getImportBlock());
    buffer.writeln(dartnative_share_bridges.DartnativeShareBridge.getImportBlock());
    buffer.writeln(dartnative_shared_preferences_bridges.DartnativeSharedPreferencesBridge.getImportBlock());
    buffer.writeln(dartnative_path_provider_bridges.DartnativePathProviderBridge.getImportBlock());
    buffer.writeln(dartnative_url_launcher_bridges.DartnativeUrlLauncherBridge.getImportBlock());
    buffer.writeln(dartnative_splash_bridges.DartnativeSplashBridge.getImportBlock());
    buffer.writeln(crypto_bridges.CryptoBridge.getImportBlock());
    buffer.writeln(native_bottomsheet_bridges.NativeBottomsheetBridge.getImportBlock());
    buffer.writeln(riverpod_kit_bridges.RiverpodKitBridge.getImportBlock());
    return buffer.toString();
  }
}
