import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  // routes: [GoRoute(path: '/', builder: (_, _) => const NavigationPage())],
  routes: [GoRoute(path: '/', builder: (_, _) => const LoginPage())],
);
