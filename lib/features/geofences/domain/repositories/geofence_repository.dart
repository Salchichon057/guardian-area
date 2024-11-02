// geofence_repository.dart
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

abstract class GeofenceRepository {
  Future<void> createGeofence(Geofence geofence);
  Future<List<Geofence>> fetchGeofences();
}
