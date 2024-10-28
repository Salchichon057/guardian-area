import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/navigation/infrastructure/providers/navigation_provider.dart';
import 'package:guardian_area/features/navigation/presentation/widgets/custom_app_bar.dart';
import 'package:guardian_area/features/navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:guardian_area/features/home/presentation/screens/home_screen.dart';
import 'package:guardian_area/features/profile/presentation/screens/profile_screen.dart';
import 'package:guardian_area/features/monitoring/presentation/screens/monitoring_screen.dart';

class MainScreen extends ConsumerWidget {
  MainScreen({super.key});

  final List<Widget> _screens = [
    const HomeScreen(),
    const MonitoringScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: _screens[navigationState.selectedIndex],
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
