import 'package:flutter/material.dart';
import 'package:guardian_area/features/activities/domain/entities/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(activity.activityName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${activity.activityType} - ${activity.dateAndTime.toLocal()}'),
        leading: const Icon(Icons.event, color: Color(0xFF08273A)),
      ),
    );
  }
}
