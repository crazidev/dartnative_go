# dartnative_go_api

Host actions the DartNative Go shell exposes to its UI:

`discover`, `refresh`, `openProject`, `openWithLink`, `toggleTheme`,
`openDevTools`, `verbose`, `reload`, `goHome`.

```dart
import 'package:dartnative_go_api/host_api.dart';

final projects = await DartGoHost.discover();
await DartGoHost.openProject(projects.first);
```

The shell installs a `DartGoHostBinding` at startup. The same library URIs
are bridged, so an interpreted UI (`dart_go start` in `pkgs/dartnative_go_ui`)
calls the real shell instead of a bundled copy of this file.

`package:dartnative_go/host_api.dart` re-exports this library.
