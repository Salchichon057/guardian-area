import 'package:guardian_area/features/vital-signs/domain/entities/health.dart';

abstract class HealthRepository {
  Future<List<Health>> getHealthData(String deviceRecordId);
}
