// geofence_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/domain/repositories/geofence_repository.dart';
import 'package:guardian_area/features/geofences/presentation/providers/geofence_repository_provider.dart';

class GeofenceState {
  final List<Geofence> geofences;
  final bool isLoading;
  final String? errorMessage;

  GeofenceState({
    this.geofences = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GeofenceState copyWith({
    List<Geofence>? geofences,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GeofenceState(
      geofences: geofences ?? this.geofences,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class GeofenceNotifier extends StateNotifier<GeofenceState> {
  final GeofenceRepository repository;

  GeofenceNotifier(this.repository) : super(GeofenceState()) {
    loadGeofences();
  }

  // Future<void> loadGeofences() async {
  //   state = state.copyWith(isLoading: true);
  //   try {
  //     final geofences = await repository.fetchGeofences();
  //     state = state.copyWith(geofences: geofences, isLoading: false);
  //   } catch (e) {
  //     state = state.copyWith(errorMessage: e.toString(), isLoading: false);
  //   }
  // }
  Future<void> loadGeofences() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      final simulatedGeofences = [
        Geofence(
          name: 'Geofence 01',
          status: 'Active',
          coordinates: [
            Coordinate(latitude: -12.0464, longitude: -77.0428)
          ],
          guardianAreaDeviceRecordId: 'device1',
        ),
        Geofence(
          name: 'Geofence 02',
          status: 'Active',
          coordinates: [Coordinate(latitude: -12.0464, longitude: -77.0428)],
          guardianAreaDeviceRecordId: 'device2',
        ),
        Geofence(
          name: 'Geofence 03',
          status: 'Active',
          coordinates: [Coordinate(latitude: -12.0464, longitude: -77.0428)],
          guardianAreaDeviceRecordId: 'device3',
        ),
      ];

      state = state.copyWith(geofences: simulatedGeofences, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> addGeofence(Geofence geofence) async {
    try {
      await repository.createGeofence(geofence);
      loadGeofences(); // Recargar geocercas después de añadir
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final geofenceProvider =
    StateNotifierProvider<GeofenceNotifier, GeofenceState>((ref) {
  final repository = ref.read(geofenceRepositoryProvider);
  return GeofenceNotifier(repository);
});
