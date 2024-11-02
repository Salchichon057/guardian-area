import 'package:guardian_area/features/devices/domain/entities/device.dart';

abstract class DeviceRepository {
  Future<Device> assignDeviceToUser(String deviceRecordId, String userId);
  Future<List<Device>> getAllDevices(String userId);
  Future<Device> updateDevice(String bearer, String deviceNickname,
      String deviceCareModes, String deviceStatuses, String deviceRecordId);
}
