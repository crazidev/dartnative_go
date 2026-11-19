/// An `<intent>` entry inside the `<queries>` element of
/// `AndroidManifest.xml`.
///
/// Queries declare the apps an application intends to interact with. Android
/// 11+ hides installed packages by default, so an app must list the intents it
/// uses with `canOpenURL`-style checks (for example launching YouTube).
///
/// ```dart
/// AndroidConfig(
///   intentQueries: [
///     AndroidIntent.view(data: [AndroidIntentData.scheme('youtube')]),
///     AndroidIntent.view(
///       data: [
///         AndroidIntentData(
///           scheme: 'https',
///           host: 'youtube.com',
///           pathPrefix: '/watch',
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class AndroidIntent {
  /// Intent action such as `android.intent.action.VIEW`.
  final String? action;

  /// Intent categories such as `android.intent.category.BROWSABLE`.
  final Set<String> categories;

  /// One or more `<data>` filters. An intent with several entries matches when
  /// any of them matches.
  final List<AndroidIntentData> data;

  const AndroidIntent({
    this.action,
    this.categories = const {},
    this.data = const [],
  });

  /// Creates a `VIEW` intent, optionally restricted by [data].
  const AndroidIntent.view({
    Set<String> categories = const {},
    List<AndroidIntentData> data = const [],
  }) : this(
         action: viewAction,
         categories: categories,
         data: data,
       );

  /// `android.intent.action.VIEW`.
  static const String viewAction = 'android.intent.action.VIEW';

  /// `android.intent.category.BROWSABLE`.
  static const String browsableCategory = 'android.intent.category.BROWSABLE';

  /// `android.intent.category.DEFAULT`.
  static const String defaultCategory = 'android.intent.category.DEFAULT';

  Map<String, Object?> toJson() => {
    if (action != null) 'action': action,
    if (categories.isNotEmpty) 'categories': categories.toList()..sort(),
    if (data.isNotEmpty) 'data': [for (final item in data) item.toJson()],
  };
}

/// A `<data>` filter for an [AndroidIntent].
class AndroidIntentData {
  /// URI scheme, for example `youtube` or `https`.
  final String? scheme;

  /// URI host, for example `youtube.com`.
  final String? host;

  /// URI port.
  final String? port;

  /// Exact URI path.
  final String? path;

  /// URI path prefix.
  final String? pathPrefix;

  /// URI path pattern, using `*` and `.` wildcards.
  final String? pathPattern;

  /// URI path advanced pattern.
  final String? pathAdvancedPattern;

  /// Scheme-specific part.
  final String? ssp;

  /// Scheme-specific part prefix.
  final String? sspPrefix;

  /// Scheme-specific part pattern.
  final String? sspPattern;

  /// Scheme-specific part advanced pattern.
  final String? sspAdvancedPattern;

  /// MIME type, for example `image/*`.
  final String? mimeType;

  const AndroidIntentData({
    this.scheme,
    this.host,
    this.port,
    this.path,
    this.pathPrefix,
    this.pathPattern,
    this.pathAdvancedPattern,
    this.ssp,
    this.sspPrefix,
    this.sspPattern,
    this.sspAdvancedPattern,
    this.mimeType,
  });

  /// Matches any URI that uses [scheme], for example:
  ///
  /// ```dart
  /// const AndroidIntentData.scheme('youtube')
  /// ```
  const AndroidIntentData.scheme(String scheme) : this(scheme: scheme);

  Map<String, Object?> toJson() => {
    if (scheme != null) 'scheme': scheme,
    if (host != null) 'host': host,
    if (port != null) 'port': port,
    if (path != null) 'path': path,
    if (pathPrefix != null) 'pathPrefix': pathPrefix,
    if (pathPattern != null) 'pathPattern': pathPattern,
    if (pathAdvancedPattern != null) 'pathAdvancedPattern': pathAdvancedPattern,
    if (ssp != null) 'ssp': ssp,
    if (sspPrefix != null) 'sspPrefix': sspPrefix,
    if (sspPattern != null) 'sspPattern': sspPattern,
    if (sspAdvancedPattern != null) 'sspAdvancedPattern': sspAdvancedPattern,
    if (mimeType != null) 'mimeType': mimeType,
  };
}

/// An `<intent-filter>` attached to an activity.
///
/// Intent filters are the inbound counterpart of [AndroidIntent] queries: they
/// declare what the app itself accepts (deep links, share targets, …).
///
/// ```dart
/// AndroidConfig(
///   intentFilters: [
///     AndroidIntentFilter.deepLink(scheme: 'dngo'),
///     AndroidIntentFilter(
///       action: 'android.intent.action.SEND',
///       categories: {AndroidIntent.defaultCategory},
///       data: [AndroidIntentData(mimeType: 'text/plain')],
///     ),
///   ],
/// )
/// ```
///
/// By default the filter is added to the app's launcher activity. Set
/// [activity] to an `android:name` from the manifest to target another
/// activity.
class AndroidIntentFilter extends AndroidIntent {
  /// Manifest `android:name` of the activity that receives this filter.
  ///
  /// When omitted, the launcher activity (`MAIN` + `LAUNCHER`) is used.
  final String? activity;

  /// Sets `android:autoVerify="true"`, used for App Links over `https`.
  final bool autoVerify;

  const AndroidIntentFilter({
    this.activity,
    this.autoVerify = false,
    super.action,
    super.categories,
    super.data,
  });

  /// Creates a `VIEW` deep-link filter with the standard `DEFAULT` and
  /// `BROWSABLE` categories.
  factory AndroidIntentFilter.deepLink({
    required String scheme,
    String? host,
    String? port,
    String? path,
    String? pathPrefix,
    String? pathPattern,
    String? mimeType,
    String? activity,
    bool autoVerify = false,
  }) => AndroidIntentFilter(
    activity: activity,
    autoVerify: autoVerify,
    action: AndroidIntent.viewAction,
    categories: const {
      AndroidIntent.defaultCategory,
      AndroidIntent.browsableCategory,
    },
    data: [
      AndroidIntentData(
        scheme: scheme,
        host: host,
        port: port,
        path: path,
        pathPrefix: pathPrefix,
        pathPattern: pathPattern,
        mimeType: mimeType,
      ),
    ],
  );

  @override
  Map<String, Object?> toJson() => {
    'activity': ?activity,
    'autoVerify': autoVerify,
    ...super.toJson(),
  };
}
