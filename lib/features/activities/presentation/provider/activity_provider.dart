import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';
import 'package:guardian_area/features/activities/infrastructure/infrastructure.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

// !Provider para cargar todas las actividades
final allActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  final storageService = ref.watch(keyValueStorageServiceProvider);
  final deviceRecordId =
      await storageService.getValue<String>('selectedDeviceRecordId');

  if (deviceRecordId == null) {
    throw Exception('No device selected');
  }

  return repository.fetchActivities(deviceRecordId);
});

final filteredActivitiesProvider =
    Provider.family<List<Activity>, String>((ref, activityType) {
  final allActivities = ref.watch(allActivitiesProvider).value ?? [];

  if (activityType == 'ALL') {
    return allActivities;
  }

  return allActivities
      .where((activity) => activity.activityType == activityType)
      .toList();
});

final activityTypeProvider = FutureProvider<List<String>>((ref) async {
  return ['ALL', 'GPS', 'BPM', 'SPO2'];
});

// !Repository y Datasource para cargar datos
final activityRepositoryProvider = Provider<ActivityRepositoryImpl>((ref) {
  final datasource = ref.watch(activityDatasourceProvider);
  return ActivityRepositoryImpl(datasource: datasource);
});

final activityDatasourceProvider = Provider<ActivityDatasourceImpl>((ref) {
  final storageService = ref.watch(keyValueStorageServiceProvider);
  return ActivityDatasourceImpl(storageService: storageService);
});
