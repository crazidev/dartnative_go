import 'package:dartnative_go/src/cli/qr_code.dart';
import 'package:test/test.dart';

void main() {
  group('QrCode', () {
    test('renders a non-empty terminal code for a server URL', () {
      final qr = QrCode('http://192.168.1.100:8088');
      expect(qr.size, greaterThanOrEqualTo(21));
      expect(qr.renderToTerminal(), isNotEmpty);
    });

    test('rendering is deterministic for the same URL', () {
      const url = 'http://192.168.1.100:8088';
      expect(
        QrCode(url).renderToTerminal(),
        equals(QrCode(url).renderToTerminal()),
      );
    });
  });
}
