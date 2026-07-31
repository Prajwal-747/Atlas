import 'package:flutter/material.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_action_tile.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_action_list.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_header.dart';

class SubjectPage extends StatelessWidget {
  final Subject subject;

  const SubjectPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubjectHeader(subject: subject),
            const SizedBox(height: 32),
            Text('Academic', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SubjectActionList(
              children: [
                SubjectActionTile(
                  icon: Icons.bar_chart,
                  title: 'Attendance',
                  subtitle: 'Track Attendance',
                  trailing: '87%',
                  onTap: () {},
                ),
                SubjectActionTile(
                  icon: Icons.schedule,
                  title: 'Timetable',
                  subtitle: 'View today\'s classes',
                  trailing: '3 Classes',
                  onTap: () {},
                ),
                SubjectActionTile(
                  icon: Icons.assignment,
                  title: 'Assignments',
                  subtitle: 'Manage coursework',
                  trailing: '2 Due',
                  onTap: () {},
                ),
                SubjectActionTile(
                  icon: Icons.note_alt,
                  title: 'Notes',
                  subtitle: 'Browse lecture notes',
                  trailing: '14 Notes',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
