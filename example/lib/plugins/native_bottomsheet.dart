import 'package:dartnative/dartnative.dart';
import 'package:native_bottomsheet/native_bottomsheet.dart';

/// Demo screen for the native bottom sheet plugin.
class BottomSheetExampleApp extends StatefulWidget {
  const BottomSheetExampleApp({super.key});

  @override
  State<BottomSheetExampleApp> createState() => _BottomSheetExampleAppState();
}

class _BottomSheetExampleAppState extends State<BottomSheetExampleApp> {
  DNSheetController? _currentActiveSheet;

  void _updateStatus(String message) {
    // ignore: avoid_print
    print(
      '[BottomSheetExample] $message '
      '(activeSheet: ${_currentActiveSheet != null})',
    );
  }

  VoidCallback _dismissedHandler(String message) {
    return () {
      _updateStatus(message);
      setState(() => _currentActiveSheet = null);
    };
  }

  void _openFitToContentSheet() {
    _updateStatus('Opening Fit-to-Content sheet...');
    _currentActiveSheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.contentFit],
      initialDetent: DNSheetDetent.contentFit,
      showGrabber: true,
      backgroundColor: const Color(0xFF18181A),
      platformConfig: DNSheetPlatformConfig.android(),
      builder: (context, controller) => FitContentSheet(
        controller: controller,
        onStateChanged: (description) =>
            _updateStatus('Fit Content: $description'),
      ),
      onDetentChanged: (detent) =>
          _updateStatus('Fit Content settled at: ${detent.label}'),
      onDismissed: _dismissedHandler('Fit Content sheet dismissed'),
    );
  }

  void _openScrollableSheet() {
    _updateStatus('Opening Scrollable sheet...');
    _currentActiveSheet = showBottomSheet(
      context,
      detents: const [DNSheetDetent.medium, DNSheetDetent.large],
      initialDetent: DNSheetDetent.medium,
      showGrabber: true,
      backgroundColor: const Color(0xFF141416),
      platformConfig: DNSheetPlatformConfig(
        android: DNSheetAndroidConfig(
          isAppearanceLightStatusBars: false,
          floatingGrabber: false,
        ),
        ios: DNSheetIOSConfig(edgeAttachedInCompactHeight: true),
      ),
      scrollExpandsSheet: true,
      builder: (context, controller) => ScrollableSheet(
        controller: controller,
        onSnapRequested: (label) =>
            _updateStatus('Programmatic snap to: $label'),
      ),
      onDetentChanged: (detent) =>
          _updateStatus('Scrollable detent: ${detent.label}'),
      onDismissed: _dismissedHandler('Scrollable sheet dismissed'),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Native Bottomsheet',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: screen.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TestCaseCard(
              title: 'Fit content',
              description:
                  'Auto-measures intrinsic content height using Yoga. Dynamically expands or collapses size on state mutation.',
              onTap: _openFitToContentSheet,
            ),
            const SizedBox(height: 14),
            TestCaseCard(
              title: 'Scrollable Content',
              description:
                  '100 rows in a fixed-height list. Scroll inside the sheet, snap between medium/large, and test scroll-expands-sheet at the list edge.',
              onTap: _openScrollableSheet,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Test Case Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class TestCaseCard extends StatelessWidget {
  const TestCaseCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Button(title: title, child: Text(description), onPressed: onTap);
  }
}

class FitContentSheet extends StatefulWidget {
  const FitContentSheet({
    super.key,
    required this.controller,
    required this.onStateChanged,
  });

  final DNSheetController controller;
  final void Function(String description) onStateChanged;

  @override
  State<FitContentSheet> createState() => FitContentSheetState();
}

class FitContentSheetState extends State<FitContentSheet> {
  int _expansionStep = 0; // 0: Compact, 1: Moderate, 2: Large

  double get _currentHeight {
    switch (_expansionStep) {
      case 0:
        return 210.0;
      case 1:
        return 330.0;
      case 2:
        return 460.0;
      default:
        return 210.0;
    }
  }

  String get _stepLabel {
    switch (_expansionStep) {
      case 0:
        return 'Compact (210px)';
      case 1:
        return 'Medium (330px)';
      case 2:
        return 'Expanded (460px)';
      default:
        return 'Default';
    }
  }

  void _cycleHeight() {
    setState(() {
      _expansionStep = (_expansionStep + 1) % 3;
    });
    widget.onStateChanged('Resized to $_stepLabel');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF18181A),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      height: _currentHeight,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fit to Content',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Current Height: ${_currentHeight.round()}px ($_stepLabel)',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF34C759),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GlassEffectContainer(
                style: GlassStyle.regular,
                borderRadius: BorderRadius.circular(100),
                child: IconButton(
                  onPressed: () => widget.controller.dismiss(),
                  icon: const Icon(
                    CupertinoIcons.xmark_1,
                    color: Colors.white60,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'DNSheetDetent.contentFit adapts the sheet height to the content size.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA1A1AA),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  onPressed: _cycleHeight,
                  child: Text(
                    'Toggle Next Size (Step ${(_expansionStep + 1) % 3})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_expansionStep >= 1) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27272A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: Color(0xFF34C759),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Auto-animation triggered! Height expanded to 330px.',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_expansionStep == 2) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27272A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.sparkles,
                          color: Color(0xFFFFD60A),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Max step reached!',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollableSheet extends StatefulWidget {
  const ScrollableSheet({
    super.key,
    required this.controller,
    required this.onSnapRequested,
  });

  final DNSheetController controller;
  final void Function(String label) onSnapRequested;

  @override
  State<ScrollableSheet> createState() => _ScrollableSheetState();
}

class _ScrollableSheetState extends State<ScrollableSheet> {
  DNSheetDetent _activeDetent = DNSheetDetent.medium;

  @override
  void initState() {
    super.initState();
    widget.controller.addDetentListener(_handleDetentChanged);
  }

  @override
  void dispose() {
    widget.controller.removeDetentListener(_handleDetentChanged);
    super.dispose();
  }

  void _handleDetentChanged(DNSheetDetent detent) {
    setState(() => _activeDetent = detent);
  }

  void _toggleDetent() {
    final next = _activeDetent == DNSheetDetent.medium
        ? DNSheetDetent.large
        : DNSheetDetent.medium;
    setState(() => _activeDetent = next);
    widget.controller.snapTo(next);
    widget.onSnapRequested(next.label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scrollable Content",
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () => widget.controller.dismiss(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _activeDetent == DNSheetDetent.medium
                  ? CupertinoIcons.rectangle_expand_vertical
                  : CupertinoIcons.rectangle_compress_vertical,
            ),
            onPressed: _toggleDetent,
          ),
        ],
      ),
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF141416),
      body: Expanded(
        child: Container(
          height: 600,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: FastList(
                  itemCount: 100,
                  showScrollBar: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF2C2C2E),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        "Row $index",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
