import 'package:guardian_area/features/chat/domain/entities/device_message.dart';

abstract class ChatStreamRepository {
  Stream<DeviceMessage> connectToDevice(String roomId);
}