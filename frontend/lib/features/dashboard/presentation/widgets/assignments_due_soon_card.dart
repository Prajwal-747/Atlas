import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';

class AssignmentsDueSoonCard extends StatelessWidget {
  final List<Assignment> assignments;
  final void Function(Assignment assignment)? onAssignmentTap;
  final VoidCallback? onViewAll;

  const AssignmentsDueSoonCard({
    super.key,
    required this.assignments,
    this.onAssignmentTap,
    this.onViewAll,
  });
  @override
  Widget build(BuildContext context) {
    final activeAssignments =
        assignments
            .where(
              (assignment) =>
                  assignment.status != AssignmentStatus.submitted &&
                  assignment.status != AssignmentStatus.graded,
            )
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final upcomingAssignments = activeAssignments.take(3).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: SectionTitle(title: 'Assignments Due Soon'),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (upcomingAssignments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(Icons.assessment_outlined),
                    SizedBox(width: AppSpacing.sm),
                    Text('No upcoming assignments.'),
                  ],
                ),
              )
            else
              ...upcomingAssignments.map(
                (assignment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    assignment.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_formatDueDate(assignment.dueDate)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onAssignmentTap == null
                      ? null
                      : () => onAssignmentTap!(assignment),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = due.difference(today).inDays;
    if (difference < 0) {
      return 'Overdue';
    }
    if (difference == 0) {
      return 'Due Today';
    }
    if (difference == 1) {
      return 'Due Tomorrow';
    }
    return 'Due in $difference days';
  }
}
