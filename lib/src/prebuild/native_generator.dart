import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import 'config.dart';
import 'plugin_discovery.dart';
import 'xml_text_editor.dart';

class DngoNativeGenerator {
  final Directory projectDir;
  final Set<String> _managedIosUrlSchemes = {};
  DngoNativeGenerator(this.projectDir);

  /// Makes sure `android/` and `ios/` exist.
  ///
  /// By default existing projects are kept and later syncs patch them in
  /// place, so manual native edits survive a prebuild. Pass [clean] to delete
  /// both folders first and recreate them from the `dn create` template.
  Future<void> ensureNativeProject({bool clean = false}) async {
    if (clean) removeNativeProjectDirs(projectDir);
    final hasAndroid =
        File('${projectDir.path}/android/app/build.gradle.kts').existsSync() &&
        File(
          '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
        ).existsSync();
    final hasIos =
        File('${projectDir.path}/ios/Podfile').existsSync() &&
        File('${projectDir.path}/ios/Runner/Info.plist').existsSync() &&
        Directory('${projectDir.path}/ios/Runner.xcodeproj').existsSync();
    final missing = <String>[];
    if (!hasAndroid) missing.add('android');
    if (!hasIos) missing.add('ios');
    if (missing.isEmpty) return;
    final args = ['create', '.', '--no-pub'];
    for (final platform in missing) {
      args.addAll(['--platforms', platform]);
    }
    final result = await Process.run(
      'dn',
      args,
      workingDirectory: projectDir.path,
    );
    if (result.exitCode != 0) {
      throw ProcessException(
        'dn',
        args,
        result.stderr.toString(),
        result.exitCode,
      );
    }
    if (missing.contains('ios')) {
      final pubResult = await Process.run(
        'dn',
        ['pub', 'get'],
        workingDirectory: projectDir.path,
      );
      if (pubResult.exitCode != 0) {
        throw ProcessException(
          'dn',
          ['pub', 'get'],
          pubResult.stderr.toString(),
          pubResult.exitCode,
        );
      }
    }
    final stillMissing = <String>[];
    if (!File('${projectDir.path}/ios/Podfile').existsSync() &&
        missing.contains('ios')) {
      stillMissing.add('ios/Podfile');
    }
    if (!File('${projectDir.path}/android/app/build.gradle.kts').existsSync() &&
        missing.contains('android')) {
      stillMissing.add('android/app/build.gradle.kts');
    }
    if (stillMissing.isNotEmpty) {
      throw StateError(
        'dn create did not generate required native files: ${stillMissing.join(', ')}',
      );
    }
  }

  Future<void> generate(DngoConfig config) async {
    config = applyDngoPluginDefaults(
      config,
      discovered: discoverPluginBuildConfigs(projectDir),
    );
    _managedIosUrlSchemes
      ..clear()
      ..addAll(_previousStringList('iosManagedUrlSchemes'));
    _generateAndroid(config);
    _generateIos(config);
    await _writeAdaptiveStudioConfig(config);
    _writeManifest(config);
  }

  void _generateAndroid(DngoConfig config) {
    final gradle = File('${projectDir.path}/android/app/build.gradle.kts');
    if (gradle.existsSync()) {
      var text = gradle.readAsStringSync();
      text = text.replaceFirst(
        RegExp(r'applicationId\s*=\s*"[^"]*"'),
        'applicationId = "${config.androidApplicationId}"',
      );
      if (config.platforms.android.versionName != null) {
        text = text.replaceFirst(
          RegExp(r'versionName\s*=\s*[^\n]+'),
          'versionName = "${config.platforms.android.versionName}"',
        );
      }
      if (config.platforms.android.minSdk != null) {
        text = text.replaceFirst(
          RegExp(r'minSdk\s*=\s*[^\n]+'),
          'minSdk = ${config.platforms.android.minSdk}',
        );
      }
      if (config.platforms.android.targetSdk != null) {
        text = text.replaceFirst(
          RegExp(r'targetSdk\s*=\s*[^\n]+'),
          'targetSdk = ${config.platforms.android.targetSdk}',
        );
      }
      if (config.platforms.android.compileSdk != null) {
        text = text.replaceFirst(
          RegExp(r'compileSdk\s*=\s*[^\n]+'),
          'compileSdk = ${config.platforms.android.compileSdk}',
        );
      }
      if (config.platforms.android.ndkVersion != null) {
        text = text.replaceFirst(
          RegExp(r'ndkVersion\s*=\s*[^\n]+'),
          'ndkVersion = "${config.platforms.android.ndkVersion}"',
        );
      }
      if (config.platforms.android.versionCode != null) {
        text = text.replaceFirst(
          RegExp(r'versionCode\s*=\s*[^\n]+'),
          'versionCode = ${config.platforms.android.versionCode}',
        );
      }
      final signing = config.platforms.android.signing;
      if (signing != null && !signing.isDebug) {
        final propertyPath = signing.propertyPath;
        if (propertyPath != null &&
            !text.contains('val keystoreProperties = Properties()')) {
          final gradlePropertyPath = _gradlePropertyPath(propertyPath);
          text =
              '''import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("$gradlePropertyPath")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

$text''';
        }
        final signingBlock = propertyPath != null
            ? '''    signingConfigs {
        create("release") {
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

'''
            : '''    signingConfigs {
        create("release") {
            storeFile = file("${signing.storeFile ?? ''}")
            storePassword = "${signing.storePassword ?? ''}"
            keyAlias = "${signing.keyAlias ?? ''}"
            keyPassword = "${signing.keyPassword ?? ''}"
        }
    }

''';
        final signingPattern = RegExp(
          r'    signingConfigs \{.*?(?=    buildTypes \{)',
          dotAll: true,
        );
        text = signingPattern.hasMatch(text)
            ? text.replaceFirst(signingPattern, signingBlock)
            : text.replaceFirst(
                '    buildTypes {',
                '$signingBlock    buildTypes {',
              );
        text = text.replaceFirst(
          'signingConfig = signingConfigs.getByName("debug")',
          'signingConfig = signingConfigs.getByName("release")',
        );
      }
      gradle.writeAsStringSync(text);
    }

    final manifest = File(
      '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
    );
    if (manifest.existsSync()) {
      manifest.writeAsStringSync(
        _updateAndroidManifest(manifest.readAsStringSync(), config),
      );
    }
  }

