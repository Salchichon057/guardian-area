import 'package:flutter/material.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/presentation/widgets/geofences_map_widget.dart';

class GeofenceDetailsScreen extends StatefulWidget {
  final Geofence geofence;

  const GeofenceDetailsScreen({super.key, required this.geofence});

  @override
  GeofenceDetailsScreenState createState() => GeofenceDetailsScreenState();
}

class GeofenceDetailsScreenState extends State<GeofenceDetailsScreen> {
  late TextEditingController _nameController;
  bool _isEditing = false;
  late Geofence _tempGeofence;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.geofence.name);
    _tempGeofence = widget.geofence.copyWith();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Restablecer valores originales si se cancela la edición
        _tempGeofence = widget.geofence.copyWith();
        _nameController.text = widget.geofence.name; // Restablecer el texto del controlador
      }
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      // Actualizar los valores de _tempGeofence con el nombre actual
      _tempGeofence = _tempGeofence.copyWith(
        name: _nameController.text,
        coordinates: List.from(_tempGeofence.coordinates),
      );
      _isEditing = false;

      // Aquí podrías llamar a un método para guardar la geocerca en la base de datos o proveedor
      // Ejemplo: provider.updateGeofence(_tempGeofence);
    });
  }

  void _cancelEditing() {
    setState(() {
      // Restaurar valores originales usando copyWith
      _tempGeofence = widget.geofence.copyWith();
      _nameController.text = widget.geofence.name;
      _isEditing = false;
    });
  }

  void _removeCoordinate(int index) {
    setState(() {
      // Crea una copia de las coordenadas sin el elemento eliminado
      final newCoordinates = List<Coordinate>.from(_tempGeofence.coordinates)..removeAt(index);
      _tempGeofence = _tempGeofence.copyWith(coordinates: newCoordinates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Geo-fence: ${widget.geofence.name}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget del mapa
            GeofenceMapWidget(geofence: _tempGeofence, isEditable: _isEditing),
            const SizedBox(height: 20),

            // Campo del nombre de la geocerca
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _tempGeofence = _tempGeofence.copyWith(name: value);
              },
            ),
            const SizedBox(height: 20),

            // Botones de acción
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: _cancelEditing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Cancel'),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isEditing ? _saveChanges : _toggleEditing,
                    child: Text(_isEditing ? 'Save changes' : 'Edit geofence'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabla de coordenadas en modo edición
            if (_isEditing) _buildCoordinatesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesTable() {
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
          itemCount: _tempGeofence.coordinates.length,
          itemBuilder: (context, index) {
            return _buildCoordinateRow(index);
          },
        ),
      ],
    );
  }

  Widget _buildCoordinateRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Coord ${index + 1}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () => _removeCoordinate(index),
            child: const Text('Eliminate'),
          ),
        ],
      ),
    );
  }
}
