import 'package:flutter/material.dart';
import '../../domain/entities/class_session.dart';

class SessionTile extends StatelessWidget {
  final ClassSession session;
  final VoidCallback? onTap;

  const SessionTile({super.key, required this.session, this.onTap});

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
                  const Icon(Icons.chevron_right),
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
