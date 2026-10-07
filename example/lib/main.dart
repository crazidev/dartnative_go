import 'package:dartnative/dartnative.dart';
import 'package:dartnative_go/server_component.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

import 'server_demo_card.dart';
import 'server_demo_text.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();

  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var textColor = Colors.black;
  var currentIndex = 0;

  var colors = [
    Colors.black,
    Colors.deepPurple,
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  void changeColor() {
    if (currentIndex >= colors.length) {
      currentIndex = 0;
    } else {
      currentIndex = currentIndex + 1;
    }
    print("currentIndex $currentIndex ${(currentIndex == colors.length)}");
    setState(() {
      textColor = colors[currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hello world",
            style: TextStyle(
              fontSize: 30,
              color: textColor,
            ),
          ),
          SizedBox(height: 10),
          ServerDemoCard(userId: currentIndex),
          const SizedBox(height: 8),
          const ServerDemoText(userId: 7),
          const SizedBox(height: 8),
          // Same component as above, but mounted through the server path:
          // the host ServerComponentView bridge fetches demo_text.ast and
          // resolves it against the live client modules. Compare the two
          // texts — identical output proves the delta merge works.
          ServerComponentView(
            componentId: 'demo_text',
            props: const {'userId': 7},
          ),
          const SizedBox(height: 10),

          Button(
            child: Text("Change State"),
            onPressed: () {
              changeColor();
            },
          ),
        ],
      ),
    );
  }
}

class Example {}
