import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:guardian_area/features/home/presentation/providers/current_location_provider.dart';
import 'package:guardian_area/features/geofences/presentation/providers/geofence_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const LatLng defaultLocation = LatLng(-12.0464, -77.0428); // Ejemplo

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocationState = ref.watch(currentLocationProvider);
    final geofenceState = ref.watch(geofenceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Time Monitoring Map'),
        backgroundColor: const Color(0xFF08273A),
      ),
      body: Stack(
        children: [
          // Mapa principal
          currentLocationState.when(
            data: (currentLocation) {
              final location =
                  LatLng(currentLocation.latitude, currentLocation.longitude);
              final riskColor = currentLocation.riskLevel == 'DANGER'
                  ? Colors.red
                  : Colors.green;

              return FlutterMap(
                options: MapOptions(
                  initialCenter: location,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onPositionChanged: (mapCamera, _) {
                    // Maneja eventos de movimiento o zoom aquí si es necesario
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: location,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: riskColor,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  if (geofenceState.geofences.isNotEmpty)
                    PolygonLayer(
                      polygons: geofenceState.geofences.map((geofence) {
                        final points = geofence.coordinates.map((coord) {
                          return LatLng(coord.latitude, coord.longitude);
                        }).toList();

                        return Polygon(
                          points: points,
                          borderColor: Colors.blue,
                          borderStrokeWidth: 2,
                          color: Colors.blue.withOpacity(0.3),
                        );
                      }).toList(),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Failed to load location: $error'),
            ),
          ),

          // Información en tiempo real
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: currentLocationState.when(
                    data: (currentLocation) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Risk Level: ${currentLocation.riskLevel}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: currentLocation.riskLevel == 'DANGER'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Latitude: ${currentLocation.latitude.toStringAsFixed(4)}, '
                          'Longitude: ${currentLocation.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    loading: () => const Text('Loading current location...'),
                    error: (error, stackTrace) => Text('Error: $error'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