  String _gradlePropertyPath(String propertyPath) {
    const androidPrefix = 'android/';
    if (propertyPath.startsWith(androidPrefix)) {
      return propertyPath.substring(androidPrefix.length);
    }
    return propertyPath;
  }

  String _updateAndroidManifest(String source, DngoConfig config) {
    final document = XmlDocument.parse(source);
    final editor = XmlTextEditor(source);

    if (!editor.has('application')) {
      editor.appendChild(
        'manifest',
        '<application android:label="${_escapeXml(config.name)}"></application>',
      );
    }
    editor.setAttribute('application', 'android:label', config.name);
    final cleartext = config.platforms.android.usesCleartextTraffic;
    if (cleartext != null) {
      editor.setAttribute(
        'application',
        'android:usesCleartextTraffic',
        '$cleartext',
      );
    }

    final managedPermissions = {
      ...config.managedAndroidPermissionKeys,
      ..._previousConfiguredAndroidPermissions(),
      ..._previousAndroidPermissions(),
    };
    for (final permission in managedPermissions.difference(
      config.androidPermissions,
    )) {
      editor.remove(
        'uses-permission',
        where: (element) =>
            editor.attribute(element, 'android:name') == permission,
      );
    }
    for (final permission in config.androidPermissions) {
      final exists = editor.has(
        'uses-permission',
        where: (element) =>
            editor.attribute(element, 'android:name') == permission,
      );
      if (!exists) {
        editor.prependChild(
          'manifest',
          '<uses-permission android:name="${_escapeXml(permission)}"/>',
        );
      }
    }

    _updateAndroidIntentQueries(editor, config);
    _updateAndroidIntentFilters(editor, document.rootElement, config);
    return editor.text;
  }

  /// Synchronises the `<queries>` element with [AndroidConfig.intentQueries].
  ///
  /// Only intents written by a previous prebuild are removed, so intents (and
  /// other query entries) added by hand or by another tool survive.
  void _updateAndroidIntentQueries(XmlTextEditor editor, DngoConfig config) {
    final current = config.platforms.android.intentQueries;
    final currentSignatures = {
      for (final intent in current) _intentSignature(intent),
    };
    final previousSignatures = _previousAndroidIntentQueries();

    while (true) {
      final queries = editor.find('queries');
      if (queries == null) break;
      XmlTextElement? stale;
      for (final intent in editor.findAll('intent', within: queries)) {
        final element = _parseElement(editor, intent);
        if (element == null) continue;
        final signature = _intentElementSignature(element);
        if (previousSignatures.contains(signature) &&
            !currentSignatures.contains(signature)) {
          stale = intent;
          break;
        }
      }
      if (stale == null) break;
      editor.remove(
        'intent',
        where: (element) =>
            element.start == stale!.start && element.end == stale.end,
      );
    }

    final existing = <String>{};
    final queries = editor.find('queries');
    if (queries != null) {
      for (final intent in editor.findAll('intent', within: queries)) {
        final element = _parseElement(editor, intent);
        if (element != null) {
          existing.add(_intentElementSignature(element));
        }
      }
    }
    final missing = [
      for (final intent in current)
        if (!existing.contains(_intentSignature(intent))) intent,
    ];
    if (missing.isNotEmpty) {
      if (queries == null) {
        final inner = missing
            .map((intent) => editor.render(_androidIntentElement(intent)))
            .join('\n');
        editor.appendChild('manifest', '<queries>\n$inner\n</queries>');
      } else {
        for (final intent in missing) {
          editor.appendChild(
            'queries',
            editor.render(_androidIntentElement(intent)),
          );
        }
      }
    }

    final remaining = editor.find('queries');
    if (remaining != null && !editor.hasChildElements(remaining)) {
      editor.remove(
        'queries',
        where: (element) => element.start == remaining.start,
      );
    }
  }

