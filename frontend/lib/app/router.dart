import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/splash/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const splash = "/";
  static const login = "/login";
  static const home = "/home";

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}