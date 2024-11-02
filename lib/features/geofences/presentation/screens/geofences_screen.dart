import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/geofences/presentation/providers/geofence_provider.dart';
import 'package:guardian_area/features/geofences/presentation/widgets/geofence_card.dart';

class GeofencesScreen extends ConsumerStatefulWidget {
  const GeofencesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GeofencesScreenState createState() => _GeofencesScreenState();
}

class _GeofencesScreenState extends ConsumerState<GeofencesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(geofenceProvider.notifier).loadGeofences());
  }

  @override
  Widget build(BuildContext context) {
    final geofenceState = ref.watch(geofenceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of geofences', style: TextStyle(fontSize: 20),),
      ),
      body: geofenceState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: geofenceState.geofences.length,
              itemBuilder: (context, index) {
                final geofence = geofenceState.geofences[index];
                return GeofenceCard(geofence: geofence);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar una nueva geocerca
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
