import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapNotifier extends ChangeNotifier {
  final MapController mapController;
  List<LatLng> geofencePoints = [];

  MapNotifier({required this.mapController});

  // Inicializar con puntos iniciales si existen
  void initializePoints(List<LatLng> initialPoints) {
    geofencePoints = List.from(initialPoints);
    notifyListeners();
  }

  // Añadir punto de geocerca
  void addGeofencePoint(LatLng point) {
    if (geofencePoints.length < 5) {
      geofencePoints.add(point);
      notifyListeners();
    }
  }

  // Eliminar punto de geocerca
  void removeGeofencePoint(int index) {
    if (index >= 0 && index < geofencePoints.length) {
      geofencePoints.removeAt(index);
      notifyListeners();
    }
  }

  // Mover el mapa a la ubicación actual
  void moveToLocation(LatLng position) {
    mapController.move(position, 15);
  }
}

// Provider para el MapNotifier
final mapProvider = ChangeNotifierProvider<MapNotifier>((ref) {
  return MapNotifier(mapController: MapController());
});
