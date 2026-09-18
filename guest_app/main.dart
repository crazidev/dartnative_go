import 'package:dartnative/dartnative.dart';

/// Entrypoint for the DartNative Go dynamic client application
Widget buildUI(
  int count,
  VoidCallback onInc,
  VoidCallback onDec,
  VoidCallback onReset,
  VoidCallback onHotReload,
  VoidCallback onExit,
) {
  return Scaffold(
    key: const ValueKey('guest_counter_screen'),
    brightness: Brightness.light,
    appBar: AppBar(
      ios: const AppBarIOSConfig(systemBar: false),
      backgroundColor: const Color(0xFFFFFFFF),
      leading: BarButtonItem(
        title: "",
        fontIcon: CupertinoIcons.xmark_1,
        onPressed: onExit,
      ),
      brightness: Brightness.light,
      title: const Text(
        'DartNative Go',
        style: TextStyle(
          color: Color(0xFF111111),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [const SizedBox(width: 8)],
    ),
    backgroundColor: const Color(0xFFF7F7F8),
    body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Edit guest_app/main.dart to see instant Hot Reload!',
            style: TextStyle(color: Color(0xFF88888E), fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                title: '- Decrement',
                variant: ButtonVariant.glass,
                onPressed: onDec,
              ),
              const SizedBox(width: 14),
              Button(
                title: '+ Increment',
                variant: ButtonVariant.prominentGlass,
                onPressed: onInc,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Button(
            title: 'Reset Count',
            variant: ButtonVariant.plain,
            foregroundColor: const Color(0xFFFF3B30),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: onReset,
          ),
        ],
      ),
    ),
  );
}
