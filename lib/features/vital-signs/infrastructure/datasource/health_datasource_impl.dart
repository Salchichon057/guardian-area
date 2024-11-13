import 'package:dio/dio.dart';
import 'package:guardian_area/config/consts/environments.dart';
import 'package:guardian_area/features/vital-signs/domain/datasource/health_datasource.dart';
import 'package:guardian_area/features/vital-signs/domain/entities/health.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:guardian_area/features/vital-signs/infrastructure/mappers/health_mapper.dart';

class HealthDatasourceImpl extends HealthDatasource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
  final KeyValueStorageService storageService;

  HealthDatasourceImpl({
    required this.storageService,
    Dio? dio,
  });

  @override
  Future<List<Health>> getHealthData(String deviceRecordId) async {
    try {
      final token = await storageService.getValue<String>('token');
      if (token == null) throw Exception('Token not found');

      final response = await dio.get(
        '/devices/$deviceRecordId/health-measures-monthly-summary',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data as List<dynamic>;
      return HealthMapper.fromJsonList(data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch health data: ${e.message}');
    }
  }
}
