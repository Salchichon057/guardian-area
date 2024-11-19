import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:guardian_area/features/navigation/infrastructure/datasources/health_stream_datasource_impl.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

class HealthStreamNotifier extends StateNotifier<AsyncValue<HealthMeasure>> {
  final HealthStreamDatasourceImpl datasource;
  final Ref ref;

  String? _currentApiKey;
  Stream<HealthMeasure>? _healthStream;
  StreamSubscription<String?>? _apiKeySubscription;

  HealthStreamNotifier({
    required this.datasource,
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final storageService = ref.read(keyValueStorageServiceProvider);

    try {
      _currentApiKey = await storageService.getValue<String>('selectedApiKey');

      if (_currentApiKey == null) {
        state = AsyncValue.error(
          'No API Key found',
          StackTrace.current,
        );
        return;
      }

      _connectToWebSocket(_currentApiKey!);

      _apiKeySubscription =
          Stream.periodic(const Duration(seconds: 1)).asyncMap((_) {
        return storageService.getValue<String>('selectedApiKey');
      }).listen((newApiKey) {
        if (newApiKey != null && newApiKey != _currentApiKey) {
          _currentApiKey = newApiKey;
          _connectToWebSocket(newApiKey);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void _connectToWebSocket(String apiKey) {
    try {
      datasource.disconnect();

      _healthStream = datasource.connectToHealthStream(apiKey);
      _healthStream!.listen(
        (data) {
          state = AsyncValue.data(data);
        },
        onError: (error) {
          state = AsyncValue.error(error, StackTrace.current);
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _apiKeySubscription?.cancel();
    datasource.disconnect();
    super.dispose();
  }
}
