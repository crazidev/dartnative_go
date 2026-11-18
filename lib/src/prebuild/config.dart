import 'dart:convert';

class DngoConfig {
  final String name;
  final String iosBundleId;
  final String androidApplicationId;
  final String versionName;
  final int buildNumber;
  final int androidMinSdk;
  final int androidTargetSdk;
  final int iosDeploymentTarget;
  final String? icon;
  final String? splash;
  final String? splashColor;
  final Map<String, String> iosPermissions;
  final Set<String> plugins;

  const DngoConfig({
    required this.name,
    required this.iosBundleId,
    required this.androidApplicationId,
    required this.versionName,
    required this.buildNumber,
    this.androidMinSdk = 26,
    this.androidTargetSdk = 35,
    this.iosDeploymentTarget = 16,
    this.icon,
    this.splash,
    this.splashColor,
    this.iosPermissions = const {},
    this.plugins = const {},
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'iosBundleId': iosBundleId,
    'androidApplicationId': androidApplicationId,
    'versionName': versionName,
    'buildNumber': buildNumber,
    'androidMinSdk': androidMinSdk,
    'androidTargetSdk': androidTargetSdk,
    'iosDeploymentTarget': iosDeploymentTarget,
    'icon': icon,
    'splash': splash,
    'splashColor': splashColor,
    'iosPermissions': iosPermissions,
    'plugins': plugins.toList()..sort(),
  };

  String encode() => jsonEncode(toJson());

  factory DngoConfig.fromJson(Map<String, dynamic> json) => DngoConfig(
    name: _required(json, 'name'),
    iosBundleId: _required(json, 'iosBundleId'),
    androidApplicationId: _required(json, 'androidApplicationId'),
    versionName: _required(json, 'versionName'),
    buildNumber: _int(json, 'buildNumber', 1),
    androidMinSdk: _int(json, 'androidMinSdk', 26),
    androidTargetSdk: _int(json, 'androidTargetSdk', 35),
    iosDeploymentTarget: _int(json, 'iosDeploymentTarget', 16),
    icon: json['icon'] as String?,
    splash: json['splash'] as String?,
    splashColor: json['splashColor'] as String?,
    iosPermissions: _strings(json['iosPermissions']),
    plugins: {..._list(json['plugins'])},
  );
}

String _required(Map<String, dynamic> json, String key) {
  final value = json[key]?.toString().trim();
  if (value == null || value.isEmpty) throw FormatException('Missing $key');
  return value;
}

int _int(Map<String, dynamic> json, String key, int fallback) =>
    int.tryParse(json[key]?.toString() ?? '') ?? fallback;

List<String> _list(Object? value) => value is List
    ? value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
    : const [];

Map<String, String> _strings(Object? value) => value is Map
    ? value.map((key, value) => MapEntry(key.toString(), value.toString()))
    : const {};

/// Reads the deliberately small, stable subset emitted by `dngo create`.
/// The file remains ordinary Dart and is compiled by the application; this
/// parser is only used by the CLI until the generated runner is available.
class DngoConfigParser {
  static DngoConfig parse(String source) {
    final values = <String, dynamic>{};
    void stringValue(String key, String pattern) {
      final match = RegExp(pattern, multiLine: true).firstMatch(source);
      if (match != null) values[key] = match.group(1);
    }

    void intValue(String key, String pattern) {
      final match = RegExp(pattern, multiLine: true).firstMatch(source);
      if (match != null) values[key] = match.group(1);
    }

    stringValue('name', r"name:\s*'([^']*)'");
    stringValue('iosBundleId', r"iosBundleId:\s*'([^']*)'");
    stringValue('androidApplicationId', r"androidApplicationId:\s*'([^']*)'");
    stringValue('versionName', r"versionName:\s*'([^']*)'");
    stringValue('icon', r"icon:\s*'([^']*)'");
    stringValue('splash', r"splash:\s*'([^']*)'");
    stringValue('splashColor', r"splashColor:\s*'([^']*)'");
    intValue('buildNumber', r'buildNumber:\s*(\d+)');
    intValue('androidMinSdk', r'androidMinSdk:\s*(\d+)');
    intValue('androidTargetSdk', r'androidTargetSdk:\s*(\d+)');
    intValue('iosDeploymentTarget', r'iosDeploymentTarget:\s*(\d+)');

    final permissionBlock = RegExp(
      r'iosPermissions:\s*\{(.*?)\}',
      dotAll: true,
    ).firstMatch(source)?.group(1);
    if (permissionBlock != null) {
      values['iosPermissions'] = {
        for (final match in RegExp(
          r"'([^']+)'\s*:\s*'([^']*)'",
        ).allMatches(permissionBlock))
          match.group(1)!: match.group(2)!,
      };
    }
    final plugins = RegExp(
      r'plugins\s*:\s*[\[\{]([^\]\}]*)[\]\}]',
      dotAll: true,
    ).firstMatch(source)?.group(1);
    if (plugins != null) {
      values['plugins'] = RegExp(
        r"'([^']+)'",
      ).allMatches(plugins).map((m) => m.group(1)!).toList();
    }
    return DngoConfig.fromJson(values);
  }
}
