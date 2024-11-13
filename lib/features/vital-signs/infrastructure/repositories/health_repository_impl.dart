import 'package:guardian_area/features/vital-signs/domain/entities/health.dart';
import 'package:guardian_area/features/vital-signs/domain/repositories/health_repository.dart';
import 'package:guardian_area/features/vital-signs/infrastructure/datasource/health_datasource_impl.dart';

class HealthRepositoryImpl extends HealthRepository {
  final HealthDatasourceImpl datasource;

  HealthRepositoryImpl(this.datasource);

  @override
  Future<List<Health>> getHealthData(String deviceRecordId) {
    return datasource.getHealthData(deviceRecordId);
  }
}
