import 'package:dartnative/dartnative.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, required this.reset});

  final VoidCallback reset;

  @override
  Widget build(BuildContext context) {
    return Button(
      title: 'Reset Count',
      variant: ButtonVariant.plain,
      foregroundColor: const Color(0xFFFF3B30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: reset,
    );
  }
}
