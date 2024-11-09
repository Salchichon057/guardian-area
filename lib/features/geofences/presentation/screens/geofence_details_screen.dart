import 'package:flutter/material.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/presentation/widgets/geofences_map_widget.dart';

class GeofenceDetailsScreen extends StatelessWidget {
  final Geofence geofence;

  const GeofenceDetailsScreen({super.key, required this.geofence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo-fence: ${geofence.name}', style: const TextStyle(
          fontSize: 18
        ),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeofenceMapWidget(geofence: geofence),
            const SizedBox(height: 20),

            // Campo para el nombre de la geocerca
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Write the name of your Geo-fence',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: geofence.name),
            ),
            const SizedBox(height: 20),

            // Botones para Dibujar y Agregar Coordenadas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para dibujar la geocerca
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Draw Geo-fence'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para ingresar coordenadas
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Enter Coordinates'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón para editar la geocerca
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para editar la geocerca
                },
                child: const Text('Edit Geo-fence'),
              ),
            ),
            const SizedBox(height: 20),

            // Tabla de coordenadas
            _buildCoordinatesTable(geofence),
          ],
        ),
      ),
    );
  }

  // Tabla de coordenadas con scroll interno
  Widget _buildCoordinatesTable(Geofence geofence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coordinates:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: geofence.coordinates.length,
          itemBuilder: (context, index) {
            final coordinate = geofence.coordinates[index];
            return _buildCoordinateRow(
              coordinate.latitude.toStringAsFixed(4),
              coordinate.longitude.toStringAsFixed(4),
            );
          },
        ),
      ],
    );
  }

  // Widget para una fila de coordenadas con botones de editar y eliminar
  Widget _buildCoordinateRow(String latitude, String longitude) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Lat: $latitude, Long: $longitude',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              // Acción para editar la coordenada
            },
            child: const Text('Edit'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              // Acción para eliminar la coordenada
            },
            child: const Text('Eliminate'),
          ),
        ],
      ),
    );
  }
}
