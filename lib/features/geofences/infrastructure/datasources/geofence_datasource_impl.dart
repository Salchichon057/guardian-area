import 'package:dio/dio.dart';
import 'package:guardian_area/config/consts/environmets.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/domain/datasources/geofence_datasource.dart';
import 'package:guardian_area/features/geofences/infrastructure/mappers/geofence_mapper.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';

class GeofenceDatasourceImpl implements GeofenceDatasource {
  final Dio dio;
  final KeyValueStorageService storageService;

  GeofenceDatasourceImpl({
    required this.storageService,
    Dio? dio,
  }) : dio = dio ?? Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  @override
  Future<void> createGeofence(Geofence geofence) async {
    try {
      await dio.post(
        '/geo-fences',
        data: GeofenceMapper.toJson(geofence),
      );
    } on DioException catch (e) {
      throw Exception('Error creating geofence: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<List<Geofence>> fetchGeofences() async {
    try {
      final token = await storageService.getValue<String>('token');
      if (token == null) throw Exception('Token not found');

      final response = await dio.get(
        '/geo-fences',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (response.data as List)
          .map((data) => GeofenceMapper.fromJson(data))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error fetching geofences: ${e.response?.data ?? e.message}');
    }
  }
}
