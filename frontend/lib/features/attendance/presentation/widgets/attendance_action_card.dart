import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';

class AttendanceActionCard extends StatelessWidget {
  final VoidCallback onPresent;
  final VoidCallback onLate;
  final VoidCallback onAbsent;

  const AttendanceActionCard({
    super.key,
    required this.onPresent,
    required this.onAbsent,
    required this.onLate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Today's Attendance"),

            const SizedBox(height: AppSpacing.md),

            FilledButton.icon(
              onPressed: onPresent,
              label: const Text("Present"),
              icon: const Icon(Icons.check_circle),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: onAbsent,
              label: const Text("Absent"),
              icon: Icon(Icons.cancel),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: onLate,
              label: const Text("Late"),
              icon: Icon(Icons.schedule),
            ),
          ],
        ),
      ),
    );
  }
}
