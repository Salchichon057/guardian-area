import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

class GeofenceMapper {
  static Geofence fromJson(Map<String, dynamic> json) {
    return Geofence(
      name: json['name'],
      status: json['geoFenceStatus'],
      coordinates: (json['coordinates'] as List)
          .map((coord) => Coordinate(
                latitude: coord['latitude'],
                longitude: coord['longitude'],
              ))
          .toList(),
      guardianAreaDeviceRecordId: json['guardianAreaDeviceRecordId'],
    );
  }

  static Map<String, dynamic> toJson(Geofence geofence) {
    return {
      'name': geofence.name,
      'geoFenceStatus': geofence.status,
      'coordinates': geofence.coordinates
          .map((coord) => {
                'latitude': coord.latitude,
                'longitude': coord.longitude,
              })
          .toList(),
      'guardianAreaDeviceRecordId': geofence.guardianAreaDeviceRecordId,
    };
  }
}