  Set<String> _previousAndroidIntentQueries() {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const {};
      final intents = decoded['androidIntentQueries'];
      if (intents is! List) return const {};
      return {
        for (final intent in intents.whereType<Map>())
          jsonEncode(intent.cast<String, Object?>()),
      };
    } on FormatException {
      return const {};
    }
  }

  /// Synchronises activity `<intent-filter>` elements with
  /// [AndroidConfig.intentFilters].
  ///
  /// Filters without an explicit activity name go to the launcher activity
  /// (`MAIN` + `LAUNCHER`). Only filters written by a previous prebuild are
  /// removed, so manually added filters survive.
  void _updateAndroidIntentFilters(
    XmlTextEditor editor,
    XmlElement manifest,
    DngoConfig config,
  ) {
    XmlElement? application;
    for (final child in manifest.children.whereType<XmlElement>()) {
      if (child.name.local == 'application') {
        application = child;
        break;
      }
    }
    if (application == null) return;

    final activities = application.children
        .whereType<XmlElement>()
        .where(
          (element) =>
              element.name.local == 'activity' ||
              element.name.local == 'activity-alias',
        )
        .toList();
    if (activities.isEmpty) return;

    final current = <(String, AndroidIntentFilter)>[];
    for (final filter in config.platforms.android.intentFilters) {
      final activity = _resolveActivityName(activities, filter.activity);
      if (activity == null) continue;
      current.add((activity, filter));
    }
    final currentSignatures = {
      for (final (activity, filter) in current)
        _filterSignature(activity, filter),
    };

    final previous = <String>{};
    for (final filter in _previousAndroidIntentFilters()) {
      final activity = _resolveActivityName(
        activities,
        filter['activity'] is String ? filter['activity'] as String : null,
      );
      if (activity == null) continue;
      previous.add(_previousFilterSignature(filter, activity));
    }

    for (final activity in activities) {
      final name = activity.getAttribute('android:name');
      if (name == null) continue;
      while (true) {
        final target = _findEditorActivity(editor, name);
        if (target == null) break;
        XmlTextElement? stale;
        for (final filter in editor.findAll('intent-filter', within: target)) {
          final element = _parseElement(editor, filter);
          if (element == null) continue;
          final signature = _filterElementSignature(name, element);
          if (previous.contains(signature) &&
              !currentSignatures.contains(signature)) {
            stale = filter;
            break;
          }
        }
        if (stale == null) break;
        editor.remove(
          'intent-filter',
          where: (element) =>
              element.start == stale!.start && element.end == stale.end,
        );
      }
    }

    for (final (activityName, filter) in current) {
      final target = _findEditorActivity(editor, activityName);
      if (target == null) continue;
      final signature = _filterSignature(activityName, filter);
      final exists = editor
          .findAll('intent-filter', within: target)
          .map((element) => _parseElement(editor, element))
          .whereType<XmlElement>()
          .any(
            (element) =>
                _filterElementSignature(activityName, element) == signature,
          );
      if (exists) continue;
      editor.appendChild(
        'activity',
        editor.render(_androidIntentFilterElement(filter)),
        where: (element) =>
            editor.attribute(element, 'android:name') == activityName,
      );
    }
  }

  XmlTextElement? _findEditorActivity(XmlTextEditor editor, String name) =>
      editor.find(
        'activity',
        where: (element) => editor.attribute(element, 'android:name') == name,
      ) ??
      editor.find(
        'activity-alias',
        where: (element) => editor.attribute(element, 'android:name') == name,
      );

  XmlElement? _parseElement(XmlTextEditor editor, XmlTextElement element) {
    try {
      return XmlDocument.parse(
        editor.text.substring(element.start, element.end),
      ).rootElement;
    } on XmlException {
      return null;
    }
  }

  String _escapeXml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  List<Map<String, Object?>> _previousAndroidIntentFilters() {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const [];
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const [];
      final filters = decoded['androidIntentFilters'];
      if (filters is! List) return const [];
      return [
        for (final filter in filters.whereType<Map>())
          filter.cast<String, Object?>(),
      ];
    } on FormatException {
      return const [];
    }
  }

  String? _resolveActivityName(
    List<XmlElement> activities,
    String? requested,
  ) {
    if (requested == null) {
      final launcher = _launcherActivity(activities) ?? activities.first;
      return launcher.getAttribute('android:name');
    }
    for (final activity in activities) {
      final name = activity.getAttribute('android:name');
      if (name == requested ||
          name == '.$requested' ||
          (name?.endsWith('.$requested') ?? false)) {
        return name;
      }
    }
    return null;
  }

  XmlElement? _launcherActivity(List<XmlElement> activities) {
    for (final activity in activities) {
      for (final filter in activity.children.whereType<XmlElement>()) {
        if (filter.name.local != 'intent-filter') continue;
        final hasMain = filter.children.whereType<XmlElement>().any(
          (child) =>
              child.name.local == 'action' &&
              child.getAttribute('android:name') ==
                  'android.intent.action.MAIN',
        );
        final hasLauncher = filter.children.whereType<XmlElement>().any(
          (child) =>
              child.name.local == 'category' &&
              child.getAttribute('android:name') ==
                  'android.intent.category.LAUNCHER',
        );
        if (hasMain && hasLauncher) return activity;
      }
    }
    return null;
  }

  String _filterSignature(String activity, AndroidIntentFilter filter) =>
      jsonEncode({
        'activity': activity,
        'autoVerify': filter.autoVerify,
        'action': ?filter.action,
        if (filter.categories.isNotEmpty)
          'categories': filter.categories.toList()..sort(),
        if (filter.data.isNotEmpty)
          'data': [for (final item in filter.data) item.toJson()],
      });

  String _previousFilterSignature(
    Map<String, Object?> filter,
    String activity,
  ) => jsonEncode({
    'activity': activity,
    'autoVerify': filter['autoVerify'] == true,
    'action': ?(filter['action'] as String?),
    if ((filter['categories'] as List?)?.isNotEmpty ?? false)
      'categories': [for (final value in filter['categories'] as List) '$value']
        ..sort(),
    if ((filter['data'] as List?)?.isNotEmpty ?? false)
      'data': [
        for (final value in filter['data'] as List)
          (value as Map).cast<String, Object?>(),
      ],
  });

  String _filterElementSignature(String activity, XmlElement filter) {
    String? action;
    final categories = <String>[];
    final data = <Map<String, Object?>>[];
    for (final child in filter.children.whereType<XmlElement>()) {
      final name = child.name.local;
      if (name == 'action') {
        action = child.getAttribute('android:name');
      } else if (name == 'category') {
        final category = child.getAttribute('android:name');
        if (category != null) categories.add(category);
      } else if (name == 'data') {
        data.add(_intentDataFromElement(child));
      }
    }
    return jsonEncode({
      'activity': activity,
      'autoVerify': filter.getAttribute('android:autoVerify') == 'true',
      'action': ?action,
      if (categories.isNotEmpty) 'categories': categories..sort(),
      if (data.isNotEmpty) 'data': data,
    });
  }

  String _intentSignature(AndroidIntent intent) => jsonEncode(intent.toJson());

  String _intentElementSignature(XmlElement intent) {
    String? action;
    final categories = <String>[];
    final data = <Map<String, Object?>>[];
    for (final child in intent.children.whereType<XmlElement>()) {
      final name = child.name.local;
      if (name == 'action') {
        action = child.getAttribute('android:name');
      } else if (name == 'category') {
        final category = child.getAttribute('android:name');
        if (category != null) categories.add(category);
      } else if (name == 'data') {
        data.add(_intentDataFromElement(child));
      }
    }
    return jsonEncode({
      'action': ?action,
      if (categories.isNotEmpty) 'categories': categories..sort(),
      if (data.isNotEmpty) 'data': data,
    });
  }

  Map<String, Object?> _intentDataFromElement(XmlElement element) => {
    for (final key in const [
      'scheme',
      'host',
      'port',
      'path',
      'pathPrefix',
      'pathPattern',
      'pathAdvancedPattern',
      'ssp',
      'sspPrefix',
      'sspPattern',
      'sspAdvancedPattern',
      'mimeType',
    ])
      if (element.getAttribute('android:$key') != null)
        key: element.getAttribute('android:$key'),
  };

  XmlElement _androidIntentElement(AndroidIntent intent) {
    final element = XmlElement(XmlName('intent'));
    _addIntentChildren(element, intent);
    return element;
  }

  XmlElement _androidIntentFilterElement(AndroidIntentFilter filter) {
    final element = XmlElement(XmlName('intent-filter'));
    if (filter.autoVerify) {
      element.setAttribute('android:autoVerify', 'true');
    }
    _addIntentChildren(element, filter);
    return element;
  }

  void _addIntentChildren(XmlElement element, AndroidIntent intent) {
    if (intent.action != null) {
      element.children.add(
        XmlElement(
          XmlName('action'),
          [XmlAttribute(XmlName('android:name'), intent.action!)],
        ),
      );
    }
    for (final category in intent.categories) {
      element.children.add(
        XmlElement(
          XmlName('category'),
          [XmlAttribute(XmlName('android:name'), category)],
        ),
      );
    }
    for (final item in intent.data) {
      element.children.add(
        XmlElement(
          XmlName('data'),
          [
            for (final entry in item.toJson().entries)
              XmlAttribute(
                XmlName('android:${entry.key}'),
                '${entry.value}',
              ),
          ],
        ),
      );
    }
  }

  /// Returns the app-level permissions written by the previous prebuild, so a
  /// permission removed from `AndroidConfig.permissions` is also removed from
  /// the manifest.
  Set<String> _previousConfiguredAndroidPermissions() {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const {};
      final permissions = decoded['configuredAndroidPermissions'];
      if (permissions is! List) return const {};
      return permissions.whereType<String>().toSet();
    } on FormatException {
      return const {};
    }
  }

  Set<String> _previousAndroidPermissions() {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const {};
      final permissions = decoded['androidPermissions'];
      if (permissions is! List) return const {};
      return permissions.whereType<String>().toSet();
    } on FormatException {
      return const {};
    }
  }

  Set<String> _previousIosPermissionKeys() {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const {};
      final permissions = decoded['iosPermissions'];
      if (permissions is! Map) return const {};
      return permissions.keys.whereType<String>().toSet();
    } on FormatException {
      return const {};
    }
  }

  void _generateIos(DngoConfig config) {
    final podfile = File('${projectDir.path}/ios/Podfile');
    if (podfile.existsSync()) {
      var text = podfile.readAsStringSync();
      text = text.replaceFirst(
        RegExp(r"platform :ios, '[^']+'"),
        "platform :ios, '${config.iosDeploymentTarget}.0'",
      );
      podfile.writeAsStringSync(text);
    }
    _generateIosProjectSettings(config);
    final plist = File('${projectDir.path}/ios/Runner/Info.plist');
    if (plist.existsSync()) {
      plist.writeAsStringSync(
        _updateInfoPlist(plist.readAsStringSync(), config),
      );
    }
    _updateIosEntitlements(config);
  }

  void _generateIosProjectSettings(DngoConfig config) {
    final iosRoot = Directory('${projectDir.path}/ios');
    if (!iosRoot.existsSync()) return;
    for (final entity in iosRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.pbxproj')) continue;
      var text = entity.readAsStringSync();
      text = text.replaceAll(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*[^;]+;'),
        'PRODUCT_BUNDLE_IDENTIFIER = ${config.iosBundleId};',
      );
      text = text.replaceAll(
        RegExp(r'IPHONEOS_DEPLOYMENT_TARGET\s*=\s*[^;]+;'),
        'IPHONEOS_DEPLOYMENT_TARGET = ${config.iosDeploymentTarget}.0;',
      );
      text = text.replaceAll(
        RegExp(r'TARGETED_DEVICE_FAMILY\s*=\s*[^;]+;'),
        'TARGETED_DEVICE_FAMILY = "${config.platforms.ios.supportsIpad ? '1,2' : '1'}";',
      );
      entity.writeAsStringSync(text);
    }
  }

  String _updateInfoPlist(String source, DngoConfig config) {
    final document = XmlDocument.parse(source);
    final dict = document.rootElement.getElement('dict');
    if (dict == null) return source;
    _setPlistValue(dict, 'CFBundleDisplayName', config.name);
    _setPlistValue(dict, 'CFBundleShortVersionString', config.versionName);
    _setPlistArray(
      dict,
      'UISupportedInterfaceOrientations',
      config.platforms.ios.supportedOrientations
          .map(_iosOrientationName)
          .toList(),
    );
    if (config.platforms.ios.supportsIpad) {
      _setPlistArray(
        dict,
        'UISupportedInterfaceOrientations~ipad',
        config.platforms.ios.supportedOrientations
            .map(_iosOrientationName)
            .toList(),
      );
    } else {
      _removePlistValue(dict, 'UISupportedInterfaceOrientations~ipad');
    }
    final querySchemes = config.platforms.ios.querySchemes;
    if (querySchemes.isEmpty) {
      _removePlistValue(dict, 'LSApplicationQueriesSchemes');
    } else {
      _setPlistArray(
        dict,
        'LSApplicationQueriesSchemes',
        querySchemes.toList()..sort(),
      );
    }
    _updateIosUrlTypes(dict, config);
    final iosPermissionKeys = {
      ...config.managedIosPermissionKeys,
      ..._previousIosPermissionKeys(),
    };
    for (final key in iosPermissionKeys) {
      final value = config.iosPermissions[key];
      if (value == null) {
        _removePlistValue(dict, key);
      } else {
        _setPlistValue(dict, key, value);
      }
    }
    return document.toXmlString(pretty: true, indent: '\t');
  }

  String _iosOrientationName(IosOrientation orientation) =>
      switch (orientation) {
        IosOrientation.portrait => 'UIInterfaceOrientationPortrait',
        IosOrientation.portraitUpsideDown =>
          'UIInterfaceOrientationPortraitUpsideDown',
        IosOrientation.landscapeLeft => 'UIInterfaceOrientationLandscapeLeft',
        IosOrientation.landscapeRight => 'UIInterfaceOrientationLandscapeRight',
      };

  /// Merges [IosConfig.urlSchemes] into the managed `CFBundleURLTypes` entry.
  ///
  /// Schemes added by a previous prebuild are removed when they disappear from
  /// config; schemes already present in the plist (for example the scaffold's
  /// `dartnativego`) are preserved.
  void _updateIosUrlTypes(XmlElement dict, DngoConfig config) {
    final current = config.platforms.ios.urlSchemes;
    final previous = _previousStringList('iosManagedUrlSchemes');
    if (current.isEmpty && previous.isEmpty) return;

    final keyElement = _findPlistKey(dict, 'CFBundleURLTypes');
    XmlElement? urlTypes;
    if (keyElement != null) {
      final value = _nextElement(dict, keyElement);
      if (value != null && value.name.local == 'array') urlTypes = value;
    }
    if (urlTypes == null) {
      if (current.isEmpty) return;
      _removePlistValue(dict, 'CFBundleURLTypes');
      urlTypes = XmlElement(XmlName('array'));
      dict.children.addAll([
        XmlElement(XmlName('key'))..children.add(XmlText('CFBundleURLTypes')),
        urlTypes,
      ]);
    }

    XmlElement? managed;
    for (final child in urlTypes.children.whereType<XmlElement>()) {
      if (child.name.local != 'dict') continue;
      final nameKey = _findPlistKey(child, 'CFBundleURLName');
      if (nameKey == null) continue;
      final name = _nextElement(child, nameKey)?.innerText;
      if (name == config.iosBundleId ||
          name == r'$(PRODUCT_BUNDLE_IDENTIFIER)') {
        managed = child;
        break;
      }
    }
    if (managed == null) {
      if (current.isEmpty) return;
      managed = XmlElement(XmlName('dict'));
      managed.children.addAll([
        XmlElement(XmlName('key'))..children.add(XmlText('CFBundleURLName')),
        XmlElement(XmlName('string'))
          ..children.add(XmlText(r'$(PRODUCT_BUNDLE_IDENTIFIER)')),
        XmlElement(XmlName('key'))..children.add(XmlText('CFBundleTypeRole')),
        XmlElement(XmlName('string'))..children.add(XmlText('Editor')),
      ]);
      urlTypes.children.add(managed);
    }

    final schemesKey = _findPlistKey(managed, 'CFBundleURLSchemes');
    XmlElement? schemes;
    if (schemesKey != null) {
      final value = _nextElement(managed, schemesKey);
      if (value != null && value.name.local == 'array') schemes = value;
    }
    if (schemes == null) {
      schemes = XmlElement(XmlName('array'));
      managed.children.addAll([
        XmlElement(XmlName('key'))..children.add(XmlText('CFBundleURLSchemes')),
        schemes,
      ]);
    }

    final existing = {
      for (final child in schemes.children.whereType<XmlElement>())
        if (child.name.local == 'string') child.innerText,
    };
    final added = current.difference(existing);
    final next = {
      for (final scheme in existing)
        if (!previous.contains(scheme) || current.contains(scheme)) scheme,
      ...current,
    };

    if (next.isEmpty) {
      urlTypes.children.remove(managed);
    } else {
      _setPlistArray(managed, 'CFBundleURLSchemes', next.toList()..sort());
    }
    if (urlTypes.children.whereType<XmlElement>().isEmpty) {
      _removePlistValue(dict, 'CFBundleURLTypes');
    }
    _managedIosUrlSchemes
      ..clear()
      ..addAll(previous.intersection(current))
      ..addAll(added);
  }

  /// Writes [IosConfig.associatedDomains] to `Runner.entitlements`.
  void _updateIosEntitlements(DngoConfig config) {
    final current = config.platforms.ios.associatedDomains;
    final previous = _previousStringList('iosAssociatedDomains');
    if (current.isEmpty && previous.isEmpty) return;

    final file = File('${projectDir.path}/ios/Runner/Runner.entitlements');
    if (!file.existsSync()) {
      if (current.isEmpty) return;
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(
          '<?xml version="1.0" encoding="UTF-8"?>\n'
          '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" '
          '"http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n'
          '<plist version="1.0">\n'
          '<dict/>\n'
          '</plist>\n',
        );
    }
    final document = XmlDocument.parse(file.readAsStringSync());
    final dict = document.rootElement.getElement('dict');
    if (dict == null) return;
    if (current.isEmpty) {
      _removePlistValue(dict, 'com.apple.developer.associated-domains');
    } else {
      _setPlistArray(
        dict,
        'com.apple.developer.associated-domains',
        current.toList()..sort(),
      );
    }
    file.writeAsStringSync(document.toXmlString(pretty: true, indent: '\t'));
  }

  Set<String> _previousStringList(String key) {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json');
    if (!file.existsSync()) return const {};
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return const {};
      final values = decoded[key];
      if (values is! List) return const {};
      return values.whereType<String>().toSet();
    } on FormatException {
      return const {};
    }
  }

  void _setPlistArray(XmlElement dict, String key, List<String> values) {
    final keyElement = _findPlistKey(dict, key);
    if (keyElement != null) {
      final valueElement = _nextElement(dict, keyElement);
      if (valueElement != null && valueElement.name.local == 'array') {
        valueElement.children
          ..clear()
          ..addAll(
            values.map(
              (value) =>
                  XmlElement(XmlName('string'))..children.add(XmlText(value)),
            ),
          );
        return;
      }
    }
    _removePlistValue(dict, key);
    dict.children.addAll([
      XmlElement(XmlName('key'))..children.add(XmlText(key)),
      XmlElement(XmlName('array'))
        ..children.addAll(
          values.map(
            (value) =>
                XmlElement(XmlName('string'))..children.add(XmlText(value)),
          ),
        ),
    ]);
  }

  void _setPlistValue(XmlElement dict, String key, String value) {
    final keyElement = _findPlistKey(dict, key);
    if (keyElement != null) {
      final valueElement = _nextElement(dict, keyElement);
      if (valueElement != null && valueElement.name.local == 'string') {
        valueElement.children
          ..clear()
          ..add(XmlText(value));
        return;
      }
    }
    dict.children.addAll([
      XmlElement(XmlName('key'))..children.add(XmlText(key)),
      XmlElement(XmlName('string'))..children.add(XmlText(value)),
    ]);
  }

  void _removePlistValue(XmlElement dict, String key) {
    final keyElement = _findPlistKey(dict, key);
    if (keyElement == null) return;
    final valueElement = _nextElement(dict, keyElement);
    dict.children.remove(keyElement);
    if (valueElement != null) dict.children.remove(valueElement);
  }

  XmlElement? _findPlistKey(XmlElement dict, String key) {
    for (final child in dict.children.whereType<XmlElement>()) {
      if (child.name.local == 'key' && child.innerText == key) return child;
    }
    return null;
  }

  XmlElement? _nextElement(XmlElement dict, XmlElement key) {
    final index = dict.children.indexOf(key);
    for (var i = index + 1; i < dict.children.length; i++) {
      final child = dict.children[i];
      if (child is XmlElement) return child;
    }
    return null;
  }

  Future<void> _writeAdaptiveStudioConfig(DngoConfig config) async {
    final androidIcon = config.androidIcon;
    final iosIcon = config.iosIcon;
    final androidSplash = config.androidSplash;
    final iosSplash = config.iosSplash;
    if (androidIcon == null &&
        iosIcon == null &&
        androidSplash == null &&
        iosSplash == null) {
      return;
    }
    final file = File(
      '${projectDir.path}/.dart_tool/dngo/flutter_adaptive_studio.yaml',
    )..createSync(recursive: true);
    file.writeAsStringSync(config.toAdaptiveStudioYaml());
    await _ensureAdaptiveStudioCli();
    removeLegacyGeneratedAssets(
      projectDir,
      androidIcon: androidIcon != null,
      androidSplash: androidSplash != null,
      iosIcon: iosIcon != null,
      iosSplash: iosSplash != null,
    );
    stdout.writeln('Generating icons and splash...');
    await _runInherited('fas', [
      'generate',
      '--project',
      projectDir.absolute.path,
      '--config',
      file.absolute.path,
    ]);
    for (final path in [
      '${projectDir.path}/lib/fas_splash.g.dart',
      '${projectDir.path}/fas_splash.g.dart',
    ]) {
      final runtimeSplash = File(path);
      if (runtimeSplash.existsSync()) runtimeSplash.deleteSync();
    }
  }

  /// `dn pub global activate` from an app directory resolves that app's
  /// pubspec and can stall or fail even when `fas` is already installed.
  Future<void> _ensureAdaptiveStudioCli() async {
    if (_hasExecutable('fas')) return;
    stdout.writeln('Activating flutter_adaptive_studio...');
    final activate = await Process.run(
      'dart',
      ['pub', 'global', 'activate', 'flutter_adaptive_studio', '^0.28.15'],
      workingDirectory: Directory.systemTemp.path,
    );
    if (activate.exitCode != 0 && !_hasExecutable('fas')) {
      throw ProcessException(
        'dart',
        ['pub', 'global', 'activate', 'flutter_adaptive_studio', '^0.28.15'],
        activate.stderr.toString(),
        activate.exitCode,
      );
    }
  }

  bool _hasExecutable(String name) {
    final result = Process.runSync(Platform.isWindows ? 'where' : 'which', [
      name,
    ]);
    return result.exitCode == 0;
  }

  Future<void> _runInherited(String executable, List<String> args) async {
    final process = await Process.start(
      executable,
      args,
      workingDirectory: projectDir.path,
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) {
      throw ProcessException(executable, args, '', code);
    }
  }

  void _writeManifest(DngoConfig config) {
    final file = File('${projectDir.path}/.dart_tool/dngo/prebuild.json')
      ..createSync(recursive: true);
    final data = config.toJson();
    data['iosManagedUrlSchemes'] = _managedIosUrlSchemes.toList()..sort();
    file.writeAsStringSync(jsonEncode(data));
  }
}

