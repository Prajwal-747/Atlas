import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';

class SubjectHeader extends StatelessWidget {
  final Subject subject;

  const SubjectHeader({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(subject.colorValue),
              child: Text(
                subject.code.substring(0, 2),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(subject.code),
                  Text(
                    'Semester ${subject.semester} • ${subject.credits} Credits',
                  ),
                  if (subject.facultyName != null || subject.classroom != null)
                    Text(
                      '${subject.facultyName ?? ''}'
                      '${subject.facultyName != null && subject.classroom != null ? ' • ' : ''}'
                      '${subject.classroom ?? ''}',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
