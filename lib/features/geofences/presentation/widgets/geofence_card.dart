import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:guardian_area/config/consts/map_token.dart';
import 'package:latlong2/latlong.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

class GeofenceCard extends StatelessWidget {
  final Geofence geofence;

  const GeofenceCard({super.key, required this.geofence});

  @override
  Widget build(BuildContext context) {
    final coordinates = geofence.coordinates.isNotEmpty
        ? LatLng(geofence.coordinates.first.latitude, geofence.coordinates.first.longitude)
        : const LatLng(0.0, 0.0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usamos FutureBuilder para cargar el token de Mapbox
          FutureBuilder<String>(
            future: MapToken.getMapToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data == 'No token found') {
                return const SizedBox(
                  height: 150,
                  child: Center(child: Text("Token no encontrado")),
                );
              }

              final mapboxToken = snapshot.data!;
              return SizedBox(
                height: 150,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: coordinates,
                    initialZoom: 17.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none, // Desactivar interacciones
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                      additionalOptions: {
                        'accessToken': mapboxToken,
                        'id': 'mapbox.streets'
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: coordinates,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  geofence.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Status: ${geofence.status}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
