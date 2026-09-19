import 'package:dartnative/dartnative.dart';

/// Starter screen — replace this with your own UI.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White-by-design screen: declare the light trait so system materials
      // (keyboard, glass) stay light even when the device is in Dark Mode.
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/dn-logo.png", width: 100, height: 100),
            Text(
              '👋  Welcome to dartnative',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Edit lib/main.dart to build your app. '
              'See README.md to swap the app icon / splash logo, '
              'and dartpub.dev for plugins.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B6B70),
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
