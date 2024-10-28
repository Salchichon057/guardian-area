import 'package:dio/dio.dart';
import 'package:guardian_area/config/consts/environmets.dart';
import 'package:guardian_area/features/auth/domain/domain.dart';
import 'package:guardian_area/features/auth/infrastructure/infrastructure.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    },
  ));
  final KeyValueStorageService storageService;

  AuthDatasourceImpl({required this.storageService});

  @override
  Future<AuthenticatedUser> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserMapper.userJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Invalid token');
      }
      throw Exception('Failed to check auth status');
    }
  }

  @override
  Future<AuthenticatedUser> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/authentication/sign-in',
        data: {'username': username, 'password': password},
      );
      return UserMapper.userJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Invalid credentials');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Check your internet connection');
      }
      throw Exception('Failed to login');
    }
  }

  @override
  Future<AuthenticatedUser> register(String username, String password, List<String> roles) async {
    try {
      final response = await dio.post(
        '/authentication/sign-up',
        data: {
          'username': username,
          'password': password,
          'roles': roles,
        },
      );
      return UserMapper.userJsonToEntity(response.data);
    } catch (e) {
      throw Exception('Registration failed');
    }
  }

  @override
  Future<UserProfile> fetchUserProfile(int userId) async {
    try {
      final token = await storageService.getValue<String>('token');
      if (token == null) throw Exception('Token not found');

      final response = await dio.get(
        '/users/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserProfileMapper.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user profile');
    }
  }
}
