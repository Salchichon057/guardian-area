// ignore_for_file: unused_result, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/devices/presentation/providers/device_provider.dart';
import 'package:guardian_area/features/devices/presentation/widgets/widgets.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userId = authState.userProfile?.id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Devices'),
        ),
        body: const Center(child: Text('User not authenticated')),
      );
    }

    final deviceAsyncValue = ref.watch(deviceProvider(userId.toString()));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Devices',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showAddDeviceDialog(context, ref, userId.toString());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08273A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF08273A),
                onRefresh: () async {
                  ref.refresh(deviceProvider(userId.toString()));
                  return Future.value();
                },
                child: deviceAsyncValue.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Error: ${error.toString().length > 50 ? '${error.toString().substring(0, 50)}...' : error.toString()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  data: (devices) {
                    if (devices.isEmpty) {
                      return const Center(child: Text('No devices found'));
                    }
                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return DeviceCard(
                          name: device.nickname,
                          careMode: device.careMode,
                          status: device.status,
                          statusColor: getStatusColor(device.status),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void showAddDeviceDialog(BuildContext context, WidgetRef ref, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AddDeviceDialog(
        onAssignDevice: (deviceId) async {
          final assignProvider = ref.read(deviceAssignProvider.notifier);
          await assignProvider.assignDeviceToUser(dialogContext, deviceId, userId);

          if (!ref.read(deviceAssignProvider).hasError) {
            if (Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext).pop();
            }
            ref.refresh(deviceProvider(userId));
          }
        },
      );
    },
  );
}


  Color getStatusColor(String status) {
    switch (status) {
      case 'CONNECTED':
        return Colors.green;
      case 'DISCONNECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
