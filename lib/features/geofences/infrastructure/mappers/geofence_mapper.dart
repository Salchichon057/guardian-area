import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

class GeofenceMapper {
  static Geofence fromJson(Map<String, dynamic> json) {
    return Geofence(
      id: json['id'],
      name: json['name'],
      geoFenceStatus: json['geoFenceStatus'],
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
      'id': geofence.id,
      'name': geofence.name,
      'geoFenceStatus': geofence.geoFenceStatus,
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
