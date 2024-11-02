import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/devices/domain/entities/device.dart';
import 'package:guardian_area/features/devices/infrastructure/infrastructure.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

class DeviceNotifier extends StateNotifier<AsyncValue<List<Device>>> {
  final DeviceRepositoryImpl repository;

  DeviceNotifier({required this.repository}) : super(const AsyncLoading());

  Future<void> fetchDevices(String userId) async {
    try {
      final devices = await repository.getAllDevices(userId);
      state = AsyncValue.data(devices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class DeviceAssignNotifier extends StateNotifier<AsyncValue<void>> {
  final DeviceRepositoryImpl repository;

  DeviceAssignNotifier({required this.repository}) : super(const AsyncData(null));

  Future<void> assignDeviceToUser(String deviceRecordId, String userId) async {
    state = const AsyncLoading();
    try {
      await repository.assignDeviceToUser(deviceRecordId, userId);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final deviceRepositoryProvider = Provider<DeviceRepositoryImpl>((ref) {
  final datasource = ref.watch(deviceDatasourceProvider);
  return DeviceRepositoryImpl(datasource);
});

final deviceDatasourceProvider = Provider<DeviceDatasourceImpl>((ref) {
  return DeviceDatasourceImpl(
    storageService: ref.watch(keyValueStorageServiceProvider),
  );
});

final deviceProvider = StateNotifierProvider.family<DeviceNotifier,
    AsyncValue<List<Device>>, String>(
  (ref, userId) {
    final repository = ref.watch(deviceRepositoryProvider);
    final notifier = DeviceNotifier(repository: repository);
    notifier.fetchDevices(userId);
    return notifier;
  },
);

final deviceAssignProvider = StateNotifierProvider<DeviceAssignNotifier, AsyncValue<void>>(
  (ref) {
    final repository = ref.watch(deviceRepositoryProvider);
    return DeviceAssignNotifier(repository: repository);
  },
);
