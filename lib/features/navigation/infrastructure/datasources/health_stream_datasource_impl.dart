import 'dart:convert';
import 'package:guardian_area/features/navigation/domain/datasources/health_stream_datasource.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HealthStreamDatasourceImpl implements HealthStreamDatasource {
  final String baseUrl;

  HealthStreamDatasourceImpl({required this.baseUrl});

  @override
  Stream<HealthMeasure> connectToHealthStream(String roomId) {
    final WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('$baseUrl/health-measures-stream?room=$roomId'),
    );

    // Log de conexión
    print('Connected to WebSocket room: $roomId');

    return channel.stream.map((event) {
      // Log de datos recibidos
      print('Received data from WebSocket: $event');

      // Decodifica los datos y convierte a una entidad `HealthMeasure`
      final jsonData = jsonDecode(event as String) as Map<String, dynamic>;
      return HealthMeasure.fromJson(jsonData);
    }).handleError((error) {
      // Log de errores
      print('WebSocket error: $error');
      throw Exception('WebSocket connection error: $error');
    }).asBroadcastStream(); // Permite múltiples listeners al Stream.
  }
}
