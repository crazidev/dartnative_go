import 'package:dartnative/dartnative.dart';

class ResetButton extends StatefulWidget {
  const ResetButton({super.key, required this.reset});

  final VoidCallback reset;

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  @override
  void initState() {
    super.initState();
    print('ResetButton initState');
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      title: 'Reset Count',
      variant: ButtonVariant.plain,
      foregroundColor: const Color(0xFFFF3B30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: widget.reset,
    );
  }
}
