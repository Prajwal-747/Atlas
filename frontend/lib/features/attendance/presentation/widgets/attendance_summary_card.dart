import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const AttendanceSummaryCard({
    super.key,
    required this.absentCount,
    required this.lateCount,
    required this.presentCount,
  });
  @override
  Widget build(BuildContext context) {
    final totalClasses = presentCount + absentCount + lateCount;
    final attendancePercentage = totalClasses == 0
        ? 0.0
        : ((presentCount + lateCount) / totalClasses) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Attendance'),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                '${attendancePercentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: attendancePercentage / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AttendanceStat(
                  label: 'Present',
                  value: presentCount,
                  color: Colors.green,
                ),
                _AttendanceStat(
                  label: 'Absent',
                  value: absentCount,
                  color: Colors.red,
                ),
                _AttendanceStat(
                  label: 'Late',
                  value: lateCount,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _AttendanceStat({
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
