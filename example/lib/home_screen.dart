import 'package:dartnative/dartnative.dart';
import 'package:riverpod_kit/riverpod_kit.dart';

// ---------------------------------------------------------------------------
// AppState Model & Riverpod Notifier
// ---------------------------------------------------------------------------
class AppState {
  final bool isLoggedIn;
  final String userName;
  final int loginCount;

  const AppState({
    this.isLoggedIn = false,
    this.userName = 'Guest',
    this.loginCount = 0,
  });

  AppState copyWith({bool? isLoggedIn, String? userName, int? loginCount}) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userName: userName ?? this.userName,
      loginCount: loginCount ?? this.loginCount,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  AppStateNotifier();

  @override
  AppState build() => const AppState();

  void login({String userName = 'Alice'}) {
    state = state.copyWith(
      isLoggedIn: true,
      userName: userName,
      loginCount: state.loginCount + 1,
    );
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false, userName: 'Guest');
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(
  () => AppStateNotifier(),
);

// ---------------------------------------------------------------------------
// HomeScreen — ConsumerWidget using Riverpod state management
// ---------------------------------------------------------------------------
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: DefaultTextStyle(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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

                // Riverpod Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '⚡️ Powered by Riverpod (`riverpod_kit`)\n\n'
                    '👉 Tap Login/Logout to mutate state via Notifier.\n'
                    'Hot reload (⌘R / r) preserves state in memory.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      onPressed: state.isLoggedIn
                          ? null
                          : () => notifier.login(),
                      title: 'Login',
                      color: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Button(
                      onPressed: state.isLoggedIn
                          ? () => notifier.logout()
                          : null,
                      title: 'Logout',
                      color: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
