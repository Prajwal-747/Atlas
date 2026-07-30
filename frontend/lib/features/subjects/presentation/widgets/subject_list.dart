import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_card.dart';

class SubjectList extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectList({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: subjects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SubjectCard(subject: subjects[index]);
      },
    );
  }
}
