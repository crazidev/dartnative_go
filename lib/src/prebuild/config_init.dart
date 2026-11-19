import 'dart:io';

import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

import 'config.dart';
import 'project_creator.dart' show renderConfig;

/// Values read from an existing DartNative project.
class ProjectInspection {
  /// Display name written to `android:label` / `CFBundleDisplayName`.
  final String name;

  /// Marketing version (`CFBundleShortVersionString` / `versionName`).
  final String versionName;

  /// Build number (`CFBundleVersion` / `versionCode`).
  final int buildNumber;

  final String iosBundleId;
  final String androidBundleId;

  /// Whether an `android/` project was found.
  final bool hasAndroid;

  /// Whether an `ios/` project was found.
  final bool hasIos;

  /// Whether native Gradle / plist / Podfile values were copied into config.
  final bool syncedFromProject;

  final AndroidConfig android;
  final IosConfig ios;

  const ProjectInspection({
    required this.name,
    required this.versionName,
    required this.buildNumber,
    required this.iosBundleId,
    required this.androidBundleId,
    required this.hasAndroid,
    required this.hasIos,
    this.syncedFromProject = false,
    this.android = const AndroidConfig(),
    this.ios = const IosConfig(),
  });

  DngoConfig toConfig() => DngoConfig(
    app: AppConfig(
      name: name,
      bundleId: BundleId(ios: iosBundleId, android: androidBundleId),
      version: AppVersion(name: versionName, buildNumber: buildNumber),
    ),
    platforms: PlatformsConfig(ios: ios, android: android),
  );
}

/// Inspects [projectDir] and writes a `dngo.config.dart` seeded with the
/// values already used by the native projects.
///
/// Existing files are left untouched unless [force] is true or
/// [confirmOverwrite] returns true.
///
/// When [syncFromProject] is null, [confirmSync] is asked whenever native
/// folders exist. A true result copies permissions, Gradle, Info.plist,
/// Podfile, entitlements and intent configuration into `dngo.config.dart`.
ProjectInspection initializeDngoConfig(
  Directory projectDir, {
  bool force = false,
  bool? syncFromProject,
  bool Function()? confirmOverwrite,
  bool Function()? confirmSync,
}) {
  final file = File('${projectDir.path}/dngo.config.dart');
  if (file.existsSync() && !force) {
    final overwrite = confirmOverwrite?.call() ?? false;
    if (!overwrite) {
      throw StateError(
        'dngo.config.dart already exists in ${projectDir.path}. '
        'Pass --force or confirm overwrite to replace it.',
      );
    }
  }
  final identity = inspectProject(projectDir);
  final shouldSync =
      syncFromProject ??
      ((identity.hasAndroid || identity.hasIos) &&
          (confirmSync?.call() ?? true));
  final inspection = shouldSync
      ? inspectProject(projectDir, syncFromProject: true)
      : identity;
  file
    ..createSync(recursive: true)
    ..writeAsStringSync(renderConfig(inspection.toConfig()));
  _formatConfig(file);
  return inspection;
}

void _formatConfig(File file) {
  try {
    Process.runSync('dart', ['format', file.path]);
  } on Object {
    // Generating the file already succeeded; skip if dart format is unavailable.
  }
}

/// Reads the app identity from `pubspec.yaml`, `AndroidManifest.xml`,
/// `build.gradle(.kts)`, `Info.plist` and `project.pbxproj`.
///
/// When [syncFromProject] is true, also copies native platform options that
/// `dngo prebuild` can manage.
ProjectInspection inspectProject(
  Directory projectDir, {
  bool syncFromProject = false,
}) {
  final pubspec = File('${projectDir.path}/pubspec.yaml');
  if (!pubspec.existsSync()) {
    throw StateError('Missing pubspec.yaml in ${projectDir.path}');
  }

  final yaml = loadYaml(pubspec.readAsStringSync());
  final map = yaml is YamlMap ? yaml : <Object?, Object?>{};
  final packageName =
      _nonEmpty(map['name']) ?? _fallbackPackageName(projectDir);
  final (versionName, buildNumber) = _parseVersion(_nonEmpty(map['version']));

  final hasAndroid = Directory('${projectDir.path}/android').existsSync();
  final hasIos = Directory('${projectDir.path}/ios').existsSync();

  final androidBundleId =
      _androidBundleId(projectDir) ?? 'com.example.$packageName';
  final iosBundleId =
      _iosBundleId(projectDir) ??
      (hasAndroid ? androidBundleId : 'com.example.$packageName');

  final name =
      _usableName(_androidLabel(projectDir)) ??
      _usableName(_iosDisplayName(projectDir)) ??
      _titleCase(packageName);

  return ProjectInspection(
    name: name,
    versionName: versionName,
    buildNumber: buildNumber,
    iosBundleId: iosBundleId,
    androidBundleId: androidBundleId,
    hasAndroid: hasAndroid,
    hasIos: hasIos,
    syncedFromProject: syncFromProject && (hasAndroid || hasIos),
    android: syncFromProject
        ? _androidConfig(projectDir)
        : const AndroidConfig(),
    ios: syncFromProject ? _iosConfig(projectDir) : const IosConfig(),
  );
}

