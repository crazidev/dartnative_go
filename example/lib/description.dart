import 'package:dartnative/dartnative.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Edit lib/main.dart to build your app. '
      'See README.md to swap the app icon / splash logo, '
      'and dartpub.dev for plugins.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(0xFF6B6B70), fontSize: 14, height: 1.45),
    );
  }
}
