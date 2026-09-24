import 'package:dartnative/dartnative.dart';

/// Text field for manually typing or pasting a dev server URL.
class ServerUrlInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const ServerUrlInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter URL (e.g. 192.168.3.159:8088)',
        filled: true,
        fillColor: Color(0xFF0E1012),
      ),
      prefixIconPadding: const EdgeInsets.only(left: 10),
      prefixIcon: CupertinoIcons.link,
      prefixIconColor: Colors.white,
      clearButtonMode: ClearButtonMode.whileEditing,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      onSubmitted: onSubmitted,
    );
  }
}