/// Parses a pubspec `version:` (`1.2.3+4`) into a version name and build
/// number. Missing or malformed values fall back to `1.0.0+1`.
(String, int) _parseVersion(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return ('1.0.0', 1);
  final plus = value.indexOf('+');
  final name = (plus < 0 ? value : value.substring(0, plus)).trim();
  final build = plus < 0 ? 1 : int.tryParse(value.substring(plus + 1)) ?? 1;
  if (!RegExp(r'^\d+(\.\d+){0,2}([-.][0-9A-Za-z.-]+)?$').hasMatch(name)) {
    return ('1.0.0', build < 1 ? 1 : build);
  }
  return (name, build < 1 ? 1 : build);
}

String? _androidBundleId(Directory projectDir) {
  for (final fileName in const ['build.gradle.kts', 'build.gradle']) {
    final file = File('${projectDir.path}/android/app/$fileName');
    if (!file.existsSync()) continue;
    final text = file.readAsStringSync();
    final applicationId = RegExp(
      r'''applicationId\s*=?\s*["']([^"']+)["']''',
    ).firstMatch(text);
    if (applicationId != null) return applicationId.group(1);
    final namespace = RegExp(
      r'''namespace\s*=?\s*["']([^"']+)["']''',
    ).firstMatch(text);
    if (namespace != null) return namespace.group(1);
  }
  return null;
}

String? _iosBundleId(Directory projectDir) {
  final file = File(
    '${projectDir.path}/ios/Runner.xcodeproj/project.pbxproj',
  );
  if (!file.existsSync()) return null;
  final counts = <String, int>{};
  for (final match in RegExp(
    r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);',
  ).allMatches(file.readAsStringSync())) {
    final value = match
        .group(1)!
        .trim()
        .replaceAll(RegExp(r'''^["']|["']$'''), '');
    if (value.isEmpty || value.contains(r'$(')) continue;
    final lower = value.toLowerCase();
    if (lower.contains('test') || lower.contains('widget')) continue;
    counts[value] = (counts[value] ?? 0) + 1;
  }
  if (counts.isEmpty) return null;
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.first.key;
}

String? _androidLabel(Directory projectDir) {
  final file = File(
    '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
  );
  if (!file.existsSync()) return null;
  final document = XmlDocument.parse(file.readAsStringSync());
  final label = document.rootElement
      .getElement('application')
      ?.getAttribute('android:label');
  if (label == null || label.trim().isEmpty) return null;
  if (label.startsWith('@string/')) {
    return _androidStringResource(projectDir, label.substring(8));
  }
  if (label.startsWith('@') || label.contains(r'${')) return null;
  return label.trim();
}

String? _androidStringResource(Directory projectDir, String name) {
  final file = File(
    '${projectDir.path}/android/app/src/main/res/values/strings.xml',
  );
  if (!file.existsSync()) return null;
  final document = XmlDocument.parse(file.readAsStringSync());
  for (final element in document.findAllElements('string')) {
    if (element.getAttribute('name') == name) {
      final value = element.innerText.trim();
      return value.isEmpty ? null : value;
    }
  }
  return null;
}

String? _iosDisplayName(Directory projectDir) {
  final file = File('${projectDir.path}/ios/Runner/Info.plist');
  if (!file.existsSync()) return null;
  final document = XmlDocument.parse(file.readAsStringSync());
  final dict = document.rootElement.getElement('dict');
  if (dict == null) return null;
  return _plistString(dict, 'CFBundleDisplayName') ??
      _plistString(dict, 'CFBundleName');
}

String? _plistString(XmlElement dict, String key) {
  final children = dict.children.whereType<XmlElement>().toList();
  for (var i = 0; i + 1 < children.length; i++) {
    if (children[i].name.local != 'key' ||
        children[i].innerText.trim() != key) {
      continue;
    }
    final value = children[i + 1];
    if (value.name.local != 'string') return null;
    final text = value.innerText.trim();
    if (text.isEmpty || text.contains(r'$(')) return null;
    return text;
  }
  return null;
}

