import 'package:go_router/go_router.dart';
import 'package:guardian_area/features/auth/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
  // TODO: Bloquear si no se está autenticado de alguna manera
);