/// Deletes the generated `android/` and `ios/` projects.
///
/// Used by `dngo prebuild --clean`; the normal prebuild path keeps the folders
/// and patches them in place so manual native changes are not lost.
void removeNativeProjectDirs(Directory projectDir) {
  for (final name in const ['android', 'ios']) {
    final dir = Directory('${projectDir.path}/$name');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }
}

/// Removes icon and splash assets written by the superseded asset generators so
/// the new `fas` output never sits beside a stale duplicate.
///
/// Each family is only cleared when that family is about to be regenerated:
/// deleting an icon while no icon is configured would leave the app without one.
void removeLegacyGeneratedAssets(
  Directory projectDir, {
  required bool androidIcon,
  required bool androidSplash,
  required bool iosIcon,
  required bool iosSplash,
}) {
  final androidRes = Directory(
    '${projectDir.path}/android/app/src/main/res',
  );
  if (androidRes.existsSync()) {
    if (androidIcon) _removeLegacyAndroidIcon(androidRes);
    if (androidSplash) _removeLegacyAndroidSplash(androidRes);
  }
  final xcassets = Directory(
    '${projectDir.path}/ios/Runner/Assets.xcassets',
  );
  if (xcassets.existsSync()) {
    if (iosIcon) _removeLegacyIosIcon(xcassets);
    if (iosSplash) _removeLegacyIosSplash(xcassets);
  }
}

