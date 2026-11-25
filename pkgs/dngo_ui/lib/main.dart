import 'package:dartnative/dartnative.dart';

import 'src/launcher/host_launcher.dart';

/// Guest entrypoint. Run `dngo start` in this package and open the
/// server from the host to preview UI changes without a native rebuild.
void main() {
  runApp(const HostLauncher());
}
