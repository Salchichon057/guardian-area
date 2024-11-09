import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:guardian_area/config/consts/map_token.dart';
import 'package:latlong2/latlong.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';

class GeofenceMapWidget extends StatelessWidget {
  final Geofence geofence;

  const GeofenceMapWidget({super.key, required this.geofence});

  @override
  Widget build(BuildContext context) {
    final coordinates = geofence.coordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();

    final cameraFit = CameraFit.coordinates(
      coordinates: coordinates,
      padding: const EdgeInsets.all(8),
      maxZoom: 17.0,
      minZoom: 10.0,
      forceIntegerZoomLevel: false,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FullScreenMap(geofence: geofence),
          ),
        );
      },
      child: SizedBox(
        height: 200,
        child: FutureBuilder<String>(
          future: MapToken.getMapToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == 'No token found') {
              return const Center(child: Text("Token no encontrado"));
            }

            final mapboxToken = snapshot.data!;
            return FlutterMap(
              options: MapOptions(
                initialCameraFit: cameraFit,
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
                    'id': 'mapbox.streets',
                  },
                ),
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
            );
          },
        ),
      ),
    );
  }
}

class FullScreenMap extends StatelessWidget {
  final Geofence geofence;

  const FullScreenMap({super.key, required this.geofence});

  @override
  Widget build(BuildContext context) {
    final coordinates = geofence.coordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();

    final cameraFit = CameraFit.coordinates(
      coordinates: coordinates,
      padding: const EdgeInsets.all(8),
      maxZoom: 17.0,
      minZoom: 10.0,
      forceIntegerZoomLevel: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de ${geofence.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<String>(
        future: MapToken.getMapToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == 'No token found') {
            return const Center(child: Text("Token no encontrado"));
          }

          final mapboxToken = snapshot.data!;
          return FlutterMap(
            options: MapOptions(
              initialCameraFit: cameraFit,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxToken',
                additionalOptions: {
                  'accessToken': mapboxToken,
                  'id': 'mapbox.streets',
                },
              ),
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
          );
        },
      ),
    );
  }
}
