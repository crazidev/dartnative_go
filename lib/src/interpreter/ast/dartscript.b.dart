// D4rt Bridge - Generated file, do not edit
// Dartscript registration for dartnative_go_ast
// Generated: 2026-11-24T16:26:03.071382 by tom_d4rt_generator 1.26.2

/// D4rt Bridge Registration for dartnative_go_ast
library;

import 'package:tom_d4rt_ast/d4rt.dart';
import 'dartnative_bridges.b.dart' as dartnative_ui_bridges;
import 'dartnative_webview_bridges.b.dart' as dartnative_webview_bridges;
import 'dartnative_share_bridges.b.dart' as dartnative_share_bridges;
import 'dartnative_shared_preferences_bridges.b.dart'
    as dartnative_shared_preferences_bridges;
import 'dartnative_path_provider_bridges.b.dart'
    as dartnative_path_provider_bridges;
import 'dartnative_url_launcher_bridges.b.dart'
    as dartnative_url_launcher_bridges;
import 'dartnative_splash_bridges.b.dart' as dartnative_splash_bridges;
import 'crypto_bridges.b.dart' as crypto_bridges;
import 'native_bottomsheet_bridges.b.dart' as native_bottomsheet_bridges;
import 'riverpod_kit_bridges.b.dart' as riverpod_kit_bridges;
import 'dio_bridges.b.dart' as dio_bridges;
import 'dartnative_flutter_compat_bridges.b.dart'
    as dartnative_flutter_compat_bridges;
import 'dartnative_notifications_bridges.b.dart'
    as dartnative_notifications_bridges;
import 'dartnative_system_bridges.b.dart' as dartnative_system_bridges;
import 'dartnative_connectivity_bridges.b.dart'
    as dartnative_connectivity_bridges;
import 'dartnative_media_picker_bridges.b.dart'
    as dartnative_media_picker_bridges;
import 'dartnative_background_bridges.b.dart' as dartnative_background_bridges;
import 'dartnative_live_activities_bridges.b.dart'
    as dartnative_live_activities_bridges;
import 'local_auth_kit_bridges.b.dart' as local_auth_kit_bridges;
import 'quick_actions_kit_bridges.b.dart' as quick_actions_kit_bridges;
import 'dartnative_skia_bridges.b.dart' as dartnative_skia_bridges;
import 'dartnative_sqlite_bridges.b.dart' as dartnative_sqlite_bridges;
import 'dartnative_secure_storage_bridges.b.dart'
    as dartnative_secure_storage_bridges;
import 'dartnative_hive_bridges.b.dart' as dartnative_hive_bridges;
import 'dartnative_social_sign_in_bridges.b.dart'
    as dartnative_social_sign_in_bridges;
import 'dartnative_firebase_bridges.b.dart' as dartnative_firebase_bridges;
import 'dartnative_video_player_bridges.b.dart'
    as dartnative_video_player_bridges;
import 'dartnative_audio_bridges.b.dart' as dartnative_audio_bridges;
import 'dartnative_permissions_bridges.b.dart'
    as dartnative_permissions_bridges;
import 'dartnative_camera_bridges.b.dart' as dartnative_camera_bridges;
import 'dartnative_image_crop_bridges.b.dart' as dartnative_image_crop_bridges;
import 'dartnative_compressor_bridges.b.dart' as dartnative_compressor_bridges;
import 'dartnative_supertonic_tts_bridges.b.dart'
    as dartnative_supertonic_tts_bridges;
