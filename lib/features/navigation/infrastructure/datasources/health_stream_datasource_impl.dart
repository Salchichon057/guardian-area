import 'dart:convert';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HealthStreamDatasourceImpl {
  final String baseUrl;
  WebSocketChannel? _channel;

  HealthStreamDatasourceImpl({required this.baseUrl});

  Stream<HealthMeasure> connectToHealthStream(String roomId) {

    print('Connecting to $baseUrl/health-measures-stream?room=$roomId');


    final uri = Uri.parse('$baseUrl/health-measures-stream?room=$roomId');
    _channel = WebSocketChannel.connect(uri);

    print('Connected to $uri');

    return _channel!.stream.map((event) {
      try {
        final jsonData = jsonDecode(event as String) as Map<String, dynamic>;

        print('Received data: $jsonData');

        return HealthMeasure.fromJson(jsonData);
      } catch (e) {
        print('Error parsing data: $e');

        return HealthMeasure(bpm: 0, spo2: 0);
      }
    }).handleError((error) {
      print('Error: $error');
      return HealthMeasure(bpm: 0, spo2: 0);
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
