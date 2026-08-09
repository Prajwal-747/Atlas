import 'package:frontend/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/domain/enums/effort_required.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final Subject? subject;
  final bool showSubject;
  final VoidCallback? onTap;

  const AssignmentCard({
    super.key,
    required this.assignment,
    this.subject,
    this.showSubject = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSubject && subject != null)
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: subject!.color,
                    radius: 5,
                  ),
                  label: Text(subject!.name),
                  visualDensity: VisualDensity.compact,
                ),

              if (showSubject) const SizedBox(height: AppSpacing.sm),

              Text(
                assignment.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                assignment.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),

                  Text(
                    formatDueDate(assignment.dueDate),
                    style: TextStyle(
                      color: assignment.dueDate.isBefore(DateTime.now())
                          ? Colors.red
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    avatar: Icon(
                      _statusIcon(),
                      size: 18,
                      color: _statusColor(),
                    ),
                    label: Text(_statusText()),
                  ),
                  Chip(
                    avatar: Icon(
                      Icons.local_fire_department,
                      size: 18,
                      color: _effortColor(),
                    ),
                    label: Text(_effortText()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _effortColor() {
    switch (assignment.effortRequired) {
      case EffortRequired.veryLow:
        return Colors.green;
      case EffortRequired.low:
        return Colors.lightGreen;
      case EffortRequired.medium:
        return Colors.orange;
      case EffortRequired.high:
        return Colors.deepOrange;
      case EffortRequired.veryHigh:
        return Colors.red;
    }
  }

  String _statusText() {
    switch (assignment.status) {
      case AssignmentStatus.notStarted:
        return "Not Started";
      case AssignmentStatus.inProgress:
        return "In Progress";
      case AssignmentStatus.submitted:
        return "Submitted";
      case AssignmentStatus.graded:
        return "Graded";
    }
  }

  String _effortText() {
    switch (assignment.effortRequired) {
      case EffortRequired.veryLow:
        return "Very Low Effort";
      case EffortRequired.low:
        return "Low";
      case EffortRequired.medium:
        return "Medium";
      case EffortRequired.high:
        return "High";
      case EffortRequired.veryHigh:
        return "Very High";
    }
  }

  Color _statusColor() {
    switch (assignment.status) {
      case AssignmentStatus.notStarted:
        return Colors.grey;
      case AssignmentStatus.inProgress:
        return Colors.orange;
      case AssignmentStatus.submitted:
        return Colors.blue;
      case AssignmentStatus.graded:
        return Colors.green;
    }
  }

  IconData _statusIcon() {
    switch (assignment.status) {
      case AssignmentStatus.notStarted:
        return Icons.schedule;
      case AssignmentStatus.inProgress:
        return Icons.edit;
      case AssignmentStatus.submitted:
        return Icons.upload_file;
      case AssignmentStatus.graded:
        return Icons.check_circle;
    }
  }

  String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = due.difference(today).inDays;

    if (difference == 0) return "Due Today";
    if (difference == 1) return "Due Tomorrow";
    if (difference > 1) return "Due in $difference days";

    return "Overdue by ${-difference} days";
  }
}
