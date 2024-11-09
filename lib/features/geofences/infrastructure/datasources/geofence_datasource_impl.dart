import 'package:dio/dio.dart';
import 'package:guardian_area/config/consts/environments.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/domain/datasources/geofence_datasource.dart';
import 'package:guardian_area/features/geofences/infrastructure/mappers/geofence_mapper.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';

class GeofenceDatasourceImpl implements GeofenceDatasource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
  final KeyValueStorageService storageService;

  GeofenceDatasourceImpl({
    required this.storageService,
    Dio? dio,
  }) {
    print("GeofenceDatasourceImpl - baseUrl: ${this.dio.options.baseUrl}");
  }

  @override
  Future<void> createGeofence(Geofence geofence) async {
    try {
      await dio.post(
        '/geo-fences',
        data: GeofenceMapper.toJson(geofence),
      );
    } on DioException catch (e) {
      throw Exception(
          'Error creating geofence: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<List<Geofence>> fetchGeofences(selectedDeviceRecordId) async {
    try {
      final token = await storageService.getValue<String>('token');

      if (token == null) throw Exception('Token not found');

      final response = await dio.get(
        '/devices/$selectedDeviceRecordId/geo-fences',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print(response.data);

      return (response.data as List)
          .map((data) => GeofenceMapper.fromJson(data))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          'Error fetching geofences: ${e.response?.data ?? e.message}');
    }
  }
}
