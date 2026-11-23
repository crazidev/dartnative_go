import 'dart:io';

import 'package:dartnative/dartnative.dart';

import '../theme/host_ui_theme.dart';

/// Top application bar for the DartNative Go launcher.
///
/// Returns a bridged [AppBar] rather than a custom [PreferredSizeWidget].
/// The guest interpreter only wraps [StatelessWidget] and [StatefulWidget]
/// subclasses, so a custom app bar cannot be passed to [Scaffold.appBar].
///
/// Host actions (theme, mode, verbose, cache, reload, home, rescan) live in the
/// floating DevTools pill and sheet, not in a menu here, so the UI package can
/// be previewed and edited as one piece.
AppBar buildLauncherAppBar(BuildContext context) {
  return AppBar(
    brightness: context.theme.brightness,
    backgroundColor: context.theme.background,
    // toolbarHeight: 50,
    centerTitle: true,
    leading: Padding(
      padding: EdgeInsets.only(left: Platform.isAndroid ? 10 : 0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/app-logo.png',
        ),
      ),
    ),
    actions: [],
    title: Text(
      'DartNative Go',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: context.theme.foreground,
      ),
    ),
  );
}
