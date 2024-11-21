import 'package:guardian_area/features/chat/domain/datasources/chat_stream_datasource.dart';
import 'package:guardian_area/features/chat/domain/entities/device_message.dart';
import 'package:guardian_area/features/chat/domain/repositories/chat_stream_repository.dart';

class ChatStreamRepositoryImpl extends ChatStreamRepository {
  final ChatStreamDatasource datasource;

  ChatStreamRepositoryImpl({required this.datasource});

  @override
  Stream<DeviceMessage> connectToDevice(String roomId) {
    return datasource.connectToDevice(roomId);
  }
}
