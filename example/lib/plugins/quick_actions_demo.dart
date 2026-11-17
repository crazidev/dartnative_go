/// Quick actions demo — dynamic home-screen shortcuts: set two shortcuts,
/// then long-press the app icon (iOS) or the launcher entry (Android) and tap
/// one; the shortcut's `type` lands in the status line. Requires a device or
/// simulator home screen — shortcut taps are delivered to `initialize`'s
/// handler while the app runs.
library;

import 'package:dartnative/dartnative.dart';
import 'package:quick_actions_kit/quick_actions_kit.dart';

class QuickActionsDemo extends StatefulWidget {
  const QuickActionsDemo({super.key});

  @override
  State<QuickActionsDemo> createState() => _QuickActionsDemoState();
}

class _QuickActionsDemoState extends State<QuickActionsDemo> {
  final _quickActions = QuickActions();
  String _status = 'Ready';

  @override
  void initState() {
    super.initState();
    _initHandler();
  }

  /// Registers the tap handler. Shortcut types arrive here — call
  /// [QuickActions.initialize] again at any time to replace the handler.
  Future<void> _initHandler() async {
    try {
      await _quickActions.initialize((type) {
        if (mounted) {
          setState(() => _status = 'Launched via shortcut: $type');
        }
      });
    } catch (e) {
      if (mounted) setState(() => _status = 'Initialize failed: $e');
    }
  }

  Future<void> _setShortcuts() async {
    try {
      await _quickActions.setShortcutItems(const [
        ShortcutItem(
          type: 'open_media',
          localizedTitle: 'Open media picker',
          localizedSubtitle: 'Jump straight to the gallery',
        ),
        ShortcutItem(
          type: 'start_auth',
          localizedTitle: 'Start local auth',
        ),
      ]);
      setState(
        () => _status = '2 shortcuts set — long-press the app icon',
      );
    } catch (e) {
      setState(() => _status = 'Set failed: $e');
    }
  }

  Future<void> _clearShortcuts() async {
    try {
      await _quickActions.clearShortcutItems();
      setState(() => _status = 'Shortcuts cleared');
    } catch (e) {
      setState(() => _status = 'Clear failed: $e');
    }
  }

  @override
  void dispose() {
    // Stops activation delivery; installed shortcuts stay until cleared.
    _quickActions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Actions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Button(title: 'Set Shortcuts', onPressed: _setShortcuts),
            const SizedBox(height: 12),
            Button(title: 'Clear Shortcuts', onPressed: _clearShortcuts),
            const SizedBox(height: 12),
            Button(title: 'Re-initialize Handler', onPressed: _initHandler),
          ],
        ),
      ),
    );
  }
}
