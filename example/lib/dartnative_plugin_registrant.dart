// GENERATED FILE — DO NOT EDIT BY HAND.
//
// Regenerated automatically on `dn pub get` / `dn create` whenever the set of
// DartNative plugins changes. `registerAll()` selects the platform bindings
// AND loads every plugin's FFI symbols, so `main()` needs only:
//
//   void main() {
//     DartNativePluginRegistrant.registerAll();
//     runApp(const MyApp());
//   }
//
// To hand-own this file, delete the header line above; the CLI then stops
// overwriting it.
//
// Plugins loaded:
//   • app_links_kit
//   • dartnative_connectivity
//   • dartnative_live_activities
//   • dartnative_media_picker
//   • dartnative_notifications
//   • dartnative_share
//   • dartnative_shared_preferences
//   • dartnative_system
//   • dartnative_url_launcher
//   • dartnative_webview
//   • local_auth_kit
//   • native_bottomsheet
//   • quick_actions_kit

import 'dart:io' show Platform;

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_ios/dartnative_ios.dart';
import 'package:dartnative_android/dartnative_android.dart';
import 'package:app_links_kit/app_links_kit.dart';
import 'package:dartnative_connectivity/connectivity.dart';
import 'package:dartnative_live_activities/dartnative_live_activities.dart';
import 'package:dartnative_media_picker/dartnative_media_picker.dart';
import 'package:dartnative_media_picker/gallery.dart';
import 'package:dartnative_notifications/dartnative_notifications.dart';
import 'package:dartnative_share/dartnative_share.dart';
import 'package:dartnative_shared_preferences/dartnative_shared_preferences.dart';
import 'package:dartnative_system/dartnative_system.dart';
import 'package:dartnative_url_launcher/dartnative_url_launcher.dart';
import 'package:dartnative_webview/dartnative_webview.dart';
import 'package:local_auth_kit/local_auth_kit.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:quick_actions_kit/quick_actions_kit.dart';

abstract final class DartNativePluginRegistrant {
  /// Registers the platform bindings and loads every DartNative plugin's
  /// FFI symbols. Call once as the first line of `main()`, before `runApp`.
  static void registerAll() {
    const dnLicenseToken = String.fromEnvironment('DART_NATIVE_LICENSE_TOKEN');
    if (dnLicenseToken.isNotEmpty) {
      DartNativeLicense.instance.provideToken(dnLicenseToken);
    }
    const dnLicenseKey = String.fromEnvironment('DN_LICENSE_KEY');
    if (dnLicenseKey.isNotEmpty) {
      DartNativeLicense.instance.provideLicenseKey(dnLicenseKey);
    }
    const dnTrialEnded = bool.fromEnvironment('DN_TRIAL_ENDED');
    if (dnTrialEnded) {
      DartNativeLicense.instance.noteTrialEnded();
    }
    DartNativeLicense.instance.reportPluginUsage(const <String>[
      'app_links_kit',
      'dartnative_background',
      'dartnative_connectivity',
      'dartnative_live_activities',
      'dartnative_media_picker',
      'dartnative_notifications',
      'dartnative_path_provider',
      'dartnative_share',
      'dartnative_shared_preferences',
      'dartnative_splash',
      'dartnative_system',
      'dartnative_url_launcher',
      'dartnative_webview',
      'local_auth_kit',
      'lucide_kit',
      'native_bottomsheet',
      'quick_actions_kit',
      'riverpod_kit',
    ]);
    registerNativeBindings(
      Platform.isAndroid
          ? AndroidNativeBindings.instance
          : IOSNativeBindings.instance,
    );
    _load('app_links_kit', () {
      AppLinksFFIBindings.loadSymbols();
    });
    _load('dartnative_connectivity', () {
      ConnectivityFFIBindings.loadSymbols();
    });
    _load('dartnative_live_activities', () {
      LiveActivitiesFFIBindings.loadSymbols();
    });
    _load('dartnative_media_picker', () {
      MediaPickerFFIBindings.loadSymbols();
      MediaGalleryFFIBindings.loadSymbols();
    });
    _load('dartnative_notifications', () {
      NotificationsFFIBindings.loadSymbols();
    });
    _load('dartnative_share', () {
      ShareFFIBindings.loadSymbols();
    });
    _load('dartnative_shared_preferences', () {
      PrefsBindings.loadSymbols();
    });
    _load('dartnative_system', () {
      SystemFFIBindings.loadSymbols();
    });
    _load('dartnative_url_launcher', () {
      UrlLauncherFFIBindings.loadSymbols();
    });
    _load('dartnative_webview', () {
      WebViewFFIBindings.loadSymbols();
    });
    _load('local_auth_kit', () {
      LocalAuthFFIBindings.loadSymbols();
    });
    _load('native_bottomsheet', () {
      BottomSheetFFIBindings.loadSymbols();
    });
    _load('quick_actions_kit', () {
      QuickActionsKitBindings.loadSymbols();
    });
  }

  /// Loads one plugin's FFI symbols, turning a missing native side into a
  /// message that names the fix.
  static void _load(String plugin, void Function() load) {
    try {
      load();
    } catch (e) {
      dnLog(
        '[dartnative] $plugin: its native symbols are not in this build.\n'
        '  iOS:     run `pod install` in ios/, then rebuild.\n'
        '  Android: rebuild so the plugin library is packaged.\n'
        '  The app keeps going; this plugin will not work until then.\n'
        '  $e',
      );
    }
  }
}
