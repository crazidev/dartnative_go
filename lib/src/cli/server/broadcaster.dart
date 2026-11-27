import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Helper to detect local network IP address and bind ports in a range.
class NetworkHelper {
  /// Finds the first non-loopback IPv4 address for local network access.
  static Future<String> getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback &&
              !addr.address.startsWith('169.254.') &&
              !addr.address.startsWith('127.')) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return '127.0.0.1';
  }

  /// Attempts to bind an [HttpServer] across a range of ports from [startPort] to [endPort].
  static Future<(HttpServer server, int port)> bindInRange({
    int startPort = 8088,
    int endPort = 8098,
    dynamic address,
  }) async {
    final bindAddress = address ?? InternetAddress.anyIPv4;
    for (var port = startPort; port <= endPort; port++) {
      try {
        final server = await HttpServer.bind(bindAddress, port);
        return (server, port);
      } on SocketException catch (_) {
        // Port in use or unavailable, try next
      }
    }
    // Fallback: system-assigned port
    final fallbackServer = await HttpServer.bind(bindAddress, 0);
    return (fallbackServer, fallbackServer.port);
  }
}

/// Broadcasts DartNative Go server discovery beacons via UDP across local LAN.
class DartGoBroadcaster {
  final String appName;
  final String host;
  final int port;
  final int startPort;
  final int endPort;
  final String dartGoVersion;
  final String? appVersion;
  final bool hasIcon;
  final String? iconUrl;
  final bool hasSplash;

  RawDatagramSocket? _udpSocket;
  Timer? _timer;

  DartGoBroadcaster({
    required this.appName,
    required this.host,
    required this.port,
    this.startPort = 8088,
    this.endPort = 8098,
    required this.dartGoVersion,
    this.appVersion,
    this.hasIcon = false,
    this.iconUrl,
    this.hasSplash = false,
  });

  /// Starts periodic UDP discovery broadcasting.
  Future<void> start({
    Duration interval = const Duration(milliseconds: 1500),
  }) async {
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _udpSocket!.broadcastEnabled = true;

      _sendBeacon();
      _timer = Timer.periodic(interval, (_) => _sendBeacon());
    } catch (e) {
      // Non-fatal if UDP broadcast fails
    }
  }

  void _sendBeacon() {
    if (_udpSocket == null) return;

    final payload = jsonEncode({
      'protocol': 'dart_go',
      'version': dartGoVersion,
      'appName': appName,
      if (appVersion != null) 'appVersion': appVersion,
      'url': 'http://$host:$port',
      'manifestUrl': 'http://$host:$port/manifest.json',
      'wsUrl': 'ws://$host:$port/ws',
      'port': port,
      'hasIcon': hasIcon,
      if (iconUrl != null) 'iconUrl': iconUrl,
      'hasSplash': hasSplash,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _broadcastBytes(utf8.encode(payload));
  }

  /// Broadcasts an immediate goodbye packet so listeners drop online status
  /// without waiting for probe timeouts.
  void _sendGoodbye() {
    if (_udpSocket == null) return;

    final payload = jsonEncode({
      'protocol': 'dart_go',
      'type': 'bye',
      'url': 'http://$host:$port',
      'port': port,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _broadcastBytes(utf8.encode(payload));
  }

  void _broadcastBytes(List<int> bytes) {
    final socket = _udpSocket;
    if (socket == null) return;

    // Broadcast to standard port range (8088..8098) and dedicated discovery port (45454)
    final broadcastTarget = InternetAddress('255.255.255.255');

    for (var targetPort = startPort; targetPort <= endPort; targetPort++) {
      try {
        socket.send(bytes, broadcastTarget, targetPort);
      } catch (_) {}
    }

    // Dedicated discovery port for mobile app listener
    try {
      socket.send(bytes, broadcastTarget, 45454);
    } catch (_) {}
  }

  /// Stops the broadcaster and releases network sockets.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _sendGoodbye();
    _udpSocket?.close();
    _udpSocket = null;
  }
}
