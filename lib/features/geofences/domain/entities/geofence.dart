class Geofence {
  final String name;
  final String status;
  final List<Coordinate> coordinates;
  final String guardianAreaDeviceRecordId;

  Geofence({
    required this.name,
    required this.status,
    required this.coordinates,
    required this.guardianAreaDeviceRecordId,
  });
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});
}
