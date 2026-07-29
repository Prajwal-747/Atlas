import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(child: Center(child: Text("Tasks Page")));
  }
}