AndroidConfig _androidConfig(Directory projectDir) {
  final gradle = _androidGradleText(projectDir);
  final manifestFile = File(
    '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
  );
  XmlDocument? manifest;
  if (manifestFile.existsSync()) {
    try {
      manifest = XmlDocument.parse(manifestFile.readAsStringSync());
    } on XmlException {
      manifest = null;
    }
  }
  return AndroidConfig(
    minSdk: _gradleInt(gradle, 'minSdk'),
    targetSdk: _gradleInt(gradle, 'targetSdk'),
    compileSdk: _gradleInt(gradle, 'compileSdk'),
    ndkVersion: _gradleQuoted(gradle, 'ndkVersion'),
    versionCode: _gradleInt(gradle, 'versionCode'),
    versionName: _gradleQuoted(gradle, 'versionName'),
    signing: _androidSigning(projectDir, gradle),
    usesCleartextTraffic: _androidCleartext(manifest),
    permissions: _androidPermissions(manifest),
    intentQueries: _androidIntentQueries(manifest),
    intentFilters: _androidIntentFilters(manifest),
  );
}

IosConfig _iosConfig(Directory projectDir) {
  final plistFile = File('${projectDir.path}/ios/Runner/Info.plist');
  XmlElement? dict;
  if (plistFile.existsSync()) {
    try {
      dict = XmlDocument.parse(
        plistFile.readAsStringSync(),
      ).rootElement.getElement('dict');
    } on XmlException {
      dict = null;
    }
  }
  final entitlements = _iosEntitlementsDict(projectDir);
  final orientations = _iosOrientations(dict);
  return IosConfig(
    minimumDeploymentTarget: _iosDeploymentTarget(projectDir),
    supportedOrientations: orientations ?? IosOrientation.defaults,
    appGroup: _plistArrayStrings(
      entitlements,
      'com.apple.security.application-groups',
    ).firstOrNull,
    supportsLiveActivities:
        _plistBool(dict, 'NSSupportsLiveActivities') ?? false,
    supportsIpad: _iosSupportsIpad(projectDir),
    querySchemes: _plistArrayStrings(dict, 'LSApplicationQueriesSchemes'),
    urlSchemes: _iosUrlSchemes(dict),
    associatedDomains: _plistArrayStrings(
      entitlements,
      'com.apple.developer.associated-domains',
    ),
  );
}

String? _androidGradleText(Directory projectDir) {
  for (final fileName in const ['build.gradle.kts', 'build.gradle']) {
    final file = File('${projectDir.path}/android/app/$fileName');
    if (file.existsSync()) return file.readAsStringSync();
  }
  return null;
}

int? _gradleInt(String? text, String key) {
  if (text == null) return null;
  final match = RegExp(
    '${RegExp.escape(key)}(?:Version)?\\s*=?\\s*(\\d+)',
  ).firstMatch(text);
  return match == null ? null : int.tryParse(match.group(1)!);
}

String? _gradleQuoted(String? text, String key) {
  if (text == null) return null;
  final match = RegExp(
    '''${RegExp.escape(key)}\\s*=?\\s*["']([^"']+)["']''',
  ).firstMatch(text);
  final value = match?.group(1)?.trim();
  if (value == null || value.isEmpty) return null;
  if (value.contains('flutter.') || value.contains(r'$')) return null;
  return value;
}

AndroidSigningConfig? _androidSigning(Directory projectDir, String? text) {
  if (text == null) return null;
  final propertyFile = RegExp(
    r'''keystorePropertiesFile\s*=\s*rootProject\.file\(\s*["']([^"']+)["']\s*\)''',
  ).firstMatch(text)?.group(1);
  if (propertyFile != null) {
    try {
      return AndroidSigningConfig.fromGradleProperty(
        propertyFile,
        baseDirectory: '${projectDir.path}/android',
      );
    } on StateError {
      return const AndroidSigningConfig.debug();
    }
  }
  final storeFile = RegExp(
    r'''storeFile\s*=\s*file\(\s*["']([^"']+)["']\s*\)''',
  ).firstMatch(text)?.group(1);
  if (storeFile == null) return const AndroidSigningConfig.debug();
  String? quoted(String key) => RegExp(
    '''${RegExp.escape(key)}\\s*=\\s*["']([^"']*)["']''',
  ).firstMatch(text)?.group(1);
  return AndroidSigningConfig(
    storeFile: storeFile,
    storePassword: quoted('storePassword') ?? '',
    keyAlias: quoted('keyAlias') ?? '',
    keyPassword: quoted('keyPassword') ?? '',
  );
}

