import 'package:guardian_area/features/navigation/domain/entities/health_measure.dart';

abstract class HealthStreamRepository {
  Stream<HealthMeasure> getHealthStream(String roomId);
}
