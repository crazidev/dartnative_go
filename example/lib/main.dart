import 'package:dartnative/dartnative.dart';
import 'package:example/todo_screen.dart';
import 'package:riverpod_kit/riverpod_kit.dart';
// ignore: unused_import
// Discovery import for the @ServerComponent live-device demo: makes the
// bundler emit server_components/demo_card.ast. Never instantiated here —
// the class mounts exclusively through the ServerComponent host widget.
import 'server_demo_card.dart';
// import 'package:example/home_screen.dart';
// import 'package:example/todo_screen.dart';
// import 'package:riverpod_kit/riverpod_kit.dart';

import 'dartnative_plugin_registrant.dart';
// ignore: unused_import
// ignore: unused_import
// ignore: unused_import

void main() {
  // Platform bindings + (once you add plugins) their FFI symbols. Keep this
  // as the FIRST line of main() — see lib/dartnative_plugin_registrant.dart.
  DartNativePluginRegistrant.registerAll();

  // App-wide system chrome default for the white template: dark status-bar
  // icons over the light background, transparent strips. Screens can override
  // in initState; the navigator restores this default on pop.
  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  runApp(ProviderScope(child: const TodoScreen()));
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