bool? _androidCleartext(XmlDocument? manifest) {
  final value = manifest?.rootElement
      .getElement('application')
      ?.getAttribute('android:usesCleartextTraffic');
  if (value == null) return null;
  if (value == 'true') return true;
  if (value == 'false') return false;
  return null;
}

Set<AndroidPermission> _androidPermissions(XmlDocument? manifest) {
  if (manifest == null) return const {};
  final byValue = {
    for (final permission in AndroidPermission.values)
      permission.value: permission,
  };
  return {
    for (final element in manifest.findAllElements('uses-permission'))
      if (byValue[element.getAttribute('android:name')] case final permission?)
        permission,
  };
}

List<AndroidIntent> _androidIntentQueries(XmlDocument? manifest) {
  if (manifest == null) return const [];
  final queries = manifest.rootElement.getElement('queries');
  if (queries == null) return const [];
  return [
    for (final element in queries.childElements)
      if (element.name.local == 'intent')
        if (_intentFromElement(element) case final intent?
            when !_isProcessTextIntent(intent))
          intent,
  ];
}

List<AndroidIntentFilter> _androidIntentFilters(XmlDocument? manifest) {
  if (manifest == null) return const [];
  final application = manifest.rootElement.getElement('application');
  if (application == null) return const [];
  final filters = <AndroidIntentFilter>[];
  for (final activity in application.childElements) {
    if (activity.name.local != 'activity' &&
        activity.name.local != 'activity-alias') {
      continue;
    }
    final name = activity.getAttribute('android:name');
    for (final child in activity.childElements) {
      if (child.name.local != 'intent-filter') continue;
      final intent = _intentFromElement(child);
      if (intent == null || _isLauncherIntent(intent)) continue;
      filters.add(
        AndroidIntentFilter(
          activity: name,
          autoVerify: child.getAttribute('android:autoVerify') == 'true',
          action: intent.action,
          categories: intent.categories,
          data: intent.data,
        ),
      );
    }
  }
  return filters;
}

AndroidIntent? _intentFromElement(XmlElement element) {
  String? action;
  final categories = <String>{};
  final data = <AndroidIntentData>[];
  for (final child in element.childElements) {
    switch (child.name.local) {
      case 'action':
        action = child.getAttribute('android:name') ?? action;
      case 'category':
        final category = child.getAttribute('android:name');
        if (category != null) categories.add(category);
      case 'data':
        data.add(
          AndroidIntentData(
            scheme: child.getAttribute('android:scheme'),
            host: child.getAttribute('android:host'),
            port: child.getAttribute('android:port'),
            path: child.getAttribute('android:path'),
            pathPrefix: child.getAttribute('android:pathPrefix'),
            pathPattern: child.getAttribute('android:pathPattern'),
            pathAdvancedPattern: child.getAttribute(
              'android:pathAdvancedPattern',
            ),
            ssp: child.getAttribute('android:ssp'),
            sspPrefix: child.getAttribute('android:sspPrefix'),
            sspPattern: child.getAttribute('android:sspPattern'),
            sspAdvancedPattern: child.getAttribute(
              'android:sspAdvancedPattern',
            ),
            mimeType: child.getAttribute('android:mimeType'),
          ),
        );
    }
  }
  if (action == null && categories.isEmpty && data.isEmpty) return null;
  return AndroidIntent(action: action, categories: categories, data: data);
}

bool _isProcessTextIntent(AndroidIntent intent) =>
    intent.action == 'android.intent.action.PROCESS_TEXT';

bool _isLauncherIntent(AndroidIntent intent) =>
    intent.action == 'android.intent.action.MAIN' &&
    intent.categories.contains('android.intent.category.LAUNCHER');

