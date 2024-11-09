import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapNotifier extends ChangeNotifier {
  final MapController mapController;
  List<LatLng> geofencePoints = [];
  final Distance distance = const Distance();

  MapNotifier({required this.mapController});

  void initializePoints(List<LatLng> initialPoints) {
    geofencePoints = List.from(initialPoints);
    _sortPointsByClosestPath();
    notifyListeners();
  }

  void addGeofencePoint(LatLng point) {
    if (geofencePoints.length < 4) {
      geofencePoints.add(point);
      notifyListeners();
    }
  }

  void removeGeofencePoint(int index) {
    if (index >= 0 && index < geofencePoints.length) {
      geofencePoints.removeAt(index);
      notifyListeners();
    }
  }

  // Ordenar puntos solo en la inicialización para establecer un orden inicial
  void _sortPointsByClosestPath() {
    if (geofencePoints.length <= 1) return;

    List<LatLng> sortedPoints = [];
    Set<LatLng> remainingPoints = Set.from(geofencePoints);
    LatLng currentPoint = remainingPoints.first;
    sortedPoints.add(currentPoint);
    remainingPoints.remove(currentPoint);

    while (remainingPoints.isNotEmpty) {
      LatLng closestPoint = remainingPoints.reduce((a, b) =>
          distance.as(LengthUnit.Meter, currentPoint, a) <
                  distance.as(LengthUnit.Meter, currentPoint, b)
              ? a
              : b);
      sortedPoints.add(closestPoint);
      remainingPoints.remove(closestPoint);
      currentPoint = closestPoint;
    }

    geofencePoints = sortedPoints;
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
