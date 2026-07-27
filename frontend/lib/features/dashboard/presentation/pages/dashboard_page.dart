import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(child: Center(child: Text('Atlas')));
  }
}
