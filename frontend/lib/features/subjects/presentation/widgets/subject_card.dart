import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/presentation/pages/subject_page.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback? onTap;

  const SubjectCard({super.key, required this.subject, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap:
            onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubjectPage(subject: subject),
                ),
              );
            },
        leading: CircleAvatar(
          backgroundColor: Color(subject.colorValue),
          child: Text(
            subject.code.substring(0, 2),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(subject.name),
        subtitle: Text(
          '${subject.code} • Semester ${subject.semester} • ${subject.credits} Credits',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
