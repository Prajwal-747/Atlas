import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';

class SubjectPage extends StatelessWidget {
  final Subject subject;

  const SubjectPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject.code, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Faculty: ${subject.facultyName ?? "Not Assigned"}'),
            Text('Semester: ${subject.semester}'),
            Text('Credits: ${subject.credits}'),

            Text('Classroom: ${subject.classroom ?? "Not Assigned"}'),
          ],
        ),
      ),
    );
  }
}
