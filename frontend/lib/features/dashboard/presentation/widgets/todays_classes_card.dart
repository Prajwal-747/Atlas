import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';

class TodaysClassesCard extends StatelessWidget {
  final VoidCallback? onTap;
  final List<ClassSession> sessions;
  const TodaysClassesCard({super.key, required this.sessions, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "Today's Classes"),
              const SizedBox(height: AppSpacing.md),
              if (sessions.isEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      "No Classes scheduled today",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                )
              else
                ...sessions
                    .take(3)
                    .map(
                      (session) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                session.startTime.format24Hour(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.subjectName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${session.startTime.format24Hour()} - '
                                    '${session.endTime.format24Hour()}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
              if (sessions.length > 3) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '+ ${sessions.length - 3} more',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
