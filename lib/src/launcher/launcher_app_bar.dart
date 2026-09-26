import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/src/theme/shadcn_theme.dart';

import '../theme/launcher_theme.dart';

/// Top application bar for the DartNative Go launcher.
class LauncherAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRescan;
  final VoidCallback? onChangeTheme;
  final VoidCallback? onCycleMode;
  final String? runtimeModeLabel;
  final LauncherColors colors;

  const LauncherAppBar({
    super.key,
    required this.onRescan,
    required this.colors,
    this.onChangeTheme,
    this.onCycleMode,
    this.runtimeModeLabel,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: context.theme.brightness,
      backgroundColor: context.theme.accent,
      toolbarHeight: 56,
      actions: [
        BarButtonItem(
          fontIcon: CupertinoIcons.ellipsis,
          titleStyle: TextStyle(color: Colors.red),
          menu: [
            MenuAction(
              onTap: onChangeTheme ?? () {},
              icon: CupertinoIcons.sun_max,
              title: 'Change Theme',
            ),
            MenuAction(
              onTap: onRescan,
              icon: CupertinoIcons.arrow_clockwise,
              title: 'Rescan Network',
            ),
            if (onCycleMode != null)
              MenuAction(
                onTap: onCycleMode!,
                icon: CupertinoIcons.gear,
                title: runtimeModeLabel != null
                    ? 'Mode: $runtimeModeLabel'
                    : 'Change Mode',
              ),
          ],
        ),
      ],
      leading: Image.asset(
        'assets/dn-logo.png',
        width: 40,
        height: 40,
      ),
      title: Row(
        children: [
          Text(
            'DartNative Go',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.accentForeground,
            ),
          ),
        ],
      ),
    );
  }
}
