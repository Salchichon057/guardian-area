import 'dart:convert'; // Import para jsonDecode
import 'package:guardian_area/features/home/domain/datasources/current_location_datasource.dart';
import 'package:guardian_area/features/home/domain/entities/current_location.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CurrentLocationDatasourceImpl extends CurrentLocationDatasource {
  WebSocketChannel? _channel;
  String baseUrl = 'wss://guardianarea.azurewebsites.net';

  @override
  Stream<CurrentLocation> connectToCurrentLocationStream(String roomId) {
    disconnect();

    final uri = Uri.parse('$baseUrl/location-stream?room=$roomId');
    print(
        'Connecting to WebSocket at: $uri'); // Print para rastrear la conexión
    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      try {
        print('Raw data received: $event'); // Print para ver los datos crudos
        // Convertir el String JSON a Map<String, dynamic>
        final jsonData = jsonDecode(event) as Map<String, dynamic>;
        final location = CurrentLocation.fromJson(jsonData);
        print(
            'Parsed CurrentLocation: $location'); // Print después de parsear los datos
        return location;
      } catch (e) {
        print(
            'Error parsing WebSocket data: $e'); // Print para manejar errores de parsing
        return CurrentLocation(latitude: 0, longitude: 0, riskLevel: '');
      }
    }).handleError((error) {
      print('WebSocket error: $error'); // Print para errores generales
      return CurrentLocation(latitude: 0, longitude: 0, riskLevel: '');
    });
  }

  void disconnect() {
    if (_channel != null) {
      print('Disconnecting from WebSocket'); // Print cuando se desconecta
      _channel!.sink.close();
      _channel = null;
    }
  }
}
