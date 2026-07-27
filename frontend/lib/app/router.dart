import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
  ],
);
