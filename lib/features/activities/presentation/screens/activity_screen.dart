import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/activities/presentation/provider/activity_provider.dart';
import 'package:guardian_area/features/activities/presentation/widgets/activity_card.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const activityType = 'GPS';
    final activityState = ref.watch(activityProvider(activityType));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: const Color(0xFF08273A),
      ),
      body: activityState.when(
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(child: Text('No activities found'));
          }
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ActivityCard(activity: activity);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
