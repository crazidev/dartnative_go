import 'package:dartnative/dartnative.dart';

import 'bench/bench_screen.dart';
import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  SystemChrome.defaultStyle = SystemUiOverlayStyle.dark;
  runApp(const BenchScreen());
}
