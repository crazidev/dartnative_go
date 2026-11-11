import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// HTTP Client optimized for DartNative Go dev server communication and probing.
class DartGoHttpClient {
  final HttpClient _client;

  DartGoHttpClient({HttpClient? client})
    : _client = client ?? HttpClient()
        ..connectionTimeout = const Duration(milliseconds: 1500);

  /// Normalizes a user-entered or scanned URL by ensuring the http scheme and stripping trailing slashes.
  static String normalizeUrl(String input) {
    var trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      trimmed = 'http://$trimmed';
    }
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  /// Pings a server at [baseUrl] to verify if it is an active DartNative Go server.
  Future<bool> ping(
    String baseUrl, {
    Duration timeout = const Duration(milliseconds: 1000),
  }) async {
    final manifest = await fetchManifest(baseUrl, timeout: timeout);
    return manifest != null;
  }

  /// Fetches the project manifest from `$baseUrl/manifest.json`.
  Future<Map<String, dynamic>?> fetchManifest(
    String baseUrl, {
    Duration timeout = const Duration(milliseconds: 1500),
  }) async {
    final normalized = normalizeUrl(baseUrl);
    try {
      final uri = Uri.parse('$normalized/manifest.json');
      final request = await _client.getUrl(uri).timeout(timeout);
      final response = await request.close().timeout(timeout);

      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(timeout);
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['protocol'] == 'dart_go') {
        return decoded;
      }
    } catch (_) {
      // Ignored for offline or unreachable hosts
    }
    return null;
  }

  /// Fetches the project bundle from [bundleUrl].
  Future<String?> fetchBundle(
    String bundleUrl, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final uri = Uri.parse(bundleUrl);
      final request = await _client.getUrl(uri).timeout(timeout);
      final response = await request.close().timeout(timeout);

      if (response.statusCode != HttpStatus.ok) {
        return null;
      }

      return await response.transform(utf8.decoder).join().timeout(timeout);
    } catch (_) {
      return null;
    }
  }

  /// Closes the HTTP client and frees underlying sockets.
  void close() {
    _client.close(force: true);
  }
}
