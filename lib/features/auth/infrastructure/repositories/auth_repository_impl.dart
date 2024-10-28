import 'package:guardian_area/features/auth/domain/domain.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<AuthenticatedUser> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<AuthenticatedUser> login(String username, String password) {
    return datasource.login(username, password);
  }

  @override
  Future<AuthenticatedUser> register(String username, String password, List<String> roles) {
    return datasource.register(username, password, roles);
  }

  @override
  Future<UserProfile> fetchUserProfile(int userId) {
    return datasource.fetchUserProfile(userId);
  }
}
