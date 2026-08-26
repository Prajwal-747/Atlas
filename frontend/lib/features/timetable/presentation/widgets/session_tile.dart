import 'package:flutter/material.dart';
import 'package:frontend/features/timetable/data/repositories/api_timetable_repository.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/presentation/pages/edit_timetable_session_page.dart';

class SessionTile extends StatelessWidget {
  final ClassSession session;
  final VoidCallback? onTap;
  final VoidCallback? onChanged;

  const SessionTile({
    super.key,
    required this.session,
    this.onTap,
    this.onChanged,
  });

  Future<void> _deleteSession(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Class?'),
          content: Text(
            'Are you sure you want to delete ${session.subjectName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await ApiTimetableRepository().deleteSession(session.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Class deleted')));
      onChanged?.call();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete class: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${session.startTime.format24Hour()} - ${session.endTime.format24Hour()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditTimetableSessionPage(session: session),
                          ),
                        );
                        if (!context.mounted) return;

                        if (updated == true) {
                          onChanged?.call();
                        }
                      }
                      if (value == 'delete') {
                        await _deleteSession(context);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                session.subjectName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
