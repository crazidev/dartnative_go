import 'package:dartnative_go/src/client/deep_link.dart';
import 'package:test/test.dart';

void main() {
  group('DartGoDeepLink.build', () {
    test('encodes the url and name into the canonical link', () {
      final link = DartGoDeepLink.build(
        'http://192.168.1.10:8088',
        appName: 'My App',
      );
      expect(link, startsWith('dartnativego://open?'));
      final uri = Uri.parse(link);
      expect(uri.queryParameters['url'], 'http://192.168.1.10:8088');
      expect(uri.queryParameters['name'], 'My App');
    });

    test('normalizes a bare host:port target', () {
      final uri = Uri.parse(DartGoDeepLink.build('192.168.1.10:8088'));
      expect(uri.queryParameters['url'], 'http://192.168.1.10:8088');
      expect(uri.queryParameters.containsKey('name'), isFalse);
    });

    test('round-trips through tryParse', () {
      final link = DartGoDeepLink.build(
        'http://10.0.0.5:8090',
        appName: 'Demo',
      );
      final parsed = DartGoDeepLink.tryParse(Uri.parse(link))!;
      expect(parsed.serverUrl, 'http://10.0.0.5:8090');
      expect(parsed.appName, 'Demo');
    });
  });

  group('DartGoDeepLink.tryParse', () {
    test('reads the canonical ?url= form', () {
      final parsed = DartGoDeepLink.tryParse(
        Uri.parse('dartnativego://open?url=http%3A%2F%2F1.2.3.4%3A8088'),
      )!;
      expect(parsed.serverUrl, 'http://1.2.3.4:8088');
    });

    test('reads a bare host:port authority', () {
      final parsed = DartGoDeepLink.tryParse(
        Uri.parse('dartnativego://192.168.1.10:8088'),
      )!;
      expect(parsed.serverUrl, 'http://192.168.1.10:8088');
    });

    test('reads a path form', () {
      final parsed = DartGoDeepLink.tryParse(
        Uri.parse('dartnativego://open/192.168.1.10:8088'),
      )!;
      expect(parsed.serverUrl, 'http://192.168.1.10:8088');
    });

    test('accepts https targets', () {
      final parsed = DartGoDeepLink.tryParse(
        Uri.parse('dartnativego://open?url=https%3A%2F%2Fexample.com'),
      )!;
      expect(parsed.serverUrl, 'https://example.com');
    });

    test('ignores other schemes and non-http targets', () {
      expect(
        DartGoDeepLink.tryParse(Uri.parse('https://example.com/app')),
        isNull,
      );
      expect(
        DartGoDeepLink.tryParse(Uri.parse('myapp://open?url=1.2.3.4')),
        isNull,
      );
      expect(
        DartGoDeepLink.tryParse(
          Uri.parse('dartnativego://open?url=ftp%3A%2F%2Fx'),
        ),
        isNull,
      );
    });

    test('ignores a link with no target', () {
      expect(DartGoDeepLink.tryParse(Uri.parse('dartnativego://open')), isNull);
    });
  });
}
