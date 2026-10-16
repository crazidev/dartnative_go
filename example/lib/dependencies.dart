import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ApiClient {
  Future<void> fetchData() async {
    print('Fetching data from API...');
  }
}

class UserRepository {
  final ApiClient apiClient;
  List<String> users = [];

  UserRepository(this.apiClient);
}

bool _dependenciesConfigured = false;

void configureDependencies() {
  // `main()` runs again after AST hot reload. Keep GetIt registration
  // idempotent while its singleton instance survives between generations.
  if (_dependenciesConfigured) return;

  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>()),
  );
  _dependenciesConfigured = true;
}
