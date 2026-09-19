import 'package:dartnative/dartnative.dart';

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '👋  Welcome to dartnative',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF111111),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
