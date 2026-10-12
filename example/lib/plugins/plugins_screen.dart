import 'package:dartnative/dartnative.dart';
import 'package:example/plugins/dartnative_media_picker.dart';
// import 'package:example/plugins/dartnative_media_picker.dart';
// import 'package:example/plugins/dartnative_notification.dart';
// import 'package:example/plugins/dartnative_webview.dart';

class PluginsScreen extends StatelessWidget {
  const PluginsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No plugin demo enabled (HiveDemo removed).
    return Container(child: MediaPickerDemo());
  }
}
