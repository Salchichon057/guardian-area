import 'package:guardian_area/features/navigation/domain/datasources/health_stream_datasource.dart';
import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';
import 'package:guardian_area/features/navigation/domain/repositories/health_stream_repository.dart';

class HealthStreamRepositoryImpl extends HealthStreamRepository {
  final HealthStreamDatasource datasource;

  HealthStreamRepositoryImpl({required this.datasource});

  @override
  Stream<HealthMeasure> getHealthStream(String roomId) {
    return datasource.connectToHealthStream(roomId);
  }
}
