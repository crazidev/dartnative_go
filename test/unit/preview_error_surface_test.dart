/// Which error surface a guest failure uses.
///
/// The host draws both surfaces in the `App.builder` layer (above every route),
/// so a failure on a screen the guest pushed is visible. The *kind* decides
/// whether the app stays usable behind a banner or the failure takes the whole
/// screen.
library;

import 'package:dartnative/dartnative.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/client/error_display_storage.dart';
// ignore: implementation_imports
import 'package:dartnative_go/src/preview/preview_route.dart';
import 'package:test/test.dart';

void main() {
  group('guest error surface', () {
    test('a soft runtime error keeps the banner over the working app', () {
      final state = PreviewState(
        widget: const Scaffold(),
        isAppMounted: true,
        errorMessage: 'Guest runtime error: Bad state: oops',
        errorStackTrace: '#0  Panel.build (package:guest/main.dart:3:5)',
      );

      expect(
        previewStateNeedsFullScreenError(state),
        isFalse,
        reason: 'the tree still renders, so a dismissible banner is enough',
      );
    });

    test('a build with no rendered child still starts as the banner', () {
      final state = PreviewState(
        widget: const Scaffold(),
        isAppMounted: true,
        errorMessage: 'Guest runtime error: Bad state: Text needs data',
        guestBlankBuild: true,
      );

      expect(
        previewStateNeedsFullScreenError(state),
        isFalse,
        reason:
            'the takeover is opt-in: a transient save must not flash a '
            'full-screen page over the app',
      );
    });

    test('tapping the banner opens the full-screen view', () {
      final state = PreviewState(
        widget: const Scaffold(),
        isAppMounted: true,
        errorMessage: 'Guest runtime error: Bad state: Text needs data',
        guestBlankBuild: true,
      );

      expect(
        previewStateNeedsFullScreenError(state, expanded: true),
        isTrue,
        reason: 'the user asked for the details by tapping the banner',
      );
    });

    test('expanded without an error shows nothing', () {
      final state = PreviewState(widget: const Scaffold(), isAppMounted: true);

      expect(previewStateNeedsFullScreenError(state, expanded: true), isFalse);
    });

    test('a project that never mounted takes the whole screen', () {
      final state = PreviewState(
        isAppMounted: false,
        errorMessage: 'Guest failed to start: Bad state: boom',
        failedToStart: true,
      );

      expect(previewStateNeedsFullScreenError(state), isTrue);
    });

    test('the persisted full-screen mode wins over a soft error', () {
      final state = PreviewState(
        widget: const Scaffold(),
        isAppMounted: true,
        errorMessage: 'Guest runtime error: Bad state: oops',
        errorDisplayMode: ErrorDisplayMode.fullscreen,
      );

      expect(previewStateNeedsFullScreenError(state), isTrue);
    });

    test('no error means no surface', () {
      final state = PreviewState(widget: const Scaffold(), isAppMounted: true);

      expect(previewStateNeedsFullScreenError(state), isFalse);
    });
  });

  _popUntilTests();
}

/// Stand-in for DartNative's synthetic `popUntil` route.
class _FakeRoute extends Route<dynamic> {
  _FakeRoute({required this.isFirst, this.name});

  @override
  final bool isFirst;
  final String? name;
}

void _popUntilTests() {
  group('preview popUntil predicate', () {
    bool byPreviewName(Route<dynamic> route) =>
        route is _FakeRoute && route.name == '/preview';

    test('a guest screen is not the preview stop', () {
      expect(
        stopAtHostPreviewRoute(
          _FakeRoute(isFirst: false),
          byName: byPreviewName,
        ),
        isFalse,
      );
    });

    test('the named preview route stops the pop', () {
      expect(
        stopAtHostPreviewRoute(
          _FakeRoute(isFirst: false, name: '/preview'),
          byName: byPreviewName,
        ),
        isTrue,
        reason:
            'DartNative passes synthetic routes; matching PageRoute.settings '
            'never worked and popped past the preview',
      );
    });

    test('isFirst always stops, even without a name', () {
      expect(
        stopAtHostPreviewRoute(
          _FakeRoute(isFirst: true),
          byName: byPreviewName,
        ),
        isTrue,
        reason: 'a pop must never empty the navigator stack',
      );
    });
  });
}
