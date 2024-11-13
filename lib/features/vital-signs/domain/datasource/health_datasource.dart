import 'package:guardian_area/features/vital-signs/domain/entities/health.dart';

abstract class HealthDatasource {
  Future<List<Health>> getHealthData(String deviceRecordId);
}
