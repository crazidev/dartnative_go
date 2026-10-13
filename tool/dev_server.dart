import 'dart:io';

import 'package:dartnative_go/src/cli/server/server.dart';

Future<void> main(List<String> args) async {
  final server = DartGoServer(
    DartGoServerOptions(
      projectDir: Directory.current,
      startPort: 8088,
      endPort: 8098,
      enableBroadcast: true,
      enableQrCode: true,
      rebuildAst: !args.contains('--no-rebuild-ast'),
    ),
  );

  ProcessSignal.sigint.watch().listen((_) {
    print('\n🛑 Shutting down Dev Server...');
    server.stop();
    exit(0);
  });

  await server.start();
}
