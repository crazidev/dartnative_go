import 'package:dartnative/dartnative.dart';
import 'package:dngo_ui/dngo_ui.dart';

/// Renders the project splash screen while bundles and resources are being loaded.
///
/// When [backgroundColorHex] is null (no project splash color config), the
/// screen uses the shell [ShadcnTheme] background so it matches light/dark
/// mode like the bottomsheet and launcher. Configured colors always win.
class ProjectSplashScreen extends StatelessWidget {
  final String appName;
  final String? splashUrl;
  final String? iconUrl;

  /// Configured light (or sole) splash background hex, e.g. `#112233`.
  final String? backgroundColorHex;

  /// Optional dark-mode splash background hex from project config.
  final String? backgroundColorDarkHex;

  final String statusMessage;
  final double? downloadProgress;
  final int? downloadedCount;
  final int? downloadTotal;

  const ProjectSplashScreen({
    super.key,
    required this.appName,
    this.splashUrl,
    this.iconUrl,
    this.backgroundColorHex,
    this.backgroundColorDarkHex,
    this.statusMessage = 'Loading project bundle...',
    this.downloadProgress,
    this.downloadedCount,
    this.downloadTotal,
  });

  /// Parses `#RRGGBB` / `#AARRGGBB`; returns null when [hex] is missing/invalid.
  static Color? tryParseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final val = int.tryParse(h, radix: 16);
    return val != null ? Color(val) : null;
  }

  /// Helper to parse hex colors like '#000000' or '#112233'.
  static Color parseHexColor(
    String? hex, {
    Color fallback = const Color(0xFF000000),
  }) {
    return tryParseHexColor(hex) ?? fallback;
  }

  Widget _buildLogo() {
    if (splashUrl != null && splashUrl!.isNotEmpty) {
      return Image.network(
        splashUrl!,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        cachePolicy: ImageCachePolicy.none,
      );
    }
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      return Image.network(
        iconUrl!,
        width: 90,
        height: 90,
        fit: BoxFit.contain,
        cachePolicy: ImageCachePolicy.none,
      );
    }
    return Image.asset('assets/app-logo.png', width: 90, height: 90);
  }

  /// Contrast foreground color computed from [background] luminance.
  static Color contrastOn(Color background) {
    final value = background.value;
    final r = (value >> 16) & 0xFF;
    final g = (value >> 8) & 0xFF;
    final b = value & 0xFF;
    final luminance = 0.299 * r + 0.587 * g + 0.114 * b;
    return luminance < 140 ? Colors.white : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final configured = tryParseHexColor(backgroundColorHex);
    final configuredDark = tryParseHexColor(backgroundColorDarkHex);

    final Color background;
    final Color onBackground;
    if (configured != null) {
      background = theme.isDark && configuredDark != null
          ? configuredDark
          : configured;
      onBackground = contrastOn(background);
    } else {
      background = theme.background;
      onBackground = theme.foreground;
    }

    return Scaffold(
      key: const ValueKey('project_splash_screen'),
      backgroundColor: background,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                Text(
                  appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: onBackground,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (downloadProgress != null) ...[
                    if (downloadedCount != null && downloadTotal != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Downloading packages ($downloadedCount / $downloadTotal)',
                          style: TextStyle(
                            fontSize: 12,
                            color: onBackground.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: downloadProgress,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: onBackground.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
