import 'package:guardian_area/features/chat/domain/datasources/chat_stream_datasource.dart';
import 'package:guardian_area/features/chat/domain/entities/device_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatStreamDatasourceImpl extends ChatStreamDatasource {
  WebSocketChannel? _channel;
  String baseUrl = 'wss://guardianarea.azurewebsites.net';

  @override
  Stream<DeviceMessage> connectToDevice(String roomId) {
    disconnect();

    final uri = Uri.parse('$baseUrl/chat-stream?room=$roomId');
    print('Connecting to WebSocket at: $uri');

    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      try {
        print('Raw data received: $event');
        final message = DeviceMessage.fromJson(event);
        return message;
      } catch (e) {
        print('Error parsing WebSocket data: $e');
        return DeviceMessage(message: 'Error parsing message');
      }
    }).handleError((error) {
      print('WebSocket error: $error');
      return DeviceMessage(message: 'Error parsing message');
    });
  }

  void disconnect() {
    if (_channel != null) {
      print('Disconnecting from WebSocket');
      _channel!.sink.close();
      _channel = null;
    }
  }
}