IosVersion _iosDeploymentTarget(Directory projectDir) {
  final podfile = File('${projectDir.path}/ios/Podfile');
  if (podfile.existsSync()) {
    final match = RegExp(
      r"platform :ios, '([0-9]+)(?:\.([0-9]+))?'",
    ).firstMatch(podfile.readAsStringSync());
    if (match != null) {
      return IosVersion(
        int.parse(match.group(1)!),
        int.tryParse(match.group(2) ?? '') ?? 0,
      );
    }
  }
  final pbx = File('${projectDir.path}/ios/Runner.xcodeproj/project.pbxproj');
  if (pbx.existsSync()) {
    final match = RegExp(
      r'IPHONEOS_DEPLOYMENT_TARGET\s*=\s*([0-9]+)(?:\.([0-9]+))?;',
    ).firstMatch(pbx.readAsStringSync());
    if (match != null) {
      return IosVersion(
        int.parse(match.group(1)!),
        int.tryParse(match.group(2) ?? '') ?? 0,
      );
    }
  }
  return const IosVersion(16, 1);
}

bool _iosSupportsIpad(Directory projectDir) {
  final pbx = File('${projectDir.path}/ios/Runner.xcodeproj/project.pbxproj');
  if (!pbx.existsSync()) return true;
  final match = RegExp(
    r'TARGETED_DEVICE_FAMILY\s*=\s*"?([^";]+)"?;',
  ).firstMatch(pbx.readAsStringSync());
  if (match == null) return true;
  return match.group(1)!.contains('2');
}

Set<IosOrientation>? _iosOrientations(XmlElement? dict) {
  final names = _plistArrayStrings(dict, 'UISupportedInterfaceOrientations');
  if (names.isEmpty) return null;
  final orientations = <IosOrientation>{};
  for (final name in names) {
    final orientation = switch (name) {
      'UIInterfaceOrientationPortrait' => IosOrientation.portrait,
      'UIInterfaceOrientationPortraitUpsideDown' =>
        IosOrientation.portraitUpsideDown,
      'UIInterfaceOrientationLandscapeLeft' => IosOrientation.landscapeLeft,
      'UIInterfaceOrientationLandscapeRight' => IosOrientation.landscapeRight,
      _ => null,
    };
    if (orientation != null) orientations.add(orientation);
  }
  return orientations.isEmpty ? null : orientations;
}

Set<String> _iosUrlSchemes(XmlElement? dict) {
  if (dict == null) return const {};
  final schemes = <String>{};
  final types = _plistValue(dict, 'CFBundleURLTypes');
  if (types == null || types.name.local != 'array') return const {};
  for (final type in types.childElements) {
    if (type.name.local != 'dict') continue;
    for (final scheme in _plistArrayStrings(type, 'CFBundleURLSchemes')) {
      if (scheme != 'dartnativego') schemes.add(scheme);
    }
  }
  return schemes;
}

XmlElement? _iosEntitlementsDict(Directory projectDir) {
  final file = File('${projectDir.path}/ios/Runner/Runner.entitlements');
  if (!file.existsSync()) return null;
  try {
    return XmlDocument.parse(
      file.readAsStringSync(),
    ).rootElement.getElement('dict');
  } on XmlException {
    return null;
  }
}

XmlElement? _plistValue(XmlElement? dict, String key) {
  if (dict == null) return null;
  final children = dict.children.whereType<XmlElement>().toList();
  for (var i = 0; i + 1 < children.length; i++) {
    if (children[i].name.local == 'key' &&
        children[i].innerText.trim() == key) {
      return children[i + 1];
    }
  }
  return null;
}

Set<String> _plistArrayStrings(XmlElement? dict, String key) {
  final value = _plistValue(dict, key);
  if (value == null) return const {};
  if (value.name.local == 'string') {
    final text = value.innerText.trim();
    return text.isEmpty ? const {} : {text};
  }
  if (value.name.local != 'array') return const {};
  return {
    for (final child in value.childElements)
      if (child.name.local == 'string' && child.innerText.trim().isNotEmpty)
        child.innerText.trim(),
  };
}

bool? _plistBool(XmlElement? dict, String key) {
  final value = _plistValue(dict, key);
  if (value == null) return null;
  if (value.name.local == 'true') return true;
  if (value.name.local == 'false') return false;
  return null;
}

String? _usableName(String? value) {
  final name = value?.trim();
  if (name == null || name.isEmpty) return null;
  if (name.contains(r'$(') || name.contains(r'${')) return null;
  return name;
}

String? _nonEmpty(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

String _fallbackPackageName(Directory projectDir) {
  final name = projectDir.absolute.path
      .replaceAll('\\', '/')
      .split('/')
      .where((part) => part.isNotEmpty)
      .last;
  return _slug(name);
}

String _slug(String value) {
  final slug = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return slug.isEmpty ? 'app' : slug;
}

String _titleCase(String value) => value
    .split(RegExp(r'[_\-\s]+'))
    .where((word) => word.isNotEmpty)
    .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');
