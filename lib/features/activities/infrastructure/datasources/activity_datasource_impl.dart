import 'package:dio/dio.dart';
import 'package:guardian_area/config/config.dart';
import 'package:guardian_area/features/activities/domain/datasources/activity_datasource.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';
import 'package:guardian_area/features/activities/infrastructure/mappers/activity_mapper.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';

class ActivityDatasourceImpl extends ActivityDatasource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
  final KeyValueStorageService storageService;

  ActivityDatasourceImpl({required this.storageService});

  @override
  Future<List<Activity>> fetchActivities(String selectedDeviceRecordId) async {
    try {
      final token = await storageService.getValue<String>('token');
      if (token == null) throw Exception('Token not found');

      final response = await dio.get(
        '/devices/$selectedDeviceRecordId/activities',
        queryParameters: {'activityType': ''},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (response.data as List)
          .map((json) => ActivityMapper.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch activities: $e');
    }
  }
}
