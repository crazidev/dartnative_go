// Demo @ServerComponent for live-device testing.
//
// The annotation is the REAL host annotation
// (`package:dartnative_go/server.dart`), served to the bundler implicitly
// by the dev server — no guest-side stub needed.
//
// IMPORTANT (v1 discovery): the component's module must be reachable from
// main.dart's import graph, otherwise the bundler never sees the annotation
// and emits no delta bundle.

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/server.dart';

import 'server_demo_detail.dart';

@ServerComponent(id: 'demo_text')
class ServerDemoText extends StatelessWidget {
  final int userId;
  const ServerDemoText({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Demo text from server with props: $userId\n${demoDetail()}',
      style: TextStyle(color: Colors.black),
    );
  }
}
