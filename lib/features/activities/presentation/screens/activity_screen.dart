// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/activities/presentation/provider/activity_provider.dart';
import 'package:guardian_area/features/activities/presentation/widgets/activity_table.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  String? selectedActivityType;

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de tipos de actividades
    final activityTypeState = ref.watch(activityTypeProvider);

    // Obtenemos las actividades basadas en el tipo seleccionado
    final activityState = ref.watch(
      activityProvider(selectedActivityType ?? 'ALL'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: activityTypeState.when(
              data: (types) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value: selectedActivityType ?? types.first,
                      items: types.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedActivityType = value;
                          });
                        }
                      },
                      style: const TextStyle(
                        color: Color(0xFF08273A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Text('Failed to load activity types'),
            ),
          ),
      
          activityState.when(
            data: (activities) {
              if (activities.isEmpty) {
                return const Center(child: Text('No activities found'));
              }
              return ActivityTable(activities: activities);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}
