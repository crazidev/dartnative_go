import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'http_client.dart';
import 'project_model.dart';
import 'storage_interface.dart';

/// Scans all connected local network interfaces and listens for UDP discovery beacons
/// across the DartNative Go port range (8088..8098) to find active projects.
class DartGoNetworkScanner {
  final int startPort;
  final int endPort;
  final int discoveryPort;
  final DartGoHttpClient _httpClient;
  final IProjectStorage _storage;

  final StreamController<List<DartGoProject>> _projectsController =
      StreamController<List<DartGoProject>>.broadcast();

  final Map<String, DartGoProject> _projectsMap = {};
  RawDatagramSocket? _udpSocket;
  Timer? _scanTimer;
  bool _isScanning = false;
  bool _disposed = false;

  DartGoNetworkScanner({
    this.startPort = 8088,
    this.endPort = 8098,
    this.discoveryPort = 45454,
    DartGoHttpClient? httpClient,
    IProjectStorage? storage,
  }) : _httpClient = httpClient ?? DartGoHttpClient(),
       _storage = storage ?? InMemoryProjectStorage();

  /// Stream of projects sorted with active projects at the top.
  Stream<List<DartGoProject>> get projectsStream => _projectsController.stream;

  /// Current list of projects sorted with active projects at the top.
  List<DartGoProject> get currentProjects => _getSortedProjects();

  /// Initializes the scanner: loads stored projects, starts UDP listener,
  /// and runs initial network scan.
  Future<void> start({Duration interval = const Duration(seconds: 4)}) async {
    // 1. Load persisted projects from storage
    final saved = await _storage.loadProjects();
    for (final p in saved) {
      _projectsMap[p.url] = p.copyWith(isActive: false);
    }
    _emitProjects();

    // 2. Start UDP beacon listener
    _startUdpListener();

    // 3. Run initial network scan
    await scanNow();

    // 4. Start periodic auto-scan
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(interval, (_) => scanNow());
  }

