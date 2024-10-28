import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guardian_area/config/router/app_router_notifier.dart';
import 'package:guardian_area/features/auth/presentation/providers/auth_provider.dart';
import 'package:guardian_area/features/auth/presentation/screens/screens.dart';
import 'package:guardian_area/features/navigation/presentation/screens/main_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      // * Ruta para chequear autenticación
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      // * Rutas de Autenticación
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // * Ruta Principal de la App
      GoRoute(
        path: '/',
        builder: (context, state) => MainScreen(),
      ),
    ],

    // * Redirecciones basadas en el estado de autenticación
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      // Si está chequeando el estado de autenticación, no redirecciona
      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      // Si no está autenticado, redirige a login o registro
      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }
        return '/login';
      }

      // Si está autenticado, evita ir a login, registro o splash
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