import 'dartnative_lottie_bridges.b.dart' as dartnative_lottie_bridges;
import 'dartnative_onnxruntime_bridges.b.dart'
    as dartnative_onnxruntime_bridges;
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
    for (final barrel
        in dartnative_ui_bridges.DartnativeUiBridge.subPackageBarrels()) {
      dartnative_ui_bridges.DartnativeUiBridge.registerBridges(d4rt, barrel);
    }
    dartnative_webview_bridges.DartnativeWebviewBridge.registerBridges(
      d4rt,
      'package:dartnative_webview/dartnative_webview.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_webview_bridges
            .DartnativeWebviewBridge.subPackageBarrels()) {
      dartnative_webview_bridges.DartnativeWebviewBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_share_bridges.DartnativeShareBridge.registerBridges(
      d4rt,
      'package:dartnative_share/dartnative_share.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_share_bridges.DartnativeShareBridge.subPackageBarrels()) {
      dartnative_share_bridges.DartnativeShareBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_shared_preferences_bridges
        .DartnativeSharedPreferencesBridge.registerBridges(
      d4rt,
      'package:dartnative_shared_preferences/dartnative_shared_preferences.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_shared_preferences_bridges
            .DartnativeSharedPreferencesBridge.subPackageBarrels()) {
      dartnative_shared_preferences_bridges
          .DartnativeSharedPreferencesBridge.registerBridges(d4rt, barrel);
    }
    dartnative_path_provider_bridges
        .DartnativePathProviderBridge.registerBridges(
      d4rt,
      'package:dartnative_path_provider/dartnative_path_provider.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_path_provider_bridges
            .DartnativePathProviderBridge.subPackageBarrels()) {
      dartnative_path_provider_bridges
          .DartnativePathProviderBridge.registerBridges(d4rt, barrel);
    }
    dartnative_url_launcher_bridges.DartnativeUrlLauncherBridge.registerBridges(
      d4rt,
      'package:dartnative_url_launcher/dartnative_url_launcher.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_url_launcher_bridges
            .DartnativeUrlLauncherBridge.subPackageBarrels()) {
      dartnative_url_launcher_bridges
          .DartnativeUrlLauncherBridge.registerBridges(d4rt, barrel);
    }
    dartnative_splash_bridges.DartnativeSplashBridge.registerBridges(
      d4rt,
      'package:dartnative_splash/dartnative_splash.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_splash_bridges
            .DartnativeSplashBridge.subPackageBarrels()) {
      dartnative_splash_bridges.DartnativeSplashBridge.registerBridges(
        d4rt,
        barrel,
      );
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
    for (final barrel
        in native_bottomsheet_bridges
            .NativeBottomsheetBridge.subPackageBarrels()) {
      native_bottomsheet_bridges.NativeBottomsheetBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    riverpod_kit_bridges.RiverpodKitBridge.registerBridges(
      d4rt,
      'package:riverpod_kit/riverpod_kit.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in riverpod_kit_bridges.RiverpodKitBridge.subPackageBarrels()) {
      riverpod_kit_bridges.RiverpodKitBridge.registerBridges(d4rt, barrel);
    }
    dio_bridges.DioBridge.registerBridges(
      d4rt,
      'package:dio/dio.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel in dio_bridges.DioBridge.subPackageBarrels()) {
      dio_bridges.DioBridge.registerBridges(d4rt, barrel);
    }
    dartnative_flutter_compat_bridges
        .DartnativeFlutterCompatBridge.registerBridges(
      d4rt,
      'package:dartnative/flutter_compat.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_flutter_compat_bridges
            .DartnativeFlutterCompatBridge.subPackageBarrels()) {
      dartnative_flutter_compat_bridges
          .DartnativeFlutterCompatBridge.registerBridges(d4rt, barrel);
    }
    dartnative_notifications_bridges
        .DartnativeNotificationsBridge.registerBridges(
      d4rt,
      'package:dartnative_notifications/dartnative_notifications.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_notifications_bridges
            .DartnativeNotificationsBridge.subPackageBarrels()) {
      dartnative_notifications_bridges
          .DartnativeNotificationsBridge.registerBridges(d4rt, barrel);
    }
    dartnative_system_bridges.DartnativeSystemBridge.registerBridges(
      d4rt,
      'package:dartnative_system/dartnative_system.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_system_bridges
            .DartnativeSystemBridge.subPackageBarrels()) {
      dartnative_system_bridges.DartnativeSystemBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_connectivity_bridges
        .DartnativeConnectivityBridge.registerBridges(
      d4rt,
      'package:dartnative_connectivity/connectivity.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_connectivity_bridges
            .DartnativeConnectivityBridge.subPackageBarrels()) {
      dartnative_connectivity_bridges
          .DartnativeConnectivityBridge.registerBridges(d4rt, barrel);
    }
    dartnative_media_picker_bridges.DartnativeMediaPickerBridge.registerBridges(
      d4rt,
      'package:dartnative_media_picker/dartnative_media_picker.dart',
    );
    dartnative_media_picker_bridges.DartnativeMediaPickerBridge.registerBridges(
      d4rt,
      'package:dartnative_media_picker/gallery.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_media_picker_bridges
            .DartnativeMediaPickerBridge.subPackageBarrels()) {
      dartnative_media_picker_bridges
          .DartnativeMediaPickerBridge.registerBridges(d4rt, barrel);
    }
    dartnative_background_bridges.DartnativeBackgroundBridge.registerBridges(
      d4rt,
      'package:dartnative_background/dartnative_background.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_background_bridges
            .DartnativeBackgroundBridge.subPackageBarrels()) {
      dartnative_background_bridges.DartnativeBackgroundBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_live_activities_bridges
        .DartnativeLiveActivitiesBridge.registerBridges(
      d4rt,
      'package:dartnative_live_activities/dartnative_live_activities.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_live_activities_bridges
            .DartnativeLiveActivitiesBridge.subPackageBarrels()) {
      dartnative_live_activities_bridges
          .DartnativeLiveActivitiesBridge.registerBridges(d4rt, barrel);
    }
    local_auth_kit_bridges.LocalAuthKitBridge.registerBridges(
      d4rt,
      'package:local_auth_kit/local_auth_kit.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in local_auth_kit_bridges.LocalAuthKitBridge.subPackageBarrels()) {
      local_auth_kit_bridges.LocalAuthKitBridge.registerBridges(d4rt, barrel);
    }
    quick_actions_kit_bridges.QuickActionsKitBridge.registerBridges(
      d4rt,
      'package:quick_actions_kit/quick_actions_kit.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in quick_actions_kit_bridges
            .QuickActionsKitBridge.subPackageBarrels()) {
      quick_actions_kit_bridges.QuickActionsKitBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_skia_bridges.DartnativeSkiaBridge.registerBridges(
      d4rt,
      'package:dartnative_skia/dartnative_skia.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_skia_bridges.DartnativeSkiaBridge.subPackageBarrels()) {
      dartnative_skia_bridges.DartnativeSkiaBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_sqlite_bridges.DartnativeSqliteBridge.registerBridges(
      d4rt,
      'package:dartnative_sqlite/dartnative_sqlite.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_sqlite_bridges
            .DartnativeSqliteBridge.subPackageBarrels()) {
      dartnative_sqlite_bridges.DartnativeSqliteBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_secure_storage_bridges
        .DartnativeSecureStorageBridge.registerBridges(
      d4rt,
      'package:dartnative_secure_storage/dartnative_secure_storage.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_secure_storage_bridges
            .DartnativeSecureStorageBridge.subPackageBarrels()) {
      dartnative_secure_storage_bridges
          .DartnativeSecureStorageBridge.registerBridges(d4rt, barrel);
    }
    dartnative_hive_bridges.DartnativeHiveBridge.registerBridges(
      d4rt,
      'package:dartnative_hive/dartnative_hive.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_hive_bridges.DartnativeHiveBridge.subPackageBarrels()) {
      dartnative_hive_bridges.DartnativeHiveBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_social_sign_in_bridges
        .DartnativeSocialSignInBridge.registerBridges(
      d4rt,
      'package:dartnative_social_sign_in/social_sign_in.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_social_sign_in_bridges
            .DartnativeSocialSignInBridge.subPackageBarrels()) {
      dartnative_social_sign_in_bridges
          .DartnativeSocialSignInBridge.registerBridges(d4rt, barrel);
    }
    dartnative_firebase_bridges.DartnativeFirebaseBridge.registerBridges(
      d4rt,
      'package:dartnative_firebase/dartnative_firebase.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_firebase_bridges
            .DartnativeFirebaseBridge.subPackageBarrels()) {
      dartnative_firebase_bridges.DartnativeFirebaseBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_video_player_bridges.DartnativeVideoPlayerBridge.registerBridges(
      d4rt,
      'package:dartnative_video_player/dartnative_video_player.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_video_player_bridges
            .DartnativeVideoPlayerBridge.subPackageBarrels()) {
      dartnative_video_player_bridges
          .DartnativeVideoPlayerBridge.registerBridges(d4rt, barrel);
    }
    dartnative_audio_bridges.DartnativeAudioBridge.registerBridges(
      d4rt,
      'package:dartnative_audio/dartnative_audio.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_audio_bridges.DartnativeAudioBridge.subPackageBarrels()) {
      dartnative_audio_bridges.DartnativeAudioBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_permissions_bridges.DartnativePermissionsBridge.registerBridges(
      d4rt,
      'package:dartnative_permissions/dartnative_permissions.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_permissions_bridges
            .DartnativePermissionsBridge.subPackageBarrels()) {
      dartnative_permissions_bridges
          .DartnativePermissionsBridge.registerBridges(d4rt, barrel);
    }
    dartnative_camera_bridges.DartnativeCameraBridge.registerBridges(
      d4rt,
      'package:dartnative_camera/dartnative_camera.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_camera_bridges
            .DartnativeCameraBridge.subPackageBarrels()) {
      dartnative_camera_bridges.DartnativeCameraBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_image_crop_bridges.DartnativeImageCropBridge.registerBridges(
      d4rt,
      'package:dartnative_image_crop/dartnative_image_crop.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_image_crop_bridges
            .DartnativeImageCropBridge.subPackageBarrels()) {
      dartnative_image_crop_bridges.DartnativeImageCropBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_compressor_bridges.DartnativeCompressorBridge.registerBridges(
      d4rt,
      'package:dartnative_compressor/dartnative_compressor.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_compressor_bridges
            .DartnativeCompressorBridge.subPackageBarrels()) {
      dartnative_compressor_bridges.DartnativeCompressorBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_supertonic_tts_bridges
        .DartnativeSupertonicTtsBridge.registerBridges(
      d4rt,
      'package:dartnative_supertonic_tts/dartnative_supertonic_tts.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_supertonic_tts_bridges
            .DartnativeSupertonicTtsBridge.subPackageBarrels()) {
      dartnative_supertonic_tts_bridges
          .DartnativeSupertonicTtsBridge.registerBridges(d4rt, barrel);
    }
    dartnative_lottie_bridges.DartnativeLottieBridge.registerBridges(
      d4rt,
      'package:dartnative_lottie/dartnative_lottie.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_lottie_bridges
            .DartnativeLottieBridge.subPackageBarrels()) {
      dartnative_lottie_bridges.DartnativeLottieBridge.registerBridges(
        d4rt,
        barrel,
      );
    }
    dartnative_onnxruntime_bridges.DartnativeOnnxruntimeBridge.registerBridges(
      d4rt,
      'package:dartnative_onnxruntime/dartnative_onnxruntime.dart',
    );
    // Register under sub-package barrels for direct imports
    for (final barrel
        in dartnative_onnxruntime_bridges
            .DartnativeOnnxruntimeBridge.subPackageBarrels()) {
      dartnative_onnxruntime_bridges
          .DartnativeOnnxruntimeBridge.registerBridges(d4rt, barrel);
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
    buffer.writeln(
      dartnative_webview_bridges.DartnativeWebviewBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_share_bridges.DartnativeShareBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_shared_preferences_bridges
          .DartnativeSharedPreferencesBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_path_provider_bridges
          .DartnativePathProviderBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_url_launcher_bridges
          .DartnativeUrlLauncherBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_splash_bridges.DartnativeSplashBridge.getImportBlock(),
    );
    buffer.writeln(crypto_bridges.CryptoBridge.getImportBlock());
    buffer.writeln(
      native_bottomsheet_bridges.NativeBottomsheetBridge.getImportBlock(),
    );
    buffer.writeln(riverpod_kit_bridges.RiverpodKitBridge.getImportBlock());
    buffer.writeln(dio_bridges.DioBridge.getImportBlock());
    buffer.writeln(
      dartnative_flutter_compat_bridges
          .DartnativeFlutterCompatBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_notifications_bridges
          .DartnativeNotificationsBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_system_bridges.DartnativeSystemBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_connectivity_bridges
          .DartnativeConnectivityBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_media_picker_bridges
          .DartnativeMediaPickerBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_background_bridges.DartnativeBackgroundBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_live_activities_bridges
          .DartnativeLiveActivitiesBridge.getImportBlock(),
    );
    buffer.writeln(local_auth_kit_bridges.LocalAuthKitBridge.getImportBlock());
    buffer.writeln(
      quick_actions_kit_bridges.QuickActionsKitBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_skia_bridges.DartnativeSkiaBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_sqlite_bridges.DartnativeSqliteBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_secure_storage_bridges
          .DartnativeSecureStorageBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_hive_bridges.DartnativeHiveBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_social_sign_in_bridges
          .DartnativeSocialSignInBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_firebase_bridges.DartnativeFirebaseBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_video_player_bridges
          .DartnativeVideoPlayerBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_audio_bridges.DartnativeAudioBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_permissions_bridges
          .DartnativePermissionsBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_camera_bridges.DartnativeCameraBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_image_crop_bridges.DartnativeImageCropBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_compressor_bridges.DartnativeCompressorBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_supertonic_tts_bridges
          .DartnativeSupertonicTtsBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_lottie_bridges.DartnativeLottieBridge.getImportBlock(),
    );
    buffer.writeln(
      dartnative_onnxruntime_bridges
          .DartnativeOnnxruntimeBridge.getImportBlock(),
    );
    return buffer.toString();
  }
}
