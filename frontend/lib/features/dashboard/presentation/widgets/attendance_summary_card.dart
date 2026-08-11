import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final VoidCallback? onTap;
  const AttendanceSummaryCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    const attendance = 87;
    const present = 42;
    const absent = 6;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Attendance", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                "$attendance%",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: attendance / 100,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Present",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "$present",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text("Absent", style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    "$absent",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
