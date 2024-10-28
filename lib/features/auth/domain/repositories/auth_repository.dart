import 'package:guardian_area/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password, List<String> roles);
  Future<User> checkAuthStatus(String token);
}
