import 'package:guardian_area/features/activities/domain/entities/activity.dart';

abstract class ActivityDatasource {
  Future<List<Activity>> fetchActivities(String selectedDeviceRecordId);
}
