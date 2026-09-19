import 'package:dartnative_go/src/cli/qr_code.dart';

void main() {
  final qr = QrCode('http://192.168.1.100:8088');
  assert(qr.size >= 21);
  final terminalOutput = qr.renderToTerminal();
  assert(terminalOutput.isNotEmpty);
  print('QR Code generated successfully (${qr.size}x${qr.size}):\n$terminalOutput');
}
