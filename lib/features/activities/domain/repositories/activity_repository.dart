import 'package:guardian_area/features/activities/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> fetchActivities(String selectedDeviceRecordId);
}
