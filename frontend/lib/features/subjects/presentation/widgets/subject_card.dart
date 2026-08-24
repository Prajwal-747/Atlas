import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/presentation/pages/subject_page.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/presentation/pages/edit_subject_page.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback? onTap;
  final VoidCallback? onChanged;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.onChanged,
  });

  Future<void> _deleteSubject(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject?'),
          content: Text('Are you sure you want to delete ${subject.name}?'),
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
      await ApiSubjectRepository().deleteSubject(subject.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Subject deleted')));
      onChanged?.call();
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete subject: $e')));
    }
  }

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
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditSubjectPage(subject: subject),
                ),
              );
              if (!context.mounted) return;
              if (updated == true) {
                onChanged?.call();
              }
            }
            if (value == 'delete') {
              _deleteSubject(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
