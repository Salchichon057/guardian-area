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
    // Convertir las coordenadas de la geocerca a una lista de LatLng
    final coordinates = geofence.coordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();

    // Crear CameraFit utilizando FitCoordinates para que ajuste todas las coordenadas
    final cameraFit = CameraFit.coordinates(
      coordinates: coordinates,
      padding: const EdgeInsets.all(8), // Espacio alrededor
      maxZoom: 17.0, // Límite de zoom máximo
      minZoom: 10.0, // Límite de zoom mínimo
      forceIntegerZoomLevel: false, // Usar niveles de zoom fraccionados
    );

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
                    initialCameraFit:
                        cameraFit, // Ajuste de cámara con las coordenadas
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none, // Desactivar interacciones
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                      additionalOptions: {
                        'accessToken': mapboxToken,
                        'id': 'mapbox.streets'
                      },
                    ),
                    // Dibuja el área de la geocerca usando PolygonLayer
                    PolygonLayer(
                      polygons: [
                        Polygon(
                          points: coordinates,
                          borderColor: Colors.blue,
                          borderStrokeWidth: 2,
                          color: Colors.blue.withOpacity(0.2),
                        ),
                      ],
                    ),
                    // Coloca un marcador en cada coordenada de la geocerca
                    MarkerLayer(
                      markers: coordinates
                          .map((point) => Marker(
                                point: point,
                                width: 20,
                                height: 20,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ))
                          .toList(),
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
