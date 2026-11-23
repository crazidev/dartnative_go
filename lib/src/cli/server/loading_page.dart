/// HTML interstitial served at `/_dngo/loading` when a browser opens the
/// dev-server URL instead of the DartNative Go app.
library;

import '../diagnostics/dart_go_version.dart';
import '../../client/deep_link.dart';

/// Path of the browser loading interstitial.
const String kDngoLoadingPath = '/_dngo/loading';

/// True when [requestAccept] looks like a browser document navigation
/// (`text/html`) rather than a JSON/API client such as the Go app.
bool isBrowserDocumentRequest(String? requestAccept) {
  if (requestAccept == null || requestAccept.isEmpty) return false;
  final accept = requestAccept.toLowerCase();
  // Browsers always list `text/html` first for address-bar navigations.
  // API clients (Go app, curl default `*/*`, Accept: application/json) do not.
  return accept.contains('text/html');
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

/// Builds the `/_dngo/loading` HTML page for [appName] at [serverUrl].
String buildLoadingPageHtml({
  required String appName,
  required String appVersion,
  required String serverUrl,
  String? projectPath,
}) {
  final deepLink = DartGoDeepLink.build(serverUrl, appName: appName);
  final safeName = _escapeHtml(appName);
  final safeVersion = _escapeHtml(appVersion);
  final safeUrl = _escapeHtml(serverUrl);
  final safePath = _escapeHtml(projectPath ?? '');
  final safeDeepLink = _escapeHtml(deepLink);
  final safeDngo = _escapeHtml(kDartGoVersion);
  final safeDn = _escapeHtml(kDartNativeVersion);

  return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>DartNative Go · $safeName</title>
  <style>
    :root {
      --bg: #0b0d10;
      --card: #14181e;
      --border: #252b33;
      --text: #e8ecf1;
      --muted: #8b95a5;
      --accent: #3d8bfd;
      --accent-text: #ffffff;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
      background:
        radial-gradient(ellipse 80% 50% at 50% -20%, rgba(61, 139, 253, 0.18), transparent),
        var(--bg);
      color: var(--text);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .card {
      width: 100%;
      max-width: 420px;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 28px 24px;
      box-shadow: 0 24px 48px rgba(0, 0, 0, 0.35);
    }
    .brand {
      font-size: 12px;
      font-weight: 600;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: var(--muted);
      margin: 0 0 8px;
    }
    h1 {
      margin: 0 0 6px;
      font-size: 22px;
      font-weight: 700;
      line-height: 1.25;
    }
    .subtitle {
      margin: 0 0 20px;
      color: var(--muted);
      font-size: 14px;
      line-height: 1.45;
    }
    .meta {
      border: 1px solid var(--border);
      border-radius: 10px;
      overflow: hidden;
      margin-bottom: 20px;
    }
    .row {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      padding: 10px 12px;
      font-size: 13px;
    }
    .row:nth-child(odd) { background: rgba(255, 255, 255, 0.03); }
    .row span:first-child { color: var(--muted); flex-shrink: 0; }
    .row span:last-child {
      text-align: right;
      word-break: break-all;
      font-variant-numeric: tabular-nums;
    }
    .cta {
      display: block;
      width: 100%;
      text-align: center;
      text-decoration: none;
      background: var(--accent);
      color: var(--accent-text);
      font-weight: 600;
      font-size: 15px;
      padding: 12px 16px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
    }
    .cta:hover { filter: brightness(1.08); }
    .hint {
      margin: 14px 0 0;
      font-size: 12px;
      color: var(--muted);
      text-align: center;
      line-height: 1.4;
    }
    #alert {
      display: none;
      margin-top: 14px;
      padding: 12px;
      border-radius: 10px;
      background: rgba(255, 90, 90, 0.12);
      color: #ffb4b4;
      font-size: 13px;
      line-height: 1.4;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="card">
    <p class="brand">DartNative Go</p>
    <h1>$safeName</h1>
    <p class="subtitle">
      This is a development server. Open the project in the DartNative Go app
      to run and hot-reload it on a device.
    </p>
    <div class="meta">
      <div class="row"><span>App version</span><span>$safeVersion</span></div>
      <div class="row"><span>Server</span><span>$safeUrl</span></div>
      <div class="row"><span>dngo</span><span>v$safeDngo</span></div>
      <div class="row"><span>DartNative SDK</span><span>v$safeDn</span></div>
      ${safePath.isEmpty ? '' : '<div class="row"><span>Path</span><span>$safePath</span></div>'}
    </div>
    <a class="cta" id="open-link" href="$safeDeepLink">Open in DartNative Go</a>
    <p class="hint">
      Scan the QR code from <code>dngo start</code>, or install the DartNative Go
      shell if the link does not open an app.
    </p>
    <div id="alert"></div>
  </div>
  <script>
    (function () {
      var alertEl = document.getElementById('alert');
      var link = document.getElementById('open-link');
      link.addEventListener('click', function () {
        var didHide = false;
        var onVis = function (e) {
          if (e.target.visibilityState === 'hidden') didHide = true;
        };
        document.addEventListener('visibilitychange', onVis);
        setTimeout(function () {
          document.removeEventListener('visibilitychange', onVis);
          if (!didHide) {
            alertEl.style.display = 'block';
            alertEl.textContent =
              'Could not open DartNative Go. Install the shell app, then try again.';
          }
        }, 900);
      });
    })();
  </script>
</body>
</html>
''';
}
