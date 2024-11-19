import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:guardian_area/features/navigation/infrastructure/datasources/health_stream_datasource_impl.dart';
import 'package:guardian_area/features/navigation/presentation/providers/health_stream_notifier.dart';

final healthStreamProvider =
    StateNotifierProvider<HealthStreamNotifier, AsyncValue<HealthMeasure>>(
  (ref) {
    final datasource = HealthStreamDatasourceImpl(
      baseUrl: 'wss://guardianarea.azurewebsites.net',
    );
    return HealthStreamNotifier(datasource: datasource, ref: ref);
  },
);
