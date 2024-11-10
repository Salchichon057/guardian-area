import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/domain/repositories/geofence_repository.dart';
import 'package:guardian_area/features/geofences/domain/datasources/geofence_datasource.dart';

class GeofenceRepositoryImpl implements GeofenceRepository {
  final GeofenceDatasource datasource;

  GeofenceRepositoryImpl({required this.datasource});

  @override
  Future<void> createGeofence(Geofence geofence) async {
    await datasource.createGeofence(geofence);
  }

  @override
  Future<List<Geofence>> fetchGeofences(selectedDeviceRecordId) async {
    return await datasource.fetchGeofences(selectedDeviceRecordId);
  }
  
  @override
  Future<Geofence> updateGeofence(Geofence geofence) {
    return datasource.updateGeofence(geofence);
  }
}