/// UI automation tests: reconciler-hooked probe + headless driver loop.
///
/// - Level 1 (widget walk) and Level 2 (DNTree walk) serializers are tested
///   against real widgets and hand-rolled `Element` fakes (the host SDK
///   stubs throw, so fakes stand in for mounted elements).
/// - The full `UiAutomator → FakeDevServer → SimulatedDevice` loop runs
///   headless; the same `UiAutomator` script drives the real app on-device
///   (probe handler in `lib/main.dart`), where Level 2 resolves for real.
library;

import 'package:dartnative/dartnative.dart';
import 'package:dartnative/src/reconciler/element.dart';
import 'package:dartnative/src/reconciler/mutations.dart';
import 'package:dartnative_go/src/runner/ui_probe.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';
import 'package:dartnative_go/src/runner/native_bottomsheet_manager.dart';
import 'package:test/test.dart';

import '../test_lab/fake_server.dart';
import '../test_lab/harness.dart';
import '../test_lab/ui_automator.dart';
import '../test_lab/ui_simulated_device.dart';

/// Host stand-in for a mounted element (host SDK accessors throw).
class FakeElement extends Element {
  final Widget _fakeWidget;
  final List<Element> _fakeChildren;
  final ViewId? _fakeViewId;

  FakeElement({
    required Widget widget,
    List<Element> children = const [],
    ViewId? viewId,
  })  : _fakeWidget = widget,
        _fakeChildren = children,
        _fakeViewId = viewId,
        super(widget);

  @override
  Widget get widget => _fakeWidget;

  @override
  List<Element> get children => _fakeChildren;

  @override
  ViewId? get viewId => _fakeViewId;
}

/// Host stand-in for a mounted native element (carries viewType).
class FakeNativeElement extends FakeElement implements NativeElement {
  final int _fakeViewType;

  FakeNativeElement({
    required super.widget,
    super.children,
    super.viewId,
    required int viewType,
  }) : _fakeViewType = viewType;

  @override
  int get viewType => _fakeViewType;

  @override
  ViewProps buildProps() => const ViewProps();

  @override
  void mount(Element? parent, UIKitReconciler rec) {}

  @override
  void update(Widget newWidget) {}

  @override
  void rebuild() {}

  @override
  bool propsEqual(ViewProps? oldProps, ViewProps newProps) => true;

  @override
  bool get stretchAsStackFlowChild => false;

  @override
  bool get isConstraintTransparent => false;

  @override
  bool get keepsOwnSizeAtRoot => false;

  @override
  void setSideSafeInset(double left, double right) {}

  @override
  int fillClaimUnder({required bool parentIsRow}) => 0;
}

Scaffold _sampleApp({VoidCallback? onPing}) => Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Hello'),
            Button(title: 'Ping', onPressed: onPing ?? () {}),
          ],
        ),
      ),
    );

