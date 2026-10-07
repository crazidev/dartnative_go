// Demo @ServerComponent for live-device testing.
//
// Guest-side stub of the host annotation: the bundler matches annotations
// by NAME, so guest code does not need a dependency on the host package.
// (Keep this stub in sync with `package:dartnative_go/server.dart`.)
//
// IMPORTANT (v1 discovery): the component's module must be reachable from
// main.dart's import graph, otherwise the bundler never sees the annotation
// and emits no delta bundle. main.dart imports this file below; the class
// itself is only ever instantiated through the ServerComponent host widget.
import 'package:flutter/widgets.dart';

import 'server_demo_detail.dart';

class ServerComponent {
  final String id;
  final int version;
  const ServerComponent({required this.id, this.version = 1});
}

@ServerComponent(id: 'demo_card')
class ServerDemoCard extends StatelessWidget {
  final int userId;
  const ServerDemoCard({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Text('server card for user $userId: ${demoDetail()}');
  }
}
