import 'package:guardian_area/features/home/domain/datasources/current_location_datasource.dart';
import 'package:guardian_area/features/home/domain/entities/current_location.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CurrentLocationDatasourceImpl extends CurrentLocationDatasource {
  WebSocketChannel? _channel;
  String baseUrl = 'wss://guardianarea.azurewebsites.net';

  @override
  Stream<CurrentLocation> connectToCurrentLocationStream(String roomId) {
    disconnect();

    final uri = Uri.parse('$baseUrl/current-location-stream?room=$roomId');
    _channel = WebSocketChannel.connect(uri);

    return _channel!.stream.map((event) {
      try {
        final jsonData = event as Map<String, dynamic>;
        return CurrentLocation.fromJson(jsonData);
      } catch (e) {
        return CurrentLocation(latitude: 0, longitude: 0, riskLevel: '');
      }
    }).handleError((error) {
      return CurrentLocation(latitude: 0, longitude: 0, riskLevel: '');
    });
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }
}
