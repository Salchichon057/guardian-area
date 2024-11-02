import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/devices/domain/entities/device.dart';
import 'package:guardian_area/features/devices/infrastructure/infrastructure.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

final deviceProvider = FutureProvider.autoDispose.family<List<Device>, String>((ref, userId) async {
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getAllDevices(userId);
});

final deviceRepositoryProvider = Provider<DeviceRepositoryImpl>((ref) {
  final datasource = ref.watch(deviceDatasourceProvider);
  return DeviceRepositoryImpl(datasource);
});

final deviceDatasourceProvider = Provider<DeviceDatasourceImpl>((ref) {
  return DeviceDatasourceImpl(
    storageService: ref.watch(keyValueStorageServiceProvider),
  );
});