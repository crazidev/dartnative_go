/// Represents a DartNative project discovered via network scan, UDP beacon,
/// or user entry.
class DartGoProject {
  final String appName;
  final String url;
  final String? manifestUrl;
  final String? bundleUrl;
  final String? wsUrl;
  final String? appVersion;
  final String? iconUrl;
  final bool isActive;
  final DateTime lastSeen;

  const DartGoProject({
    required this.appName,
    required this.url,
    this.manifestUrl,
    this.bundleUrl,
    this.wsUrl,
    this.appVersion,
    this.iconUrl,
    this.isActive = false,
    required this.lastSeen,
  });

  DartGoProject copyWith({
    String? appName,
    String? url,
    String? manifestUrl,
    String? bundleUrl,
    String? wsUrl,
    String? appVersion,
    String? iconUrl,
    bool? isActive,
    DateTime? lastSeen,
  }) {
    return DartGoProject(
      appName: appName ?? this.appName,
      url: url ?? this.url,
      manifestUrl: manifestUrl ?? this.manifestUrl,
      bundleUrl: bundleUrl ?? this.bundleUrl,
      wsUrl: wsUrl ?? this.wsUrl,
      appVersion: appVersion ?? this.appVersion,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'url': url,
      'manifestUrl': manifestUrl,
      'bundleUrl': bundleUrl,
      'wsUrl': wsUrl,
      'appVersion': appVersion,
      'iconUrl': iconUrl,
      'isActive': isActive,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory DartGoProject.fromJson(Map<String, dynamic> json) {
    return DartGoProject(
      appName: json['appName'] as String? ?? 'DartNative Project',
      url: json['url'] as String? ?? '',
      manifestUrl: json['manifestUrl'] as String?,
      bundleUrl: json['bundleUrl'] as String?,
      wsUrl: json['wsUrl'] as String?,
      appVersion: json['appVersion'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory DartGoProject.fromManifest(
    Map<String, dynamic> manifest,
    String baseUrl,
  ) {
    final appName = manifest['appName'] as String? ?? 'DartNative Project';
    final appVersion = manifest['appVersion'] as String?;
    final iconUrl = manifest['iconUrl'] as String?;
    final serverUrl = manifest['serverUrl'] as String? ?? baseUrl;

    return DartGoProject(
      appName: appName,
      url: serverUrl,
      manifestUrl: '$serverUrl/manifest.json',
      bundleUrl: '$serverUrl/bundle.json',
      wsUrl: '${serverUrl.replaceFirst('http', 'ws')}/ws',
      appVersion: appVersion,
      iconUrl: iconUrl,
      isActive: true,
      lastSeen: DateTime.now(),
    );
  }

  factory DartGoProject.fromBeacon(Map<String, dynamic> beacon) {
    final appName = beacon['appName'] as String? ?? 'DartNative Project';
    final appVersion = beacon['appVersion'] as String?;
    final url = beacon['url'] as String? ?? '';
    final bundleUrl = beacon['bundleUrl'] as String?;
    final manifestUrl = beacon['manifestUrl'] as String?;
    final wsUrl = beacon['wsUrl'] as String?;
    final hasIcon = beacon['hasIcon'] as bool? ?? false;
    final iconUrl =
        beacon['iconUrl'] as String? ??
        (hasIcon ? '$url/assets/icon.png' : null);

    return DartGoProject(
      appName: appName,
      appVersion: appVersion,
      url: url,
      manifestUrl: manifestUrl ?? '$url/manifest.json',
      bundleUrl: bundleUrl ?? '$url/bundle.json',
      wsUrl: wsUrl ?? '${url.replaceFirst('http', 'ws')}/ws',
      iconUrl: iconUrl,
      isActive: true,
      lastSeen: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartGoProject &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}
