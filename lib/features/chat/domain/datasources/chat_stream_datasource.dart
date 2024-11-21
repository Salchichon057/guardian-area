import 'package:guardian_area/features/chat/domain/entities/device_message.dart';

abstract class ChatStreamDatasource {
  Stream<DeviceMessage> connectToDevice(String roomId);
}
