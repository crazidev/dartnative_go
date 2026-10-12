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

@ServerComponent(id: 'demo_card')
class ServerDemoCard extends StatefulWidget {
  final int userId;

  const ServerDemoCard({required this.userId});

  @override
  State<ServerDemoCard> createState() => _ServerDemoCardState();
}

class _ServerDemoCardState extends State<ServerDemoCard> {
  @override
  void initState() {
    print("This is a server component");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: Center(
        child: Text(
          widget.userId.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
