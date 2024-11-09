import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_provider.dart';
import '../../domain/entities/geofence.dart';
import '../widgets/geofences_map_widget.dart';

class GeofenceDetailsScreen extends ConsumerStatefulWidget {
  final Geofence geofence;

  const GeofenceDetailsScreen({super.key, required this.geofence});

  @override
  GeofenceDetailsScreenState createState() => GeofenceDetailsScreenState();
}

class GeofenceDetailsScreenState extends ConsumerState<GeofenceDetailsScreen> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.geofence.name);

    // Inicializar los puntos en el mapProvider
    final initialPoints = widget.geofence.coordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider).initializePoints(initialPoints);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      final mapNotifier = ref.read(mapProvider);
      final updatedCoordinates = mapNotifier.geofencePoints
          .map((point) =>
              Coordinate(latitude: point.latitude, longitude: point.longitude))
          .toList();

      widget.geofence.copyWith(
        name: _nameController.text,
        coordinates: updatedCoordinates,
      );
      _isEditing = false;
    });
  }

  void _removeCoordinate(int index) {
    ref.read(mapProvider).removeGeofencePoint(index);
  }

  @override
  Widget build(BuildContext context) {
    final mapNotifier = ref.watch(mapProvider);

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
            GeofenceMapWidget(
              geofence: widget.geofence,
              isEditable: _isEditing,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _nameController.text = widget.geofence.name;
                          ref.read(mapProvider).initializePoints(widget
                              .geofence.coordinates
                              .map((coord) =>
                                  LatLng(coord.latitude, coord.longitude))
                              .toList());
                        });
                      },
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
            if (_isEditing) _buildCoordinatesTable(mapNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesTable(MapNotifier mapNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Coordinates:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mapNotifier.geofencePoints.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text('Coord ${index + 1}',
                          style: const TextStyle(fontSize: 16))),
                  TextButton(
                    onPressed: () => _removeCoordinate(index),
                    child: const Text('Eliminate'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
