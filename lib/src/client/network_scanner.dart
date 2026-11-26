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

  /// URLs the user has actually opened, most-recently-opened first.
  ///
  /// Discovery alone must not mutate this — otherwise a fresh `dngo start`
  /// appears in Recents, and probe `lastSeen` bumps would reshuffle the list.
  final List<String> _recentOrder = [];

  RawDatagramSocket? _udpSocket;
  Timer? _scanTimer;
  Duration _scanInterval = const Duration(seconds: 4);
  bool _paused = false;
  bool _isScanning = false;
  bool _disposed = false;

  /// When true, [_addOrUpdateActiveProject] skips stream emits so a scan can
  /// publish one coherent snapshot instead of flashing per-probe.
  bool _batchingEmits = false;

  /// How long a server may miss probes before it is treated as offline.
  /// Prevents one flaky ping from blinking a dead server back into the list.
  static const Duration _offlineGrace = Duration(seconds: 6);

  /// Last emitted UI-relevant fingerprint (active flags + recent order).
  /// Skips no-op stream events that would rebuild the launcher for lastSeen-only bumps.
  String? _lastEmitFingerprint;

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

  /// Projects the user has opened, in stable open-order (not probe order).
  ///
  /// Discovered-but-never-opened servers are omitted; they only appear in
  /// [currentProjects] while [DartGoProject.isActive].
  List<DartGoProject> get recentProjects => [
    for (final url in _recentOrder)
      if (_projectsMap[url] != null) _projectsMap[url]!,
  ];

  /// Initializes the scanner: loads stored projects, starts UDP listener,
  /// and runs initial network scan.
  Future<void> start({Duration interval = const Duration(seconds: 4)}) async {
    // 1. Load persisted projects from storage (order is the recent order)
    final saved = await _storage.loadProjects();
    _recentOrder
      ..clear()
      ..addAll(saved.map((p) => p.url));
    for (final p in saved) {
      _projectsMap[p.url] = p.copyWith(isActive: false);
    }
    _emitProjects();

    // 2. Start UDP beacon listener
    _startUdpListener();

    // 3. Run initial network scan
    await scanNow();

    // 4. Start periodic auto-scan
    _scanInterval = interval;
    _scanTimer?.cancel();
    if (!_paused) {
      _scanTimer = Timer.periodic(interval, (_) => scanNow());
    }
  }

  /// Pauses periodic background scanning while a guest app is running so
  /// SharedPreferences FFI reads and HTTP probes don't contend with UI frames.
  void pause() {
    _paused = true;
    _scanTimer?.cancel();
    _scanTimer = null;
  }

  /// Resumes periodic background scanning when returning to the launcher.
  void resume() {
    if (!_paused || _disposed) return;
    _paused = false;
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(_scanInterval, (_) => scanNow());
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
        if (json['type'] == 'bye') {
          final rawUrl = json['url'] as String?;
          if (rawUrl != null && rawUrl.isNotEmpty) {
            _markProjectOffline(DartGoHttpClient.normalizeUrl(rawUrl));
          }
          return;
        }
        final project = DartGoProject.fromBeacon(json);
        _addOrUpdateActiveProject(project);
      }
    } catch (_) {}
  }

  /// Immediately marks [url] offline (e.g. on UDP goodbye) and drops it if
  /// not in [_recentOrder].
  void _markProjectOffline(String url) {
    final existing = _projectsMap[url];
    if (existing == null) return;
    if (_recentOrder.contains(url)) {
      if (!existing.isActive) return;
      _projectsMap[url] = existing.copyWith(isActive: false);
    } else {
      _projectsMap.remove(url);
    }
    if (!_batchingEmits) {
      _emitProjects();
    }
  }

  /// Runs an active scan across all connected network interfaces and known hosts.
  Future<void> scanNow() async {
    if (_isScanning || _disposed) return;
    _isScanning = true;
    _batchingEmits = true;

    try {
      // 1. Collect all connected network IPs
      final targetHosts = await _getConnectedNetworkHosts();

      // 2. Also include hosts from active or recent projects (skip stale
      //    offline discoveries so they are not re-probed into a flash).
      for (final p in _projectsMap.values) {
        if (!p.isActive && !_recentOrder.contains(p.url)) continue;
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

      // 4. Refresh lastSeen for tracked URLs that still answer (in parallel).
      //    Failures do not flip isActive here — [_reconcileActiveFlags] applies grace.
      final tracked = _projectsMap.values
          .where((p) => p.isActive || _recentOrder.contains(p.url))
          .toList();
      await Future.wait([
        for (final project in tracked)
          _httpClient.ping(project.url).then((isAlive) {
            final current = _projectsMap[project.url];
            if (current == null || !isAlive) return;
            _projectsMap[project.url] = current.copyWith(
              isActive: true,
              lastSeen: DateTime.now(),
            );
          }),
      ]);

      _reconcileActiveFlags();
    } catch (_) {
    } finally {
      _batchingEmits = false;
      _isScanning = false;
      _emitProjects();
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

  /// Adds or updates an active project in memory.
  ///
  /// Persists only when the URL is already in [recentProjects] so discovery
  /// refreshes metadata without inventing a recent entry.
  void _addOrUpdateActiveProject(DartGoProject project) {
    final existing = _projectsMap[project.url];
    final updated = DartGoProject(
      appName: project.appName,
      url: existing?.url ?? project.url,
      manifestUrl: project.manifestUrl ?? existing?.manifestUrl,
      bundleUrl: project.bundleUrl ?? existing?.bundleUrl,
      wsUrl: project.wsUrl ?? existing?.wsUrl,
      appVersion: project.appVersion ?? existing?.appVersion,
      iconUrl: project.iconUrl,
      isActive: true,
      lastSeen: DateTime.now(),
    );

    final metadataChanged =
        existing == null ||
        !existing.isActive ||
        existing.appName != updated.appName ||
        existing.appVersion != updated.appVersion ||
        existing.iconUrl != updated.iconUrl;
    _projectsMap[project.url] = updated;
    // Refresh stored metadata in place — never reshuffle [_recentOrder].
    if (_recentOrder.contains(updated.url)) {
      unawaited(_storage.upsertProject(updated));
    }
    if (!_batchingEmits && metadataChanged) {
      _emitProjects();
    }
  }

  /// Marks servers offline only after [_offlineGrace] without a sighting, and
  /// drops non-recent offline discoveries so they cannot flash back in.
  void _reconcileActiveFlags() {
    final now = DateTime.now();
    for (final project in _projectsMap.values.toList()) {
      final stale = now.difference(project.lastSeen) > _offlineGrace;
      if (project.isActive && stale) {
        _projectsMap[project.url] = project.copyWith(isActive: false);
      }
      final current = _projectsMap[project.url];
      if (current != null &&
          !current.isActive &&
          !_recentOrder.contains(current.url) &&
          stale) {
        _projectsMap.remove(current.url);
      }
    }
  }

  /// Moves [url] to the front of the recent order (most recently opened).
  void _touchRecentOrder(String url) {
    _recentOrder.remove(url);
    _recentOrder.insert(0, url);
  }

  /// Rewrites storage so on-disk order matches [_recentOrder].
  Future<void> _persistRecentOrder() async {
    final projects = [
      for (final url in _recentOrder)
        if (_projectsMap[url] != null) _projectsMap[url]!,
    ];
    await _storage.saveProjects(projects);
  }

  /// Records that the user opened [url], adding it to recent storage.
  Future<void> rememberOpenedProject(
    String url, {
    String? appName,
  }) async {
    final normalized = DartGoHttpClient.normalizeUrl(url);
    final existing = _projectsMap[normalized];
    final project =
        (existing ??
                DartGoProject(
                  appName:
                      appName ?? Uri.tryParse(normalized)?.host ?? 'Dev Server',
                  url: normalized,
                  lastSeen: DateTime.now(),
                ))
            .copyWith(
              appName: appName ?? existing?.appName,
              lastSeen: DateTime.now(),
            );

    _projectsMap[project.url] = project;
    _touchRecentOrder(project.url);
    await _persistRecentOrder();
    _emitProjects();
  }

  /// Adds a manually entered project URL, tests connection, and persists it
  /// as a recent entry (the user explicitly chose this URL).
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
    _touchRecentOrder(project.url);
    await _persistRecentOrder();
    _emitProjects();
    return project;
  }

  /// Removes a project from recents. If it is still online it stays visible
  /// in the active/discovered list until it goes offline.
  Future<void> removeProject(String url) async {
    _recentOrder.remove(url);
    await _storage.removeProject(url);
    final existing = _projectsMap[url];
    if (existing == null || !existing.isActive) {
      _projectsMap.remove(url);
    }
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
    if (_disposed || _projectsController.isClosed) return;
    final projects = _getSortedProjects();
    final fingerprint = [
      for (final p in projects)
        '${p.url}|${p.isActive}|${p.appName}|${p.appVersion ?? ''}|${p.iconUrl ?? ''}',
      'recent:${_recentOrder.join(',')}',
    ].join('\n');
    if (fingerprint == _lastEmitFingerprint) return;
    _lastEmitFingerprint = fingerprint;
    _projectsController.add(projects);
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
