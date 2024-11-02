class Device {
  final String guardianAreaDeviceRecordId;
  final String nickname;
  final String bearer;
  final String careMode;
  final String status;
  final String userId;
  final String apiKey;

  Device({
    required this.guardianAreaDeviceRecordId,
    required this.nickname,
    required this.bearer,
    required this.careMode,
    required this.status,
    required this.userId,
    required this.apiKey,
  });
}
