import 'package:guardian_area/features/devices/domain/entities/device.dart';

class DeviceMapper {
  static Device fromJson(Map<String, dynamic> json) {
    return Device(
      guardianAreaDeviceRecordId: '',
      nickname: '',
      bearer: '',
      careMode: '',
      status: '',
      userId: '',
      apiKey: '',
    );
  }

  static Map<String, dynamic> toJson(Device device) {
    return {
      'guardianAreaDeviceRecordId': device.guardianAreaDeviceRecordId,
      'nickname': device.nickname,
      'bearer': device.bearer,
      'careMode': device.careMode,
      'status': device.status,
      'userId': device.userId,
      'apiKey': device.apiKey,
    };
  }
}
