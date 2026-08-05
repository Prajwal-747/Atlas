import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';

class AttendanceInsightsCard extends StatelessWidget {
  final int totalClasses;
  final double percentage;

  const AttendanceInsightsCard({
    super.key,
    required this.totalClasses,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    String message;

    if (percentage >= 90) {
      message = "Excellant attendance. Keep it up!";
    } else if (percentage >= 85) {
      message = "You're safely above the minimum attendance.";
    } else {
      message = "Attendance is below the safe limit";
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Insights"),
            const SizedBox(height: AppSpacing.md),

            Text("Total Classes: $totalClasses"),

            const SizedBox(height: 8),

            Text(message),
          ],
        ),
      ),
    );
  }
}
