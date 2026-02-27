import 'package:devstrix/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
}
