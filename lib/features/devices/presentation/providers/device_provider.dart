// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final Ref ref;

  DeviceAssignNotifier({required this.repository, required this.ref}) : super(const AsyncData(null));

  Future<void> assignDeviceToUser(
      BuildContext context, String deviceRecordId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await repository.assignDeviceToUser(deviceRecordId, userId);

      final deviceNotifier = ref.read(deviceProvider(userId).notifier);
      await deviceNotifier.fetchDevices(userId);

      Navigator.of(context).pop();
    } on DioException catch (e, stackTrace) {
      final errorMessage = e.response?.data?['message']?.toString() ?? 'Device not found';
      state = AsyncValue.error(errorMessage, stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
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

final deviceAssignProvider =
    StateNotifierProvider<DeviceAssignNotifier, AsyncValue<void>>(
  (ref) {
    final repository = ref.watch(deviceRepositoryProvider);
    return DeviceAssignNotifier(repository: repository, ref: ref);
  },
);
