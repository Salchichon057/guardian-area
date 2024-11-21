import 'package:guardian_area/features/chat/domain/entities/device_message.dart';
import 'package:guardian_area/features/chat/domain/entities/message.dart';

class MessageMapper {
  static Message fromDeviceMessage(DeviceMessage deviceMessage) {
    return Message(
      text: deviceMessage.message,
      fromWho: FromWho.device,
    );
  }

  static DeviceMessage toDeviceMessage(Message message) {
    return DeviceMessage(
      message: message.text,
    );
  }
}
