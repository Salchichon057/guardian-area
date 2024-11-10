import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

abstract class GeofenceDatasource {
  Future<Geofence> createGeofence(Geofence geofence);
  Future<List<Geofence>> fetchGeofences(String selectedDeviceRecordId);
  Future<Geofence> updateGeofence(Geofence geofence);
}
