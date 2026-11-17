/// Local auth demo — device support, biometrics and a full authenticate
/// flow with Face ID / Touch ID / device credentials.
library;

import 'package:dartnative/dartnative.dart';
import 'package:local_auth_kit/local_auth_kit.dart';

class LocalAuthDemo extends StatefulWidget {
  const LocalAuthDemo({super.key});

  @override
  State<LocalAuthDemo> createState() => _LocalAuthDemoState();
}

class _LocalAuthDemoState extends State<LocalAuthDemo> {
  final _auth = LocalAuthentication();
  String _status = 'Ready';

  Future<void> _check() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final biometrics = await _auth.getAvailableBiometrics();
      setState(() {
        _status =
            'supported:$supported canCheck:$canCheck '
            'biometrics:${biometrics.map((b) => b.name).join(',')}';
      });
    } catch (e) {
      setState(() => _status = 'Check failed: $e');
    }
  }

  Future<void> _authenticate() async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock the demo with biometrics or passcode',
      );
      setState(() => _status = ok ? 'Authenticated ✓' : 'Auth failed');
    } catch (e) {
      setState(() => _status = 'Authenticate failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Auth')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Button(title: 'Check Device', onPressed: _check),
            const SizedBox(height: 12),
            Button(title: 'Authenticate', onPressed: _authenticate),
          ],
        ),
      ),
    );
  }
}
