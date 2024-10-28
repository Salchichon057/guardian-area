import 'package:flutter/material.dart';

class GeofencesScreen extends StatelessWidget {
  const GeofencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Geofences Screen',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ), 
          ),
        ],
      ),
    );
  }
}
