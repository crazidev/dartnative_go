import 'dart:io';

import 'package:dartnative/dartnative.dart';

import '../theme/host_ui_theme.dart';

/// Text field for manually typing or pasting a dev server URL or deep link.
class ServerUrlInput extends StatelessWidget {
  final TextEditingController controller;

  /// `Function`, not `ValueChanged`: guest closures are `dynamic Function()`.
  final Function onSubmitted;

  const ServerUrlInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: theme.input,
        border: Border.all(color: theme.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 13,
          color: theme.foreground,
        ),
        cursorColor: theme.primary,
        decoration: InputDecoration(
          hintText: 'Enter Development Server URL',
          hintStyle: TextStyle(
            fontSize: 13,
            color: theme.mutedForeground,
          ),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        prefixIcon: CupertinoIcons.link,
        prefixIconColor: theme.mutedForeground,
        prefixIconPadding: Platform.isIOS
            ? EdgeInsets.only(left: 10)
            : EdgeInsets.only(right: 10),
        clearButtonMode: ClearButtonMode.whileEditing,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.go,
        onSubmitted: (value) => onSubmitted(value),
      ),
    );
  }
}
