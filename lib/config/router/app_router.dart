import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guardian_area/config/router/app_router_notifier.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/auth/presentation/screens/screens.dart';
import 'package:guardian_area/features/navigation/presentation/screens/main_screen.dart';
import 'package:guardian_area/features/devices/presentation/screens/devices_screen.dart';
import 'package:guardian_area/features/home/presentation/screens/home_screen.dart';
import 'package:guardian_area/features/monitoring/presentation/screens/monitoring_screen.dart';
import 'package:guardian_area/features/profile/presentation/screens/profile_screen.dart';
import 'package:guardian_area/features/settings/presentation/screens/settings_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ShellRoute principal con BottomNavigationBar
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/monitoring',
            builder: (context, state) => const MonitoringScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/devices', // Define devices route here within the ShellRoute
            builder: (context, state) => const DevicesScreen(),
          ),
          // Ruta para Settings sin BottomNavigationBar
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
