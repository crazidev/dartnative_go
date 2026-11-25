import 'package:dngo_api/host_api.dart';
import 'package:test/test.dart';

void main() {
  late _FakeHost fake;

  setUp(() {
    fake = _FakeHost();
    DartGoHost.bind(fake);
  });

  tearDown(() {
    DartGoHost.unbind(fake);
  });

  test('discover and refresh return the binding snapshot', () async {
    fake.projects = const [
      DartGoProject(
        appName: 'Example',
        url: 'http://127.0.0.1:8088',
        isActive: true,
      ),
    ];

    final discovered = await DartGoHost.discover();
    expect(discovered.single.appName, 'Example');

    fake.projects = const [
      DartGoProject(appName: 'UI', url: 'http://127.0.0.1:8090'),
    ];
    final refreshed = await DartGoHost.refresh();
    expect(refreshed.single.url, 'http://127.0.0.1:8090');
    expect(fake.refreshed, isTrue);
    expect(DartGoHost.projects.single.appName, 'UI');
  });

  test('open, theme, verbose, reload, and go home reach the binding', () async {
    var notified = 0;
    DartGoHost.addListener(() => notified++);

    await DartGoHost.openProject(
      const DartGoProject(appName: 'Example', url: 'http://10.0.0.8:8088'),
    );
    await DartGoHost.openWithLink(
      'dartnativego://open?url=http://10.0.0.2:8088',
    );
    expect(await DartGoHost.toggleTheme(), 'light');
    expect(DartGoHost.theme, 'light');
    await DartGoHost.openDevTools();
    await DartGoHost.setVerbose(true);
    expect(DartGoHost.verbose, isTrue);
    expect(await DartGoHost.toggleVerbose(), isFalse);
    await DartGoHost.reload();
    await DartGoHost.goHome();
    await DartGoHost.cycleRuntimeMode();

    expect(fake.openedUrl, 'http://10.0.0.8:8088');
    expect(fake.link, 'dartnativego://open?url=http://10.0.0.2:8088');
    expect(fake.devToolsOpened, isTrue);
    expect(fake.reloaded, isTrue);
    expect(fake.wentHome, isTrue);
    expect(fake.cycledMode, isTrue);
    expect(fake.listeners, isNotEmpty);
    expect(notified, greaterThan(0));

    final listener = fake.listeners.single;
    DartGoHost.removeListener(listener);
    expect(fake.listeners, isEmpty);
    expect(DartGoHost.binding, same(fake));
  });

  test('unbound calls fail clearly', () {
    DartGoHost.unbind(fake);
    expect(DartGoHost.discover, throwsStateError);
  });
}

class _FakeHost implements DartGoHostBinding {
  @override
  List<DartGoProject> projects = const [];

  @override
  List<DartGoProject> get recentProjects => projects;

  bool refreshed = false;
  String? openedUrl;
  String? link;
  String themeName = 'system';
  bool devToolsOpened = false;
  bool verboseFlag = false;
  bool reloaded = false;
  bool wentHome = false;
  bool cycledMode = false;
  final List<void Function()> listeners = [];

  @override
  Future<List<DartGoProject>> discover() async => projects;

  @override
  Future<List<DartGoProject>> refresh() async {
    refreshed = true;
    return projects;
  }

  @override
  bool get isScanning => false;

  @override
  Future<void> openProject(DartGoProject project) async {
    openedUrl = project.url;
  }

  @override
  Future<void> removeProject(DartGoProject project) async {
    projects = [
      for (final item in projects)
        if (item.url != project.url) item,
    ];
  }

  @override
  Future<void> openWithLink(String value) async {
    link = value;
  }

  @override
  Future<String> toggleTheme() async {
    themeName = 'light';
    return themeName;
  }

  @override
  String get theme => themeName;

  @override
  Future<void> openDevTools() async {
    devToolsOpened = true;
  }

  @override
  Future<void> claimDevTools() async {}

  @override
  Future<void> releaseDevTools() async {}

  @override
  bool get verbose => verboseFlag;

  @override
  Future<void> setVerbose(bool enabled) async {
    verboseFlag = enabled;
    for (final listener in List<void Function()>.of(listeners)) {
      listener();
    }
  }

  @override
  Future<void> reload() async {
    reloaded = true;
  }

  @override
  Future<void> goHome() async {
    wentHome = true;
  }

  @override
  String get runtimeModeLabel => 'AST';

  @override
  List<String> get runtimeModes => const ['AST'];

  @override
  Future<void> setRuntimeMode(String label) async {}

  @override
  Future<void> cycleRuntimeMode() async {
    cycledMode = true;
  }

  @override
  String get appName => 'Fake';

  @override
  String? get appVersion => null;

  @override
  String get serverUrl => '';

  @override
  bool get isConnected => false;

  @override
  String get dependencyCacheLabel => '0 B (0 packages)';

  @override
  Future<void> clearDependencyCache() async {}

  @override
  Future<String> setTheme(String mode) async {
    themeName = mode;
    return themeName;
  }

  @override
  void addListener(void Function() listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    listeners.remove(listener);
  }
}
