import 'package:frontend/features/navigation/presentation/pages/navigation_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (_, _) => const NavigationPage())],
);
