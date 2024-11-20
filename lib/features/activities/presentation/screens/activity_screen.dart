import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardian_area/features/activities/presentation/provider/activity_provider.dart';
import 'package:guardian_area/features/activities/presentation/widgets/activity_table.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  String selectedActivityType = 'ALL';

  @override
  Widget build(BuildContext context) {
    final allActivitiesState = ref.watch(allActivitiesProvider);
    final activityTypeState = ref.watch(activityTypeProvider);

    // Estado filtrado calculado solo cuando hay datos
    final filteredActivities =
        ref.watch(filteredActivitiesProvider(selectedActivityType));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: const Color(0xFF08273A),
            onRefresh: () async {
              ref.invalidate(allActivitiesProvider); // Invalida y recarga
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Dropdown dinámico
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
                            value: selectedActivityType,
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF08273A),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator()), // Cargando tipos
                    error: (error, stackTrace) =>
                        const Text('Failed to load activity types'), // Error
                  ),
                ),

                allActivitiesState.when(
                  data: (_) {
                    return filteredActivities.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No activities found'),
                            ),
                          )
                        : ActivityTable(activities: filteredActivities);
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator()), // Cargando datos
                  error: (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/bell-slash-solid.svg',
                            width: 50,
                            height: 50,
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 16), // Espaciado
                          const Text(
                            'If you don\'t see the activities, please check if you have selected a device.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF08273A),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (allActivitiesState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF08273A),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