/// The old generators wrote `ic_launcher` rasters/XML into `mipmap-*`, some
/// adaptive layers into `mipmap-*`, and a `values/ic_launcher_background.xml`
/// colour. `fas` writes its own set (and may use a custom icon name), so every
/// old `ic_launcher*` file goes before regeneration.
void _removeLegacyAndroidIcon(Directory res) {
  for (final dir in res.listSync().whereType<Directory>()) {
    final folder = _baseName(dir.path);
    if (!folder.startsWith('mipmap-') && !folder.startsWith('drawable')) {
      continue;
    }
    for (final file in dir.listSync().whereType<File>()) {
      if (_baseName(file.path).startsWith('ic_launcher')) file.deleteSync();
    }
  }
  final background = File('${res.path}/values/ic_launcher_background.xml');
  if (background.existsSync()) background.deleteSync();
}

/// `dartnative_splash` used `splash.png` (pre-31) and `android12splash.png`
/// (API 31+). `fas` owns its own `splash_icon*` names and rewrites the styles,
/// so keeping these would leave two launch logos in the APK.
void _removeLegacyAndroidSplash(Directory res) {
  const legacyNames = {'splash.png', 'android12splash.png'};
  for (final dir in res.listSync().whereType<Directory>()) {
    if (!_baseName(dir.path).startsWith('drawable')) continue;
    for (final file in dir.listSync().whereType<File>()) {
      if (legacyNames.contains(_baseName(file.path))) file.deleteSync();
    }
  }
}

