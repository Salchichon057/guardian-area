import 'package:guardian_area/features/chat/domain/datasources/chat_stream_datasource.dart';
import 'package:guardian_area/features/chat/domain/entities/device_message.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatStreamDatasourceImpl extends ChatStreamDatasource {
  WebSocketChannel? _channel;
  String baseUrl = 'wss://guardianarea.azurewebsites.net';

  @override
  Stream<DeviceMessage> connectToDevice(String roomId) {
    disconnect();

    final uri = Uri.parse('$baseUrl/chat-stream?room=$roomId');
    // print('Connecting to WebSocket at: $uri');

    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      try {
        if (_isJson(event)) {
          final jsonData = jsonDecode(event);
          final message = DeviceMessage.fromJson(jsonData);
          // print('Parsed WebSocket message: $message');
          return message;
        } else if (event == 'ALARM_ON') {
          // print('Received plain text message: $event');
          return DeviceMessage(message: 'The alarm is active');
        } else {
          return DeviceMessage(message: 'Waiting alarm');
        }
      } catch (e) {
        // print('Error parsing WebSocket data: $e');
        return DeviceMessage(
            message: 'Sorry, I tried to get the message but I failed');
      }
    }).handleError((error) {
      // print('WebSocket error: $error');
      return DeviceMessage(
          message: 'Sorry, but I failed to connect to the Device');
    });
  }

  void sendMessage(String text) {
    if (_channel != null) {
      // print('Sending message: $text');
      _channel!.sink.add(text);
    } else {
      // print('Cannot send message, WebSocket is not connected.');
    }
  }

  void disconnect() {
    if (_channel != null) {
      // print('Disconnecting from WebSocket');
      _channel!.sink.close();
      _channel = null;
    }
  }

  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }
}
