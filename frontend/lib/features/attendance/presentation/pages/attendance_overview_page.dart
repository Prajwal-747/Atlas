import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/core/widgets/section_title.dart';
import 'package:frontend/features/attendance/data/repositories/mock_attendance_repository.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/presentation/pages/attendance_page.dart';
import 'package:frontend/features/subjects/data/repositories/mock_subject_repository.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';

class AttendanceOverviewPage extends StatefulWidget {
  const AttendanceOverviewPage({super.key});

  @override
  State<AttendanceOverviewPage> createState() => _AttendanceOverviewPageState();
}

class _AttendanceOverviewPageState extends State<AttendanceOverviewPage> {
  final MockSubjectRepository subjectRepository = MockSubjectRepository();
  final MockAttendanceRepository attendanceRepository =
      MockAttendanceRepository();
  late Future<List<Subject>> subjects;

  @override
  void initState() {
    super.initState();
    subjects = subjectRepository.getAllSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Attendance Overview',
      child: FutureBuilder<List<Subject>>(
        future: subjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subjects found.'));
          }
          final subjectList = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionTitle(title: 'Subject Attendance'),
              const SizedBox(height: 12),
              ...subjectList.map(
                (subject) => _AttendanceSubjectCard(
                  subject: subject,
                  attendanceRepository: attendanceRepository,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendancePage(
                          subjectId: subject.id,
                          subjectName: subject.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AttendanceSubjectCard extends StatelessWidget {
  final Subject subject;
  final MockAttendanceRepository attendanceRepository;
  final VoidCallback onTap;

  const _AttendanceSubjectCard({
    required this.subject,
    required this.attendanceRepository,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AttendanceRecord>>(
      future: attendanceRepository.getAttendanceForSubject(subject.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: ListTile(
              title: Text(subject.name),
              subtitle: const Text('Unable to load attendance'),
            ),
          );
        }
        final records = snapshot.data ?? [];
        final presentCount = records
            .where((record) => record.status == AttendanceStatus.present)
            .length;
        final lateCount = records
            .where((record) => record.status == AttendanceStatus.late)
            .length;
        final totalClasses = records.length;
        final percentage = totalClasses == 0
            ? 0.0
            : ((presentCount + lateCount) / totalClasses) * 100;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 6, backgroundColor: subject.color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          subject.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: percentage / 100),
                  const SizedBox(height: 8),
                  Text(
                    '$presentCount present '
                    '$lateCount late '
                    '$totalClasses classes ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
