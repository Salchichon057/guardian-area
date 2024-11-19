import 'package:guardian_area/features/activities/domain/entities/activity.dart';

class ActivityMapper {
  static Activity fromJson(Map<String, dynamic> json) {
    return Activity(
      guardianAreaDeviceRecordId: json["guardianAreaDeviceRecordId"],
      activityName: json["activityName"],
      activityType: json["activityType"],
      dateAndTime: DateTime.parse(json["dateAndTime"]),
    );
  }

  static Map<String, dynamic> toJson(Activity activity) {
    return {
      "guardianAreaDeviceRecordId": activity.guardianAreaDeviceRecordId,
      "activityName": activity.activityName,
      "activityType": activity.activityType,
      "dateAndTime": activity.dateAndTime.toIso8601String(),
    };
  }
}
