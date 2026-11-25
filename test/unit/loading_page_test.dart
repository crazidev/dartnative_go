import 'package:dartnative_go/src/cli/server/loading_page.dart';
import 'package:dngo_api/version.dart';
import 'package:test/test.dart';

void main() {
  group('isBrowserDocumentRequest', () {
    test('detects browser Accept headers', () {
      expect(
        isBrowserDocumentRequest(
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        ),
        isTrue,
      );
    });

    test('rejects API / empty Accept', () {
      expect(isBrowserDocumentRequest(null), isFalse);
      expect(isBrowserDocumentRequest(''), isFalse);
      expect(isBrowserDocumentRequest('*/*'), isFalse);
      expect(isBrowserDocumentRequest('application/json'), isFalse);
    });
  });

  group('buildLoadingPageHtml', () {
    test('embeds project identity and open deep link', () {
      final html = buildLoadingPageHtml(
        appName: 'example',
        appVersion: '0.1.0+1',
        serverUrl: 'http://172.20.10.3:8089',
        projectPath: '/tmp/example',
      );
      expect(html, contains('example'));
      expect(html, contains('0.1.0+1'));
      expect(html, contains('http://172.20.10.3:8089'));
      expect(html, contains('dartnativego://open'));
      expect(html, contains('v$kDartGoVersion'));
      expect(html, contains('v$kDartNativeVersion'));
      expect(html, contains('Open in DartNative Go'));
    });
  });
}
