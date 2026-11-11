/// Deep-link support for the `dartnativego://` custom URL scheme.
///
/// Supported forms: `dartnativego://open?url=…`, `dartnativego://open/<host:port>`,
/// and `dartnativego://<host:port>` (bare). `app_links_kit` delivers links including cold-starts.
library;

import '../runner/bundle_loader.dart' show BundleLoader;

/// One parsed `dartnativego://` link.
class DartGoDeepLink {
  /// Server URL, normalized to `http://host:port`.
  final String serverUrl;

  /// Optional display name shown while the project loads.
  final String? appName;

  const DartGoDeepLink({required this.serverUrl, this.appName});

  /// Scheme registered by the iOS/Android manifests.
  static const String scheme = 'dartnativego';

  /// Builds the canonical link for [serverUrl]; the CLI prints exactly this.
  static String build(String serverUrl, {String? appName}) {
    final query = <String, String>{
      'url': BundleLoader.normalizeUrl(serverUrl),
      if (appName != null && appName.trim().isNotEmpty) 'name': appName.trim(),
    };
    return Uri(scheme: scheme, host: 'open', queryParameters: query).toString();
  }

  /// Parses [uri], or returns null for unrelated/malformed links. Never throws.
  static DartGoDeepLink? tryParse(Uri uri) {
    if (uri.scheme.toLowerCase() != scheme) return null;

    // Accepted shapes, in order of preference:
    //   dartnativego://open?url=…   (canonical)
    //   dartnativego://open/<url>   (hand-typed)
    //   dartnativego://<host:port>  (bare)
    final query = uri.queryParameters;
    var target = query['url'] ?? query['project'] ?? '';

    if (target.isEmpty) {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (uri.host == 'open' || uri.host.isEmpty) {
        target = segments.isEmpty ? '' : segments.join('/');
      } else {
        // Bare form: the authority itself is the address. `uri.host` strips a
        // port, so rebuild from authority to keep it.
        target = uri.hasPort ? '${uri.host}:${uri.port}' : uri.authority;
        if (segments.isNotEmpty) target = '$target/${segments.join('/')}';
      }
    }

    target = target.trim();
    if (target.isEmpty) return null;

    // `192.168.1.10:8088` is a server address, not a scheme.
    if (!target.contains('://')) target = 'http://$target';

    final parsed = Uri.tryParse(target);
    if (parsed == null || parsed.host.isEmpty) return null;
    if (parsed.scheme != 'http' && parsed.scheme != 'https') return null;

    final name = query['name'] ?? query['app'] ?? query['appName'];
    return DartGoDeepLink(
      serverUrl: BundleLoader.normalizeUrl(parsed.toString()),
      appName: (name == null || name.trim().isEmpty) ? null : name.trim(),
    );
  }
}
