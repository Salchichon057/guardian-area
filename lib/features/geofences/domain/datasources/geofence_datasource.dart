import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

abstract class GeofenceDatasource {
  Future<void> createGeofence(Geofence geofence);
  Future<List<Geofence>> fetchGeofences();
}
