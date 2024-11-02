import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

class GeofenceMapWidget extends StatelessWidget {
  final List<Geofence> geofences;

  const GeofenceMapWidget({Key? key, required this.geofences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-12.0464, -77.0428), // Ubicación inicial
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: geofences.map((geofence) {
            // Asume que la primera coordenada representa el centro de la geocerca
            final LatLng geofencePoint = LatLng(
              geofence.coordinates.first.latitude,
              geofence.coordinates.first.longitude,
            );
            return Marker(
              point: geofencePoint,
              width: 30,
              height: 30,
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
