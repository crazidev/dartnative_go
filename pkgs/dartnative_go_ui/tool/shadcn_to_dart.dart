// Converts a shadcn CSS token file (`:root` + `.dark` blocks with
// `oklch(...)` colors) into `lib/src/theme/shadcn_theme.dart`.
//
// Thin CLI over `lib/src/theme/shadcn_converter.dart` so the parsing,
// OKLCH→sRGB math and codegen stay unit-testable on the host.
//
// Usage:
//   dart run tool/shadcn_to_dart.dart [cssPath] [outPath]
// Defaults: tool/shadcn_tokens.css → lib/src/theme/shadcn_theme.dart
import 'dart:io';

import 'package:dartnative_go_ui/src/theme/shadcn_converter.dart';

void main(List<String> args) {
  final cssPath = args.isNotEmpty ? args[0] : 'tool/shadcn_tokens.css';
  final outPath = args.length > 1 ? args[1] : 'lib/src/theme/shadcn_theme.dart';

  final cssFile = File(cssPath);
  if (!cssFile.existsSync()) {
    stderr.writeln('shadcn_to_dart: no such file: $cssPath');
    exit(2);
  }
  late Map<String, TokenMap> themes;
  try {
    themes = parseShadcnCss(cssFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('shadcn_to_dart: $e');
    exit(2);
  }
  late String dart;
  try {
    dart = generateThemeDart(
      light: themes['light']!,
      dark: themes['dark']!,
      sourcePath: cssPath,
    );
  } on FormatException catch (e) {
    stderr.writeln('shadcn_to_dart: $e');
    exit(2);
  }
  File(outPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(dart);
  stdout.writeln(
    'shadcn_to_dart: ${themes['light']!.length} light + '
    '${themes['dark']!.length} dark tokens → $outPath',
  );
}
