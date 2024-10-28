import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guardian_area/features/navigation/infrastructure/providers/navigation_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final navigationNotifier = ref.read(navigationProvider.notifier);

    return BottomNavigationBar(
      currentIndex: navigationState.selectedIndex,
      onTap: (index) {
        navigationNotifier.updateIndex(index);

        if (index == 0) context.go('/');
        if (index == 1) context.go('/activities');
        if (index == 2) context.go('/profile');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Activities'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Vital signs'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Geofences'),
      ],
    );
  }
}
