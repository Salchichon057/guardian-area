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
      activityProvider(selectedActivityType ?? 'GPS'), // Default: GPS
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        backgroundColor: const Color(0xFF08273A),
      ),
      body: Column(
        children: [
          // Dropdown dinámico basado en los tipos de actividad
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: activityTypeState.when(
              data: (types) {
                return DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Filter by Activity Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Text('Failed to load types'),
            ),
          ),

          // Tabla de actividades
          Expanded(
            child: activityState.when(
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
          ),
        ],
      ),
    );
  }
}
