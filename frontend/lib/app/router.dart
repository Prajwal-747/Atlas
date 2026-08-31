import 'package:frontend/core/network/token_storage.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';
import 'package:frontend/features/navigation/presentation/pages/navigation_page.dart';
import 'package:go_router/go_router.dart';

final TokenStorage tokenStorage = TokenStorage();

final GoRouter appRouter = GoRouter(
  redirect: (context, state) async {
    final token = await tokenStorage.getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;
    final isAuthPage =
        state.matchedLocation == '/' || state.matchedLocation == '/register';

    if (!isLoggedIn && !isAuthPage) {
      return '/';
    }

    if (isLoggedIn && isAuthPage) {
      return '/app';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/app', builder: (_, _) => const NavigationPage()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
  ],
);
