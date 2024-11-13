import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guardian_area/config/router/app_router_notifier.dart';
import 'package:guardian_area/features/activities/presentation/screens/screens.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/auth/presentation/screens/screens.dart';
import 'package:guardian_area/features/chat/presentation/screens/screens.dart';
import 'package:guardian_area/features/devices/presentation/screens/screens.dart';
import 'package:guardian_area/features/geofences/domain/entities/geofence.dart';
import 'package:guardian_area/features/geofences/presentation/screens/screens.dart';
import 'package:guardian_area/features/home/presentation/screens/screens.dart';
import 'package:guardian_area/features/navigation/presentation/screens/main_screen.dart';
import 'package:guardian_area/features/profile/presentation/screens/screens.dart';
import 'package:guardian_area/features/settings/presentation/screens/screens.dart';
import 'package:guardian_area/features/vital-signs/presentation/screens/screens.dart';

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
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          //! BottomNavigationBar Routes
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/activities',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/vital-signs',
            builder: (context, state) => const VitalSignsScreen(),
          ),
          GoRoute(
            path: '/geofences',
            builder: (context, state) => const GeofencesScreen(),
          ),

          // !Into geofences
          GoRoute(
            path: '/geofences/create',
            builder: (context, state) => const GeofenceDetailsScreen(
              isEditMode: false,
            ),
          ),
          GoRoute(
            path:
                '/geofences/detail/:id',
            builder: (context, state) {
              final geofence = state.extra as Geofence;
              return GeofenceDetailsScreen(
                geofence: geofence,
                isEditMode: true,
              );
            },
          ),

          //! AppNavigator Routes
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/devices',
            builder: (context, state) => const DevicesScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authStatus = goRouterNotifier.authStatus;
      final isGoingTo = state.matchedLocation;

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