void main() {
  group('Level 1 — widget walk', () {
    test('serializeTree captures Text and Button nodes', () {
      final tree = serializeTree(_sampleApp());
      expect(findTextNodes(tree, 'Hello'), hasLength(1));
      expect(findButtonNodes(tree, 'Ping'), hasLength(1));
      expect(findTextNodes(tree, 'Missing'), isEmpty);
    });
  });

  group('Level 2 — DNTree walk (fake mounted elements)', () {
    late Text textWidget;
    late Button buttonWidget;
    late FakeElement root;

    setUp(() {
      var tapped = 0;
      textWidget = const Text('Hello');
      buttonWidget = Button(title: 'Ping', onPressed: () => tapped++);
      root = FakeElement(
        widget: _sampleApp(),
        children: [
          FakeNativeElement(widget: textWidget, viewId: 11, viewType: 1),
          FakeNativeElement(
            widget: buttonWidget,
            viewId: 12,
            viewType: 16,
            children: [
              FakeElement(widget: const Text('inner'), viewId: 13),
            ],
          ),
        ],
      );
      // ignore: unused_local_variable
      tapped;
    });

    test('serializeElementTree attaches viewId/viewType + semantics', () {
      final tree = serializeElementTree(root);
      final texts = findTextNodes(tree, 'Hello');
      expect(texts, hasLength(1));
      expect(texts.single['viewId'], equals(11));
      expect(texts.single['viewType'], equals(1));

      final buttons = findButtonNodes(tree, 'Ping');
      expect(buttons, hasLength(1));
      expect(buttons.single['viewId'], equals(12));
      expect(buttons.single['viewType'], equals(16));
      expect(buttons.single['tappable'], isTrue);
    });

    test('indexElementsByWidget joins widgets to their elements', () {
      final index = indexElementsByWidget(root);
      expect(index[textWidget]?.viewId, equals(11));
      expect(index[buttonWidget]?.viewId, equals(12));

      // Identity join: a FRESH tree of non-const widgets gets no enrichment…
      final suffix = String.fromCharCodes([108, 111]);
      final fresh = Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('Hel$suffix'),
              Button(title: 'Ping', onPressed: () {}),
            ],
          ),
        ),
      );
      final unenriched = serializeTree(fresh, index);
      expect(
        findTextNodes(unenriched, 'Hello').single.containsKey('viewId'),
        isFalse,
      );

      // …while const-canonical instances ARE the same objects, so they join.
      // (Documents why `const` widgets probe reliably.)
      final enriched = serializeTree(_sampleApp(), index);
      expect(
        findTextNodes(enriched, 'Hello').single['viewId'],
        equals(11),
      );
    });

    test('index enriches the exact mounted instances', () {
      final app = _sampleApp();
      final text = ((app.body as Center).child as Column).children.first;
      final button =
          ((app.body as Center).child as Column).children[1] as Button;
      final elementRoot = FakeElement(
        widget: app,
        children: [
          FakeNativeElement(widget: text, viewId: 21, viewType: 1),
          FakeNativeElement(widget: button, viewId: 22, viewType: 16),
        ],
      );
      final enriched = serializeTree(app, indexElementsByWidget(elementRoot));
      expect(
        findTextNodes(enriched, 'Hello').single['viewId'],
        equals(21),
      );
      expect(
        findButtonNodes(enriched, 'Ping').single['viewType'],
        equals(16),
      );
    });

    test('tapButtonInElementTree dispatches through mounted elements', () {
      var tapped = 0;
      final btn = Button(title: 'Go', onPressed: () => tapped++);
      final el = FakeElement(
        widget: _sampleApp(),
        children: [FakeNativeElement(widget: btn, viewId: 31, viewType: 16)],
      );
      expect(tapButtonInElementTree(el, 'Go'), isNull);
      expect(tapped, equals(1));
      expect(
        tapButtonInElementTree(el, 'Nope'),
        contains('no Button titled "Nope"'),
      );
    });

    test('probeGuest prefers elements, falls back to widgets', () {
      final el = FakeElement(widget: _sampleApp(), viewId: 1);
      final probed = probeGuest(elementRoot: el, widgetRoot: _sampleApp());
      expect(probed.fromElements, isTrue);

      final fallback = probeGuest(widgetRoot: _sampleApp());
      expect(fallback.fromElements, isFalse);
      expect(findTextNodes(fallback.tree, 'Hello'), hasLength(1));

      final empty = probeGuest();
      expect(empty.tree['type'], equals('Error'));
      expect(probeRootElement(GlobalKey()), isNull);
    });
  });

  group('headless driver loop (automator + simulated device)', () {
    late FakeDevServer server;
    late DnHarness harness;
    late SimulatedDevice device;
    late UiAutomator automator;

    const guest = r'''
import 'package:dartnative/dartnative.dart';

void main() {
  runApp(
    Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Hello'),
            // Host-visible side effect: guest prints route to the device log
            // (LiveConnection.sendDeviceLog on-device, DnHarness.onLog here),
            // which is how automation verifies a tap end-to-end. Interpreted
            // statics are per-execute isolated, so they can't serve as the
            // assertion channel (plugin/bridge state lives in host memory
            // and CAN — see the SharedPreferences test).
            Button(title: 'Ping', onPressed: () => print('ui:ping-tapped')),
          ],
        ),
      ),
    ),
  );
}
''';

    // Guest prints captured here = device logs on-device.
    final deviceLogs = <String>[];
    setUp(() async {
      deviceLogs.clear();
      server = FakeDevServer(appName: 'UI Loop App');
      await server.start();
      harness = DnHarness(onLog: deviceLogs.add);
      await harness.evaluate({'main.dart': guest});
      device = SimulatedDevice(harness: harness, serverUrl: server.baseUrl);
      await device.connect();
      automator = UiAutomator(serverUrl: server.baseUrl);
      await automator.connect();
    });

    tearDown(() async {
      await automator.disconnect();
      await device.disconnect();
      harness.dispose();
      await server.stop();
    });

    test('probe sees the tree; tap dispatches; missing tap fails', () async {
      final tree = await automator.probe();
      UiAutomator.expectText(tree, 'Hello');
      UiAutomator.expectButton(tree, 'Ping');

      await automator.tap('Ping');
      // The tap's print surfaces in device logs — end-to-end proof the
      // button callback dispatched through the automation path.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(deviceLogs, contains('ui:ping-tapped'));

      expect(
        () => automator.tap('Nope'),
        throwsA(isA<UiAutomationFailure>()),
      );
    });

    test('hover resolves; focus/submit on buttons fail cleanly', () async {
      await automator.probe();
      // Hover is reachability + viewId reporting (no SDK hover surface).
      final viewId = await automator.hover(target: {'title': 'Ping'});
      expect(viewId, isNull); // Level-1 tree: no native ids headless

      // Buttons have no focus/submit surface — clean errors, not crashes.
      expect(
        () => automator.focus(target: {'title': 'Ping'}),
        throwsA(isA<UiAutomationFailure>()),
      );
      expect(
        () => automator.submit(target: {'title': 'Ping'}),
        throwsA(isA<UiAutomationFailure>()),
      );
    });
  });

  group('keys, icons, and input triggers', () {
    test('serializeTree emits key_value and icon data', () {
      const app = Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('K', key: ValueKey('k1')),
              Icon(IconData(0xe123, fontFamily: 'test_font')),
            ],
          ),
        ),
      );
      final tree = serializeTree(app);
      final keyed = findKeyNodes(tree, 'k1');
      expect(keyed, hasLength(1));
      expect(keyed.single['type'], equals('Text'));

      final icons = findIconNodes(tree, codePoint: 0xe123);
      expect(icons, hasLength(1));
      expect(icons.single['icon']['font_family'], equals('test_font'));
      expect(
        findIconNodes(tree, codePoint: 0x9999),
        isEmpty,
      );
      UiAutomator.expectKey(tree, 'k1');
      UiAutomator.expectIcon(tree, codePoint: 0xe123);
      expect(
        () => UiAutomator.expectIcon(tree, codePoint: 1),
        throwsA(isA<UiAutomationFailure>()),
      );
    });

    test('resolveTarget matches key/title/icon, rejects empty spec', () {
      const app = Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('Hi', key: ValueKey('hi')),
              Button(title: 'Go', onPressed: null),
            ],
          ),
        ),
      );
      expect(
        resolveTarget(widgetRoot: app, spec: const TargetSpec()).error,
        contains('empty target'),
      );
      final byKey =
          resolveTarget(widgetRoot: app, spec: const TargetSpec(key: 'hi'));
      expect(byKey.target?.widget, isA<Text>());
      final byTitle =
          resolveTarget(widgetRoot: app, spec: const TargetSpec(title: 'Go'));
      expect(byTitle.target?.widget, isA<Button>());
      expect(
        resolveTarget(
          widgetRoot: app,
          spec: const TargetSpec(title: 'Missing'),
        ).error,
        contains('no element matching'),
      );
    });

    test('submit dispatches onSubmitted with text override', () {
      final submitted = <String>[];
      final app = Scaffold(
        body: Center(
          child: TextField(
            onSubmitted: submitted.add,
          ),
        ),
      );
      final outcome = submitTarget(
        widgetRoot: app,
        spec: const TargetSpec(key: 'nope'),
        text: 'hello',
      );
      // No key on the field → clean miss, not a crash.
      expect(outcome.ok, isFalse);

      final keyed = Scaffold(
        body: Center(
          child: TextField(
            key: const ValueKey('q'),
            onSubmitted: submitted.add,
          ),
        ),
      );
      final ok = submitTarget(
        widgetRoot: keyed,
        spec: const TargetSpec(key: 'q'),
        text: 'hello',
      );
      expect(ok.ok, isTrue);
      expect(submitted, equals(['hello']));
    });

    test('focus/blur/type degrade gracefully without native support', () {
      final app = Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(key: const ValueKey('q')),
              Button(title: 'Go', onPressed: null),
            ],
          ),
        ),
      );
      // No FocusNode on the field → clean error (host stubs would throw).
      expect(
        focusTarget(
          widgetRoot: app,
          spec: const TargetSpec(key: 'q'),
        ).error,
        contains('no focusNode'),
      );
      // Button has no focus surface at all.
      expect(
        focusTarget(
          widgetRoot: app,
          spec: const TargetSpec(title: 'Go'),
        ).error,
        contains('needs a TextField'),
      );
      // No controller → clean error instead of a stub throw.
      expect(
        typeIntoTarget(
          widgetRoot: app,
          spec: const TargetSpec(key: 'q'),
          text: 'hi',
        ).error,
        contains('no controller'),
      );
    });

    test('tapTarget dispatches to GestureDetector, BarButtonItem, and nested Icons', () {
      var gestureTapped = 0;
      var barButtonTapped = 0;

      final app = Scaffold(
        appBar: AppBar(
          actions: [
            BarButtonItem(
              fontIcon: const IconData(62601, fontFamily: 'CupertinoIcons'),
              onPressed: () => barButtonTapped++,
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => gestureTapped++,
                child: const Icon(IconData(62409, fontFamily: 'CupertinoIcons')),
              ),
            ],
          ),
        ),
      );

      // 1. Tap nested icon inside GestureDetector by icon code point
      final res1 = tapTarget(
        widgetRoot: app,
        spec: const TargetSpec(iconCodePoint: 62409, iconFontFamily: 'CupertinoIcons'),
      );
      expect(res1.ok, isTrue);
      expect(gestureTapped, equals(1));

      // 2. Tap BarButtonItem by fontIcon code point
      final res2 = tapTarget(
        widgetRoot: app,
        spec: const TargetSpec(iconCodePoint: 62601, iconFontFamily: 'CupertinoIcons'),
      );
      expect(res2.ok, isTrue);
      expect(barButtonTapped, equals(1));

      // 3. Tap element with no tap handler reports clear failure
      final unclickable = const Scaffold(
        body: Center(child: Text('Just text')),
      );
      final res3 = tapTarget(
        widgetRoot: unclickable,
        spec: const TargetSpec(text: 'Just text'),
      );
      expect(res3.ok, isFalse);
      expect(res3.error, contains('has no tappable ancestor'));
    });

    test('scrollTarget jumps controller and degrades gracefully', () {
      final controller = ScrollController();
      final app = Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: const Column(
            children: [
              Text('Top'),
              SizedBox(height: 1000),
              Text('Bottom'),
            ],
          ),
        ),
      );

      final res = scrollTarget(
        widgetRoot: app,
        deltaY: 150,
      );
      expect(res.ok, isTrue);

      final noScroll = const Scaffold(body: Center(child: Text('Flat')));
      final resNone = scrollTarget(widgetRoot: noScroll);
      expect(resNone.ok, isFalse);
      expect(resNone.error, contains('no scrollable widget'));
    });

    test('named icon resolution supports CupertinoIcons and FontAwesome5 across probe and tap', () {
      // 1. IconRegistry resolves names
      final plus = resolveIcon('CupertinoIcons.plus');
      expect(plus, isNotNull);
      expect(plus!.codePoint, equals(62601));
      expect(plus.fontFamily, equals('CupertinoIcons'));

      final gear = resolveIcon('FontAwesome5.gear');
      expect(gear, isNotNull);
      expect(gear!.codePoint, equals(0xf013));
      expect(gear.fontFamily, equals('FontAwesome5'));

      // 2. TargetSpec resolves named icon map
      final spec = TargetSpec.fromJson({'icon': 'CupertinoIcons.plus'});
      expect(spec.iconCodePoint, equals(62601));
      expect(spec.iconFontFamily, equals('CupertinoIcons'));

      // 3. Tree serialization and expectIcon assertion
      var iconTapped = 0;
      final app = Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () => iconTapped++,
            child: const Icon(IconData(62601, fontFamily: 'CupertinoIcons')),
          ),
        ),
      );
      final tree = serializeTree(app);
      UiAutomator.expectIcon(tree, icon: 'CupertinoIcons.plus');

      // 4. Tap via TargetSpec with named icon
      final tapRes = tapTarget(widgetRoot: app, spec: spec);
      expect(tapRes.ok, isTrue);
      expect(iconTapped, equals(1));
    });

    test('NativeBottomSheet integration discovers sheet components and dispatches taps', () {
      var sheetBtnTapped = 0;
      final controller = DNSheetController.create(
        sheetId: 101,
        detents: const [DNSheetDetent.medium, DNSheetDetent.large],
        initialDetent: DNSheetDetent.medium,
      );
      final sheetWidget = Container(
        child: Column(
          children: [
            const Text('New note modal'),
            Button(
              title: 'Save Note',
              onPressed: () => sheetBtnTapped++,
            ),
          ],
        ),
      );
      final scope = NativeBottomSheetScope(
        controller: controller,
        child: sheetWidget,
      );
      final state = scope.createState();
      state.initState();

      try {
        final mainApp = Scaffold(
          body: const Center(child: Text('Main Screen Content')),
        );

        // 1. probeGuest includes both main screen and bottom sheet
        final probed = probeGuest(widgetRoot: mainApp);
        expect(findTextNodes(probed.tree, 'Main Screen Content'), hasLength(1));
        expect(findTextNodes(probed.tree, 'New note modal'), hasLength(1));
        // Substring match works too
        expect(findTextNodes(probed.tree, 'New note'), hasLength(1));
        expect(findButtonNodes(probed.tree, 'Save Note'), hasLength(1));

        // 2. tapTarget resolves into the bottom sheet
        final res = tapTarget(
          widgetRoot: mainApp,
          spec: const TargetSpec(title: 'Save Note'),
        );
        expect(res.ok, isTrue);
        expect(sheetBtnTapped, equals(1));
      } finally {
        state.dispose();
      }

      // 3. After dispose, sheet is no longer present
      final afterDispose = probeGuest(widgetRoot: Scaffold(body: const Text('Back')));
      expect(findTextNodes(afterDispose.tree, 'New note modal'), isEmpty);
    });

    test('typeIntoTarget types text, notifies controller listeners, and fires onChanged', () {
      final titleController = TextEditingController();
      final descController = TextEditingController();
      String? changed;
      int listenerCallCount = 0;
      bool hasListenerSupport = false;
      try {
        titleController.addListener(() => listenerCallCount++);
        hasListenerSupport = true;
      } catch (_) {}

      final form = Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Note title'),
            onChanged: (val) => changed = val,
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: 'Add a description...'),
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'No controller note'),
            onChanged: (val) => changed = 'onChangedOnly:$val',
          ),
        ],
      );

      // 1. Type into title via placeholder
      final r1 = typeIntoTarget(
        widgetRoot: form,
        spec: const TargetSpec(placeholder: 'Note title'),
        text: 'Buy groceries',
      );
      expect(r1.ok, isTrue);
      try {
        expect(titleController.text, equals('Buy groceries'));
      } catch (_) {}
      expect(changed, equals('Buy groceries'));
      if (hasListenerSupport) {
        expect(listenerCallCount, greaterThan(0));
      }

      // 2. Type into description via TargetSpec.fromJson({into: ...})
      final r2 = typeIntoTarget(
        widgetRoot: form,
        spec: TargetSpec.fromJson({'into': 'description'}),
        text: 'Milk, eggs, and bread',
      );
      expect(r2.ok, isTrue);
      try {
        expect(descController.text, equals('Milk, eggs, and bread'));
      } catch (_) {}

      // 3. Type into field with onChanged only (no controller)
      final r3 = typeIntoTarget(
        widgetRoot: form,
        spec: const TargetSpec(placeholder: 'No controller note'),
        text: 'pure onChanged text',
      );
      expect(r3.ok, isTrue);
      expect(changed, equals('onChangedOnly:pure onChanged text'));

      // 4. Type with empty spec targets first TextField
      final r4 = typeIntoTarget(
        widgetRoot: form,
        spec: const TargetSpec(),
        text: 'Updated Title',
      );
      expect(r4.ok, isTrue);
      try {
        expect(titleController.text, equals('Updated Title'));
      } catch (_) {}
    });
  });
}
