import 'package:dartnative/dartnative.dart';

// ---------------------------------------------------------------------------
// AppState — a simple singleton that survives hot reload.
// Hot reload patches widget code but does NOT reinitialize Dart statics,
// so any mutations you make at runtime are preserved between reloads.
// Hot RESTART resets everything back to initial values.
// ---------------------------------------------------------------------------
class AppState {
  AppState._(); // private constructor
  static final AppState instance = AppState._(); // created once, ever

  bool isLoggedIn = false;
  String userName = 'Guest';
  int loginCount = 0;
}

// ---------------------------------------------------------------------------
// HomeScreen — lets you mutate AppState and observe what survives hot reload.
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Shortcut reference — same singleton instance every time.
  final state = AppState.instance;

  void _login() {
    setState(() {
      state.isLoggedIn = true;
      state.userName = 'Alice';
      state.loginCount++;
    });
  }

  void _logout() {
    setState(() {
      state.isLoggedIn = false;
      state.userName = 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: DefaultTextStyle(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status icon
                Icon(
                  state.isLoggedIn
                      ? CupertinoIcons.person_fill
                      : CupertinoIcons.person,
                  size: 72,
                  color: state.isLoggedIn ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 16),

                // Current state display
                Text(
                  state.isLoggedIn
                      ? 'Logged in as ${state.userName}'
                      : 'Not logged in',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login count: ${state.loginCount}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Hot reload hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    ''
                    '👉 Change the state above, then hot reload (⌘R / r).\n'
                    'The values should stay the same.\n\n'
                    '🔄 Hot restart (⇧⌘R / R) will reset everything.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      onPressed: state.isLoggedIn ? null : _login,
                      title: 'Login',
                      color: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Button(
                      onPressed: state.isLoggedIn ? _logout : null,
                      title: 'Logout',
                      color: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
