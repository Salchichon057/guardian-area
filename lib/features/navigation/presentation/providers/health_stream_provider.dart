import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:guardian_area/features/navigation/infrastructure/datasources/health_stream_datasource_impl.dart';
import 'package:guardian_area/features/navigation/infrastructure/repositories/health_stream_repository_impl.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

final healthStreamProvider =
    StreamProvider.autoDispose<HealthMeasure>((ref) async* {
  final storageService = ref.watch(keyValueStorageServiceProvider);

  // Obtener el API Key del almacenamiento
  // final selectedApiKey = await storageService.getValue<String>('selectedApiKey');
  const selectedApiKey = 'UJ5AOv3WKh-JW_PFaz_QQ3KkxJ1La5cz';

  if (selectedApiKey == null) {
    throw Exception('No API Key found for the selected device.');
  }

  const baseUrl = 'ws://guardianarea.azurewebsites.net';
  final datasource = HealthStreamDatasourceImpl(baseUrl: baseUrl);
  final repository = HealthStreamRepositoryImpl(datasource: datasource);

  // Emitir el flujo de datos como objetos `HealthMeasure`
  yield* repository.getHealthStream(selectedApiKey);
});