  /// Listens for UDP discovery beacons sent by DartGoBroadcaster.
  void _startUdpListener() async {
    try {
      _udpSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        discoveryPort,
        reuseAddress: true,
        reusePort: true,
      );
      _udpSocket!.broadcastEnabled = true;

      _udpSocket!.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _udpSocket?.receive();
          if (datagram != null) {
            _handleUdpDatagram(datagram);
          }
        }
      });
    } catch (_) {
      // Non-fatal if UDP listener fails to bind
    }
  }

  void _handleUdpDatagram(Datagram datagram) {
    try {
      final text = utf8.decode(datagram.data);
      final json = jsonDecode(text) as Map<String, dynamic>;

      if (json['protocol'] == 'dart_go') {
        final project = DartGoProject.fromBeacon(json);
        _addOrUpdateActiveProject(project);
      }
    } catch (_) {}
  }

  /// Runs an active scan across all connected network interfaces and known hosts.
  Future<void> scanNow() async {
    if (_isScanning || _disposed) return;
    _isScanning = true;

    try {
      // 1. Collect all connected network IPs
      final targetHosts = await _getConnectedNetworkHosts();

      // 2. Also include hosts from known/recent projects
      for (final p in _projectsMap.values) {
        final uri = Uri.tryParse(p.url);
        if (uri != null && uri.host.isNotEmpty) {
          targetHosts.add(uri.host);
        }
      }

      // 3. Probe all target hosts across port range (8088..8098)
      final probeFutures = <Future<void>>[];
      for (final host in targetHosts) {
        for (var port = startPort; port <= endPort; port++) {
          probeFutures.add(_probeEndpoint(host, port));
        }
      }

      // Execute in parallel
      await Future.wait(probeFutures);

      // 4. Verify health of currently tracked active projects that weren't just probed
      for (final project in _projectsMap.values.toList()) {
        final isAlive = await _httpClient.ping(project.url);
        if (_projectsMap.containsKey(project.url)) {
          if (!isAlive && project.isActive) {
            _projectsMap[project.url] = project.copyWith(isActive: false);
          } else if (isAlive && !project.isActive) {
            _projectsMap[project.url] = project.copyWith(
              isActive: true,
              lastSeen: DateTime.now(),
            );
          }
        }
      }

      _emitProjects();
    } catch (_) {
    } finally {
      _isScanning = false;
    }
  }

  /// Probes a specific host and port for a DartNative Go manifest.
  Future<void> _probeEndpoint(String host, int port) async {
    final baseUrl = 'http://$host:$port';
    final manifest = await _httpClient.fetchManifest(
      baseUrl,
      timeout: const Duration(milliseconds: 700),
    );

    if (manifest != null) {
      final project = DartGoProject.fromManifest(manifest, baseUrl);
      _addOrUpdateActiveProject(project);
    }
  }

  /// Discovers active IPv4 addresses on all connected network interfaces.
  Future<Set<String>> _getConnectedNetworkHosts() async {
    final hosts = <String>{'127.0.0.1', 'localhost'};

    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: true,
      );

      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.address.startsWith('169.254.')) {
            hosts.add(addr.address);
          }
        }
      }
    } catch (_) {}

    return hosts;
  }

  /// Adds or updates an active project in the list and storage.
  void _addOrUpdateActiveProject(DartGoProject project) {
    final existing = _projectsMap[project.url];
    final updated = (existing ?? project).copyWith(
      appName: project.appName,
      isActive: true,
      lastSeen: DateTime.now(),
      manifestUrl: project.manifestUrl,
      bundleUrl: project.bundleUrl,
      wsUrl: project.wsUrl,
      iconUrl: project.iconUrl ?? existing?.iconUrl,
    );

    _projectsMap[project.url] = updated;
    _storage.upsertProject(updated);
    _emitProjects();
  }

  /// Adds a manually entered project URL, tests connection, and persists it.
  Future<DartGoProject> addManualProject(String rawUrl) async {
    final normalized = DartGoHttpClient.normalizeUrl(rawUrl);
    final manifest = await _httpClient.fetchManifest(normalized);

    final project = manifest != null
        ? DartGoProject.fromManifest(manifest, normalized)
        : DartGoProject(
            appName: Uri.tryParse(normalized)?.host ?? 'Dev Server',
            url: normalized,
            isActive: false,
            lastSeen: DateTime.now(),
          );

    _projectsMap[project.url] = project;
    await _storage.upsertProject(project);
    _emitProjects();
    return project;
  }

  /// Removes a project by URL.
  Future<void> removeProject(String url) async {
    _projectsMap.remove(url);
    await _storage.removeProject(url);
    _emitProjects();
  }

  /// Sorts projects for a stable list: online projects first, then by port.
  ///
  /// `lastSeen` refreshes on every probe, and the probes finish in parallel in
  /// nondeterministic order, so ordering by it made two online projects trade
  /// places after each scan. Port is stable, so the list never shuffles; the
  /// URL breaks ties (two hosts can share a port).
  List<DartGoProject> _getSortedProjects() {
    final list = _projectsMap.values.toList();
    list.sort((a, b) {
      if (a.isActive != b.isActive) {
        return a.isActive ? -1 : 1; // Online first
      }
      final portCompare = _portOf(a).compareTo(_portOf(b));
      if (portCompare != 0) return portCompare;
      return a.url.compareTo(b.url);
    });
    return list;
  }

  /// The URL's port (the scheme default when omitted), or 0 if unparseable.
  static int _portOf(DartGoProject project) {
    final uri = Uri.tryParse(project.url);
    return uri == null ? 0 : uri.port;
  }

  void _emitProjects() {
    if (!_disposed && !_projectsController.isClosed) {
      _projectsController.add(_getSortedProjects());
    }
  }

  /// Disposes background timers and open sockets.
  void dispose() {
    _disposed = true;
    _scanTimer?.cancel();
    _scanTimer = null;
    _udpSocket?.close();
    _udpSocket = null;
    _httpClient.close();
    _projectsController.close();
  }
}
