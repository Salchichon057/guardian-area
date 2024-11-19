import 'package:guardian_area/features/activities/domain/datasources/activity_datasource.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';
import 'package:guardian_area/features/activities/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl extends ActivityRepository {
  final ActivityDatasource datasource;

  ActivityRepositoryImpl({required this.datasource});

  @override
  Future<List<Activity>> fetchActivities(
      String selectedDeviceRecordId) {
    return datasource.fetchActivities(selectedDeviceRecordId);
  }
}
