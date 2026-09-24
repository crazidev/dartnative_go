import 'package:dartnative/dartnative.dart';

/// Top application bar for the DartNative Go launcher.
class LauncherAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRescan;
  final VoidCallback? onChangeTheme;
  final VoidCallback? onCycleMode;
  final String? runtimeModeLabel;

  const LauncherAppBar({
    super.key,
    required this.onRescan,
    this.onChangeTheme,
    this.onCycleMode,
    this.runtimeModeLabel,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      actions: [
        BarButtonItem(
          fontIcon: CupertinoIcons.ellipsis,
          titleStyle: const TextStyle(color: Colors.white),
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
      title: const Row(
        children: [
          Text(
            'DartNative Go',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
