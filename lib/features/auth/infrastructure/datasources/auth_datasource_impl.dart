import 'package:dio/dio.dart';
import 'package:guardian_area/config/consts/environmets.dart';
import 'package:guardian_area/features/auth/domain/domain.dart';
import 'package:guardian_area/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Invalid token');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/api/v1/authentication/sign-in',
        data: {'username': username, 'password': password},
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Invalid credentials');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Check your internet connection');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String username, String password, List<String> roles) async {
    try {
      final response = await dio.post(
        '/api/v1/authentication/sign-up',
        data: {
          'username': username,
          'password': password,
          'roles': roles,
        },
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      throw Exception('Registration failed');
    }
  }
}
