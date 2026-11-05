import 'package:dartnative/dartnative.dart';

/// Renders the project splash screen while bundles and resources are being loaded.
class ProjectSplashScreen extends StatelessWidget {
  final String appName;
  final String? splashUrl;
  final String? iconUrl;
  final Color backgroundColor;
  final String statusMessage;
  final double? downloadProgress;
  final int? downloadedCount;
  final int? downloadTotal;

  const ProjectSplashScreen({
    super.key,
    required this.appName,
    this.splashUrl,
    this.iconUrl,
    this.backgroundColor = const Color(0xFF000000),
    this.statusMessage = 'Loading project bundle...',
    this.downloadProgress,
    this.downloadedCount,
    this.downloadTotal,
  });

  /// Helper to parse hex colors like '#000000' or '#112233'.
  static Color parseHexColor(
    String? hex, {
    Color fallback = const Color(0xFF000000),
  }) {
    if (hex == null || hex.isEmpty) return fallback;
    var h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final val = int.tryParse(h, radix: 16);
    return val != null ? Color(val) : fallback;
  }

  Widget _buildLogo() {
    if (splashUrl != null && splashUrl!.isNotEmpty) {
      return Image.network(
        splashUrl!,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      );
    }
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      return Image.network(
        iconUrl!,
        width: 90,
        height: 90,
        fit: BoxFit.contain,
      );
    }
    return Image.asset('assets/dn-logo.png', width: 90, height: 90);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('project_splash_screen'),
      // backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                Text(
                  appName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: downloadProgress,
                        // backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    const CircularProgressIndicator(
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      // color: Colors.white70,
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
