import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';
import 'package:guardian_area/features/activities/infrastructure/infrastructure.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

// Provider para cargar todas las actividades
final allActivitiesProvider =
    FutureProvider.autoDispose<List<Activity>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  final storageService = ref.watch(keyValueStorageServiceProvider);

  try {
    final deviceRecordId =
        await storageService.getValue<String>('selectedDeviceRecordId');

    if (deviceRecordId == null) {
      throw Exception('No device selected');
    }

    return await repository.fetchActivities(deviceRecordId);
  } catch (e) {
    throw Exception('Failed to load activities: ${e.toString()}');
  }
});

// Provider para actividades filtradas
final filteredActivitiesProvider =
    Provider.autoDispose.family<List<Activity>, String>((ref, activityType) {
  final allActivitiesState = ref.watch(allActivitiesProvider);

  return allActivitiesState.maybeWhen(
    data: (allActivities) {
      if (activityType == 'ALL') {
        return allActivities;
      }

      return allActivities
          .where((activity) => activity.activityType == activityType)
          .toList();
    },
    orElse: () => [], // Lista vacía si no hay datos
  );
});

final activityTypeProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  return ['ALL', 'GPS', 'BPM', 'SPO2'];
});

// Repository y Datasource para cargar datos
final activityRepositoryProvider = Provider<ActivityRepositoryImpl>((ref) {
  final datasource = ref.watch(activityDatasourceProvider);
  return ActivityRepositoryImpl(datasource: datasource);
});

final activityDatasourceProvider = Provider<ActivityDatasourceImpl>((ref) {
  final storageService = ref.watch(keyValueStorageServiceProvider);
  return ActivityDatasourceImpl(storageService: storageService);
});
