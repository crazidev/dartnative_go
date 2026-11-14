import 'package:dartnative/dartnative.dart';
import 'package:example/plugins/dartnative_connectivity.dart';
import 'package:example/plugins/dartnative_media_picker.dart';
import 'package:example/plugins/dartnative_notification.dart';
import 'package:example/plugins/dartnative_share.dart';
import 'package:example/plugins/dartnative_webview.dart';
import 'package:example/plugins/dio_demo.dart';
import 'package:equatable/equatable.dart';
import 'package:example/plugins/native_bottomsheet.dart';

class Plugins extends Equatable {
  final Widget widget;
  final String name;
  final String version;

  Plugins({required this.widget, required this.name, required this.version});

  @override
  List<Object?> get props => [widget, name, version];
}

List<Plugins> plugins = [
  Plugins(
    name: "Native Bottomsheet",
    widget: BottomSheetExampleApp(),
    version: '1.0.0',
  ),
  Plugins(
    name: "Dartnative Media Picker",
    widget: MediaPickerDemo(),
    version: '1.1.0',
  ),
  Plugins(
    name: "Dartnative Webview",
    widget: WebViewDemoScreen(),
    version: '1.0.1',
  ),
  Plugins(
    name: "Dartnative Notification",
    widget: NotificationsDemo(),
    version: '1.0.1',
  ),
  Plugins(
    name: "Dartnative Connectivity",
    widget: ConnectivityDemo(),
    version: '1.0.0',
  ),
  Plugins(
    name: "Dartnative Share",
    widget: ShareDemoApp(),
    version: '1.0.0',
  ),
  Plugins(
    name: "dio (headless interpreter)",
    widget: DioDemo(),
    version: '5.11.1',
  ),
];

class PluginsScreen extends StatefulWidget {
  const PluginsScreen({super.key});

  @override
  State<PluginsScreen> createState() => _PluginsScreenState();
}

class _PluginsScreenState extends State<PluginsScreen> {
  @override
  void initState() {
    print("===== Init state $runtimeType");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Plugin List',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            ...plugins.map(
              (plugin) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("Navigate to ${plugin.name}");
                      Navigator.of(
                        context,
                      ).push(
                        PageRoute(
                          builder: (c) => plugin.widget,
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      leading: Image.asset(
                        'assets/dn-logo-1.png',
                        width: 40,
                        height: 40,
                      ),
                      subtitle: Text(
                        plugin.version,
                        style: TextStyle(color: Colors.grey),
                      ),
                      title: Text(
                        plugin.name,
                        style: TextStyle(fontWeight: FontWeight.semiBold),
                      ),
                      trailing: Icon(
                        CupertinoIcons.chevron_forward,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300, thickness: .5),
                ],
              ),
            ),
            // ServerDemoCard(userId: 1),
          ],
        ),
      ),
    );
  }
}
