import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final greeting = switch (now.hour) {
      < 12 => "Good Morning",
      < 17 => "Good Afternoon",
      _ => "Good Evening",
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$greeting 👋", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, d MMMM').format(now),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