/// The old generators wrote a single `AppIcon.png` (or an `AppIcon-*.png`
/// matrix). `fas` writes `Icon-1024*.png` and rewrites `Contents.json`, so any
/// other PNG left behind is an unreferenced duplicate.
void _removeLegacyIosIcon(Directory xcassets) {
  final dir = Directory('${xcassets.path}/AppIcon.appiconset');
  if (!dir.existsSync()) return;
  for (final file in dir.listSync().whereType<File>()) {
    if (_baseName(file.path).toLowerCase().endsWith('.png')) {
      file.deleteSync();
    }
  }
}

/// `dartnative_splash` wrote `LaunchImage.imageset` plus a full-bleed
/// `LaunchBackground.imageset`. `fas` regenerates the launch image and owns
/// `LaunchBackground` as a colour set, so stale image sets make the catalog
/// ambiguous and can shadow the new background.
void _removeLegacyIosSplash(Directory xcassets) {
  for (final name in const [
    'LaunchImage.imageset',
    'LaunchBackground.imageset',
    'LaunchBackgroundImage.imageset',
  ]) {
    final dir = Directory('${xcassets.path}/$name');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }
}

String _baseName(String path) {
  final normalized = path.replaceAll('\\', '/');
  final trimmed = normalized.endsWith('/')
      ? normalized.substring(0, normalized.length - 1)
      : normalized;
  return trimmed.substring(trimmed.lastIndexOf('/') + 1);
}
