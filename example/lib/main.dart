import 'package:dartnative/dartnative.dart';
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
    currentIndex = (currentIndex + 1) % colors.length;
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
          const SizedBox(height: 10),
          const ServerDemoText(userId: 7),
          const SizedBox(height: 10),

          // ServerComponentView(
          //   componentId: 'demo_text',
          //   props: const {'userId': 2},
          //   fallback: Container(
          //     width: 300,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.blue,
          //     ),
          //   ),
          //   loadingBuilder: (context) => Container(
          //     width: 300,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.yellow,
          //     ),
          //   ),
          //   errorBuilder: (error) {
          //     return Container(
          //       width: 300,
          //       height: 100,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.red,
          //       ),
          //     );
          //   },
          // ),
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
